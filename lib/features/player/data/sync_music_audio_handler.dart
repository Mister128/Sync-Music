import 'dart:async';

import 'package:audio_service/audio_service.dart';

import 'package:sync_music/core/logging/app_logger.dart';
import 'package:sync_music/features/library/domain/entities/track.dart';
import 'package:sync_music/features/player/data/media_item_mapper.dart';
import 'package:sync_music/features/player/domain/entities/player_snapshot.dart';
import 'package:sync_music/features/player/domain/entities/repeat_mode.dart';
import 'package:sync_music/features/player/domain/services/playback_service.dart';

/// Android system media session: media notification, lockscreen
/// controls, headset/BT buttons.
///
/// A MIRROR of the engine, not a second implementation:
///
///   system buttons   -> handler callbacks -> PlaybackService (engine)
///   engine snapshots -> playbackState / mediaItem / queue -> system UI
///
/// The Flutter UI never touches this class: it keeps talking to the same
/// engine singleton via PlaybackService, so both input paths converge on
/// ONE source of truth. Queue/skip/repeat logic stays in JustAudioPlayback
/// together with its tests.
class SyncMusicAudioHandler extends BaseAudioHandler {
  new(this._engine) {
    _log.debug('system media session attached');
    _subscriptions = [
      _engine.watchSnapshot().listen(_onSnapshot),
      _engine.watchPosition().listen(_onPosition),
    ];
  }

  /// The one engine singleton shared with the UI (wired in bootstrap).
  final PlaybackService _engine;
  final ScopedLogger _log = AppLogger.scope('audio-service');
  late final List<StreamSubscription<dynamic>> _subscriptions;

  /// Position ticks arrive several times a second.
  static const Duration _jumpThreshold = Duration(seconds: 1);
  Duration _lastPosition = Duration.zero;

  static const String shuffleActionName = 'toggleShuffle';
  static const String repeatActionName = 'cycleRepeatMode';

  PlayerSnapshot? _lastSnapshot;

  /// Change detectors: never spam the platform channel with the full
  /// 3000-track queue or the same MediaItem on every play/pause.
  List<Track>? _publishedQueue;
  String? _publishedItemKey;

  // ---- system -> engine ----

  @override
  Future<void> play() => _engine.play();

  @override
  Future<void> pause() => _engine.pause();

  @override
  Future<void> seek(Duration position) => _engine.seek(position);

  @override
  Future<void> skipToNext() => _engine.skipNext();

  @override
  Future<void> skipToPrevious() => _engine.skipPrevious();

  @override
  Future<void> skipToQueueItem(int index) => _engine.playAtIndex(index);

  @override
  Future<void> setRepeatMode(AudioServiceRepeatMode repeatMode) =>
      _engine.setRepeatMode(switch (repeatMode) {
        AudioServiceRepeatMode.none => RepeatMode.off,
        AudioServiceRepeatMode.one => RepeatMode.one,
        AudioServiceRepeatMode.all ||
        AudioServiceRepeatMode.group => RepeatMode.all,
      });

  @override
  Future<void> setShuffleMode(AudioServiceShuffleMode shuffleMode) => _engine
      .setShuffleEnabled(enabled: shuffleMode != AudioServiceShuffleMode.none);

  @override
  Future<void> stop() async {
    await _engine.pause();
    await super.stop();
  }

  MediaControl _shuffleControl({required bool enabled}) => MediaControl.custom(
    // A monochrome system icon has exactly ONE state channel: the glyph.
    // Filled tile = active (labels only help TalkBack, UIs don't render
    // them on the button).
    androidIcon: enabled ? 'drawable/ic_shuffle_on' : 'drawable/ic_shuffle',
    label: enabled ? 'Shuffle on' : 'Shuffle off',
    name: shuffleActionName,
  );

  /// Filled tile = an active mode: plain loop = off, filled loop = all,
  /// filled loop with "1" = repeat one.
  MediaControl _repeatControl(RepeatMode mode) => MediaControl.custom(
    androidIcon: switch (mode) {
      RepeatMode.off => 'drawable/ic_repeat',
      RepeatMode.all => 'drawable/ic_repeat_on',
      RepeatMode.one => 'drawable/ic_repeat_one_on',
    },
    label: switch (mode) {
      RepeatMode.off => 'Repeat off',
      RepeatMode.all => 'Repeat all',
      RepeatMode.one => 'Repeat one',
    },
    name: repeatActionName,
  );

  /// Clicks on the custom buttons above land here (also from Android Auto).
  @override
  Future<dynamic> customAction(
    String name, [
    Map<String, dynamic>? extras,
  ]) async {
    switch (name) {
      case shuffleActionName:
        await _toggleShuffle();
      case repeatActionName:
        await _cycleRepeatMode();
      default:
        await super.customAction(name, extras);
    }
  }

  Future<void> _toggleShuffle() async {
    final enabled = _lastSnapshot?.shuffleEnabled ?? false;
    await _engine.setShuffleEnabled(enabled: !enabled);
  }

  /// off -> all -> one -> off (the cycle Spotify and Samsung Music use).
  Future<void> _cycleRepeatMode() async {
    final next = switch (_lastSnapshot?.repeatMode ?? RepeatMode.off) {
      RepeatMode.off => RepeatMode.all,
      RepeatMode.all => RepeatMode.one,
      RepeatMode.one => RepeatMode.off,
    };
    await _engine.setRepeatMode(next);
  }

  // ---- engine -> system ----

  void _onSnapshot(PlayerSnapshot snapshot) {
    _lastSnapshot = snapshot;

    // Queue: re-broadcast only when the engine REPLACED the list instance -
    // it builds a new one on every queue mutation and reuses it for pure
    // play-state changes (the snapshot stores the same reference).
    if (!identical(_publishedQueue, snapshot.queue)) {
      _publishedQueue = snapshot.queue;
      queue.add([for (final track in snapshot.queue) trackToMediaItem(track)]);
    }

    // MediaItem: re-publish when the track OR its artwork changed - the
    // background extraction pass may fill in a missing cover later.
    final track = snapshot.currentTrack;
    final itemKey = track == null ? null : '${track.id}|${track.artworkHash}';
    if (itemKey != _publishedItemKey) {
      _publishedItemKey = itemKey;
      mediaItem.add(track == null ? null : trackToMediaItem(track));
    }

    playbackState.add(_buildState(snapshot));
  }

  void _onPosition(Duration position) {
    final jumped = (position - _lastPosition).abs() > _jumpThreshold;
    _lastPosition = position;
    final snapshot = _lastSnapshot;
    if (jumped && snapshot != null) {
      playbackState.add(_buildState(snapshot));
    }
  }

  PlaybackState _buildState(PlayerSnapshot s) {
    final hasTrack = s.currentTrack != null;
    return PlaybackState(
      controls: [
        MediaControl.skipToPrevious,
        if (s.isPlaying) MediaControl.pause else MediaControl.play,
        MediaControl.skipToNext,
        _shuffleControl(enabled: s.shuffleEnabled),
        _repeatControl(s.repeatMode),
      ],
      systemActions: const {
        MediaAction.setRepeatMode,
        MediaAction.seek,
        MediaAction.setShuffleMode,
      },
      androidCompactActionIndices: const [0, 1, 2],
      processingState: hasTrack
          ? AudioProcessingState.ready
          : AudioProcessingState.idle,
      playing: s.isPlaying,
      updatePosition: _lastPosition,
      repeatMode: switch (s.repeatMode) {
        RepeatMode.off => AudioServiceRepeatMode.none,
        RepeatMode.one => AudioServiceRepeatMode.one,
        RepeatMode.all => AudioServiceRepeatMode.all,
      },
      shuffleMode: s.shuffleEnabled
          ? AudioServiceShuffleMode.all
          : AudioServiceShuffleMode.none,
      queueIndex: hasTrack ? s.currentIndex : null,
    );
  }

  /// Tests only - in production the handler lives as long as the process.
  Future<void> dispose() async {
    for (final sub in _subscriptions) {
      await sub.cancel();
    }
  }
}
