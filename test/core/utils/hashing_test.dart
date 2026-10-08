import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:sync_music/core/utils/hashing.dart';

void main() {
  late Directory tempDir;

  setUp(() => tempDir = Directory.systemTemp.createTempSync('hashing_test'));
  tearDown(() => tempDir.deleteSync(recursive: true));

  File write(String name, List<int> bytes) =>
      File('${tempDir.path}/$name')..writeAsBytesSync(bytes);

  test('same content in different files -> same hash', () {
    final a = write('a.mp3', List.filled(1000, 42));
    final b = write('b_copy.mp3', List.filled(1000, 42));
    expect(fastHashFile(a.path), fastHashFile(b.path));
  });

  test('hash is a lowercase sha256 hex string', () {
    expect(
      fastHashFile(write('f.mp3', [1, 2, 3]).path),
      matches(RegExp(r'^[0-9a-f]{64}$')),
    );
  });

  test('different first byte -> different hash', () {
    final a = write('a.mp3', [1, 2, 3]);
    final b = write('b.mp3', [9, 2, 3]);
    expect(fastHashFile(a.path), isNot(fastHashFile(b.path)));
  });

  test(
    'same prefix, different size -> different hash (size is hashed too)',
    () {
      final a = write('a.mp3', List.filled(100, 7));
      final b = write('b.mp3', List.filled(200, 7));
      expect(fastHashFile(a.path), isNot(fastHashFile(b.path)));
    },
  );

  test('empty file does not crash', () {
    expect(fastHashFile(write('empty.mp3', []).path), hasLength(64));
  });

  test('large file: change in the TAIL region is detected', () {
    final big = List<int>.generate(400 * 1024, (i) => i % 251);
    final a = write('big_a.mp3', big);

    final mutated = List<int>.of(big)..[big.length - 1] = (big.last + 1) % 256;
    final b = write('big_b.mp3', mutated);

    expect(fastHashFile(a.path), isNot(fastHashFile(b.path)));
  });

  test(
    'large file: change in the MIDDLE is NOT detected (documented tradeoff)',
    () {
      // 400KB file: head covers 0..256KB, tail covers 336KB..400KB.
      // A byte at 300KB falls into the blind spot — by design.
      final big = List<int>.generate(400 * 1024, (i) => i % 251);
      final a = write('big_a.mp3', big);

      final mutated = List<int>.of(big)
        ..[300 * 1024] = (big[300 * 1024] + 1) % 256;
      final b = write('big_b.mp3', mutated);

      expect(fastHashFile(a.path), fastHashFile(b.path)); // SAME - intentional
    },
  );
}
