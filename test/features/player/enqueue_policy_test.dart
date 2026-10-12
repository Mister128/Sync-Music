import 'package:flutter_test/flutter_test.dart';

import 'package:sync_music/features/player/domain/services/enqueue_policy.dart';

void main() {
  group('enqueueAction', () {
    test('empty queue -> play now, whatever was requested', () {
      expect(
        enqueueAction(queueEmpty: true, next: true),
        EnqueueAction.playNow,
      );
      expect(
        enqueueAction(queueEmpty: true, next: false),
        EnqueueAction.playNow,
      );
    });

    test('non-empty queue -> the requested spot', () {
      expect(
        enqueueAction(queueEmpty: false, next: true),
        EnqueueAction.insertNext,
      );
      expect(
        enqueueAction(queueEmpty: false, next: false),
        EnqueueAction.appendToQueue,
      );
    });
  });
}
