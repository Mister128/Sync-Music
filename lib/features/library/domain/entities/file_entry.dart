import 'package:freezed_annotation/freezed_annotation.dart';

part 'file_entry.freezed.dart';

/// Minimal info about a file on disk, enough for incremental diffing.
@freezed
abstract class FileEntry with _$FileEntry {
  const factory ({
    /// Absolute path as produced by Directory.list().
    required String path,

    /// File size in bytes — cheap change detector.
    required int sizeBytes,

    /// Last-modified time, ms since epoch (File.lastModifiedSync()).
    required int mtimeMs,
  }) = _FileEntry;
}
