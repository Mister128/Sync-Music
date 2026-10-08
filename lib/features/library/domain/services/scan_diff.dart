import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sync_music/core/utils/path_normalizer.dart';

import 'package:sync_music/features/library/domain/entities/file_entry.dart';

part 'scan_diff.freezed.dart';

/// Result of comparing disk state vs database state.
/// `added`/`changed` carry full entries (the scanner needs size/mtime later);
/// removed files are referenced by path only — the repository will look up
/// their track ids and set tombstones.
@freezed
abstract class ScanDiff with _$ScanDiff {
  const factory({
    required List<FileEntry> added,
    required List<FileEntry> changed,
    required List<String> removedPaths,
  }) = _ScanDiff;
}

ScanDiff diffLibrary({
  required List<FileEntry> onDisk,
  required List<FileEntry> inDb,
  String Function(String path) pathNormalizer = defaultPathNormalizer,
}) {
  final dbByPath = <String, FileEntry>{
    for (final entry in inDb) pathNormalizer(entry.path): entry,
  };

  final added = <FileEntry>[];
  final changed = <FileEntry>[];
  final removedPaths = <String>[];

  for (final disk in onDisk) {
    final known = dbByPath.remove(pathNormalizer(disk.path));

    if (known == null) {
      added.add(disk);
    } else if (known.sizeBytes != disk.sizeBytes ||
        known.mtimeMs != disk.mtimeMs) {
      changed.add(disk);
    }
  }

  for (final stale in dbByPath.values) {
    removedPaths.add(stale.path);
  }

  return ScanDiff(added: added, changed: changed, removedPaths: removedPaths);
}
