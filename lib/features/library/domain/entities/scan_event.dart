import 'package:freezed_annotation/freezed_annotation.dart';

part 'scan_event.freezed.dart';

/// Progress protocol of a library rescan. The UI (3.6+) and logs consume
/// this stream; the scanner itself never touches talker from isolates.
@freezed
sealed class ScanEvent with _$ScanEvent {
  const factory started({required int filesFound, required int toProcess}) =
      ScanStarted;
  const factory progress({required int processed, required int total}) =
      ScanProgress;
  const factory finished({
    required int added,
    required int changed,
    required int removed,
    required int skipped,
  }) = ScanFinished;
  const factory failed({required String message}) = ScanFailed;
}
