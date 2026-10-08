import 'package:drift/drift.dart';
import 'package:sync_music/core/database/app_database.dart';
import 'package:sync_music/core/database/tables/tracks.dart';
import 'package:sync_music/core/utils/ids.dart';
import 'package:sync_music/features/library/domain/entities/scanned_track.dart';

part 'library_dao.g.dart';

@DriftAccessor(tables: [Tracks])
class LibraryDao extends DatabaseAccessor<AppDatabase> with _$LibraryDaoMixin {
  new(super.attachedDatabase);

  Stream<List<Track>> watchTracks() {
    final query = select(tracks)..where((t) => t.deletedAtMs.isNull());
    return query.watch();
  }

  /// One-shot snapshot of ALL tracks — tombstones included.
  /// The rescan orchestrator builds DB fingerprints from it; the UI uses
  /// [watchTracks] instead (live stream, deleted rows filtered out).
  Future<List<Track>> getAllOnce() => select(tracks).get();

  Future<void> insertAllAtomic(List<TracksCompanion> rows) =>
      batch((b) => b.insertAll(tracks, rows));

  /// Inserts new tracks. contentHash collisions (same song in two folders)
  /// are silently ignored - first copy wins.
  Future<void> insertScanned(List<ScannedTrack> scanned) {
    final now = DateTime.now().millisecondsSinceEpoch;
    return batch(
      (b) => b.insertAll(tracks, [
        for (final t in scanned)
          TracksCompanion.insert(
            id: newId(),
            contentHash: t.contentHash,
            title: t.title,
            addedAtMs: now,
            updatedAtMs: now,
            artistName: Value(t.artistName),
            albumTitle: Value(t.albumTitle),
            durationMs: Value(t.durationMs),
            localPath: Value(t.path),
            sizeBytes: Value(t.sizeBytes),
            fileMtimeMs: Value(t.mtimeMs),
            trackNumber: Value(t.trackNumber),
            discNumber: Value(t.discNumber),
            year: Value(t.year),
            genre: Value(t.genre),
            bitrate: Value(t.bitrate),
            sampleRate: Value(t.sampleRate),
          ),
      ], mode: InsertMode.insertOrIgnore),
    );
  }

  /// Re-tags an existing row matched by path (file content changed).
  Future<void> updateScannedByPath(ScannedTrack t) {
    final query = update(tracks)..where((r) => r.localPath.equals(t.path));
    return query.write(
      TracksCompanion(
        contentHash: Value(t.contentHash),
        title: Value(t.title),
        artistName: Value(t.artistName),
        albumTitle: Value(t.albumTitle),
        durationMs: Value(t.durationMs),
        sizeBytes: Value(t.sizeBytes),
        fileMtimeMs: Value(t.mtimeMs),
        trackNumber: Value(t.trackNumber),
        discNumber: Value(t.discNumber),
        year: Value(t.year),
        genre: Value(t.genre),
        bitrate: Value(t.bitrate),
        sampleRate: Value(t.sampleRate),
        updatedAtMs: Value(DateTime.now().millisecondsSinceEpoch),
      ),
    );
  }

  /// Tombstones for files that vanished from disk.
  Future<void> markDeletedByPaths(List<String> paths) {
    if (paths.isEmpty) return Future.value();
    final query = update(tracks)
      ..where((r) => r.localPath.isIn(paths) & r.deletedAtMs.isNull());
    return query.write(
      TracksCompanion(
        deletedAtMs: Value(DateTime.now().millisecondsSinceEpoch),
      ),
    );
  }
}
