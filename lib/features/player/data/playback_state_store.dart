import 'dart:async';
import 'dart:convert';

import 'package:drift/drift.dart' show Value;

import 'package:sync_music/core/database/app_database.dart' hide Track;
import 'package:sync_music/core/logging/app_logger.dart';
import 'package:sync_music/features/library/domain/entities/track.dart';
import 'package:sync_music/features/player/data/playback_state_dao.dart';
import 'package:sync_music/features/player/domain/entities/player_snapshot.dart';
import 'package:sync_music/features/player/domain/entities/repeat_mode.dart';
import 'package:sync_music/features/player/domain/services/playback_service.dart';
import 'package:sync_music/features/player/domain/services/restore_policy.dart';

/// Resolves saved track ids back to Tracks: alive (non-tombstoned), in the
/// order of [ids], dead ids simply missing. Injected at wiring time
/// (player_providers) so this store never imports the library feature.
typedef TrackResolver = Future<List<Track>> Function(List<String> ids);

/// Persists the playback session and restores it on the next launch.
class PlaybackStateStore {
  new({
    required this._engine,
    required this._dao,
    required this._resolveTracks,
  });

  /// How often the ticking position reaches the disk while playing.
  static const Duration positionWriteInterval = Duration(seconds: 5);

  /// Same threshold the audio handler uses: bigger = a real seek or track
  /// change, not a measurement tick.
  static const Duration _jumpThreshold = Duration(seconds: 1);

  final PlaybackService _engine;
  final PlaybackStateDao _dao;
  final TrackResolver _resolveTracks;
  final ScopedLogger _log = AppLogger.scope('playback-state');

  List<StreamSubscription<dynamic>> _subscriptions = const [];
  bool _started = false;

  PlayerSnapshot? _snapshot;
  Duration _lastPosition = Duration.zero;
  DateTime _lastPositionWrite = DateTime.fromMillisecondsSinceEpoch(0);

  /// Loads the saved session into the engine, PAUSED. Files deleted since
  /// the last run are dropped (the resolver returns alive tracks only);
  /// where to resume is decided by the pure restore_policy.
  Future<void> restore() async {
    final row = await _dao.read();
    if (row == null) return;

    final savedIds = (jsonDecode(row.queueTrackIds) as List)
        .whereType<String>()
        .toList();
    if (savedIds.isEmpty) return;

    final tracks = await _resolveTracks(savedIds);
    if (tracks.isEmpty) {
      _log.debug('restore: none of the saved tracks are alive anymore');
      return;
    }

    final resumed = restorePosition(
      restoredIds: [for (final track in tracks) track.id],
      savedIndex: row.currentIndex,
      savedTrackId: row.currentTrackId,
      savedPositionMs: row.positionMs,
    );

    await _engine.restoreQueue(
      tracks,
      startIndex: resumed.index,
      position: Duration(milliseconds: resumed.positionMs),
    );
    await _engine.setRepeatMode(
      RepeatMode.values[row.repeatMode.clamp(0, RepeatMode.values.length - 1)],
    );
    await _engine.setShuffleEnabled(enabled: row.shuffleEnabled);

    _log.info(
      'restored ${tracks.length} track(s), index ${resumed.index}, '
      'position ${resumed.positionMs}ms',
    );
  }

  /// Subscribes to the engine and keeps the row fresh. Idempotent;
  /// call AFTER restore() (see the class doc).
  void startAutoSave() {
    if (_started) return;
    _started = true;
    _subscriptions = [
      _engine.watchSnapshot().listen(_onSnapshot),
      _engine.watchPosition().listen(_onPosition),
    ];
  }

  /// Immediate write - app lifecycle hooks call this.
  Future<void> flush() => _save();

  void _onSnapshot(PlayerSnapshot snapshot) {
    _snapshot = snapshot;
    unawaited(_save()); // rare event: queue/index/mode/playing changed
  }

  void _onPosition(Duration position) {
    final jumped = (position - _lastPosition).abs() > _jumpThreshold;
    _lastPosition = position;

    if (jumped) {
      unawaited(_save());
      return;
    }
    if (!(_snapshot?.isPlaying ?? false)) return;
    if (DateTime.now().difference(_lastPositionWrite) < positionWriteInterval) {
      return;
    }
    unawaited(_save());
  }

  Future<void> _save() async {
    final snapshot = _snapshot;
    if (snapshot == null) return; // engine never published - nothing to save
    _lastPositionWrite = DateTime.now();
    try {
      await _dao.upsert(
        PlaybackStatesCompanion(
          queueTrackIds: Value(
            jsonEncode([for (final track in snapshot.queue) track.id]),
          ),
          currentIndex: Value(snapshot.currentIndex ?? 0),
          currentTrackId: Value(snapshot.currentTrack?.id),
          positionMs: Value(_lastPosition.inMilliseconds),
          repeatMode: Value(snapshot.repeatMode.index),
          shuffleEnabled: Value(snapshot.shuffleEnabled),
          updatedAtMs: Value(DateTime.now().millisecondsSinceEpoch),
        ),
      );
    } on Object catch (e, st) {
      // Background persistence must never surface to the user.
      _log.error('save failed', e, st);
    }
  }

  Future<void> dispose() async {
    for (final sub in _subscriptions) {
      await sub.cancel();
    }
    _subscriptions = const [];
  }
}
