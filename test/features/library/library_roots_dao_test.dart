import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sync_music/core/database/app_database.dart';
import 'package:sync_music/features/library/data/datasources/library_roots_dao.dart';

void main() {
  late AppDatabase db;
  late LibraryRootsDao dao;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    dao = LibraryRootsDao(db);
  });

  tearDown(() => db.close());

  test('addRoot: folder appears in the watched list', () async {
    await dao.addRoot(r'D:\Music');

    final roots = await dao.watchRoots().first;

    expect(roots, hasLength(1));
    expect(roots.single.path, r'D:\Music');
    expect(roots.single.addedAtMs, greaterThan(0));
    expect(roots.single.lastScannedAtMs, isNull);
  });

  test('addRoot twice with the same path: no crash, no duplicate', () async {
    await dao.addRoot(r'D:\Music');
    await dao.addRoot(r'D:\Music'); // InsertMode.insertOrIgnore kicks in

    final roots = await dao.watchRoots().first;
    expect(roots, hasLength(1));
  });

  test('removeRoot: only the removed folder disappears', () async {
    await dao.addRoot(r'D:\Music');
    await dao.addRoot(r'E:\Downloads\Music');

    await dao.removeRoot(r'D:\Music');

    final roots = await dao.watchRoots().first;
    expect(roots.map((r) => r.path), [r'E:\Downloads\Music']);
  });

  test(
    'watchRoots re-emits when the table changes (the UI relies on this!)',
    () async {
      await dao.addRoot(r'D:\Music');

      final expectation = expectLater(
        dao.watchRoots(),
        emitsThrough(hasLength(2)),
      );

      await dao.addRoot(r'E:\Audio');

      await expectation;
    },
  );
}
