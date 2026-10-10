import 'package:sync_music/features/library/domain/entities/album.dart';
import 'package:sync_music/features/library/domain/entities/artist.dart';
import 'package:sync_music/features/library/domain/entities/track.dart';

/// What the presentation layer is allowed to know about the library.
/// Implementations (drift today, something else tomorrow) live in data/.

abstract interface class LibraryRepository {
  /// Live list of non-deleted tracks, ready for the UI.
  Stream<List<Track>> watchTracks();

  /// Albums/artists are DERIVED from tracks (GROUP BY) - no separate tables,
  /// so they can never go out of sync with the library.
  Stream<List<Album>> watchAlbums();

  Stream<List<Artist>> watchArtists();

  /// Playing order within one album (disc -> track number -> title).
  Stream<List<Track>> watchAlbumTracks({
    required String albumTitle,
    required String artistName,
  });

  /// All tracks of one artist, grouped by album.
  Stream<List<Track>> watchArtistTracks(String artistName);

  // TODO(Mister128): Grow later search(), watchFolders()...
}
