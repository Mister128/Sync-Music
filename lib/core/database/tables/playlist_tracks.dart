import 'package:drift/drift.dart';

/// Playlist membership: which track, in which order.
///
/// sort_key is a FRACTIONAL INDEX (core/utils/tractional_index.dart):
/// inserting between two neighbours never renumbers the list
///
/// PK (playlistId, trackId): a track appears at most ONCE per playlist -
/// deliberate, unlike the play queue: it keeps membership a clean LWW row
/// for sync
class PlaylistTracks extends Table {
  TextColumn get playlistId => text()();
  TextColumn get trackId => text()();
  TextColumn get sortKey => text()();
  IntColumn get addedAtMs => integer()();
  IntColumn get deletedAtMs => integer().nullable()(); // tombstone

  @override
  Set<Column<Object>>? get primaryKey => {playlistId, trackId};
}
