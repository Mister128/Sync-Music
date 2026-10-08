import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:sync_music/features/library/data/datasources/filesystem_walker.dart';

void main() {
  late Directory tempDir;

  setUp(() => tempDir = Directory.systemTemp.createTempSync('walker_test'));
  tearDown(() => tempDir.deleteSync(recursive: true));

  /// Creates an empty file (walker doesn't read content, so empty is fine).
  /// createSync(recursive: true) also builds missing parent dirs.
  File touch(String relativePath) =>
      File(p.join(tempDir.path, relativePath))..createSync(recursive: true);

  test('finds audio files recursively, ignores everything else', () async {
    touch('a.mp3');
    touch(p.join('sub', 'c.flac'));
    touch('b.txt');
    touch('cover.jpg');

    final result = await walkAudioFiles(tempDir.path);

    expect(result.warnings, isEmpty);
    // Compare BASENAMES via package:path - full paths on Windows depend on
    // temp-dir spelling and separators; basenames are platform-proof.
    expect(result.entries.map((e) => p.basename(e.path)).toSet(), {
      'a.mp3',
      'c.flac',
    });

    // Stat facts are filled in.
    final a = result.entries.firstWhere((e) => p.basename(e.path) == 'a.mp3');
    expect(a.sizeBytes, 0);
    expect(a.mtimeMs, greaterThan(0));
  });

  test('uppercase extension is audio too', () async {
    touch('TRACK.MP3');

    final result = await walkAudioFiles(tempDir.path);

    expect(result.entries, hasLength(1));
    expect(result.warnings, isEmpty);
  });

  test('a DIRECTORY named like an audio file is not an entry', () async {
    // Pins the `entity is! File` guard: with the old && bug a folder
    // called "fake.mp3" would slip through into the library.
    Directory(p.join(tempDir.path, 'fake.mp3')).createSync();
    touch('real.mp3');

    final result = await walkAudioFiles(tempDir.path);

    expect(result.entries.map((e) => p.basename(e.path)).toSet(), {'real.mp3'});
  });

  test('missing root: no throw, empty entries, honest warning', () async {
    final result = await walkAudioFiles(p.join(tempDir.path, 'does_not_exist'));

    expect(result.entries, isEmpty);
    expect(result.warnings, isNotEmpty); // the catch must NOT be silent
  });

  test('empty folder: empty result, no warnings', () async {
    final result = await walkAudioFiles(tempDir.path);

    expect(result.entries, isEmpty);
    expect(result.warnings, isEmpty);
  });
}
