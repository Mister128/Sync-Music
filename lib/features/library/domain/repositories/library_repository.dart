import 'package:sync_music/features/library/domain/entities/track.dart';

/// What the presentation layer is allowed to know about the library.
/// Implementations (drift today, something else tomorrow) live in data/.

abstract interface class LibraryRepository {
  /// Live list of non-deleted tracks, ready for the UI.
  Stream<List<Track>> watchTracks();

  // TODO(Mister128): Grow later watchAlbums(), watchArtists(), search(), ...
}
