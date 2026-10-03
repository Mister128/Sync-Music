import 'package:drift/drift.dart';

import 'package:sync_music/core/database/tables/tracks.dart';
import 'package:sync_music/core/database/app_database.dart';

part 'library_dao.g.dart';

@DriftAccessor(tables: [Tracks])
class LibraryDao extends DatabaseAccessor<AppDatabase> with _$LibraryDaoMixin {
  LibraryDao(super.db);

  Stream<List<Track>> watchTracks() {
    final query = select(tracks)..where((t) => t.deleteAtMs.isNull());
    return query.watch();
  }

  Future<List<Track>> getAllOnce() => select(tracks).get();

  Future<void> insertAllAtomic(List<TracksCompanion> rows) =>
      batch((b) => b.insertAll(tracks, rows));

  // TODO: updateTrack, markDeleted (tombstone), lookup by path...
}
