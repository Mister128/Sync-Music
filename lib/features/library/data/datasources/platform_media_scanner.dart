import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:sync_music/features/library/domain/entities/file_entry.dart';

/// The device's system media library as a file-entry source
/// (Android: MediaStore; iOS would slot MPMediaLibrary in behind this
/// same interface if it ever happens).
///
/// Abstract so RescanLibrary stays testable with a fake on any host OS.
abstract interface class PlatformMediaScanner {
  Future<bool> hasPermission();

  /// Asks the user once; false = denied (the caller must NOT tombstone
  /// anything in that case).
  Future<bool> requestPermission();

  /// Every audio file known to the system: path + size + mtimeMs - the
  /// SAME shape the desktop walker produces, so diff/parse/artwork are
  /// shared. mtime comes from MediaStore (seconds x1000), never from
  /// statSync - consistently, because the pipeline persists whatever the
  /// FileEntry carried.
  Future<List<FileEntry>> queryAudioFiles();
}

class MediaStoreScanner implements PlatformMediaScanner {
  const new();

  static const _channel = MethodChannel('sync_music/media_store');

  // Permission.audio = READ_MEDIA_AUDIO on API 33+; permission_handler
  // falls back to READ_EXTERNAL_STORAGE on older Android (irrelevant for
  // our devices, but the manifest covers both).
  @override
  Future<bool> hasPermission() => Permission.audio.isGranted;

  @override
  Future<bool> requestPermission() async {
    final status = await Permission.audio.request();
    return status.isGranted;
  }

  @override
  Future<List<FileEntry>> queryAudioFiles() async {
    final raw = await _channel.invokeMethod<List<Object?>>('queryAudioFiles');
    return [
      for (final item in raw ?? const <Object?>[])
        if (item is Map)
          FileEntry(
            path: item['path']! as String,
            sizeBytes: (item['sizeBytes']! as num).toInt(),
            mtimeMs: (item['mtimeMs']! as num).toInt(),
          ),
    ];
  }
}