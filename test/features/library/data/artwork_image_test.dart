import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:sync_music/features/library/data/datasources/artwork_image.dart';

void main() {
  // A real encoded image, so decodeImage() has something to chew on.
  Uint8List png(int w, int h) => img.encodePng(img.Image(width: w, height: h));

  group('resizeToJpeg', () {
    test('downscales the longest side to maxSize, aspect preserved', () {
      final out = resizeToJpeg(png(1200, 800));
      expect(out, isNotNull);
      final decoded = img.decodeImage(out!)!;
      expect(decoded.width, 600);
      expect(decoded.height, 400); // 800 * 0.5
    });

    test('portrait: caps the height instead of the width', () {
      final decoded = img.decodeImage(resizeToJpeg(png(800, 1200))!)!;
      expect(decoded.width, 400);
      expect(decoded.height, 600);
    });

    test('already small -> unchanged size (still re-encoded to JPEG)', () {
      final decoded = img.decodeImage(resizeToJpeg(png(100, 50))!)!;
      expect(decoded.width, 100);
      expect(decoded.height, 50);
    });

    test('square at the limit stays square', () {
      final decoded = img.decodeImage(resizeToJpeg(png(600, 600))!)!;
      expect(decoded.width, 600);
      expect(decoded.height, 600);
    });

    test('undecodable bytes -> null (never writes garbage)', () {
      expect(resizeToJpeg(Uint8List.fromList([1, 2, 3, 4])), isNull);
    });

    test('truncated PSD-like bytes -> null (image package sniffer bug)', () {
      final bytes = Uint8List.fromList(<int>[
        0x38,
        0x42,
        0x50,
        0x53,
        0x00,
        0x01,
        0x00,
        0x00,
      ]);

      expect(resizeToJpeg(bytes), isNull);
    });
  });
}
