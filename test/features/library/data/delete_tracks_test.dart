import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sync_music/core/database/app_database.dart' hide Track;
import 'package:sync_music/core/logging/app_logger.dart';
import 'package:sync_music/features/library/data/datasources/file_deleter.dart';
import 'package:sync_music/features/library/data/datasources/library_dao.dart';
import 'package:sync_music/features/library/data/services/delete_tracks.dart';
import 'package:sync_music/features/library/domain/entities/track.dart';

/// "Deletes" everything except [keep], recording the calls.
class _FakeDeleter implements FileDeleter {
  new({this.keep = const {}});

  final Set<String> keep;
  final calls = <List<String>>[];

  @override
  Future<List<String>> deleteFiles(List<String> paths) async {
    calls.add(paths);
    return paths.where((p) => !keep.contains(p)).toList();
  }
}

void main() {
  setUpAll(AppLogger.init);

  late AppDatabase db;
  late LibraryDao dao;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    dao = LibraryDao(db);
  });

  tearDown(() async => await db.close());

  Future<Track> seedTrack(String id, {String? localPath}) async {
    await db
        .into(db.tracks)
        .insert(
          TracksCompanion.insert(
            id: id,
            contentHash: 'h-$id',
            title: 'T$id',
            addedAtMs: 0,
            updatedAtMs: 0,
            localPath: Value(localPath),
          ),
        );
    return Track(
      id: id,
      contentHash: 'h-$id',
      title: 'T$id',
      artistName: 'Artist',
      localPath: localPath,
    );
  }

  test('confirmed deletions tombstone their rows', () async {
    final track = await seedTrack('t1', localPath: '/music/t1.mp3');
    final delete = DeleteTracks(deleter: _FakeDeleter(), tracksDao: dao);

    final result = await delete([track]);

    expect(result, (deleted: 1, failed: 0));
    expect(await dao.watchTracks().first, isEmpty);
    // Tombstone, not a hard delete - the row survives for revival/sync.
    final rows = await db.select(db.tracks).get();
    expect(rows.single.deletedAtMs, isNotNull);
  });

  test('a failed file delete keeps the row alive', () async {
    final track = await seedTrack('t1', localPath: '/music/locked.mp3');
    final delete = DeleteTracks(
      deleter: _FakeDeleter(keep: {'/music/locked.mp3'}),
      tracksDao: dao,
    );

    final result = await delete([track]);

    expect(result, (deleted: 0, failed: 1));
    expect(await dao.watchTracks().first, hasLength(1));
  });

  test('phantom tracks (no local path) never reach the deleter', () async {
    final phantom = await seedTrack('p1');
    final deleter = _FakeDeleter();
    final delete = DeleteTracks(deleter: deleter, tracksDao: dao);

    final result = await delete([phantom]);

    expect(result, (deleted: 0, failed: 1));
    expect(deleter.calls, isEmpty);
  });

  test('mixed batch: only confirmed files are tombstoned', () async {
    final ok = await seedTrack('ok', localPath: '/music/ok.mp3');
    final locked = await seedTrack('locked', localPath: '/music/locked.mp3');
    final delete = DeleteTracks(
      deleter: _FakeDeleter(keep: {'/music/locked.mp3'}),
      tracksDao: dao,
    );

    final result = await delete([ok, locked]);

    expect(result, (deleted: 1, failed: 1));
    final alive = await dao.watchTracks().first;
    expect(alive.map((t) => t.id), ['locked']);
  });
}
