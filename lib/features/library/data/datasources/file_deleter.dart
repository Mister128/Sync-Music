import 'dart:io';

import 'package:flutter/services.dart';

/// Removes audio files from disk and returns the subset of paths that were
/// ACTUALLY removed - callers tombstone ONLY those. A file that survived
/// (locked, no permission) must keep its library row, or the row would
/// lie about reality. Never throws for individual file failures.
///
/// Same shape as PlatformMediaScanner: one interface, platform
/// implementations, chosen in library_providers.
abstract interface class FileDeleter {
  Future<List<String>> deleteFiles(List<String> paths);
}

/// Windows/Linux: plain File.delete(). The OS refuses to delete an
/// OPEN file (the currently playing track on Windows) - that surfaces as a
/// failed path, honestly.
class DesktopFileDeleter implements FileDeleter {
  const new();

  @override
  Future<List<String>> deleteFiles(List<String> paths) async {
    final removed = <String>[];
    for (final path in paths) {
      try {
        await File(path).delete();
        removed.add(path);
      } on Object {
        // Locked / already gone / no permission - the row stays alive and
        // the next rescan keeps agreeing with the disk.
      }
    }
    return removed;
  }
}

/// Android 11+ (API 30): scoped storage forbids silent deletes, so we ask
/// the SYSTEM. MediaStore.createDeleteRequest shows its own confirmation
/// (all-or-nothing) - that dialog IS the confirmation, the app must not
/// stack its own on top. Below API 30 deletion is unsupported.
class AndroidMediaStoreDeleter implements FileDeleter {
  const new();

  static const _channel = MethodChannel('sync_music/media_store');

  @override
  Future<List<String>> deleteFiles(List<String> paths) async {
    final deleted = await _channel.invokeMethod<List<Object?>>(
      'deleteFiles',
      paths,
    );
    return [for (final path in deleted ?? const <Object?>[]) '$path'];
  }
}
