import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:sync_music/core/database/app_database.dart' as db;
import 'package:sync_music/core/database/database_provider.dart';
import 'package:sync_music/features/library/data/datasources/artwork_store.dart';
import 'package:sync_music/features/library/data/datasources/library_dao.dart';
import 'package:sync_music/features/library/data/datasources/library_roots_dao.dart';
import 'package:sync_music/features/library/data/repositories/library_repository.dart';
import 'package:sync_music/features/library/data/repositories/library_repository_impl.dart';
import 'package:sync_music/features/library/data/services/extract_artwork.dart';
import 'package:sync_music/features/library/data/services/rescan_library.dart';
import 'package:sync_music/features/library/domain/entities/album.dart';
import 'package:sync_music/features/library/domain/entities/artist.dart';
import 'package:sync_music/features/library/domain/entities/track.dart';

final libraryDaoProvider = Provider<LibraryDao>(
  (ref) => LibraryDao(ref.watch(databaseProvider)),
);

final libraryRootsDaoProvider = Provider<LibraryRootsDao>(
  (ref) => LibraryRootsDao(ref.watch(databaseProvider)),
);

/// Emits a new list automatically whenever the table changes -
/// the UI never refreshes itself manually.
final libraryRootsProvider = StreamProvider<List<db.LibraryRoot>>(
  (ref) => ref.watch(libraryRootsDaoProvider).watchRoots(),
);

final rescanLibraryProvider = Provider<RescanLibrary>(
  (ref) => RescanLibrary(
    db: ref.watch(databaseProvider),
    tracksDao: ref.watch(libraryDaoProvider),
    rootsDao: ref.watch(libraryRootsDaoProvider),
  ),
);

/// Binds the domain interface to today's drift implementation.
/// The wiring lives in data/ so that domain/ imports nothing.
final libraryRepositoryProvider = Provider<LibraryRepository>(
  (ref) => LibraryRepositoryImpl(ref.watch(libraryDaoProvider)),
);

/// What UI pages actually watch: live domain entities.
final tracksProvider = StreamProvider<List<Track>>(
  (ref) => ref.watch(libraryRepositoryProvider).watchTracks(),
);

final artworkStoreProvider = Provider<ArtworkStore>(
  (ref) => const ArtworkStore(),
);

/// Background artwork extraction. Long-lived on purpose: the `_running`
/// reentrancy guard lives on the instance.
final extractArtworkProvider = Provider<ExtractArtwork>(
  (ref) => ExtractArtwork(
    tracksDao: ref.watch(libraryDaoProvider),
    store: ref.watch(artworkStoreProvider),
  ),
);

final albumProvider = StreamProvider<List<Album>>(
  (ref) => ref.watch(libraryRepositoryProvider).watchAlbums(),
);

final artistProvider = StreamProvider<List<Artist>>(
  (ref) => ref.watch(libraryRepositoryProvider).watchArtists(),
);

/// Detail pages. The album family key is a RECORD - records have structural
/// equality, so they work as cache keys out of the box.
final StreamProviderFamily<
  List<Track>,
  ({String albumTitle, String artistName})
>
albumTracksProvider =
    StreamProvider.family<
      List<Track>,
      ({String albumTitle, String artistName})
    >(
      (ref, key) => ref
          .watch(libraryRepositoryProvider)
          .watchAlbumTracks(
            albumTitle: key.albumTitle,
            artistName: key.artistName,
          ),
    );

final StreamProviderFamily<List<Track>, String> artistTracksProvider =
    StreamProvider.family<List<Track>, String>(
      (ref, artistName) =>
          ref.watch(libraryRepositoryProvider).watchArtistTracks(artistName),
    );
