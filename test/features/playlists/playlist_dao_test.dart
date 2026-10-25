import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sync_music/core/database/app_database.dart';
import 'package:sync_music/core/utils/fractional_index.dart';
import 'package:sync_music/features/playlists/data/datasources/playlist_dao.dart';
import 'package:sync_music/features/playlists/domain/entities/playlist.dart';

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

  group('playlist tracks', () {
    test('tracks come back in sort_key order', () async {
      final id = await dao.createPlaylist('Mix');
      for (final t in ['t1', 't2', 't3']) {
        await seedTrack(t);
      }
      // Deliberately out of id order - sort_key decides, not insertion ids.
      await dao.addTrack(playlistId: id, trackId: 't2');
      await dao.addTrack(playlistId: id, trackId: 't1');
      await dao.addTrack(playlistId: id, trackId: 't3');

      final ids = (await dao.watchPlaylistTracks(id).first)
          .map((t) => t.id)
          .toList();
      expect(ids, ['t2', 't1', 't3']);
    });

    test('re-adding moves the track to the end', () async {
      final id = await dao.createPlaylist('Mix');
      await seedTrack('t1');
      await seedTrack('t2');
      await dao.addTrack(playlistId: id, trackId: 't1');
      await dao.addTrack(playlistId: id, trackId: 't2');

      await dao.addTrack(playlistId: id, trackId: 't1');

      final ids = (await dao.watchPlaylistTracks(id).first)
          .map((t) => t.id)
          .toList();
      expect(ids, ['t2', 't1']);
    });

    test('removeTrack tombstones the membership', () async {
      final id = await dao.createPlaylist('Mix');
      await seedTrack('t1');
      await seedTrack('t2');
      await dao.addTrack(playlistId: id, trackId: 't1');
      await dao.addTrack(playlistId: id, trackId: 't2');

      await dao.removeTrack(playlistId: id, trackId: 't1');

      final ids = (await dao.watchPlaylistTracks(id).first)
          .map((t) => t.id)
          .toList();
      expect(ids, ['t2']);
      // Tombstone, not delete: the row survives for sync (stage 8).
      expect(await db.select(db.playlistTracks).get(), hasLength(2));
    });

    test('moveTrackToIndex reorders via neighbor keys only', () async {
      final id = await dao.createPlaylist('Mix');
      for (final t in ['t1', 't2', 't3']) {
        await seedTrack(t);
        await dao.addTrack(playlistId: id, trackId: t);
      }

      Future<List<String>> order() async =>
          (await dao.watchPlaylistTracks(id).first).map((t) => t.id).toList();

      await dao.moveTrackToIndex(
        playlistId: id,
        trackId: 't1',
        newIndex: 2,
      ); // -> end
      expect(await order(), ['t2', 't3', 't1']);

      await dao.moveTrackToIndex(
        playlistId: id,
        trackId: 't1',
        newIndex: 0,
      ); // -> top
      expect(await order(), ['t1', 't2', 't3']);

      await dao.moveTrackToIndex(
        playlistId: id,
        trackId: 't3',
        newIndex: 1,
      ); // -> middle
      expect(await order(), ['t1', 't3', 't2']);
    });

    test(
      'a tombstoned library track disappears but its membership lives',
      () async {
        final id = await dao.createPlaylist('Mix');
        await seedTrack('t1');
        await seedTrack('t2', deletedAtMs: 1); // file deleted, rescan hit it
        await dao.addTrack(playlistId: id, trackId: 't1');
        await dao.addTrack(playlistId: id, trackId: 't2');

        final ids = (await dao.watchPlaylistTracks(id).first)
            .map((t) => t.id)
            .toList();
        expect(ids, ['t1']);
        expect(await db.select(db.playlistTracks).get(), hasLength(2));
      },
    );
  });

  group('favorites', () {
    test('toggle seeds the system playlist and adds the track', () async {
      await seedTrack('t1');

      await dao.toggleFavorite('t1');

      expect(await dao.watchFavoriteIds().first, {'t1'});
      final tracks = await dao.watchPlaylistTracks(kFavoritesPlaylistId).first;
      expect(tracks.map((track) => track.id), ['t1']);
      // The system playlist NEVER shows up in the user-facing stream.
      expect(await dao.watchPlaylists().first, isEmpty);
    });

    test('second toggle tombstones the membership', () async {
      await seedTrack('t1');
      await dao.toggleFavorite('t1');

      await dao.toggleFavorite('t1');

      expect(await dao.watchFavoriteIds().first, isEmpty);
    });

    test('re-toggle revives and appends AT THE END', () async {
      await seedTrack('t1');
      await seedTrack('t2');
      await dao.toggleFavorite('t1');
      await dao.toggleFavorite('t2');

      await dao.toggleFavorite('t1'); // off
      await dao.toggleFavorite('t1'); // on again -> after t2

      final tracks = await dao.watchPlaylistTracks(kFavoritesPlaylistId).first;
      expect(tracks.map((track) => track.id), ['t2', 't1']);
    });

    test('dead track hides from the list but KEEPS its membership', () async {
      await seedTrack('t1');
      await dao.toggleFavorite('t1');

      await (db.update(db.tracks)..where((t) => t.id.equals('t1'))).write(
        const TracksCompanion(deletedAtMs: Value(1)),
      );

      final tracks = await dao.watchPlaylistTracks(kFavoritesPlaylistId).first;
      expect(tracks, isEmpty);
      // Same philosophy as playlists: restore the file -> track is back.
      expect(await dao.watchFavoriteIds().first, {'t1'});
    });
  });
}
