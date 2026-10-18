import 'package:drift/drift.dart';

import 'package:sync_music/core/database/app_database.dart' hide Track;
import 'package:sync_music/core/database/tables/playlist_tracks.dart';
import 'package:sync_music/core/database/tables/playlists.dart';
import 'package:sync_music/core/database/tables/tracks.dart';
import 'package:sync_music/core/utils/fractional_index.dart';
import 'package:sync_music/core/utils/ids.dart';

// Cross-feature data imports
import 'package:sync_music/features/library/data/models/track_mapper.dart';
import 'package:sync_music/features/library/domain/entities/track.dart';
import 'package:sync_music/features/playlists/domain/entities/playlist.dart';

part 'playlist_dao.g.dart';

@DriftAccessor(tables: [Playlists, PlaylistTracks, Tracks])
class PlaylistDao extends DatabaseAccessor<AppDatabase>
    with _$PlaylistDaoMixin {
  new(super.attachedDatabase);

  /// Live playlists with derived aggregates. trackCount counts only ALIVE
  /// tracks of ALIVE memberships (COUNT on the joined tracks.id ignores
  /// NULLs from both left joins); the cover is MIN(artwork_hash) - any
  /// track's cover, albums convention.
  Stream<List<Playlist>> watchPlaylists() {
    final anyArtwork = tracks.artworkHash.min();
    final trackCount = tracks.id.count();

    final query =
        select(playlists).join([
            leftOuterJoin(
              playlistTracks,
              playlistTracks.playlistId.equalsExp(playlists.id) &
                  playlistTracks.deletedAtMs.isNull(),
            ),
            leftOuterJoin(
              tracks,
              tracks.id.equalsExp(playlistTracks.trackId) &
                  tracks.deletedAtMs.isNull(),
            ),
          ])
          ..where(playlists.deletedAtMs.isNull())
          ..addColumns([anyArtwork, trackCount])
          ..groupBy([playlists.id])
          ..orderBy([OrderingTerm.asc(playlists.name)]);

    return query.watch().map(
      (rows) => [
        for (final row in rows)
          Playlist(
            id: row.readTable(playlists).id,
            name: row.readTable(playlists).name,
            trackCount: row.read(trackCount) ?? 0,
            artworkHash: row.read(anyArtwork),
          ),
      ],
    );
  }

  /// Creates a playlist, returns its fresh id.
  Future<String> createPlaylist(String name) async {
    final id = newId();
    final now = DateTime.now().millisecondsSinceEpoch;
    await into(playlists).insert(
      PlaylistsCompanion.insert(
        id: id,
        name: name,
        createdAtMs: now,
        updatedAtMs: now,
      ),
    );
    return id;
  }

  Future<void> renamePlaylist(String id, String name) {
    final query = update(playlists)..where((p) => p.id.equals(id));
    return query.write(
      PlaylistsCompanion(
        name: Value(name),
        updatedAtMs: Value(DateTime.now().millisecondsSinceEpoch),
      ),
    );
  }

  Future<void> deletePlaylist(String id) {
    final now = DateTime.now().millisecondsSinceEpoch;
    final query = update(playlists)..where((p) => p.id.equals(id));
    return query.write(
      PlaylistsCompanion(deletedAtMs: Value(now), updatedAtMs: Value(now)),
    );
  }

  /// Tracks of one playlist in sort_key order. Filtered twice: alive
  /// memberships AND alive library tracks (a deleted file hides the track
  /// here, but its membership survives - restore the file and the track is
  /// back in the playlist).
  Stream<List<Track>> watchPlaylistTracks(String playlistId) {
    final query =
        select(playlistTracks).join([
            innerJoin(
              tracks,
              tracks.id.equalsExp(playlistTracks.trackId) &
                  tracks.deletedAtMs.isNull(),
            ),
          ])
          ..where(
            playlistTracks.playlistId.equals(playlistId) &
                playlistTracks.deletedAtMs.isNull(),
          )
          ..orderBy([OrderingTerm.asc(playlistTracks.sortKey)]);

    return query.watch().map(
      (rows) => [for (final row in rows) row.readTable(tracks).toEntity()],
    );
  }

  /// Appends a track to the END. Re-adding an existing or tombstoned
  /// membership revives it and moves it to the end (PK is explicit here -
  /// no rowid surprises, cf. playback_states).
  Future<void> addTrack({
    required String playlistId,
    required String trackId,
  }) async {
    final lastKey = playlistTracks.sortKey.max();
    final lastQuery = selectOnly(playlistTracks)
      ..addColumns([lastKey])
      ..where(
        playlistTracks.playlistId.equals(playlistId) &
            playlistTracks.deletedAtMs.isNull(),
      );

    final last = (await lastQuery.getSingle()).read(lastKey);

    await into(playlistTracks).insertOnConflictUpdate(
      PlaylistTracksCompanion(
        playlistId: Value(playlistId),
        trackId: Value(trackId),
        sortKey: Value(generateKeyBetween(last, null)),
        addedAtMs: Value(DateTime.now().millisecondsSinceEpoch),
        deletedAtMs: const Value(null),
      ),
    );
  }

  /// Tombstones the membership (never a hard delete - sync, stage 8).
  Future<void> removeTrack({
    required String playlistId,
    required String trackId,
  }) {
    final query = update(playlistTracks)
      ..where(
        (pt) => pt.playlistId.equals(playlistId) & pt.trackId.equals(trackId),
      );
    return query.write(
      PlaylistTracksCompanion(
        deletedAtMs: Value(DateTime.now().millisecondsSinceEpoch),
      ),
    );
  }

  /// Reorders [trackId] to [newIndex] (FINAL position - the normalized
  /// semantics of ReorderableListView.onReorderItem). The new sort key is
  /// generated BETWEEN the future neighbors; the rest of the list is not
  /// touched - the whole point of fractional indexing.
  Future<void> moveTrackToIndex({
    required String playlistId,
    required String trackId,
    required int newIndex,
  }) async {
    final entries = await _orderedEntries(playlistId);
    final others = [
      for (final entry in entries)
        if (entry.$1 != trackId) entry.$2,
    ];
    if (others.length == entries.length) return; // not in the list

    final to = newIndex.clamp(0, others.length);
    final prev = to == 0 ? null : others[to - 1];
    final next = to == others.length ? null : others[to];

    final query = update(playlistTracks)
      ..where(
        (pt) => pt.playlistId.equals(playlistId) & pt.trackId.equals(trackId),
      );
    await query.write(
      PlaylistTracksCompanion(sortKey: Value(generateKeyBetween(prev, next))),
    );
  }

  /// Alive memberships with alive tracks, in list order - the SAME set and
  /// order watchPlaylistTracks renders, so UI indexes map 1:1.
  Future<List<(String, String)>> _orderedEntries(String playlistId) async {
    final query =
        (select(playlistTracks)
              ..where(
                (pt) =>
                    pt.playlistId.equals(playlistId) & pt.deletedAtMs.isNull(),
              )
              ..orderBy([(pt) => OrderingTerm.asc(pt.sortKey)]))
            .join([
              innerJoin(
                tracks,
                tracks.id.equalsExp(playlistTracks.trackId) &
                    tracks.deletedAtMs.isNull(),
              ),
            ]);
    final rows = await query.get();
    return [
      for (final row in rows)
        (row.read(playlistTracks.trackId)!, row.read(playlistTracks.sortKey)!),
    ];
  }
}
