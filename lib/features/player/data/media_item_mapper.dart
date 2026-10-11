import 'package:audio_service/audio_service.dart';

import 'package:sync_music/core/storage/artwork_paths.dart';
import 'package:sync_music/features/library/domain/entities/track.dart';

/// Track -> MediaItem: the system media UI (notification, lockscreen,
/// Android Auto) speaks MediaItem, the app speaks Track.
///
/// Pure mapping, no side effects. Cover URIs go through artWorkFileFor()
/// (same content-addressed store the UI tiles use), which requires
/// initArtWorkDir() from bootstrap - tests pass a temp base dir instead.
MediaItem trackToMediaItem(Track track) {
  final artworkHash = track.artworkHash;
  final durationMs = track.durationMs;

  return MediaItem(
    id: track.id,
    title: track.title,
    artist: track.artistName,
    album: track.albumTitle,
    duration: durationMs == null ? null : Duration(milliseconds: durationMs),
    artUri: artworkHash == null ? null : artWorkFileFor(artworkHash).uri,
  );
}
