import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sync_music/features/library/domain/entities/track.dart';
import 'package:sync_music/features/player/data/player_providers.dart';
import 'package:sync_music/features/player/domain/entities/player_snapshot.dart';
import 'package:sync_music/features/player/domain/entities/repeat_mode.dart';

/// The ONLY player object widgets touch: mirrors the service snapshot into
/// Riverpod state and relays commands. ZERO playback logic here - the
/// service is the source of truth.
class PlayerController extends Notifier<PlayerSnapshot> {
  static const _empty = PlayerSnapshot(
    queue: [],
    currentIndex: null,
    isPlaying: false,
    duration: null,
    repeatMode: RepeatMode.off,
    shuffleEnabled: false,
  );

  @override
  PlayerSnapshot build() {
    final service = ref.watch(playbackServiceProvider);
    final sub = service.watchSnapshot().listen((snapshot) => state = snapshot);
    ref.onDispose(sub.cancel);
    return _empty;
  }

  Future<void> playQueue(List<Track> tracks, {int startIndex = 0}) => ref
      .read(playbackServiceProvider)
      .playQueue(tracks, startIndex: startIndex);

  Future<void> togglePlay() => ref.read(playbackServiceProvider).togglePlay();

  Future<void> seek(Duration position) =>
      ref.read(playbackServiceProvider).seek(position);

  Future<void> skipNext() => ref.read(playbackServiceProvider).skipNext();

  Future<void> skipPrevious() =>
      ref.read(playbackServiceProvider).skipPrevious();

  Future<void> insertNext(Track track) =>
      ref.read(playbackServiceProvider).insertNext(track);

  Future<void> addToQueue(Track track) =>
      ref.read(playbackServiceProvider).addToQueue(track);

  Future<void> playAtIndex(int index) =>
      ref.read(playbackServiceProvider).playAtIndex(index);

  Future<void> moveQueueItem(int from, int to) =>
      ref.read(playbackServiceProvider).moveQueueItem(from, to);

  Future<void> removeQueueItem(int index) =>
      ref.read(playbackServiceProvider).removeQueueItem(index);
}

final playerControllerProvider =
    NotifierProvider<PlayerController, PlayerSnapshot>(PlayerController.new);

final positionProvider = StreamProvider<Duration>(
  (ref) => ref.watch(playbackServiceProvider).watchPosition(),
);
