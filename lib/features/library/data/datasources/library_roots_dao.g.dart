// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'library_roots_dao.dart';

// ignore_for_file: type=lint
mixin _$LibraryRootsDaoMixin on DatabaseAccessor<AppDatabase> {
  $LibraryRootsTable get libraryRoots => attachedDatabase.libraryRoots;
  LibraryRootsDaoManager get managers => LibraryRootsDaoManager(this);
}

class LibraryRootsDaoManager {
  final _$LibraryRootsDaoMixin _db;
  LibraryRootsDaoManager(this._db);
  $$LibraryRootsTableTableManager get libraryRoots =>
      $$LibraryRootsTableTableManager(_db.attachedDatabase, _db.libraryRoots);
}
