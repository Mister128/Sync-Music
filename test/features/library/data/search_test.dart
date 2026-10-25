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

  Future<void> seed(
    String id, {
    required String title,
    String artist = 'Unknown artist',
    String? album,
    int? deletedAtMs,
  }) => db
      .into(db.tracks)
      .insert(
        TracksCompanion.insert(
          id: id,
          contentHash: 'h-$id',
          title: title,
          artistName: Value(artist),
          albumTitle: Value(album),
          addedAtMs: 0,
          updatedAtMs: 0,
          deletedAtMs: Value(deletedAtMs),
        ),
      );

  group('searchTracks', () {
    test('prefix match, dead tracks excluded', () async {
      await seed('t1', title: 'Trollsong');
      await seed('t2', title: 'Trollzone', deletedAtMs: 1);
      await seed('t3', title: 'Unrelated');

      final found = await dao.searchTracks('trol');

      expect(found.map((row) => row.id), ['t1']);
    });

    test('matches title, artist AND album columns', () async {
      await seed(
        't1',
        title: 'Song One',
        artist: 'Мумий Тролль',
        album: 'Морская',
      );

      expect((await dao.searchTracks('мумий')).single.id, 't1');
      expect((await dao.searchTracks('морск')).single.id, 't1');
    });

    test('cyrillic case folds (unicode61)', () async {
      await seed('t1', title: 'Владивосток 2000');

      expect((await dao.searchTracks('влади')).single.id, 't1');
      expect((await dao.searchTracks('ВЛАДИ')).single.id, 't1');
    });

    test('index follows re-tags (AU trigger)', () async {
      await seed('t1', title: 'Old Name');
      expect(await dao.searchTracks('old'), hasLength(1));

      await (db.update(db.tracks)..where((t) => t.id.equals('t1'))).write(
        const TracksCompanion(title: Value('Brand New')),
      );

      expect(await dao.searchTracks('old'), isEmpty);
      expect((await dao.searchTracks('brand')).single.id, 't1');
    });

    test('blank query -> empty, FTS operators neutralized', () async {
      await seed('t1', title: 'Plain song');

      expect(await dao.searchTracks('   '), isEmpty);
      expect(await dao.searchTracks('a OR b NEAR(c)'), isEmpty);
    });
  });

  group('section search', () {
    test('albums aggregate over matched titles only', () async {
      await seed('t1', title: 'A', artist: 'Мумий Тролль', album: 'Морская');
      await seed('t2', title: 'B', artist: 'Мумий Тролль', album: 'Морская');
      await seed('t3', title: 'C', artist: 'Someone', album: 'Trolls');

      final albums = await dao.searchAlbums('мор');
      expect(albums.single.albumTitle, 'Морская');
      expect(albums.single.trackCount, 2);

      expect((await dao.searchAlbums('trol')).single.albumTitle, 'Trolls');
    });

    test('artists aggregate album counts', () async {
      await seed('t1', title: 'A', artist: 'Мумий Тролль', album: 'Морская');
      await seed('t2', title: 'B', artist: 'Мумий Тролль', album: 'Икра');

      final artists = await dao.searchArtists('мум');
      expect(artists.single.artistName, 'Мумий Тролль');
      expect(artists.single.albumCount, 2);
      expect(artists.single.trackCount, 2);
    });
  });
}
