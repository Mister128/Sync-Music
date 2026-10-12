import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;

import 'package:sync_music/core/utils/dominant_color.dart';

void main() {
  /// Solid red JPEG with an optional white strip at the bottom.
  Uint8List fixture({int whiteFrom = 64}) {
    final image = img.Image(width: 64, height: 64);
    // fillRect takes two INCLUSIVE corners (x1,y1)-(x2,y2), clamped to
    // the image bounds - the last pixel is 63, not 64.
    img.fillRect(
      image,
      x1: 0,
      y1: 0,
      x2: 63,
      y2: 63,
      color: img.ColorRgb8(200, 40, 40),
    );
    if (whiteFrom < 64) {
      img.fillRect(
        image,
        x1: 0,
        y1: whiteFrom,
        x2: 63,
        y2: 63,
        color: img.ColorRgb8(255, 255, 255),
      );
    }
    return img.encodeJpg(image);
  }

  group('dominantColor', () {
    test('solid color comes back approximately intact', () async {
      final argb = await dominantColor(fixture());

      expect(argb, isNotNull);
      final r = (argb! >> 16) & 0xFF;
      final g = (argb >> 8) & 0xFF;
      final b = argb & 0xFF;
      // JPEG is lossy and Celebi moves cluster centers - wide tolerance.
      expect((r - 200).abs(), lessThan(40));
      expect(g, lessThan(110));
      expect(b, lessThan(110));
    });

    test('the majority color wins over a big minority', () async {
      // 70% red, 30% white: red must win even though white is "louder"
      // for naive extremes-skipping heuristics.
      final argb = (await dominantColor(fixture(whiteFrom: 45)))!;

      final r = (argb >> 16) & 0xFF;
      final g = (argb >> 8) & 0xFF;
      expect(r, greaterThan(140));
      expect(g, lessThan(110));
    });

    test('undecodable bytes -> null', () async {
      // 5 bytes of garbage. package:image 4.10.1 THROWS on this (PSD
      // sniffer reads a uint16 out of bounds) - dominantColor must catch
      // and return null: the contract is "never throws".
      expect(await dominantColor(Uint8List.fromList([1, 2, 3, 4, 5])), isNull);
    });
  });
}
