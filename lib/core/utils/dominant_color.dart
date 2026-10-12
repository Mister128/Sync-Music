import 'dart:typed_data';

import 'package:image/image.dart' as img;
import 'package:material_color_utilities/material_color_utilities.dart';

/// The most prominent color of an encoded image, as 0xAARRGGBB, or null
/// when the bytes are not a decodable image.
///
/// We take the LARGEST cluster, not Score.score(): Score is built for
/// generating whole color schemes (it filters "boring" colors and falls
/// back to a default BLUE - a white cover would tint the player blue).
/// "The dominant color" = the biggest population, exactly what
/// palette_generator.dominantColor used to return.
Future<int?> dominantColor(
  Uint8List encodedBytes, {
  int sampleSize = 64,
}) async {
  final img.Image? decoded;
  try {
    decoded = img.decodeImage(encodedBytes);
  } on Object {
    return null;
  }

  if (decoded == null) return null;

  // Downscale first: quantization cost is per pixel, and a 64px thumbnail
  // carries all the information a background tint needs (also averages
  // away JPEG noise).
  final small = img.copyResize(
    decoded,
    width: sampleSize,
    height: sampleSize,
    interpolation: img.Interpolation.linear,
  );

  // Covers come from our own store as JPEG - alpha is always opaque.
  // (Worth knowing: the quantizer DROPS pixels with alpha < 255, so a
  // transparent PNG would silently lose those areas - not our case.)
  final pixels = <int>[
    for (final pixel in small)
      (pixel.a.toInt() << 24) |
          (pixel.r.toInt() << 16) |
          (pixel.g.toInt() << 8) |
          pixel.b.toInt(),
  ];
  if (pixels.isEmpty) return null;

  final result = await QuantizerCelebi().quantize(pixels, 128);
  final clusters = result.colorToCount; // argb -> population
  if (clusters.isEmpty) return null;

  return clusters.entries.reduce((a, b) => a.value >= b.value ? a : b).key;
}
