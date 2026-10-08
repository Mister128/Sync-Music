import 'package:drift/drift.dart';
import 'package:sync_music/core/database/app_database.dart';
import 'package:sync_music/core/database/tables/library_roots.dart';

part 'library_roots_dao.g.dart';

@DriftAccessor(tables: [LibraryRoots])
class LibraryRootsDao extends DatabaseAccessor<AppDatabase>
    with _$LibraryRootsDaoMixin {
  new(super.attachedDatabase);

  /// Live list of music folders for the settings UI.
  Stream<List<LibraryRoot>> watchRoots() => select(libraryRoots).watch();

  /// Adds a folder; duplicates are ignored silently (path is the PK -
  /// picking the same folder twice must not crash).
  Future<void> addRoot(String path) async => await into(libraryRoots).insert(
    LibraryRootsCompanion.insert(
      path: path,
      addedAtMs: DateTime.now().millisecondsSinceEpoch,
    ),
    mode: InsertMode.insertOrIgnore,
  );

  /// Drops a folder from the library (files on disk are untouched).
  Future<void> removeRoot(String path) {
    final query = delete(libraryRoots)..where((r) => r.path.equals(path));
    return query.go();
  }
}
