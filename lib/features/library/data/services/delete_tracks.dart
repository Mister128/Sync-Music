import 'package:sync_music/core/logging/app_logger.dart';
import 'package:sync_music/features/library/data/datasources/file_deleter.dart';
import 'package:sync_music/features/library/data/datasources/library_dao.dart';
import 'package:sync_music/features/library/domain/entities/track.dart';

/// Delete forever: remove the FILE from
/// disk, THEN tombstone the row. Order matters - a tombstone without file
/// removal would be resurrected by the next rescan (the file still walks
/// the disk and insertScanned revives rows by contentHash).
class DeleteTracks {
  new({required this.deleter, required this.tracksDao});

  final FileDeleter deleter;
  final LibraryDao tracksDao;
  final ScopedLogger _log = AppLogger.scope('delete');

  /// Honest counts: only files the deleter CONFIRMED get tombstoned.
  /// Tracks without a local path (future P2P phantoms) count as failed -
  /// there is nothing on disk to delete.
  Future<({int deleted, int failed})> call(List<Track> tracks) async {
    final paths = <String>[
      for (final track in tracks)
        if (track.localPath != null) track.localPath!,
    ];
    final phantoms = tracks.length - paths.length;
    if (paths.isEmpty) return (deleted: 0, failed: tracks.length);

    final removed = await deleter.deleteFiles(paths);
    if (removed.isNotEmpty) {
      await tracksDao.markDeletedByPaths(removed);
    }

    final failed = paths.length - removed.length + phantoms;
    _log.info('deleted ${removed.length} file(s), $failed failed');
    return (deleted: removed.length, failed: failed);
  }
}
