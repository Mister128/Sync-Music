import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';

import 'package:sync_music/core/database/tables/library_roots.dart';
import 'package:sync_music/core/database/tables/tracks.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Tracks, LibraryRoots])
class AppDatabase extends _$AppDatabase {
  /// Production: file-backed DB, drift_flutter handles paths per platform.
  new()
    : super(
        driftDatabase(
          name: 'sync_music',
          native: const DriftNativeOptions(
            databaseDirectory: getApplicationSupportDirectory,
          ),
        ),
      );

  /// Tests: in-memory, no files, fast.
  new forTesting(super.e);

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await customStatement(
          'ALTER TABLE tracks RENAME COLUMN delete_at_ms TO deleted_at_ms',
        );
        await customStatement(
          'ALTER TABLE tracks ADD COLUMN track_number INTEGER',
        );
        await customStatement(
          'ALTER TABLE tracks ADD COLUMN disc_number INTEGER',
        );
        await customStatement('ALTER TABLE tracks ADD COLUMN year INTEGER');
        await customStatement('ALTER TABLE tracks ADD COLUMN genre TEXT');
        await customStatement('ALTER TABLE tracks ADD COLUMN bitrate INTEGER');
        await customStatement(
          'ALTER TABLE tracks ADD COLUMN sample_rate INTEGER',
        );
      }
    },
  );
}
