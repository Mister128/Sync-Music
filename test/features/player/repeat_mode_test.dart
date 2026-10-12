import 'package:flutter_test/flutter_test.dart';

import 'package:sync_music/features/player/domain/entities/repeat_mode.dart';

void main() {
  group('RepeatModeCycle', () {
    test('cycles off -> all -> one -> off', () {
      expect(RepeatMode.off.next, RepeatMode.all);
      expect(RepeatMode.all.next, RepeatMode.one);
      expect(RepeatMode.one.next, RepeatMode.off);
    });

    test('three taps land back on the original mode', () {
      var mode = RepeatMode.one;
      for (var i = 0; i < 3; i++) {
        mode = mode.next;
      }
      expect(mode, RepeatMode.one);
    });
  });
}
