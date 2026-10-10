import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sync_music/core/database/app_database.dart';
import 'package:sync_music/features/library/data/datasources/library_dao.dart';

void main() {
  late AppDatabase db;
  late LibraryDao dao;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    dao = LibraryDao(db);
  });

  tearDown(() async => await db.close());

  Future<void> insert({
    required String id,
    required String title,
    required String artist,
    String? album,
    String? artworkHash,
    int? discNumber,
    int? trackNumber,
    bool deleted = false,
  }) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    await dao.insertAllAtomic([
      TracksCompanion.insert(
        id: id,
        contentHash: 'ch-$id',
        title: title,
        addedAtMs: now,
        updatedAtMs: now,
        artistName: Value(artist),
        albumTitle: Value(album),
        artworkHash: Value(artworkHash),
        discNumber: Value(discNumber),
        trackNumber: Value(trackNumber),
        deletedAtMs: Value(deleted ? now : null),
      ),
    ]);
  }

  group('watchAlbums', () {
    test(
      'groups by (album, artist), counts tracks, ignores tombstones',
      () async {
        await insert(
          id: '1',
          title: 'One',
          artist: 'Queen',
          album: 'Opera',
          artworkHash: 'art-b',
        );
        await insert(
          id: '2',
          title: 'Two',
          artist: 'Queen',
          album: 'Opera',
          artworkHash: 'art-a',
        );
        await insert(id: '3', title: 'Three', artist: 'Queen', album: 'News');
        await insert(
          id: '4',
          title: 'Gone',
          artist: 'Queen',
          album: 'Opera',
          deleted: true,
        );
        await insert(id: '5', title: 'No album', artist: 'Queen');

        final albums = await dao.watchAlbums().first;

        expect(albums, hasLength(2)); // 'No album' never appears
        expect(albums[0].albumTitle, 'News'); // ordered by title
        expect(albums[0].trackCount, 1);
        expect(albums[1].albumTitle, 'Opera');
        expect(albums[1].trackCount, 2); // tombstone excluded
      },
    );

    test(
      'cover = any non-null artwork of the album (MIN ignores NULLs)',
      () async {
        await insert(id: '1', title: 'One', artist: 'Queen', album: 'Opera');
        await insert(
          id: '2',
          title: 'Two',
          artist: 'Queen',
          album: 'Opera',
          artworkHash: 'art-z',
        );
        await insert(id: '3', title: 'Bare', artist: 'Someone', album: 'Bare');

        final albums = await dao.watchAlbums().first;

        expect(
          albums.firstWhere((a) => a.albumTitle == 'Opera').artworkHash,
          'art-z',
        );
        expect(
          albums.firstWhere((a) => a.albumTitle == 'Bare').artworkHash,
          isNull,
        );
      },
    );

    test('same title from different artists = ONE merged album', () async {
      await insert(id: '1', title: 'A', artist: 'Queen', album: 'Download');
      await insert(id: '2', title: 'B', artist: 'Someone', album: 'Download');

      final albums = await dao.watchAlbums().first;

      expect(albums, hasLength(1));
      expect(albums.single.trackCount, 2);
      // Representative artist: MIN = alphabetically first.
      expect(albums.single.artistName, 'Queen');
    });
  });

  group('watchArtists', () {
    test('counts tracks and DISTINCT albums; tombstones excluded', () async {
      await insert(id: '1', title: 'One', artist: 'Queen', album: 'Opera');
      await insert(id: '2', title: 'Two', artist: 'Queen', album: 'Opera');
      await insert(id: '3', title: 'Three', artist: 'Queen', album: 'News');
      await insert(id: '4', title: 'Single', artist: 'Queen');
      await insert(
        id: '5',
        title: 'Gone',
        artist: 'Queen',
        album: 'Opera',
        deleted: true,
      );

      final artists = await dao.watchArtists().first;

      expect(artists.single.artistName, 'Queen');
      expect(artists.single.trackCount, 4);
      expect(artists.single.albumCount, 2); // 'Single' has no album
    });
  });

  group('detail streams', () {
    test('album key = title only: all artists merged, disc -> track order',
            () async {
          await insert(
            id: '1', title: 'B', artist: 'Queen', album: 'Opera',
            discNumber: 1, trackNumber: 2,
          );
          await insert(
            id: '2', title: 'A', artist: 'Queen', album: 'Opera',
            discNumber: 1, trackNumber: 1,
          );
          await insert(
            id: '3', title: 'C', artist: 'Queen', album: 'Opera',
            discNumber: 2, trackNumber: 1,
          );
          await insert(
            id: '4', title: 'Guest', artist: 'Someone', album: 'Opera',
            discNumber: 1, trackNumber: 3,
          );

          final tracks = await dao.watchAlbumTracks('Opera').first;

          expect(tracks.map((t) => t.title), ['A', 'B', 'Guest', 'C']);
        });

    test('artist tracks are grouped by album', () async {
      await insert(
        id: '1',
        title: 'Z',
        artist: 'Queen',
        album: 'Opera',
        trackNumber: 1,
        artworkHash: 'art-a'
      );
      await insert(
        id: '2',
        title: 'Y',
        artist: 'Queen',
        album: 'Aah',
        trackNumber: 5,
        artworkHash: 'art-b'
      );

      final tracks = await dao.watchArtistTracks('Queen').first;

      expect(tracks.map((t) => t.albumTitle), ['Aah', 'Opera']);
    });

    test('albums stream re-emits when the library changes', () async {
      await insert(id: '1', title: 'One', artist: 'Queen', album: 'Opera');

      final expectation = expectLater(
        dao.watchAlbums(),
        emitsThrough(hasLength(2)),
      );

      await insert(id: '2', title: 'Two', artist: 'Queen', album: 'News');

      await expectation;
    });
  });
}
