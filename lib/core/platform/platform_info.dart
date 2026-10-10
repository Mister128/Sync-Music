import 'dart:io' show Platform;

/// "Who are we" - the single place for platform questions. Widgets and
/// services ask here instead of sprinkling Platform.isX checks around.
abstract final class PlatformInfo {
  /// True when the library comes from the system media database
  /// (Android: MediaStore) instead of user-picked folders - scoped storage
  /// makes folder picking useless there.
  static bool get usesSystemMediaLibrary => Platform.isAndroid;

  static bool get isDesktop =>
      Platform.isWindows || Platform.isLinux || Platform.isMacOS;
}
