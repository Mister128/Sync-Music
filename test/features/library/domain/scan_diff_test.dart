import 'package:flutter_test/flutter_test.dart';
import 'package:sync_music/features/library/domain/entities/file_entry.dart';
import 'package:sync_music/features/library/domain/services/scan_diff.dart';

void main() {
  // Deterministic normalizer: the suite must behave identically on Windows,
  // Linux and CI regardless of the host platform.
  String lower(String p) => p.toLowerCase();

  // Identity normalizer: simulates case-sensitive file systems (Android/Linux).
  String asIs(String p) => p;

  /// Shorthand for entries - keeps test tables readable.
  FileEntry f(String path, int size, int mtime) =>
      FileEntry(path: path, sizeBytes: size, mtimeMs: mtime);

  group('diffLibrary', () {
    test('empty db: everything on disk is added', () {
      final diff = diffLibrary(
        onDisk: [f('a.mp3', 100, 1), f('b.flac', 200, 2)],
        inDb: const [],
        pathNormalizer: lower,
      );

      expect(
        diff,
        ScanDiff(
          added: [f('a.mp3', 100, 1), f('b.flac', 200, 2)],
          changed: const [],
          removedPaths: const [],
        ),
      );
    });

    test('identical states produce an empty diff', () {
      final state = [f('a.mp3', 100, 1), f('b.flac', 200, 2)];

      final diff = diffLibrary(
        onDisk: state,
        inDb: state,
        pathNormalizer: lower,
      );

      // The most common real-world case: silent auto-rescan on app start.
      expect(diff, const ScanDiff(added: [], changed: [], removedPaths: []));
    });

    test('changed mtime marks the file as changed (disk version wins)', () {
      final diff = diffLibrary(
        onDisk: [f('a.mp3', 100, 5), f('b.flac', 200, 2)],
        inDb: [f('a.mp3', 100, 1), f('b.flac', 200, 2)],
        pathNormalizer: lower,
      );

      expect(
        diff,
        ScanDiff(
          added: const [],
          // CONTRACT: `changed` carries the DISK entry (fresh size/mtime),
          // not the stale DB one - the scanner will persist these values.
          changed: [f('a.mp3', 100, 5)],
          removedPaths: const [],
        ),
      );
    });

    test('changed size marks the file as changed', () {
      final diff = diffLibrary(
        onDisk: [f('a.mp3', 999, 1)],
        inDb: [f('a.mp3', 100, 1)],
        pathNormalizer: lower,
      );

      // Same mtime, different size - must NOT slip through as "unchanged".
      expect(diff.changed, [f('a.mp3', 999, 1)]);
      expect(diff.added, isEmpty);
      expect(diff.removedPaths, isEmpty);
    });

    test('file missing on disk ends up in removedPaths, in db order', () {
      final diff = diffLibrary(
        onDisk: [f('b.flac', 200, 2)],
        inDb: [f('gone1.ogg', 100, 1), f('b.flac', 200, 2), f('gone2.opus', 300, 3)],
        pathNormalizer: lower,
      );

      expect(
        diff,
        const ScanDiff(added: [], changed: [], removedPaths: ['gone1.ogg', 'gone2.opus']),
      );
    });

    test('removedPaths keep the ORIGINAL db casing (repository looks rows up by localPath)', () {
      final diff = diffLibrary(
        onDisk: const [],
        inDb: [f(r'D:\Music\Song.MP3', 100, 1)],
        pathNormalizer: lower,
      );

      // CONTRACT: paths are removed normalized (they are Map keys internally),
      // but reported exactly as stored in the DB - otherwise the repository
      // would fail to find the row by localPath on case-sensitive systems.
      expect(diff.removedPaths, [r'D:\Music\Song.MP3']);
    });

    test('windows casing: same file despite different case', () {
      final diff = diffLibrary(
        onDisk: [f(r'd:\music\a.mp3', 100, 1)],
        inDb: [f(r'D:\Music\A.MP3', 100, 1)],
        pathNormalizer: lower,
      );

      expect(diff, const ScanDiff(added: [], changed: [], removedPaths: []));
    });

    test('case-sensitive normalizer treats different case as different files', () {
      final diff = diffLibrary(
        onDisk: [f(r'/music/a.mp3', 100, 1)],
        inDb: [f(r'/music/A.mp3', 100, 1)],
        pathNormalizer: asIs, // Android/Linux/macOS behavior
      );

      expect(
        diff,
        ScanDiff(
          added: [f(r'/music/a.mp3', 100, 1)],
          changed: const [],
          removedPaths: [r'/music/A.mp3'],
        ),
      );
    });

    test('mixed scenario: order follows the inputs, untouched files ignored', () {
      final onDisk = [
        f('same.mp3', 100, 1),       // untouched
        f('tagged.mp3', 300, 9),     // mtime bumped -> changed
        f('zzz_new.flac', 400, 4),   // -> added
        f('aaa_new.opus', 500, 5),   // -> added (AFTER zzz: disk order, not alphabetical!)
        f('same2.wav', 200, 2),      // untouched
      ];
      final inDb = [
        f('tagged.mp3', 300, 5),
        f('same.mp3', 100, 1),
        f('gone.ogg', 600, 6),       // -> removedPaths
        f('same2.wav', 200, 2),
      ];

      final diff = diffLibrary(
        onDisk: onDisk,
        inDb: inDb,
        pathNormalizer: lower,
      );

      expect(
        diff,
        ScanDiff(
          added: [f('zzz_new.flac', 400, 4), f('aaa_new.opus', 500, 5)],
          changed: [f('tagged.mp3', 300, 9)],
          removedPaths: ['gone.ogg'],
        ),
      );
    });
  });
}