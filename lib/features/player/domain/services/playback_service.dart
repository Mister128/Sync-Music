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

  Future<void> play();
  Future<void> pause();
  Future<void> togglePlay();
  Future<void> seek(Duration position);
  Future<void> skipNext();
  Future<void> skipPrevious();

  Future<void> insertNext(Track track);
  Future<void> addToQueue(Track track);
  Future<void> moveQueueItem(int from, int to);
  Future<void> removeQueueItem(int index);

  Future<void> setRepeatMode(RepeatMode mode);
  Future<void> setShuffleEnabled({required bool enabled});

  Future<void> dispose();
}
