import 'package:drift/drift.dart';
import 'package:sync_music/core/database/app_database.dart';
import 'package:sync_music/core/database/tables/tracks.dart';
import 'package:sync_music/core/utils/ids.dart';
import 'package:sync_music/features/library/data/datasources/fts_query.dart';
import 'package:sync_music/features/library/domain/entities/album.dart';
import 'package:sync_music/features/library/domain/entities/artist.dart';
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

  /// Albums = alive tracks grouped by album TITLE ONLY: the same title from
  /// different artists is ONE album (compilations like "Download" merge).
  /// artistName is a deterministic representative - MIN() picks the
  /// alphabetically first. MIN(artwork_hash) picks any non-null cover.
  Stream<List<Album>> watchAlbums() {
    final albumTitle = tracks.albumTitle;
    final repArtist = tracks.artistName.min();
    final trackCount = countAll();
    final anyArtwork = tracks.artworkHash.min();

    final query = selectOnly(tracks)
      ..addColumns([albumTitle, repArtist, trackCount, anyArtwork])
      ..where(tracks.deletedAtMs.isNull() & albumTitle.isNotNull())
      ..groupBy([albumTitle])
      ..orderBy([OrderingTerm.asc(albumTitle)]);

    return query.watch().map(
      (rows) => [
        for (final row in rows)
          Album(
            albumTitle: row.read(albumTitle)!,
            artistName: row.read(repArtist)!,
            trackCount: row.read(trackCount) ?? 0,
            artworkHash: row.read(anyArtwork),
          ),
      ],
    );
  }

  /// Artists = alive tracks grouped by name; albumCount counts DISTINCT
  /// non-null album titles.
  Stream<List<Artist>> watchArtists() {
    final artistName = tracks.artistName;
    final trackCount = countAll();
    final albumCount = tracks.albumTitle.count(distinct: true);
    final anyArtwork = tracks.artworkHash.min();

    final query = selectOnly(tracks)
      ..addColumns([artistName, trackCount, albumCount, anyArtwork])
      ..where(tracks.deletedAtMs.isNull())
      ..groupBy([artistName])
      ..orderBy([OrderingTerm.asc(artistName)]);

    return query.watch().map(
      (rows) => [
        for (final row in rows)
          Artist(
            artistName: row.read(artistName)!,
            trackCount: row.read(trackCount) ?? 0,
            albumCount: row.read(albumCount) ?? 0,
            artworkHash: row.read(anyArtwork),
          ),
      ],
    );
  }

  /// Tracks of ONE album (the title is the whole key now - compilations
  /// include every artist), in playing order: disc -> track number -> title.
  Stream<List<Track>> watchAlbumTracks(String albumTitle) {
    final query = select(tracks)
      ..where((t) => t.deletedAtMs.isNull() & t.albumTitle.equals(albumTitle))
      ..orderBy([
        (t) => OrderingTerm.asc(t.discNumber),
        (t) => OrderingTerm.asc(t.trackNumber),
        (t) => OrderingTerm.asc(t.title),
      ]);
    return query.watch();
  }

  /// All tracks of ONE artist, grouped by album.
  Stream<List<Track>> watchArtistTracks(String artistName) {
    final query = select(tracks)
      ..where((t) => t.deletedAtMs.isNull() & t.artistName.equals(artistName))
      ..orderBy([
        (t) => OrderingTerm.asc(t.albumTitle),
        (t) => OrderingTerm.asc(t.discNumber),
        (t) => OrderingTerm.asc(t.trackNumber),
        (t) => OrderingTerm.asc(t.title),
      ]);
    return query.watch();
  }

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

  /// Alive tracks for the given ids, in the ORDER of [ids] (SQL's IN does
  /// not preserve order - reindex in Dart). Dead ids are simply missing
  /// from the result. Used by the player's session restore.
  Future<List<Track>> tracksByIds(List<String> ids) async {
    if (ids.isEmpty) return const [];
    final query = select(tracks)
      ..where((t) => t.id.isIn(ids) & t.deletedAtMs.isNull());
    final rows = await query.get();
    final byId = {for (final row in rows) row.id: row};
    return [for (final id in ids) ?byId[id]];
  }

  static const searchTracksLimit = 50;
  static const searchSectionsLimit = 20;

  /// Full-text track search, best matches first (FTS5 bm25 `rank`).
  /// The ranked ids go through tracksByIds: it re-reads full rows IN
  /// THE GIVEN ORDER and drops dead ones - ordering, alive-filtering
  /// and row->entity mapping all come for free.
  Future<List<Track>> searchTracks(
    String query, {
    int limit = searchTracksLimit,
  }) async {
    final match = buildMatchQuery(query);
    if (match.isEmpty) return const [];

    final rows = await customSelect(
      'SELECT tracks.id AS id '
      'FROM tracks_fts '
      'JOIN tracks ON tracks.rowid = tracks_fts.rowid '
      'WHERE tracks_fts MATCH ? AND tracks.deleted_at_ms IS NULL '
      'ORDER BY tracks_fts.rank '
      'LIMIT ?',
      variables: [Variable.withString(match), Variable.withInt(limit)],
    ).get();

    return await tracksByIds([for (final row in rows) row.read<String>('id')]);
  }

  /// Albums whose TITLE matches - the same aggregates as watchAlbums(),
  /// narrowed to the FTS-matched titles. (Deliberately not LIKE: LIKE is
  /// case-insensitive for ASCII only, the FTS index folds Cyrillic too.)
  Future<List<Album>> searchAlbums(
    String query, {
    int limit = searchSectionsLimit,
  }) async {
    final titles = await _matchedColumn('album_title', query, limit);
    if (titles.isEmpty) return const [];

    final albumTitle = tracks.albumTitle;
    final repArtist = tracks.artistName.min();
    final trackCount = countAll();
    final anyArtwork = tracks.artworkHash.min();

    final q = selectOnly(tracks)
      ..addColumns([albumTitle, repArtist, trackCount, anyArtwork])
      ..where(tracks.deletedAtMs.isNull() & albumTitle.isIn(titles))
      ..groupBy([albumTitle])
      ..orderBy([OrderingTerm.asc(albumTitle)]);

    final rows = await q.get();
    return [
      for (final row in rows)
        Album(
          albumTitle: row.read(albumTitle)!,
          artistName: row.read(repArtist)!,
          trackCount: row.read(trackCount) ?? 0,
          artworkHash: row.read(anyArtwork),
        ),
    ];
  }

  /// Artists whose NAME matches - same story as searchAlbums().
  Future<List<Artist>> searchArtists(
    String query, {
    int limit = searchSectionsLimit,
  }) async {
    final names = await _matchedColumn('artist_name', query, limit);
    if (names.isEmpty) return const [];

    final artistName = tracks.artistName;
    final trackCount = countAll();
    final albumCount = tracks.albumTitle.count(distinct: true);
    final anyArtwork = tracks.artworkHash.min();

    final q = selectOnly(tracks)
      ..addColumns([artistName, trackCount, albumCount, anyArtwork])
      ..where(tracks.deletedAtMs.isNull() & artistName.isIn(names))
      ..groupBy([artistName])
      ..orderBy([OrderingTerm.asc(artistName)]);

    final rows = await q.get();
    return [
      for (final row in rows)
        Artist(
          artistName: row.read(artistName)!,
          trackCount: row.read(trackCount) ?? 0,
          albumCount: row.read(albumCount) ?? 0,
          artworkHash: row.read(anyArtwork),
        ),
    ];
  }

  /// DISTINCT alive values of one indexed column matched by FTS.
  /// [column] is ALWAYS one of the hardcoded literals above - never
  /// user input (it goes into the SQL text, not into a variable).
  Future<List<String>> _matchedColumn(
    String column,
    String query,
    int limit,
  ) async {
    final match = buildMatchQuery(query);
    if (match.isEmpty) return const [];

    final rows = await customSelect(
      'SELECT DISTINCT tracks.$column AS v '
      'FROM tracks_fts '
      'JOIN tracks ON tracks.rowid = tracks_fts.rowid '
      'WHERE tracks_fts MATCH ? AND tracks.deleted_at_ms IS NULL '
      'AND tracks.$column IS NOT NULL '
      'LIMIT ?',
      variables: [Variable.withString(match), Variable.withInt(limit)],
    ).get();
    return [for (final row in rows) row.read<String>('v')];
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
