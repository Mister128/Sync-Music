import 'package:drift/drift.dart';

/// User-selected music folders to scan (desktop model).
/// Android/MediaStore will simply ignore roots later.
class LibraryRoots extends Table {
  TextColumn get path => text()();
  IntColumn get addedAtMs => integer()();
  IntColumn get lastScannedAtMs => integer().nullable()();

  @override
  Set<Column<Object>>? get primaryKey => {path};
}