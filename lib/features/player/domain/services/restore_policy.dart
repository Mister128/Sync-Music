/// Where to resume a restored session after dead tracks (files deleted
/// since the last run) were filtered out of the saved queue.
/// Pure rule, no Flutter - same pattern as skip_policy/enqueue_policy.
({int index, int positionMs}) restorePosition({
  required List<String> restoredIds,
  required int savedIndex,
  required String? savedTrackId,
  required int savedPositionMs,
}) {
  if (restoredIds.isEmpty) return (index: 0, positionMs: 0);

  // Happy path: the saved spot still holds the saved track. Exact even
  // when the queue contains the same track twice.
  if (savedIndex >= 0 &&
      savedIndex < restoredIds.length &&
      restoredIds[savedIndex] == savedTrackId) {
    return (index: savedIndex, positionMs: savedPositionMs);
  }

  final moved = savedTrackId == null ? -1 : restoredIds.indexOf(savedTrackId);
  if (moved >= 0) return (index: moved, positionMs: savedPositionMs);

  return (index: savedIndex.clamp(0, restoredIds.length - 1), positionMs: 0);
}
