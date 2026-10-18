import 'package:drift/drift.dart';

import 'package:sync_music/core/database/app_database.dart';
import 'package:sync_music/core/database/tables/playlist_tracks.dart';
import 'package:sync_music/core/database/tables/playlists.dart';
import 'package:sync_music/core/database/tables/tracks.dart';
import 'package:sync_music/core/utils/ids.dart';
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
}
