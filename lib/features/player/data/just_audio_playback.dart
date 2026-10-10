import 'dart:async';

import 'package:just_audio/just_audio.dart';

import 'package:sync_music/core/logging/app_logger.dart';
import 'package:sync_music/features/library/domain/entities/track.dart';
import 'package:sync_music/features/player/domain/entities/player_snapshot.dart';
import 'package:sync_music/features/player/domain/entities/repeat_mode.dart';
import 'package:sync_music/features/player/domain/services/playback_service.dart';

/// Plain just_audio implementation: Windows (media_kit backend) and Android
/// in the FOREGROUND. Notifications/lockscreen/ducking arrive in 4.2 with
/// AudioServicePlayback - the PlaybackService interface hides the swap.
class JustAudioPlayback implements PlaybackService {
  new({AudioPlayer? player})
    : _player = player ?? AudioPlayer(maxSkipsOnError: _maxSkipsOnError) {
    _subscriptions = [
      _player.currentIndexStream.listen((index) {
        _currentIndex = index;
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
  late final List<StreamSubscription<dynamic>> _subscriptions;

  // Mirror of the player state, assembled into immutable snapshots.
  List<Track> _queue = const [];
  int? _currentIndex;
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
    final playable = [
      for (final track in tracks)
        if (track.localPath != null) track,
    ];
    if (playable.isEmpty) {
      _log.warn('playQueue: nothing playable');
      return;
    }
    final requested = startIndex < tracks.length ? tracks[startIndex] : null;
    final initialIndex = requested == null
        ? 0
        : playable.indexOf(requested).clamp(0, playable.length - 1);

    _queue = List.unmodifiable(playable);
    await _player.setAudioSources(
      [
        for (final track in playable)
          AudioSource.uri(Uri.file(track.localPath!), tag: track.id),
      ],
      initialIndex: initialIndex,
      initialPosition: Duration.zero,
    );
    _currentIndex = initialIndex;
    unawaited(_player.play());
    _publish();
  }

  @override
  Future<void> play() async => unawaited(_player.play());

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> togglePlay() => _isPlaying ? pause() : play();

  @override
  Future<void> seek(Duration position) => _player.seek(position);

  @override
  Future<void> skipNext() => _player.seekToNext();

  @override
  Future<void> skipPrevious() => _player.seekToPrevious();

  @override
  Future<void> insertNext(Track track) async {
    final path = track.localPath;
    if (path == null) return;
    final at = (_currentIndex ?? -1) + 1;
    _queue = [..._queue.take(at), track, ..._queue.skip(at)];
    await _player.insertAudioSource(
      at,
      AudioSource.uri(Uri.file(path), tag: track.id),
    );
    _publish();
  }

  @override
  Future<void> addToQueue(Track track) async {
    final path = track.localPath;
    if (path == null) return;
    _queue = [..._queue, track];
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
    await _player.moveAudioSource(from, to);
    _publish();
  }

  @override
  Future<void> removeQueueItem(int index) async {
    if (index < 0 || index >= _queue.length) return;
    _queue = [..._queue]..removeAt(index);
    await _player.removeAudioSourceAt(index);
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
  Future<void> setShuffleEnabled(bool enabled) async {
    _shuffleEnabled = enabled;
    await _player.setShuffleModeEnabled(enabled);
    _publish();
  }

  @override
  Future<void> dispose() async {
    for (final sub in _subscriptions) {
      await sub.cancel();
    }
    await _snapshots.close();
    await _player.dispose();
  }

  PlayerSnapshot _build() => PlayerSnapshot(
    queue: _queue,
    currentIndex: _currentIndex,
    isPlaying: _isPlaying,
    duration: _duration,
    repeatMode: _repeatMode,
    shuffleEnabled: _shuffleEnabled,
  );

  void _publish() {
    if (!_snapshots.isClosed) _snapshots.add(_build());
  }
}
