import 'dart:io';

import 'package:sync_music/core/constants/audio_extensions.dart';
import 'package:sync_music/features/library/domain/entities/file_entry.dart';

typedef WalkResult = ({
  List<FileEntry> entries,
  List<String> warnings,
  bool rootAvailable, // false -> orchestrator skips this root ENTIRELY
});

Future<WalkResult> walkAudioFiles(String rootPath) async {
  // A missing/unpluggable root is NOT "an empty folder with zero tracks":
  // pretending it's empty would tombstone the whole library section.
  if (!Directory(rootPath).existsSync()) {
    return (
      entries: const <FileEntry>[],
      warnings: ['$rootPath: folder is missing = skipped, tracks preserved'],
      rootAvailable: false,
    );
  }

  final entries = <FileEntry>[];
  final warnings = <String>[];

  try {
    await for (final entity in Directory(
      rootPath,
    ).list(recursive: true, followLinks: false)) {
      if (entity is! File) continue;
      if (!isAudioFile(entity.path)) continue;

      final stats = entity.statSync();
      final entryFile = FileEntry(
        path: entity.path,
        sizeBytes: stats.size,
        mtimeMs: stats.modified.millisecondsSinceEpoch,
      );

      entries.add(entryFile);
    }
  } on FileSystemException catch (e) {
    warnings.add('$rootPath: scan incomplete ($e) ');
    return (entries: entries, warnings: warnings, rootAvailable: false);
  }

  return (entries: entries, warnings: warnings, rootAvailable: true);
}
