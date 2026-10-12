import 'dart:async';

import 'package:sync_music/features/library/domain/entities/track.dart';
import 'package:sync_music/features/player/domain/entities/player_snapshot.dart';
import 'package:sync_music/features/player/domain/entities/repeat_mode.dart';
import 'package:sync_music/features/player/domain/services/playback_service.dart';

/// Records commands, lets tests drive the snapshot stream by hand.
/// Shared by the player tests (same pattern as fake_platform_scanner.dart).
class FakePlayback implements PlaybackService {
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
  Future<void> restoreQueue(
    List<Track> tracks, {
    int startIndex = 0,
    Duration position = Duration.zero,
  }) async => calls.add('restoreQueue:${tracks.length}:$startIndex:$position');
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
  Future<void> playAtIndex(int index) async => calls.add('playAtIndex:$index');
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
