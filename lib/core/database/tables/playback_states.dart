import 'package:drift/drift.dart';

@DataClassName('PlaybackStateRow')
class PlaybackStates extends Table {
  /// Always PlaybackStateDao.rowId - the table never grows past one row.
  IntColumn get id => integer().withDefault(const Constant(0))();

  /// JSON array of track ids in queue order. Duplicates allowed: the
  /// queue page lets the same track be added twice.
  TextColumn get queueTrackIds => text()();

  /// Saved together on purpose: the INDEX is exact even with duplicate
  /// tracks; the ID survives dead-track filtering on restore. The rule
  /// combining them lives in domain/services/restore_policy.dart.
  IntColumn get currentIndex => integer()();
  TextColumn get currentTrackId => text().nullable()();

  IntColumn get positionMs => integer()();

  /// RepeatMode.index - the enum ORDER is part of the persisted format:
  /// never reorder it, only append.
  IntColumn get repeatMode => integer().withDefault(const Constant(0))();

  BoolColumn get shuffleEnabled =>
      boolean().withDefault(const Constant(false))();

  IntColumn get updatedAtMs => integer()();

  @override
  Set<Column<Object>>? get primaryKey => {id};
}
