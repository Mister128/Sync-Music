import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sync_music/features/library/data/library_providers.dart';
import 'package:sync_music/features/library/domain/entities/track.dart';
import 'package:sync_music/features/library/domain/repositories/library_repository.dart';
import 'package:sync_music/features/library/domain/repositories/library_repository_impl.dart';

final libraryRepositoryProvider = Provider<LibraryRepository>(
  (ref) => LibraryRepositoryImpl(ref.watch(libraryDaoProvider)),
);

final tracksProvider = StreamProvider<List<Track>>(
  (ref) => ref.watch(libraryRepositoryProvider).watchTracks(),
);
