import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

import 'package:sync_music/core/database/app_database.dart';
import 'package:sync_music/core/logging/app_logger.dart';
import 'package:sync_music/features/library/data/datasources/artwork_store.dart';
import 'package:sync_music/features/library/data/datasources/library_dao.dart';
import 'package:sync_music/features/library/data/services/extract_artwork.dart';
import 'package:sync_music/features/library/domain/entities/scanned_track.dart';

/// Deterministic stand-in for the real store: no audio files, no isolates.
class _FakeArtworkStore implements ArtworkStore {
  final List<String> called = [];

  @override
  Future<({String? hash, String? warning})> storeFromAudio(
    String audioPath,
  ) async {
    called.add(audioPath);
    final name = p.basename(audioPath);
    if (name.contains('nocover')) return (hash: null, warning: null);
    if (name.contains('broken')) {
      return (hash: null, warning: 'fake extraction failure');
    }
    return (hash: 'hash-of-$name', warning: null);
  }
}

void main() {
  setUpAll(AppLogger.init);

  late AppDatabase db;
  late LibraryDao dao;
  late _FakeArtworkStore store;
  late ExtractArtwork extract;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    dao = LibraryDao(db);
    store = _FakeArtworkStore();
    extract = ExtractArtwork(tracksDao: dao, store: store);
  });

  tearDown(() async => await db.close());

  Future<void> insertTrack(
      String title, {
        String? localPath,
        bool remote = false,
        bool deleted = false,
      }) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    await dao.insertAllAtomic([
      TracksCompanion.insert(
        id: 'id-$title',
        contentHash: 'ch-$title',
        title: title,
        addedAtMs: now,
        updatedAtMs: now,
        // remote = P2P phantom row: metadata only, no file on this device.
        localPath: Value(remote ? null : localPath ?? '/music/$title.mp3'),
        deletedAtMs: Value(deleted ? now : null),
      ),
    ]);
  }

  ScannedTrack scannedFrom(Track row) => ScannedTrack(
    path: row.localPath!,
    sizeBytes: row.sizeBytes,
    mtimeMs: row.fileMtimeMs ?? 0,
    contentHash: row.contentHash,
    title: row.title,
    artistName: row.artistName,
  );

  group('tracksMissingArtwork query', () {
    test('pending = alive + file-backed + never checked', () async {
      await insertTrack('queued');
      await insertTrack('remote', remote: true); // P2P phantom row
      await insertTrack('deleted', deleted: true); // tombstone

      final pending = await dao.tracksMissingArtwork();

      expect(pending.map((t) => t.title), ['queued']);
    });

    test('checked rows drop out - with or without a cover', () async {
      await insertTrack('with_cover');
      await insertTrack('without_cover');

      await dao.updateArtworkHash('id-with_cover', 'abc123');
      await dao.updateArtworkHash('id-without_cover', null);

      expect(await dao.tracksMissingArtwork(), isEmpty);
    });
  });

  group('ExtractArtwork pass', () {
    test(
      'stores hashes, stamps cover-less files, one DB write per track',
      () async {
        await insertTrack('song');
        await insertTrack('song_nocover');

        final stored = await extract();

        expect(stored, 1);
        expect(store.called, ['/music/song.mp3', '/music/song_nocover.mp3']);

        final song = await dao.getAllOnce().then(
          (rows) => rows.firstWhere((t) => t.id == 'id-song'),
        );
        expect(song.artworkHash, 'hash-of-song.mp3');
        expect(song.artworkCheckedAtMs, isNotNull);

        final bare = await dao.getAllOnce().then(
          (rows) => rows.firstWhere((t) => t.id == 'id-song_nocover'),
        );
        expect(bare.artworkHash, isNull);
        expect(bare.artworkCheckedAtMs, isNotNull); // never re-read again
      },
    );

    test('second run reads nothing (incremental)', () async {
      await insertTrack('song');
      await extract();
      store.called.clear();

      final stored = await extract();

      expect(stored, 0);
      expect(store.called, isEmpty);
    });

    test('a broken file stays queued and is retried next run', () async {
      await insertTrack('song_broken');

      expect(await extract(), 0);
      expect(await dao.tracksMissingArtwork(), hasLength(1)); // NOT stamped

      expect(await extract(), 0);
      expect(store.called, hasLength(2)); // retried
    });

    test('re-tagged file is requeued by updateScannedById', () async {
      await insertTrack('song');
      await extract();
      expect(await dao.tracksMissingArtwork(), isEmpty);

      final row = (await dao.getAllOnce()).single;
      await dao.updateScannedById(row.id, scannedFrom(row));

      final pending = await dao.tracksMissingArtwork();
      expect(pending, hasLength(1));
      expect(pending.single.artworkHash, 'hash-of-song.mp3');
    });
  });
}
