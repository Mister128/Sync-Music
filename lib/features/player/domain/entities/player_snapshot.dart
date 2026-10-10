import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:sync_music/features/library/domain/entities/track.dart';
import 'package:sync_music/features/player/domain/entities/repeat_mode.dart';

part 'player_snapshot.freezed.dart';

/// Everything the player UI needs EXCEPT the ticking position - that one
/// is a separate high-frequency stream (see PlaybackService.watchPosition),
/// so a seek bar never rebuilds whole pages.
@freezed
abstract class PlayerSnapshot with _$PlayerSnapshot {
  const factory({
    required List<Track> queue,
    required int? currentIndex,
    required bool isPlaying,

    /// Duration of the CURRENT track (null until it is loaded).
    required Duration? duration,
    required RepeatMode repeatMode,
    required bool shuffleEnabled,
  }) = _PlayerSnapshot;
}

extension PlayerSnapshotX on PlayerSnapshot {
  /// Null until something is actually playing. Bounds-checked: the index
  /// can briefly point past the queue while edits are in flight.
  Track? get currentTrack {
    final index = currentIndex;
    if (index == null || index < 0 || index >= queue.length) return null;
    return queue[index];
  }
}
