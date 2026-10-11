const Duration restartCurrentTrackWithin = Duration(seconds: 10);

enum SkipPreviousAction { restartCurrent, goToPrevious }

SkipPreviousAction skipPreviousAction(Duration position) =>
    position > restartCurrentTrackWithin
    ? SkipPreviousAction.restartCurrent
    : SkipPreviousAction.goToPrevious;
