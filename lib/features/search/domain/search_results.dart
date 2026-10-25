import 'package:sync_music/features/library/domain/entities/album.dart';
import 'package:sync_music/features/library/domain/entities/artist.dart';
import 'package:sync_music/features/library/domain/entities/track.dart';

/// Combined outcome of ONE search across the three library sections.
/// A plain immutable value object on purpose: it is a query DTO, not a
/// domain entity - no freezed, nobody needs equality semantics on it.
class SearchResults {
  const new({
    required this.tracks,
    required this.albums,
    required this.artists,
  });

  const new empty() : tracks = const [], albums = const [], artists = const [];

  final List<Track> tracks;
  final List<Album> albums;
  final List<Artist> artists;

  bool get isEmpty => tracks.isEmpty && albums.isEmpty && artists.isEmpty;
}
