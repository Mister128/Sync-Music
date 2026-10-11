import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sync_music/features/library/domain/entities/track.dart';
import 'package:sync_music/features/player/data/player_providers.dart';
import 'package:sync_music/features/player/domain/entities/player_snapshot.dart';
import 'package:sync_music/features/player/domain/entities/repeat_mode.dart';
import 'package:sync_music/features/player/domain/services/playback_service.dart';
import 'package:sync_music/features/player/presentation/controllers/player_controller.dart';

/// Records commands, lets the test drive the snapshot stream by hand.
class _FakePlayback implements PlaybackService {
  final snapshots = StreamController<PlayerSnapshot>.broadcast();
  final positions = StreamController<Duration>.broadcast();
  final calls = <String>[];

  @override
  Stream<PlayerSnapshot> watchSnapshot() => snapshots.stream;
  @override
  Stream<Duration> watchPosition() => positions.stream;
  @override
  Future<void> playQueue(List<Track> tracks, {int startIndex = 0}) async =>
      calls.add('playQueue:${tracks.length}:$startIndex');
  @override
  Future<void> play() async => calls.add('play');
  @override
  Future<void> pause() async => calls.add('pause');
  @override
  Future<void> togglePlay() async => calls.add('togglePlay');
  @override
  Future<void> seek(Duration position) async => calls.add('seek:$position');
  @override
  Future<void> skipNext() async => calls.add('skipNext');
  @override
  Future<void> skipPrevious() async => calls.add('skipPrevious');
  @override
  Future<void> insertNext(Track track) async =>
      calls.add('insertNext:${track.id}');
  @override
  Future<void> addToQueue(Track track) async =>
      calls.add('addToQueue:${track.id}');
  @override
  Future<void> moveQueueItem(int from, int to) async =>
      calls.add('move:$from->$to');
  @override
  Future<void> removeQueueItem(int index) async => calls.add('remove:$index');
  @override
  Future<void> setRepeatMode(RepeatMode mode) async =>
      calls.add('repeat:$mode');
  @override
  Future<void> setShuffleEnabled({required bool enabled}) async =>
      calls.add('shuffle:$enabled');
  @override
  Future<void> dispose() async => calls.add('dispose');
}

void main() {
  late _FakePlayback playback;
  late ProviderContainer container;

  setUp(() {
    playback = _FakePlayback();
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
}
