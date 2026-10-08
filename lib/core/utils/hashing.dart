import 'dart:io';
import 'dart:math' show min;
import 'dart:typed_data';

import 'package:crypto/crypto.dart';

/// Byte budget for the cheap fingerprint
const int _headBytes = 256 * 1024;
const int _tailBytes = 64 * 1024;

/// fast_hash = sha256(size || head 256KB || tail 64KB).
///
/// Reads at most ~320KB regardless of file size. Known limitation (pinned
/// by a test): changes in the MIDDLE of files larger than head+tail are
/// not detected - acceptable for duplicate matching; a full hash will be
/// computed lazily for files actually transferred over P2P (stage 10).
///
/// Sync on purpose - designed to run inside a worker isolate.
/// Must produce identical results on different devices (P2P matching!).
String fastHashFile(String path) {
  final file = File(path);
  final length = file.lengthSync();

  final raf = file.openSync();
  try {
    // Head: first 256KB (or the whole file if it's smaller).
    final head = raf.readSync(min(length, _headBytes));

    // Tail: last 64KB, only when the file is big enough that head and
    // tail do not overlap. Otherwise tail stays empty.
    var tail = Uint8List(0);
    if (length > _headBytes + _tailBytes) {
      raf.setPositionSync(length - _tailBytes);
      tail = raf.readSync(_tailBytes);
    }

    // Encode the size as 8 bytes, big-endian - byte-identical on every
    // device, so two peers hashing the same file get the same result.
    final sizeBytes = (ByteData(8)..setUint64(0, length)).buffer.asUint8List();

    // Glue into one byte sequence: [8 size bytes][head][tail].
    final bytes = <int>[...sizeBytes, ...head, ...tail];

    return sha256.convert(bytes).toString();
  } finally {
    raf.closeSync();
  }
}
