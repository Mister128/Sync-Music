import 'dart:typed_data';

Uint8List buildTinyWav({int fill = 0x80}) {
  const sampleRate = 8000;
  const dataSize = 100;
  final bytes = Uint8List(44 + dataSize);
  final bd = ByteData.sublistView(bytes);

  void str(int offset, String s) {
    for (var i = 0; i < s.length; i++) {
      bd.setUint8(offset + i, s.codeUnitAt(i));
    }
  }

  // NOTE: WAV is little-endian (contrast with our big-endian size in hashing -
  // every format picks its own byte order, that's why it's always explicit).
  str(0, 'RIFF');
  bd.setUint32(4, 36 + dataSize, Endian.little);
  str(8, 'WAVE');
  str(12, 'fmt ');
  bd
    ..setUint32(16, 16, Endian.little) // fmt chunk size
    ..setUint16(20, 1, Endian.little) // PCM
    ..setUint16(22, 1, Endian.little) // mono
    ..setUint32(24, sampleRate, Endian.little)
    ..setUint32(28, sampleRate, Endian.little) // byte rate (8-bit mono)
    ..setUint16(32, 1, Endian.little) // block align
    ..setUint16(34, 8, Endian.little); // bits per sample
  str(36, 'data');
  bd.setUint32(40, dataSize, Endian.little);
  bytes.fillRange(44, 44 + dataSize, fill);
  return bytes;
}
