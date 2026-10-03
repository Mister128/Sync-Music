import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sync_music/core/database/database_provider.dart';
import 'package:sync_music/features/library/data/datasources/library_dao.dart';

final libraryDaoProvider = Provider<LibraryDao>(
  (ref) => LibraryDao(ref.watch(databaseProvider)),
);
