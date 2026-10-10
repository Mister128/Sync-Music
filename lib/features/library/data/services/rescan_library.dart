import 'dart:io';
import 'dart:isolate';
import 'dart:math' show min;

import 'package:path/path.dart' as p;

import 'package:sync_music/core/database/app_database.dart';
import 'package:sync_music/core/logging/app_logger.dart';
import 'package:sync_music/core/platform/platform_info.dart';
import 'package:sync_music/core/utils/path_normalizer.dart';
import 'package:sync_music/features/library/data/datasources/filesystem_walker.dart';
import 'package:sync_music/features/library/data/datasources/library_dao.dart';
import 'package:sync_music/features/library/data/datasources/library_roots_dao.dart';
import 'package:sync_music/features/library/data/datasources/platform_media_scanner.dart';
import 'package:sync_music/features/library/data/datasources/tag_reader.dart';
import 'package:sync_music/features/library/domain/entities/file_entry.dart';
import 'package:sync_music/features/library/domain/entities/scan_event.dart';
import 'package:sync_music/features/library/domain/entities/scanned_track.dart';
import 'package:sync_music/features/library/domain/services/scan_diff.dart';

/// Orchestrates a full incremental library rescan.
class RescanLibrary {
  new({
    required this.db,
    required this.tracksDao,
    required this.rootsDao,
    required this.platformScanner,
    bool? android,
  }) : isAndroid = android ?? PlatformInfo.usesSystemMediaLibrary;

  final AppDatabase db;
  final LibraryDao tracksDao;
  final LibraryRootsDao rootsDao;
  final PlatformMediaScanner platformScanner;

  /// Injectable for tests (Platform is not fakeable)
  final bool isAndroid;

  static const int _batchSize = 50;

  Stream<ScanEvent> call() async* {
    final log = AppLogger.scope('scanner');
    final stopwatch = Stopwatch()..start();

    try {
      final disk = <FileEntry>[];
      final walkedRoots = <String>[];
      var allRootPaths = const <String>[];

      if (isAndroid) {
        // ---- Android: MediaStore is the ONLY source, there are no roots ----
        var granted = await platformScanner.hasPermission();
        if (!granted) granted = await platformScanner.requestPermission();
        if (!granted) {
          // Denied != "empty library": touching nothing is the whole point
          // (same philosophy as an unavailable root on desktop).
          log.warn('audio permission denied - library untouched');
          yield const ScanFailed(message: 'audio permission denied');
          return;
        }
        disk.addAll(await platformScanner.queryAudioFiles());
        log.debug('MediaStore listed ${disk.length} audio file(s)');
      } else {
        // ---- 1. Roots: registered vs actually reachable ----
        final roots = await rootsDao.watchRoots().first;
        allRootPaths = [for (final root in roots) root.path];
        final availableRoots = <String>[];
        for (final root in roots) {
          if (Directory(root.path).existsSync()) {
            availableRoots.add(root.path);
          } else {
            log.warn('root unavailable, skipping: ${root.path}');
          }
        }

        // ---- 2. Walk available roots (worker isolate) ----
        for (final rootPath in availableRoots) {
          final walkResult = await _walkRootInIsolate(rootPath);
          walkResult.warnings.forEach(log.warn); // warnings travel as data
          if (!walkResult.rootAvailable) continue; // root stays "protected"
          disk.addAll(walkResult.entries);
          walkedRoots.add(rootPath);
        }
      }

      // ---- 3. Alive DB rows -> classification ----
      final alive = await tracksDao.watchTracks().first;
      final inDb = <FileEntry>[]; // joins the diff
      final idByPath = <String, String>{}; // normalized path -> row id
      final orphanedPaths = <String>[]; // no root claims them -> tombstone
      var protectedCount = 0; // root unavailable or partially walked

      for (final row in alive) {
        final path = row.localPath;
        if (path == null) continue; // P2P/remote rows are not file-backed

        // Android: MediaStore is authoritative for EVERY file-backed row -
        // there are no roots, so nothing is protected or orphaned; rows it
        // no longer lists are genuinely gone (diff.removedPaths tombstones
        // them below).
        final claimed = isAndroid || _underAnyRoot(path, walkedRoots);

        if (claimed) {
          // Updates match rows BY ID: path casing may drift on Windows,
          // the primary key never does.
          idByPath[defaultPathNormalizer(path)] = row.id;
          inDb.add(
            FileEntry(
              path: path,
              sizeBytes: row.sizeBytes,
              // null mtime -> 0 forces one re-parse; self-healing
              mtimeMs: row.fileMtimeMs ?? 0,
            ),
          );
        } else if (_underAnyRoot(path, allRootPaths)) {
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
        // The single implementation lives in tag_reader.dart.
        final parsed = await _parseBatchInIsolate(chunk);

        // Warnings traveled as data — log them HERE, where talker lives.
        parsed.warnings.forEach(log.warn);
        skipped += parsed.skipped;

        final fresh = <ScannedTrack>[];
        final refreshed = <ScannedTrack>[];
        for (final track in parsed.tracks) {
          (addedPaths.contains(track.path) ? fresh : refreshed).add(track);
        }

        // ON the main isolate: one transaction per batch
        // (50 writes, 1 commit — not 50 commits).
        await db.transaction(() async {
          added += await tracksDao.insertScanned(fresh); // honest count:
          // insert-or-revive by contentHash, alive duplicates skipped
          for (final track in refreshed) {
            final id = idByPath[defaultPathNormalizer(track.path)];
            if (id == null) {
              skipped++; // row vanished between the snapshot and the write
              continue;
            }
            changed += await tracksDao.updateScannedById(id, track);
          }
        });

        processed += chunk.length;
        yield ScanProgress(processed: processed, total: work.length);
      }

      // ---- 7. Stamp only the roots walked to completion (desktop-only:
      //      on Android walkedRoots is empty and this loop is a no-op) ----
      for (final rootPath in walkedRoots) {
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

  // ---- Isolate-safe helpers: static scope, sendable captures only ----

  static Future<WalkResult> _walkRootInIsolate(String rootPath) =>
      Isolate.run(() => walkAudioFiles(rootPath));

  static Future<ParseBatchResult> _parseBatchInIsolate(List<FileEntry> chunk) =>
      Isolate.run(() => parseTrackBatch(chunk));

  /// True when [filePath] lies under any of [rootPaths].
  /// Both sides go through the same normalizer (Windows: case-insensitive).
  static bool _underAnyRoot(String filePath, List<String> rootPaths) {
    final normalized = defaultPathNormalizer(filePath);
    return rootPaths.any(
          (root) => p.isWithin(defaultPathNormalizer(root), normalized),
    );
  }
}
