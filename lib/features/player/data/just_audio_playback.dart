import 'dart:async';
import 'dart:math';

import 'package:just_audio/just_audio.dart';

import 'package:sync_music/core/logging/app_logger.dart';
import 'package:sync_music/features/library/domain/entities/track.dart';
import 'package:sync_music/features/player/domain/entities/player_snapshot.dart';
import 'package:sync_music/features/player/domain/entities/repeat_mode.dart';
import 'package:sync_music/features/player/domain/services/playback_service.dart';
import 'package:sync_music/features/player/domain/services/skip_policy.dart';

/// The ONLY playback engine: just_audio 0.10 (Windows via media_kit).
/// SyncMusicAudioHandler mirrors it for the Android media session;
/// The UI only ever sees PlaybackService.
class JustAudioPlayback implements PlaybackService {
  new({AudioPlayer? player})
    : _player = player ?? AudioPlayer(maxSkipsOnError: _maxSkipsOnError) {
    _subscriptions = [
      // player.currentIndex is a PLAY-ORDER position (we never enable
      // backend shuffle, so the loaded order can't diverge from ours).
      _player.currentIndexStream.listen((index) {
        _syncCurrentTrack(index);
        _publish();
      }),
      _player.playingStream.listen((playing) {
        _isPlaying = playing;
        _publish();
      }),
      _player.durationStream.listen((duration) {
        _duration = duration;
        _publish();
      }),
      // maxSkipsOnError auto-skips broken files; here we only explain WHY
      // a track was skipped (talker scope: player).
      _player.errorStream.listen(
        (e) => _log.warn('playback error ${e.code}: ${e.message}'),
      ),
    ];
  }

  /// Broken files are skipped instead of killing the queue.
  static const int _maxSkipsOnError = 6;

  final AudioPlayer _player;
  final ScopedLogger _log = AppLogger.scope('player');
  final Random _random = Random();
  late final List<StreamSubscription<dynamic>> _subscriptions;

  // Mirror of the player state, assembled into immutable snapshots.
  List<Track> _queue = const [];
  List<Track> _playOrder = const [];

  /// Id of the track currently loaded in the player. Both the queue-space
  /// index (snapshot) and play-order lookups derive from it - never the
  /// other way around.
  String? _currentTrackId;

  bool _isPlaying = false;
  Duration? _duration;
  RepeatMode _repeatMode = RepeatMode.off;
  bool _shuffleEnabled = false;

  final _snapshots = StreamController<PlayerSnapshot>.broadcast();

  @override
  Stream<PlayerSnapshot> watchSnapshot() async* {
    yield _build(); // late subscribers get the CURRENT state immediately
    yield* _snapshots.stream;
  }

  @override
  Stream<Duration> watchPosition() => _player.positionStream;

  @override
  Future<void> playQueue(List<Track> tracks, {int startIndex = 0}) async {
    final playable = _playable(tracks);
    if (playable.isEmpty) {
      _log.warn('playQueue: nothing playable');
      return;
    }
    final requested = startIndex < tracks.length ? tracks[startIndex] : null;
    final initialIndex = requested == null
        ? 0
        : playable.indexOf(requested).clamp(0, playable.length - 1);

    await _loadQueue(playable, initialIndex: initialIndex);
    unawaited(_player.play());
  }

  @override
  Future<void> restoreQueue(
    List<Track> tracks, {
    int startIndex = 0,
    Duration position = Duration.zero,
  }) async {
    final playable = _playable(tracks);
    if (playable.isEmpty) {
      _log.debug('restoreQueue: nothing playable, session dropped');
      return;
    }
    // Index-based on purpose: the resolver already dropped dead tracks,
    // the clamp only guards a shrunken queue.
    await _loadQueue(
      playable,
      initialIndex: startIndex.clamp(0, playable.length - 1),
      initialPosition: position,
    );
    // NO play() here - a restored session is a PAUSED session.
  }

  /// Shared loader: sets _queue, derives _playOrder (honoring an ALREADY
  /// enabled shuffle - e.g. restoring a shuffled session), reloads the
  /// sources and republishes. Whether playback starts is the CALLER's
  /// decision.
  Future<void> _loadQueue(
    List<Track> playable, {
    required int initialIndex,
    Duration initialPosition = Duration.zero,
  }) async {
    _queue = List.unmodifiable(playable);
    if (_shuffleEnabled) {
      _playOrder = _shuffledOrder(playable[initialIndex]);
      await _reload(startIndex: 0, position: initialPosition);
    } else {
      _playOrder = _queue;
      await _reload(startIndex: initialIndex, position: initialPosition);
    }
  }

  /// The ONE place that talks to setAudioSources: loads _playOrder and
  /// pins the current track id deterministically (no stream round-trip).
  Future<void> _reload({
    required int startIndex,
    Duration position = Duration.zero,
  }) async {
    try {
      await _player.setAudioSources(
        [
          for (final track in _playOrder)
            AudioSource.uri(Uri.file(track.localPath!), tag: track.id),
        ],
        initialIndex: startIndex,
        initialPosition: position,
      );
    } on Object catch (e) {
      // Preparing the initial item can fail HARD - e.g. the media
      // permission was revoked in system settings while a session was
      // saved, so every /storage/... file became unreadable. A dead
      // session must degrade to "no queue", never into a crash: without
      // this, restoreQueue takes the whole bootstrap down before runApp.
      _log.warn('setAudioSources failed, queue dropped: $e');
      _queue = const [];
      _playOrder = const [];
      _currentTrackId = null;
      _publish();
      return;
    }
    _currentTrackId = _playOrder[startIndex].id;
    _publish();
  }

  /// The whole queue in random order with [current] moved to the front:
  /// the track being listened to always survives a shuffle toggle.
  List<Track> _shuffledOrder(Track current) {
    final shuffled = [..._queue]..shuffle(_random);
    final index = shuffled.indexWhere((track) => track.id == current.id);
    if (index > 0) shuffled.insert(0, shuffled.removeAt(index));
    return List.unmodifiable(shuffled);
  }

  static List<Track> _playable(List<Track> tracks) => [
    for (final track in tracks)
      if (track.localPath != null) track,
  ];

  @override
  Future<void> play() async => unawaited(_player.play());

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> togglePlay() => _isPlaying ? pause() : play();

  @override
  Future<void> seek(Duration position) => _player.seek(position);

  @override
  Future<void> skipNext() async {
    final length = _playOrder.length;
    if (length == 0) return;

    // LoopMode.one turns just_audio's own next into "restart me"
    // (_getRelativeIndex literally returns currentIndex). A MANUAL skip
    // always means "another track" (product rule, Samsung style) -
    // compute the cyclic neighbor in PLAY order ourselves; seek(index:)
    // ignores the loop mode. Auto-repeat at track end stays untouched.
    if (_repeatMode == RepeatMode.one) {
      final current = _player.currentIndex ?? 0;
      await _player.seek(Duration.zero, index: (current + 1) % length);
      return;
    }

    if (_player.hasNext) {
      await _player.seekToNext();
    } else {
      await _player.seek(Duration.zero, index: 0);
    }
  }

  @override
  Future<void> skipPrevious() async {
    final length = _playOrder.length;
    if (length == 0) return;

    if (skipPreviousAction(_player.position) ==
        SkipPreviousAction.restartCurrent) {
      await _player.seek(Duration.zero);
      return;
    }

    if (_repeatMode == RepeatMode.one) {
      final current = _player.currentIndex ?? 0;
      await _player.seek(Duration.zero, index: (current - 1 + length) % length);
      return;
    }

    if (_player.hasPrevious) {
      await _player.seekToPrevious();
    } else {
      await _player.seek(Duration.zero, index: length - 1);
    }
  }

  @override
  Future<void> playAtIndex(int index) async {
    if (index < 0 || index >= _queue.length) return;
    // The UI speaks QUEUE order; the loaded sources speak PLAY order -
    // they differ whenever shuffle is on. The track id bridges the two.
    final target = _playOrderIndexFor(_queue[index].id);
    if (target == null) return;
    await _player.seek(Duration.zero, index: target);
    unawaited(_player.play());
  }

  @override
  Future<void> insertNext(Track track) async {
    final path = track.localPath;
    if (path == null) return;
    // Right after the current track in BOTH orders: queue-space for the
    // visible list, play-space for the "play next" meaning under shuffle.
    final atQueue = (_currentQueueIndex() ?? -1) + 1;
    _queue = [..._queue.take(atQueue), track, ..._queue.skip(atQueue)];
    final atPlay = (_player.currentIndex ?? -1) + 1;
    _playOrder = [
      ..._playOrder.take(atPlay),
      track,
      ..._playOrder.skip(atPlay),
    ];
    await _player.insertAudioSource(
      atPlay,
      AudioSource.uri(Uri.file(path), tag: track.id),
    );
    _publish();
  }

  @override
  Future<void> addToQueue(Track track) async {
    final path = track.localPath;
    if (path == null) return;
    _queue = [..._queue, track];
    _playOrder = [..._playOrder, track];
    await _player.addAudioSource(
      AudioSource.uri(Uri.file(path), tag: track.id),
    );
    _publish();
  }

  @override
  Future<void> moveQueueItem(int from, int to) async {
    if (from == to ||
        from < 0 ||
        to < 0 ||
        from >= _queue.length ||
        to >= _queue.length) {
      return;
    }
    final moved = _queue[from];
    _queue = [..._queue]
      ..removeAt(from)
      ..insert(to, moved);
    if (!_shuffleEnabled) {
      // Play order mirrors the queue 1:1 - apply the same move.
      _playOrder = _queue;
      await _player.moveAudioSource(from, to);
    }
    // While shuffled, a queue edit does not change the play order;
    // unshuffling restores the edited _queue.
    _publish();
  }

  @override
  Future<void> removeQueueItem(int index) async {
    if (index < 0 || index >= _queue.length) return;
    final removed = _queue[index];
    _queue = [..._queue]..removeAt(index);
    final playIndex = _playOrderIndexFor(removed.id);
    if (playIndex != null) {
      _playOrder = [..._playOrder]..removeAt(playIndex);
      await _player.removeAudioSourceAt(playIndex);
    }
    _publish();
  }

  @override
  Future<void> setRepeatMode(RepeatMode mode) async {
    _repeatMode = mode;
    await _player.setLoopMode(switch (mode) {
      RepeatMode.off => LoopMode.off,
      RepeatMode.one => LoopMode.one,
      RepeatMode.all => LoopMode.all,
    });
    _publish();
  }

  @override
  Future<void> setShuffleEnabled({required bool enabled}) async {
    if (enabled == _shuffleEnabled) return;
    _shuffleEnabled = enabled;

    final currentId = _currentTrackId;
    if (_queue.isEmpty || currentId == null) {
      // Nothing loaded (or nothing current) yet - just remember the
      // flag; _loadQueue will honor it on the next load.
      _publish();
      return;
    }

    // Physical reload across the toggle: keep the position and the
    // playing flag (setAudioSources goes through load(), which is not
    // gapless - the price of engine-owned shuffle; with local files the
    // pause is a blink).
    final wasPlaying = _isPlaying;
    final position = _player.position;

    if (enabled) {
      final current = _queue.firstWhere(
        (track) => track.id == currentId,
        orElse: () => _queue.first,
      );
      _playOrder = _shuffledOrder(current);
      await _reload(startIndex: 0, position: position);
    } else {
      _playOrder = _queue;
      await _reload(startIndex: _currentQueueIndex() ?? 0, position: position);
    }
    if (wasPlaying) unawaited(_player.play());
  }

  @override
  Future<void> dispose() async {
    for (final sub in _subscriptions) {
      await sub.cancel();
    }
    await _snapshots.close();
    await _player.dispose();
  }

  // ---- index-space helpers ----

  /// Resolve the current track from OUR play order (player.currentIndex
  /// is a play-order position - the loaded order cannot diverge from
  /// _playOrder because backend shuffle is never enabled and every
  /// source edit updates _playOrder synchronously first).
  void _syncCurrentTrack(int? playIndex) {
    if (playIndex == null || playIndex < 0 || playIndex >= _playOrder.length) {
      _currentTrackId = null;
      return;
    }
    _currentTrackId = _playOrder[playIndex].id;
  }

  /// QUEUE-space index of the current track (the snapshot semantics:
  /// `queue[currentIndex] == current track`).
  int? _currentQueueIndex() {
    final id = _currentTrackId;
    if (id == null) return null;
    final index = _queue.indexWhere((track) => track.id == id);
    return index == -1 ? null : index;
  }

  /// PLAY-order position of a track id - the index space seek() speaks.
  int? _playOrderIndexFor(String trackId) {
    final index = _playOrder.indexWhere((track) => track.id == trackId);
    return index == -1 ? null : index;
  }

  PlayerSnapshot _build() => PlayerSnapshot(
    queue: _queue,
    currentIndex: _currentQueueIndex(),
    isPlaying: _isPlaying,
    duration: _duration,
    repeatMode: _repeatMode,
    shuffleEnabled: _shuffleEnabled,
  );

  void _publish() {
    if (!_snapshots.isClosed) _snapshots.add(_build());
  }
}
