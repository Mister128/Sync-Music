import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sync_music/core/database/app_database.dart' hide Track;
import 'package:sync_music/core/logging/app_logger.dart';
import 'package:sync_music/features/library/domain/entities/track.dart';
import 'package:sync_music/features/player/data/playback_state_dao.dart';
import 'package:sync_music/features/player/data/playback_state_store.dart';
import 'package:sync_music/features/player/domain/entities/player_snapshot.dart';
import 'package:sync_music/features/player/domain/entities/repeat_mode.dart';

import 'fake_playback.dart';

void main() {
  setUpAll(AppLogger.init);

  late AppDatabase db;
  late PlaybackStateDao dao;
  late FakePlayback engine;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    dao = PlaybackStateDao(db);
    engine = FakePlayback();
  });

  tearDown(() async {
    await db.close();
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

  PlaybackStateStore buildStore({TrackResolver? resolver}) =>
      PlaybackStateStore(
        engine: engine,
        dao: dao,
        resolveTracks: resolver ?? (ids) async => const [],
      );

  group('save', () {
    test('snapshot changes are persisted', () async {
      final store = buildStore()..startAutoSave();
      addTearDown(store.dispose);

      engine.snapshots.add(
        snapshot(
          queue: [track('a'), track('b')],
          currentIndex: 1,
          isPlaying: true,
          repeatMode: RepeatMode.one,
          shuffleEnabled: true,
        ),
      );
      await pumpEventQueue(); // deliver the event to the store
      // flush() is AWAITED: after this line the latest snapshot is
      // guaranteed to be on disk. If the row is still missing here, the
      // subscription is broken - not the timing.
      await store.flush();

      final row = await dao.read();
      expect(row, isNotNull);
      expect(row!.queueTrackIds, '["a","b"]');
      expect(row.currentIndex, 1);
      expect(row.currentTrackId, 'b');
      expect(row.positionMs, 0);
      expect(row.repeatMode, RepeatMode.one.index);
      expect(row.shuffleEnabled, isTrue);
    });

    test('ordinary ticks are throttled, jumps and flush are not', () async {
      final store = buildStore()..startAutoSave();
      addTearDown(store.dispose);

      engine.snapshots.add(
        snapshot(queue: [track('a')], currentIndex: 0, isPlaying: true),
      );
      await pumpEventQueue();
      await store.flush(); // deterministic baseline on disk

      // Small tick while playing: inside the 5 s window - no write.
      engine.positions.add(const Duration(milliseconds: 300));
      await pumpEventQueue();
      expect((await dao.read())!.positionMs, 0);

      // A jump (user seek): stale by more than a tick - written at once.
      engine.positions.add(const Duration(seconds: 42));
      await pumpEventQueue();
      expect((await dao.read())!.positionMs, 42000);

      // Paused tick writes nothing on its own; flush() does (backgrounding).
      engine.snapshots.add(
        snapshot(queue: [track('a')], currentIndex: 0),
      );
      await pumpEventQueue();
      engine.positions.add(const Duration(seconds: 42, milliseconds: 400));
      await pumpEventQueue();
      await store.flush();
      expect((await dao.read())!.positionMs, 42400);
    });
  });

  group('restore', () {
    test('no saved row -> engine untouched', () async {
      await buildStore().restore();

      expect(engine.calls, isEmpty);
    });

    test('saved session comes back paused, dead tracks filtered', () async {
      // Last session: a -> b -> c, current 'b' at 1:00, repeat all,
      // shuffle on. Since then 'a' was deleted from the library.
      await dao.upsert(
        PlaybackStatesCompanion(
          queueTrackIds: const Value('["a","b","c"]'),
          currentIndex: const Value(1),
          currentTrackId: const Value('b'),
          positionMs: const Value(60000),
          repeatMode: Value(RepeatMode.all.index),
          shuffleEnabled: const Value(true),
          updatedAtMs: const Value(0),
        ),
      );

      final store = buildStore(
        resolver: (ids) async => [
          for (final id in ids)
            if (id != 'a') track(id),
        ],
      );
      await store.restore();

      expect(engine.calls, [
        // 'b' and 'c' survived; 'b' is now at index 0, position kept.
        'restoreQueue:2:0:0:01:00.000000',
        'repeat:RepeatMode.all',
        'shuffle:true',
      ]);
    });

    test('every saved track is dead -> nothing restored', () async {
      await dao.upsert(
        const PlaybackStatesCompanion(
          queueTrackIds: Value('["a"]'),
          currentIndex: Value(0),
          currentTrackId: Value('a'),
          positionMs: Value(1000),
          updatedAtMs: Value(0),
        ),
      );

      await buildStore().restore();

      expect(engine.calls, isEmpty);
    });
  });
}
