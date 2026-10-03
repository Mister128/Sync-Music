import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sync_music/core/database/app_database.dart';
import 'package:sync_music/features/library/data/datasources/library_dao.dart';

void main() {
  late AppDatabase db;

  setUp(() => db = AppDatabase.forTesting(NativeDatabase.memory()));
  tearDown(() => db.close());

  test('inserted track is visible via dao', () async {
    final dao = LibraryDao(db);
    final now = DateTime.now().millisecondsSinceEpoch;

    await dao.insertAllAtomic([
      TracksCompanion.insert(
        id: 'test-id-1',
        contentHash: 'hash-1',
        title: 'Test Track',
        addedAtMs: now,
        updatedAtMs: now,
      ),
    ]);

    final rows = await dao.getAllOnce();
    expect(rows.single.title, 'Test Track');
  });
}
