import 'package:drift/drift.dart';

/// User playlists. Row class renamed (PlatlistRow) to avoid colliding with
/// the domain entity
@DataClassName('PlaylistRow')
class Playlists extends Table {
  TextColumn get id => text()(); // UUIDv7
  TextColumn get name => text()();

  BoolColumn get isSystem => boolean().withDefault(const Constant(false))();

  IntColumn get createdAtMs => integer()();
  IntColumn get updatedAtMs => integer()();
  IntColumn get deletedAtMs => integer().nullable()(); //tombstone

  @override
  Set<Column<Object>>? get primaryKey => {id};
}
