import 'package:flutter_test/flutter_test.dart';

import 'package:sync_music/features/player/domain/services/restore_policy.dart';

void main() {
  group('restorePosition', () {
    test('nothing survived -> empty defaults', () {
      expect(
        restorePosition(
          restoredIds: const [],
          savedIndex: 2,
          savedTrackId: 'c',
          savedPositionMs: 5000,
        ),
        (index: 0, positionMs: 0),
      );
    });

    test('intact session restores exactly, duplicates included', () {
      final res = restorePosition(
        restoredIds: const ['a', 'b', 'a'],
        savedIndex: 2,
        savedTrackId: 'a',
        savedPositionMs: 42000,
      );
      expect(res.index, 2); // the SECOND 'a', not the first
      expect(res.positionMs, 42000);
    });

    test('dead neighbors shift the index, the track id wins', () {
      // 'b' before the current 'c' died: saved index 2 is now 1.
      final res = restorePosition(
        restoredIds: const ['a', 'c', 'd'],
        savedIndex: 2,
        savedTrackId: 'c',
        savedPositionMs: 10000,
      );
      expect(res.index, 1);
      expect(res.positionMs, 10000);
    });

    test('current track gone -> keep the queue, start fresh', () {
      final res = restorePosition(
        restoredIds: const ['a', 'b'],
        savedIndex: 5,
        savedTrackId: 'zzz',
        savedPositionMs: 10000,
      );
      expect(res.index, 1); // clamped to the last alive
      expect(res.positionMs, 0);
    });
  });
}
