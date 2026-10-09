import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Content-addressed artwork lives in `<support>/artwork/<hash>.jpg` - right
/// next to the drift DB (drift_flutter uses getApplicationSupportDirectory too).
String? _artworkDirPath;

/// Resolves and creates the artwork directory. Call once from bootstrap()
/// before runApp(). [base] overrides the support dir - tests point it at a
/// temp folder instead of touching the real one.
Future<Directory> initArtWorkDir({Directory? base}) async {
  final support = base ?? await getApplicationSupportDirectory();
  final dir = Directory(p.join(support.path, 'artwork'));
  if (!dir.existsSync()) {
    await dir.create(recursive: true);
  }
  _artworkDirPath = dir.path;
  return dir;
}

/// The cached artwork directory. Requires `initArtworkDir()` to have run.
Directory get artworkDir {
  final path = _artworkDirPath;
  assert(path != null, 'call initArtWorkDir() during bootstrap dirst');
  return Directory(path!);
}

/// Sync hash -> file lookup, used by the UI. Never blocks build().
File artWorkFileFor(String hash) => File(p.join(artworkDir.path, '$hash.jpg'));
