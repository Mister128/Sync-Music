import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sync_music/core/database/app_database.dart';
import 'package:sync_music/core/database/database_provider.dart';
import 'package:sync_music/features/library/data/datasources/library_dao.dart';
import 'package:sync_music/features/library/data/datasources/library_roots_dao.dart';
import 'package:sync_music/features/library/data/services/rescan_library.dart';

final libraryDaoProvider = Provider<LibraryDao>(
  (ref) => LibraryDao(ref.watch(databaseProvider)),
);

final libraryRootsDaoProvider = Provider<LibraryRootsDao>(
  (ref) => LibraryRootsDao(ref.watch(databaseProvider)),
);

/// Emits a new list automatically whenever the table changes -
/// the UI never refreshes itself manually.
final libraryRootsProvider = StreamProvider<List<LibraryRoot>>(
  (ref) => ref.watch(libraryRootsDaoProvider).watchRoots(),
);

final rescanLibraryProvider = Provider<RescanLibrary>(
  (ref) => RescanLibrary(
    db: ref.watch(databaseProvider),
    tracksDao: ref.watch(libraryDaoProvider),
    rootsDao: ref.watch(libraryRootsDaoProvider),
  ),
);
