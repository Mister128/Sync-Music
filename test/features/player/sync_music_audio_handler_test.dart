import 'package:audio_service/audio_service.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sync_music/core/logging/app_logger.dart';
import 'package:sync_music/features/library/domain/entities/track.dart';
import 'package:sync_music/features/player/data/sync_music_audio_handler.dart';
import 'package:sync_music/features/player/domain/entities/player_snapshot.dart';
import 'package:sync_music/features/player/domain/entities/repeat_mode.dart';

import 'fake_playback.dart';

void main() {
  // The handler holds a ScopedLogger - talker must exist first.
  setUpAll(AppLogger.init);

  late FakePlayback engine;
  late SyncMusicAudioHandler handler;

  setUp(() {
    engine = FakePlayback();
    handler = SyncMusicAudioHandler(engine);
  });

  tearDown(() async {
    await handler.dispose();
    await engine.snapshots.close();
    await engine.positions.close();
  });

  Track track(String id) => Track(
    id: id,
    contentHash: 'h-$id',
    title: 'T$id',
    artistName: 'Artist',
    localPath: '/music/$id.mp3',
  );

  PlayerSnapshot snapshot({
    List<Track> queue = const [],
    int? currentIndex,
    bool isPlaying = false,
    RepeatMode repeatMode = RepeatMode.off,
    bool shuffleEnabled = false,
  }) => PlayerSnapshot(
    queue: queue,
    currentIndex: currentIndex,
    isPlaying: isPlaying,
    duration: null,
    repeatMode: repeatMode,
    shuffleEnabled: shuffleEnabled,
  );

  test('engine snapshot is mirrored into playbackState', () async {
    engine.snapshots.add(
      snapshot(queue: [track('a')], currentIndex: 0, isPlaying: true),
    );
    await pumpEventQueue();

    // BehaviorSubject.first = the CURRENT value, no nullability games.
    final state = await handler.playbackState.first;
    expect(state.playing, isTrue);
    expect(state.processingState, AudioProcessingState.ready);
    expect(state.controls, contains(MediaControl.pause));
    expect(state.queueIndex, 0);
  });

  test('queue and mediaItem follow the snapshot', () async {
    engine.snapshots.add(
      snapshot(
        queue: [track('a'), track('b')],
        currentIndex: 1,
        isPlaying: true,
      ),
    );
    await pumpEventQueue();

    final items = await handler.queue.first;
    expect(items.map((item) => item.id), ['a', 'b']);

    final current = await handler.mediaItem.first;
    expect(current?.title, 'Tb');
  });

  test('system buttons are forwarded to the engine', () async {
    await handler.play();
    await handler.skipToNext();
    await handler.skipToPrevious();
    await handler.seek(const Duration(seconds: 30));

    expect(engine.calls, [
      'play',
      'skipNext',
      'skipPrevious',
      'seek:0:00:30.000000',
    ]);
  });

  test('repeat and shuffle modes are translated', () async {
    await handler.setRepeatMode(AudioServiceRepeatMode.one);
    await handler.setShuffleMode(AudioServiceShuffleMode.all);
    await handler.setShuffleMode(AudioServiceShuffleMode.none);

    expect(engine.calls, [
      'repeat:RepeatMode.one',
      'shuffle:true',
      'shuffle:false',
    ]);
  });

  test('stop silences the engine and idles the session', () async {
    await handler.stop();

    expect(engine.calls, ['pause']);
    final state = await handler.playbackState.first;
    expect(state.processingState, AudioProcessingState.idle);
  });

  test('position jumps are broadcast, ordinary ticks are not', () async {
    engine.snapshots.add(
      snapshot(queue: [track('a')], currentIndex: 0, isPlaying: true),
    );
    await pumpEventQueue();

    final emissions = <PlaybackState>[];
    final sub = handler.playbackState.skip(1).listen(emissions.add);

    engine.positions.add(const Duration(milliseconds: 300)); // tick
    engine.positions.add(const Duration(milliseconds: 600)); // tick
    await pumpEventQueue();
    expect(emissions, isEmpty);

    engine.positions.add(const Duration(minutes: 1, seconds: 30)); // user seek
    await pumpEventQueue();
    expect(emissions, hasLength(1));
    expect(
      emissions.single.updatePosition,
      const Duration(minutes: 1, seconds: 30),
    );

    await sub.cancel();
  });

  test('skipToQueueItem is forwarded to the engine', () async {
    await handler.skipToQueueItem(2);

    expect(engine.calls, ['playAtIndex:2']);
  });

  test('repeat and shuffle modes are mirrored into playbackState', () async {
    engine.snapshots.add(
      snapshot(
        queue: [track('a')],
        currentIndex: 0,
        isPlaying: true,
        repeatMode: RepeatMode.one,
        shuffleEnabled: true,
      ),
    );
    await pumpEventQueue();

    // This is what the system toggles read their on/off state from.
    final state = await handler.playbackState.first;
    expect(state.repeatMode, AudioServiceRepeatMode.one);
    expect(state.shuffleMode, AudioServiceShuffleMode.all);
  });

  test('custom shuffle/repeat controls are part of the state', () async {
    engine.snapshots.add(
      snapshot(queue: [track('a')], currentIndex: 0, isPlaying: true),
    );
    await pumpEventQueue();

    final state = await handler.playbackState.first;
    final customs = state.controls
        .where((control) => control.action == MediaAction.custom)
        .toList();
    expect(customs.map((control) => control.customAction?.name), [
      SyncMusicAudioHandler.shuffleActionName,
      SyncMusicAudioHandler.repeatActionName,
    ]);
  });

  test(
    'customAction toggles shuffle and cycles repeat via the engine',
    () async {
      engine.snapshots.add(
        snapshot(queue: [track('a')], currentIndex: 0, isPlaying: true),
      );
      await pumpEventQueue();

      await handler.customAction(SyncMusicAudioHandler.shuffleActionName);
      expect(engine.calls, ['shuffle:true']);

      await handler.customAction(SyncMusicAudioHandler.repeatActionName);
      expect(engine.calls, ['shuffle:true', 'repeat:RepeatMode.all']);

      await handler.customAction('unknownAction'); // -> super, no engine calls
      expect(engine.calls, hasLength(2));
    },
  );

  test('custom button icons encode the current modes', () async {
    Map<String, String> customIcons(PlaybackState state) => {
      for (final control in state.controls)
        if (control.customAction != null)
          control.customAction!.name: control.androidIcon,
    };

    engine.snapshots.add(
      snapshot(
        queue: [track('a')],
        currentIndex: 0,
        isPlaying: true,
        repeatMode: RepeatMode.one,
        shuffleEnabled: true,
      ),
    );
    await pumpEventQueue();

    var icons = customIcons(await handler.playbackState.first);
    expect(
      icons[SyncMusicAudioHandler.shuffleActionName],
      'drawable/ic_shuffle_on',
    );
    expect(
      icons[SyncMusicAudioHandler.repeatActionName],
      'drawable/ic_repeat_one_on',
    );

    // Modes off -> plain glyphs again.
    engine.snapshots.add(
      snapshot(queue: [track('a')], currentIndex: 0, isPlaying: true),
    );
    await pumpEventQueue();

    icons = customIcons(await handler.playbackState.first);
    expect(
      icons[SyncMusicAudioHandler.shuffleActionName],
      'drawable/ic_shuffle',
    );
    expect(icons[SyncMusicAudioHandler.repeatActionName], 'drawable/ic_repeat');
  });
}
