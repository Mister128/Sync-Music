import 'dart:math';
import 'dart:typed_data';

import 'package:image/image.dart';

/// Decodes raw embedded cover bytes, downscales to fit within [maxDimension] on the
/// longest side (aspect preserved) and re-encodes as JPEG.
Uint8List? resizeToJpeg(Uint8List raw, {int maxDimension = 600}) {
  try {
    final decoded = decodeImage(raw);
    if (decoded == null) return null;

    var resized = decoded;
    final longest = max(decoded.width, decoded.height);
    if (longest > maxDimension) {
      final scale = maxDimension / longest;
      resized = copyResize(
        decoded,
        width: max(1, (decoded.width * scale).round()),
        height: max(1, (decoded.height * scale).round()),
        interpolation: Interpolation.linear,
      );
    }

    return Uint8List.fromList(encodeJpg(resized, quality: 85));
  } on Object {
    return null;
  }
}
