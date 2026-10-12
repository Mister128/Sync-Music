import 'package:sync_music/features/library/domain/entities/track.dart';
import 'package:sync_music/features/player/domain/entities/player_snapshot.dart';
import 'package:sync_music/features/player/domain/entities/repeat_mode.dart';

/// The ONLY thing the player UI knows about playback:
/// widgets -> PlayerController -> PlaybackService -> just_audio/audio_service.
abstract interface class PlaybackService {
  /// RARE updates: queue, index, playing flag, modes.
  /// Emits the current snapshot immediately on listen.
  Stream<PlayerSnapshot> watchSnapshot();

  /// FREQUENT updates (~10/s): position of the current track.
  Stream<Duration> watchPosition();

  /// Replaces the whole queue and starts playing from [startIndex].
  /// Tracks without a local file are skipped (future P2P phantoms).
  Future<void> playQueue(List<Track> tracks, {int startIndex = 0});

  Future<void> restoreQueue(
    List<Track> tracks, {
    int startIndex = 0,
    Duration position = Duration.zero,
  });

  Future<void> play();

  Future<void> pause();

  Future<void> togglePlay();

  Future<void> seek(Duration position);

  /// Queue navigation with PRODUCT rules (see skip_policy.dart):
  /// skipPrevious restarts the current track once the position passes the
  /// threshold, otherwise moves back; BOTH directions wrap around the
  /// queue ends circularly.
  Future<void> skipNext();

  Future<void> skipPrevious();

  /// Jumps to the queue item at [index] and starts playing it - both a
  /// queue-page tap and the system's skipToQueueItem expect auto-play.
  /// Out-of-range indexes are ignored. Gapless: unlike playQueue, the
  /// loaded sequence is NOT rebuilt.
  Future<void> playAtIndex(int index);

  Future<void> insertNext(Track track);

  Future<void> addToQueue(Track track);

  Future<void> moveQueueItem(int from, int to);

  Future<void> removeQueueItem(int index);

  Future<void> setRepeatMode(RepeatMode mode);

  Future<void> setShuffleEnabled({required bool enabled});

  Future<void> dispose();
}
