import 'dart:isolate';
import 'dart:math' show min;

import 'package:sync_music/core/database/app_database.dart';
import 'package:sync_music/core/logging/app_logger.dart';
import 'package:sync_music/features/library/data/datasources/filesystem_walker.dart';
import 'package:sync_music/features/library/data/datasources/library_dao.dart';
import 'package:sync_music/features/library/data/datasources/library_roots_dao.dart';
import 'package:sync_music/features/library/data/datasources/tag_reader.dart';
import 'package:sync_music/features/library/domain/entities/file_entry.dart';
import 'package:sync_music/features/library/domain/entities/scan_event.dart';
import 'package:sync_music/features/library/domain/entities/scanned_track.dart';
import 'package:sync_music/features/library/domain/services/scan_diff.dart';

/// Orchestrates a full incremental rescan. Lives on the MAIN isolate;
/// heavy work (walk, hash+tags) is shipped to workers via Isolate.run.
class RescanLibrary {
  new({required this.db, required this.tracksDao, required this.rootsDao});

  final AppDatabase db;
  final LibraryDao tracksDao;
  final LibraryRootsDao rootsDao;

  static const int _batchSize = 50;

  Stream<ScanEvent> call() async* {
    final log = AppLogger.scope('scanner');
    try {
      final roots = await rootsDao.getAllOnce();

      if (roots.isEmpty) {
        yield const ScanEvent.finished(
          added: 0,
          changed: 0,
          removed: 0,
          skipped: 0,
        );
        return;
      }

      final disk = <FileEntry>[];
      for (final root in roots) {
        final path = root.path;
        final result = await _walkRoot(path);
        disk.addAll(result.entries);
        result.warnings.forEach(log.warn);
      }

      final rows = await tracksDao.getAllOnce();
      final inDb = [
        for (final t in rows)
          if (t.localPath != null && t.deletedAtMs == null)
            FileEntry(
              path: t.localPath!,
              sizeBytes: t.sizeBytes,
              mtimeMs: t.fileMtimeMs ?? 0,
            ),
      ];

      final diff = diffLibrary(onDisk: disk, inDb: inDb);
      final work = [...diff.added, ...diff.changed];
      yield ScanEvent.started(filesFound: disk.length, toProcess: work.length);

      if (diff.removedPaths.isNotEmpty) {
        await tracksDao.markDeletedByPaths(diff.removedPaths);
      }

      // A Set of "new" paths tells insert from update inside the merged queue.
      final addedPaths = diff.added.map((e) => e.path).toSet();
      var added = 0;
      var changed = 0;
      var skipped = 0;
      var processed = 0;

      for (var i = 0; i < work.length; i += _batchSize) {
        // Manual chunking - no extra package needed.
        final chunk = work.sublist(i, min(i + _batchSize, work.length));

        // OFF the main isolate: hashing + tag parsing (the slow part).
        final parsed = await _parseBatch(chunk);

        parsed.warnings.forEach(log.warn);
        skipped += parsed.skipped;

        await db.transaction(() async {
          final toInsert = <ScannedTrack>[];
          for (final t in parsed.tracks) {
            if (addedPaths.contains(t.path)) {
              toInsert.add(t);
            } else {
              await tracksDao.updateScannedByPath(t);
              changed++;
            }
          }

          if (toInsert.isNotEmpty) {
            await tracksDao.insertScanned(toInsert);
            added += toInsert.length;
          }
        });

        processed += chunk.length;
        yield ScanEvent.progress(processed: processed, total: work.length);
      }

      for (final root in roots) {
        await rootsDao.markScanned(root.path);
      }

      final done = ScanEvent.finished(
        added: added,
        changed: changed,
        removed: diff.removedPaths.length,
        skipped: skipped,
      );
      log.info('$done');
      yield done;
    } on Object catch (e, st) {
      log.error('rescan failed', e, st);
      yield ScanEvent.failed(message: '$e');
    }
  }

  /// Isolate-spawning helpers live in their OWN scope on purpose:
  /// a closure created inside call() would drag the shared method context
  /// (including `this` with DAO/sqlite handles) into the isolate message.
  /// Static scope = the closure captures ONLY its sendable argument.
  static Future<WalkResult> _walkRoot(String rootPath) =>
      Isolate.run(() => walkAudioFiles(rootPath));

  static Future<ParseBatchResult> _parseBatch(List<FileEntry> chunk) =>
      Isolate.run(() => parseTrackBatch(chunk));
}
