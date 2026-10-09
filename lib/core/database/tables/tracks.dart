import 'package:drift/drift.dart';

class Tracks extends Table {
  TextColumn get id => text()();
  TextColumn get contentHash => text().unique()();
  TextColumn get title => text()();
  TextColumn get artistName =>
      text().withDefault(const Constant('Unknown artist'))();
  TextColumn get albumTitle => text().nullable()();
  IntColumn get durationMs => integer().nullable()();
  TextColumn get localPath => text().nullable()();
  IntColumn get sizeBytes => integer().withDefault(const Constant(0))();
  IntColumn get fileMtimeMs => integer().nullable()();
  TextColumn get artworkHash => text().nullable()();
  IntColumn get artworkCheckedAtMs => integer().nullable()();
  IntColumn get addedAtMs => integer()();
  IntColumn get updatedAtMs => integer()();
  IntColumn get deletedAtMs => integer().nullable()();
  IntColumn get trackNumber => integer().nullable()();
  IntColumn get discNumber => integer().nullable()();
  IntColumn get bitrate => integer().nullable()();
  IntColumn get sampleRate => integer().nullable()();
  IntColumn get year => integer().nullable()();
  TextColumn get genre => text().nullable()();

  @override
  Set<Column<Object>>? get primaryKey => {id};
}
