import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sync_music/core/database/app_database.dart';
import 'package:sync_music/core/utils/fractional_index.dart';
import 'package:sync_music/features/playlists/data/datasources/playlist_dao.dart';

void main() {
  late AppDatabase db;
  late PlaylistDao dao;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    dao = PlaylistDao(db);
  });

  tearDown(() async => await db.close());

  Future<void> seedTrack(String id, {String? artworkHash, int? deletedAtMs}) =>
      db
          .into(db.tracks)
          .insert(
            TracksCompanion.insert(
              id: id,
              contentHash: 'h-$id',
              title: 'T$id',
              addedAtMs: 0,
              updatedAtMs: 0,
              artworkHash: Value(artworkHash),
              deletedAtMs: Value(deletedAtMs),
            ),
          );

  Future<void> seedMembership(
    String playlistId,
    String trackId, {
    int? deletedAtMs,
  }) => db
      .into(db.playlistTracks)
      .insert(
        PlaylistTracksCompanion.insert(
          playlistId: playlistId,
          trackId: trackId,
          // The first real sort key - 5.1's generateKeyBetween at work.
          sortKey: generateKeyBetween(null, null),
          addedAtMs: 0,
          deletedAtMs: Value(deletedAtMs),
        ),
      );

  test('created playlist shows up in the live stream', () async {
    final id = await dao.createPlaylist('Road trip');

    final playlists = await dao.watchPlaylists().first;
    expect(playlists.single.id, id);
    expect(playlists.single.name, 'Road trip');
    expect(playlists.single.trackCount, 0);
    expect(playlists.single.artworkHash, isNull);
  });

  test('rename flows through the stream', () async {
    final id = await dao.createPlaylist('Old name');

    await dao.renamePlaylist(id, 'New name');

    expect((await dao.watchPlaylists().first).single.name, 'New name');
  });

  test('delete tombstones - the row survives for sync', () async {
    final id = await dao.createPlaylist('Doomed');

    await dao.deletePlaylist(id);

    expect(await dao.watchPlaylists().first, isEmpty);
    final rows = await db.select(db.playlists).get();
    expect(rows.single.deletedAtMs, isNotNull);
  });

  test('aggregates count only alive tracks of alive memberships', () async {
    final id = await dao.createPlaylist('Mix');
    await seedTrack('t1', artworkHash: 'art1');
    await seedTrack('t2', artworkHash: 'art2');
    await seedTrack('t3', artworkHash: 'art3', deletedAtMs: 1);
    await seedMembership(id, 't1');
    await seedMembership(id, 't2', deletedAtMs: 1); // removed from playlist
    await seedMembership(id, 't3'); // library track itself is tombstoned

    final playlist = (await dao.watchPlaylists().first).single;
    expect(playlist.trackCount, 1); // only t1 survives both filters
    expect(playlist.artworkHash, 'art1');
  });

  test('playlists are ordered by name', () async {
    await dao.createPlaylist('Beta');
    await dao.createPlaylist('Alpha');

    final names = (await dao.watchPlaylists().first)
        .map((p) => p.name)
        .toList();
    expect(names, ['Alpha', 'Beta']);
  });
}
