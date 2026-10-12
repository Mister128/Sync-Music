import 'package:drift/drift.dart';

import 'package:sync_music/core/database/app_database.dart';
import 'package:sync_music/core/database/tables/playback_states.dart';

part 'playback_state_dao.g.dart';

/// The single saved session row. Player-owned data against the shared
/// AppDatabase - same pattern as LibraryDao in the library feature
@DriftAccessor(tables: [PlaybackStates])
class PlaybackStateDao extends DatabaseAccessor<AppDatabase>
    with _$PlaybackStateDaoMixin {
  new(super.attachedDatabase);

  static const int rowId = 0;

  Future<PlaybackStateRow?> read() => (select(
    playbackStates,
  )..where((t) => t.id.equals(rowId))).getSingleOrNull();

  Future<void> upsert(PlaybackStatesCompanion row) =>
      into(playbackStates)
          .insertOnConflictUpdate(row.copyWith(id: const Value(rowId)));
}
