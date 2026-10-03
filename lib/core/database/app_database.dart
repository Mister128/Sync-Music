import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';

import 'package:sync_music/core/database/tables/library_roots.dart';
import 'package:sync_music/core/database/tables/tracks.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Tracks, LibraryRoots])
class AppDatabase extends _$AppDatabase {
  /// Production: file-backed DB, drift_flutter handles paths per platform.
  AppDatabase()
    : super(
        driftDatabase(
          name: 'sync_music',
          native: const DriftNativeOptions(
            databaseDirectory: getApplicationSupportDirectory,
          ),
        ),
      );

  /// Tests: in-memory, no files, fast.
  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration =>
      MigrationStrategy(onCreate: (m) => m.createAll());
}
