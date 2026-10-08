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
  Future<void> addRoot(String path) => into(libraryRoots).insert(
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

  /// One-shot snapshot of all music folders.
  /// For a live UI list use [watchRoots]; this one is for logic that needs
  /// the current state exactly once (e.g. the rescan orchestrator).
  Future<List<LibraryRoot>> getAllOnce() => select(libraryRoots).get();

  /// Stamps the folder with "scanned at" - settings UI shows it later.
  Future<void> markScanned(String path) {
    final query = update(libraryRoots)..where((r) => r.path.equals(path));
    return query.write(
      LibraryRootsCompanion(
        lastScannedAtMs: Value(DateTime.now().millisecondsSinceEpoch),
      ),
    );
  }
}
