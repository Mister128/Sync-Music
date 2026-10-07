import 'dart:io' show Platform;

/// Windows paths are case-insensitive (D:\Music == d:\music);
/// Android/Linux/macOS are case-SENSITIVE - never lowercase there,
/// or two real files "Track.mp3"/"track.mp3" would merge into one.
String defaultPathNormalizer(String path) =>
    Platform.isWindows ? path.toLowerCase() : path;
