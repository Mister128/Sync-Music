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
    final query = select(tracks)
      ..where((t) => t.deletedAtMs.isNull())
      ..orderBy([(t) => OrderingTerm.asc(t.title)]);
    return query.watch();
  }

  Future<List<Track>> getAllOnce() => select(tracks).get();

  Future<void> insertAllAtomic(List<TracksCompanion> rows) =>
      batch((b) => b.insertAll(tracks, rows));

  /// Inserts new tracks. contentHash collisions (same song in two folders)
  /// are silently ignored - first copy wins.
  Future<int> insertScanned(List<ScannedTrack> scanned) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    var affected = 0;

    for (final t in scanned) {
      final existingQuery = select(tracks)
        ..where((r) => r.contentHash.equals(t.contentHash))
        ..limit(1);
      final existing = await existingQuery.getSingleOrNull();

      if (existing == null) {
        await into(tracks).insert(_insertCompanion(t, now));
        affected++;
      } else if (existing.deletedAtMs != null) {
        final query = update(tracks)..where((r) => r.id.equals(existing.id));
        await query.write(_reviveCompanion(t, now));
        affected++;
      }
    }
    return affected;
  }

  /// Re-tags an existing row by PRIMARY KEY.
  Future<int> updateScannedById(String id, ScannedTrack t) {
    final query = update(tracks)..where((r) => r.id.equals(id));
    return query.write(
      TracksCompanion(
        contentHash: Value(t.contentHash),
        localPath: Value(t.path),
        // refresh to the current on-disk spelling
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
        artworkCheckedAtMs: const Value(null),
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

  /// Alive, file-backed tracks never checked by the artwork pass on this
  /// device. Ordered like watchTracks() so covers light up top-to-bottom
  /// in the list the user is looking at.
  Future<List<Track>> tracksMissingArtwork() {
    final query = select(tracks)
      ..where(
        (t) =>
            t.artworkCheckedAtMs.isNull() &
            t.localPath.isNotNull() &
            t.deletedAtMs.isNull(),
      )
      ..orderBy([(t) => OrderingTerm.asc(t.title)]);
    return query.get();
  }

  /// Records one extraction attempt: the cover hash (null = the file has
  /// no usable cover) + the "checked" stamp, so cover-less files are never
  /// re-read. Failures must NOT call this - they stay queued for a retry.
  Future<void> updateArtworkHash(String id, String? artworkHash) {
    final query = update(tracks)..where((t) => t.id.equals(id));
    return query.write(
      TracksCompanion(
        artworkHash: Value(artworkHash),
        artworkCheckedAtMs: Value(DateTime.now().millisecondsSinceEpoch),
      ),
    );
  }
}

TracksCompanion _insertCompanion(ScannedTrack t, int now) =>
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
    );

TracksCompanion _reviveCompanion(ScannedTrack t, int now) => TracksCompanion(
  title: Value(t.title),
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
  updatedAtMs: Value(now),
  deletedAtMs: const Value(null),
  artworkCheckedAtMs: const Value(null),
);
