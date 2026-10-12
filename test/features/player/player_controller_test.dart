import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sync_music/features/library/domain/entities/track.dart';
import 'package:sync_music/features/player/data/player_providers.dart';
import 'package:sync_music/features/player/domain/entities/player_snapshot.dart';
import 'package:sync_music/features/player/domain/entities/repeat_mode.dart';
import 'package:sync_music/features/player/presentation/controllers/player_controller.dart';

import 'fake_playback.dart';

void main() {
  late FakePlayback playback;
  late ProviderContainer container;

  setUp(() {
    playback = FakePlayback();
    container = ProviderContainer(
      overrides: [playbackServiceProvider.overrideWithValue(playback)],
    );
    addTearDown(container.dispose);
  });

  Track track(String id) => Track(
    id: id,
    contentHash: 'h-$id',
    title: 'T$id',
    artistName: 'Artist',
    localPath: '/music/$id.mp3',
  );

  test('initial state is an empty snapshot', () {
    final snapshot = container.read(playerControllerProvider);

    expect(snapshot.queue, isEmpty);
    expect(snapshot.currentTrack, isNull);
    expect(snapshot.isPlaying, isFalse);
  });

  test('service snapshots flow into controller state', () async {
    container.read(playerControllerProvider.notifier);

    playback.snapshots.add(
      PlayerSnapshot(
        queue: [track('a')],
        currentIndex: 0,
        isPlaying: true,
        duration: const Duration(minutes: 3),
        repeatMode: RepeatMode.off,
        shuffleEnabled: false,
      ),
    );
    await pumpEventQueue();

    final state = container.read(playerControllerProvider);
    expect(state.isPlaying, isTrue);
    expect(state.currentTrack?.title, 'Ta');
  });

  test('commands are relayed verbatim', () async {
    final controller = container.read(playerControllerProvider.notifier);

    await controller.playQueue([track('a'), track('b')], startIndex: 1);
    await controller.togglePlay();
    await controller.skipNext();

    expect(playback.calls, ['playQueue:2:1', 'togglePlay', 'skipNext']);
  });

  test('currentTrack is bounds-safe on a stale index', () {
    const stale = PlayerSnapshot(
      queue: [],
      currentIndex: 3, // queue shrank mid-edit
      isPlaying: false,
      duration: null,
      repeatMode: RepeatMode.off,
      shuffleEnabled: false,
    );

    expect(stale.currentTrack, isNull);
  });

  test('queue actions are relayed', () async {
    final controller = container.read(playerControllerProvider.notifier);

    await controller.insertNext(track('a'));
    await controller.addToQueue(track('b'));

    expect(playback.calls, ['insertNext:a', 'addToQueue:b']);
  });
}
