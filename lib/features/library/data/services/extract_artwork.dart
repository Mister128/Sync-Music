import 'dart:async';

import 'package:sync_music/core/logging/app_logger.dart';
import 'package:sync_music/features/library/data/datasources/artwork_store.dart';
import 'package:sync_music/features/library/data/datasources/library_dao.dart';

/// Background pass that fills in `artworkHash` for tracks never checked on
/// this device. Deliberately SEPARATE from RescanLibrary: scanning with
/// getImage: true is much slower, and the library list must not wait for
/// covers - tiles light up on their own through the watchTracks() stream.
///
/// Incremental by design: only `artworkCheckedAtMs IS NULL` rows are read,
/// so repeated runs cost nothing. Failures stay queued and are retried on
/// the next pass (files deleted meanwhile get tombstoned by the next scan,
/// which drops them from the queue).
class ExtractArtwork {
  new({required this.tracksDao, required this.store});

  final LibraryDao tracksDao;
  final ArtworkStore store;

  bool _running = false;

  /// Returns the number of covers stored. Safe to call unawaited; a second
  /// concurrent call is a no-op (the queue is persistent - whatever this
  /// pass misses, the next one picks up).
  Future<int> call() async {
    if (_running) return 0;
    _running = true;

    final log = AppLogger.scope('artwork');
    final stopwatch = Stopwatch()
      ..start();

    try {
      final queue = await tracksDao.tracksMissingArtwork();
      if (queue.isEmpty) return 0;

      log.debug('background pass: ${queue.length} track(s) to check');

      var extracted = 0;
      var withoutCover = 0;
      var failed = 0;

      for (final row in queue) {
        final path = row.localPath;
        if (path == null) continue;

        final res = await store.storeFromAudio(path);
        if (res.warning != null) {
          log.warn(res.warning);
          failed++;
          continue;
        }

        await tracksDao.updateArtworkHash(row.id, res.hash);
        if (res.hash != null) {
          extracted++;
        } else {
          withoutCover++;
        }
      }

      stopwatch.stop();
      final seconds = (stopwatch.elapsedMilliseconds / 1000).toStringAsFixed(1);
      log.info(
        'done: $extracted covers stored, $withoutCover without cover, '
            '$failed failed in ${seconds}s',
      );
      return extracted;
    } on Object catch (e, st) {
      stopwatch.stop();
      log.error('extraction pass failed', e, st);
      return 0;
    } finally {
      _running = false;
    }
  }
}
