import 'package:freezed_annotation/freezed_annotation.dart';

part 'scanned_track.freezed.dart';

/// A fully parsed track, ready to be written into the DB.
/// Primitives only - must survive the trip back from a worker isolate.
@freezed
abstract class ScannedTrack with _$ScannedTrack {
  const factory({
    // --- facts from the file system (FileEntry) ---
    required String path,
    required int sizeBytes,
    required int mtimeMs,

    // --- identity ---
    required String contentHash,

    // --- facts from tags (with filename fallbacks applied) ---
    required String title,
    required String artistName,
    String? albumTitle,
    int? trackNumber,
    int? discNumber,
    int? year,
    String? genre,
    int? durationMs,
    int? bitrate,
    int? sampleRate,
  }) = _ScannedTrack;
}
