import 'package:flutter_test/flutter_test.dart';

import 'package:sync_music/features/player/domain/services/skip_policy.dart';

void main() {
  group('skipPreviousAction', () {
    test('at the start of the track -> restart it', () {
      expect(
        skipPreviousAction(Duration.zero),
        SkipPreviousAction.restartCurrent,
      );
      expect(
        skipPreviousAction(const Duration(seconds: 9, milliseconds: 999)),
        SkipPreviousAction.restartCurrent,
      );
    });

    test('past the window -> go to the previous track', () {
      expect(
        skipPreviousAction(const Duration(seconds: 11)),
        SkipPreviousAction.goToPrevious,
      );
      expect(
        skipPreviousAction(const Duration(minutes: 3)),
        SkipPreviousAction.goToPrevious,
      );
    });

    test('the window is EXCLUSIVE: exactly 10s already goes back', () {
      expect(
        skipPreviousAction(restartCurrentTrackWithin),
        SkipPreviousAction.goToPrevious,
      );
    });
  });
}
