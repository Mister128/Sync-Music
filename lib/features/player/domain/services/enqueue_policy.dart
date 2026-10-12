/// What a queue request ("play next" / "add to queue") turns into, given
/// the current queue. Pure product rule, no Flutter - same pattern as
/// skip_policy.dart.
enum EnqueueAction { playNow, insertNext, appendToQueue }

/// With an EMPTY queue both requests collapse to "play now": there is no
/// "next" to insert at, and an added-but-not-current track would be
/// invisible (MiniPlayer hides until something is current). Samsung Music
/// behaves the same way.
EnqueueAction enqueueAction({required bool queueEmpty, required bool next}) =>
    queueEmpty
    ? EnqueueAction.playNow
    : next
    ? EnqueueAction.insertNext
    : EnqueueAction.appendToQueue;
