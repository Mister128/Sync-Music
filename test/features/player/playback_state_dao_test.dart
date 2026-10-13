import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sync_music/core/database/app_database.dart';
import 'package:sync_music/features/player/data/playback_state_dao.dart';

void main() {
  late AppDatabase db;
  late PlaybackStateDao dao;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    dao = PlaybackStateDao(db);
  });

  tearDown(() async => await db.close());

  PlaybackStatesCompanion row(int positionMs) => PlaybackStatesCompanion(
    queueTrackIds: const Value('["a"]'),
    currentIndex: const Value(0),
    currentTrackId: const Value('a'),
    positionMs: Value(positionMs),
    updatedAtMs: const Value(0),
  );

  test('read on a fresh database is null', () async {
    expect(await dao.read(), isNull);
  });

  test('upserts keep exactly ONE row at id 0 (SQLite rowid trap)', () async {
    // INTEGER PRIMARY KEY = rowid alias: an omitted id would be
    // auto-assigned 1, 2, ... ignoring the DEFAULT - the dao forces it.
    await dao.upsert(row(100));
    await dao.upsert(row(200));

    final saved = await dao.read();
    expect(saved, isNotNull);
    expect(saved!.positionMs, 200); // second upsert UPDATED, not appended

    final all = await db.select(db.playbackStates).get();
    expect(all, hasLength(1));
    expect(all.single.id, PlaybackStateDao.rowId);
  });
}
