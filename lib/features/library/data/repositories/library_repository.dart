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

  /// Playing order within one album; the title is the whole key.
  Stream<List<Track>> watchAlbumTracks(String albumTitle);

  /// All tracks of one artist, grouped by album.
  Stream<List<Track>> watchArtistTracks(String artistName);

  /// One-shot search. Tracks come in FTS rank order; albums and
  /// artists are matched names with the usual aggregates. A blank query
  /// yields empty lists without touching the database.
  Future<List<Track>> searchTracks(String query);

  Future<List<Album>> searchAlbums(String query);

  Future<List<Artist>> searchArtists(String query);
}
