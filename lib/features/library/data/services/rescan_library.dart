import 'dart:io';
import 'dart:isolate';
import 'dart:math' show min;

import 'package:path/path.dart' as p;

import 'package:sync_music/core/database/app_database.dart';
import 'package:sync_music/core/logging/app_logger.dart';
import 'package:sync_music/core/utils/hashing.dart';
import 'package:sync_music/core/utils/path_normalizer.dart';
import 'package:sync_music/features/library/data/datasources/filesystem_walker.dart';
import 'package:sync_music/features/library/data/datasources/library_dao.dart';
import 'package:sync_music/features/library/data/datasources/library_roots_dao.dart';
import 'package:sync_music/features/library/data/datasources/tag_reader.dart';
import 'package:sync_music/features/library/domain/entities/file_entry.dart';
import 'package:sync_music/features/library/domain/entities/scan_event.dart';
import 'package:sync_music/features/library/domain/entities/scanned_track.dart';
import 'package:sync_music/features/library/domain/services/scan_diff.dart';

/// One parsed batch, traveling back from the worker isolate as DATA
/// (talker is not available inside isolates — the orchestrator logs it).
typedef ParsedBatch = ({List<ScannedTrack?> tracks, List<String> warnings});

/// Orchestrates a full incremental library rescan.
class RescanLibrary {
  new({required this.db, required this.tracksDao, required this.rootsDao});

  final AppDatabase db;
  final LibraryDao tracksDao;
  final LibraryRootsDao rootsDao;

  static const int _batchSize = 50;

  Stream<ScanEvent> call() async* {
    final log = AppLogger.scope('scanner');
    final stopwatch = Stopwatch()..start();

    try {
      // ---- 1. Roots: split into available / unavailable ----
      final roots = await rootsDao.watchRoots().first;
      final availableRoots = <String>[];
      final unavailableRoots = <String>[];
      for (final root in roots) {
        if (Directory(root.path).existsSync()) {
          availableRoots.add(root.path);
        } else {
          unavailableRoots.add(root.path);
          log.warn('root unavailable, skipping: ${root.path}');
        }
      }

      // ---- 2. Walk available roots (worker isolate) ----
      final disk = <FileEntry>[];
      for (final rootPath in availableRoots) {
        final walkResult = await _walkRootInIsolate(rootPath)..entries;
        disk.addAll(walkResult.entries);
      }

      // ---- 3. Alive DB rows -> three-way classification ----
      final alive = await tracksDao.watchTracks().first;
      final inDb = <FileEntry>[]; // under an available root -> join the diff
      final orphanedPaths = <String>[]; // root was removed -> tombstone
      var protectedCount = 0; // under an unavailable root -> untouched

      for (final row in alive) {
        final path = row.localPath;
        if (path == null) continue; // P2P/remote rows are not file-backed
        if (_underAnyRoot(path, availableRoots)) {
          inDb.add(
            FileEntry(
              path: path,
              sizeBytes: row.sizeBytes,
              // null mtime -> 0 forces one re-parse; self-healing
              mtimeMs: row.fileMtimeMs ?? 0,
            ),
          );
        } else if (_underAnyRoot(path, unavailableRoots)) {
          protectedCount++;
        } else {
          orphanedPaths.add(path);
        }
      }

      // ---- 4. The pure calculator ----
      final diff = diffLibrary(onDisk: disk, inDb: inDb);

      // ---- 5. Tombstones: gone files + removed folders ----
      final toTombstone = [...diff.removedPaths, ...orphanedPaths];
      if (toTombstone.isNotEmpty) {
        await tracksDao.markDeletedByPaths(toTombstone);
      }

      // ---- 6. Parse added+changed: isolate -> transaction, per batch ----
      final work = [...diff.added, ...diff.changed];
      // Set of "new" paths tells insert from update inside the merged queue.
      final addedPaths = diff.added.map((e) => e.path).toSet();

      yield ScanStarted(filesFound: disk.length, toProcess: work.length);

      var added = 0;
      var changed = 0;
      var skipped = 0;
      var processed = 0;

      for (var i = 0; i < work.length; i += _batchSize) {
        final chunk = work.sublist(i, min(i + _batchSize, work.length));

        // OFF the main isolate: hashing + tag parsing (the slow part).
        final parsed = await _parseBatchInIsolate(chunk);

        // Warnings traveled as data — log them HERE, where talker lives.
        parsed.warnings.forEach(log.warn);

        final fresh = <ScannedTrack>[];
        final refreshed = <ScannedTrack>[];
        for (final track in parsed.tracks) {
          if (track == null) {
            skipped++; // died between walk and parse, or unreadable
            continue;
          }
          (addedPaths.contains(track.path) ? fresh : refreshed).add(track);
        }

        // ON the main isolate: one transaction per batch
        // (50 writes, 1 commit — not 50 commits).
        await db.transaction(() async {
          added += await tracksDao.insertScanned(fresh); // honest count:
          // insert-or-revive by contentHash, alive duplicates skipped
          for (final track in refreshed) {
            await tracksDao.updateScannedByPath(track);
            changed++;
          }
        });

        processed += chunk.length;
        yield ScanProgress(processed: processed, total: work.length);
      }

      // ---- 7. Stamp only the roots we actually walked ---------------------
      for (final rootPath in availableRoots) {
        await rootsDao.markScanned(rootPath);
      }

      stopwatch.stop();
      final seconds = (stopwatch.elapsedMilliseconds / 1000).toStringAsFixed(1);
      log.info(
        'done: $added added, $changed changed, ${toTombstone.length} removed '
        'in ${seconds}s (skipped: $skipped, protected: $protectedCount)',
      );

      yield ScanFinished(
        added: added,
        changed: changed,
        removed: toTombstone.length,
        skipped: skipped,
      );
    } on Object catch (e, st) {
      stopwatch.stop();
      log.error('rescan failed', e, st);
      yield ScanFailed(message: '$e');
    }
  }

  // ---- Isolate-safe helpers: static scope, sendable captures only --------

  static Future<WalkResult> _walkRootInIsolate(String rootPath) =>
      Isolate.run(() => walkAudioFiles(rootPath));

  static Future<ParsedBatch> _parseBatchInIsolate(List<FileEntry> chunk) =>
      Isolate.run(() => parseTrackBatch(chunk));

  /// Runs INSIDE the worker isolate: hash + tags for one file.
  /// A single broken file must not kill the batch — catch, count, warn.
  static ParsedBatch parseTrackBatch(List<FileEntry> chunk) {
    final tracks = <ScannedTrack?>[];
    final warnings = <String>[];

    void skip(FileEntry entry, Object e) {
      tracks.add(null);
      warnings.add('${entry.path}: skipped ($e)');
    }

    for (final entry in chunk) {
      try {
        final contentHash = fastHashFile(entry.path);
        final read = readTrack(entry, contentHash);
        if (read.warning != null) warnings.add(read.warning!);
        tracks.add(read.track);
      } on FileSystemException catch (e) {
        skip(entry, e);
      } on FormatException catch (e) {
        skip(entry, e);
      } catch (e) {
        skip(entry, e);
      }
    }
    return (tracks: tracks, warnings: warnings);
  }

  /// True when [filePath] lies under any of [rootPaths].
  /// Both sides go through the same normalizer (Windows: case-insensitive).
  static bool _underAnyRoot(String filePath, List<String> rootPaths) {
    final normalized = defaultPathNormalizer(filePath);
    return rootPaths.any(
      (root) => p.isWithin(defaultPathNormalizer(root), normalized),
    );
  }
}
