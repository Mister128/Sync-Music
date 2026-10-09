import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:audio_metadata_reader/audio_metadata_reader.dart';
import 'package:crypto/crypto.dart';
import 'package:path/path.dart' as p;

import 'package:sync_music/core/storage/artwork_paths.dart';
import 'package:sync_music/features/library/data/datasources/artwork_image.dart';

/// One embedded cover prepared inside a worker isolate.
/// Same "warnings travel as data" contract as ParseBatchResult.
typedef PreparedArtWork = ({String? hash, Uint8List? jpeg, String? warning});

/// Runs INSIDE a worker isolate: top-level, sendable args/results only -
/// identical rules to parseTrackBatch in tag_reader.dart.
///
/// Hashes the ORIGINAL cover bytes (the content address), and - unless an
/// identical cover is already on disk - resizes it to JPEG.
PreparedArtWork prepareArtWork(String audioPath, String artworkDirPath) {
  try {
    final meta = readMetadata(File(audioPath), getImage: true);
    if (meta.pictures.isEmpty) {
      return (hash: null, jpeg: null, warning: null);
    }

    final raw = meta.pictures.first.bytes;
    final hash = sha256.convert(raw).toString();

    // Dedup: every track of an album embeds the same cover bytes, so a single
    // `<hash>.jpg` is shared by all of them. Skip the resize when it exists.
    if (File(p.join(artworkDirPath, '$hash.jpg')).existsSync()) {
      return (hash: hash, jpeg: null, warning: null);
    }

    final jpeg = resizeToJpeg(raw);
    if (jpeg == null) {
      return (
        hash: null,
        jpeg: null,
        warning: '$audioPath: embedded cover undecodable',
      );
    }
    return (hash: hash, jpeg: jpeg, warning: null);
  } on Object catch (e) {
    return (hash: null, jpeg: null, warning: '$audioPath: artwork failed ($e)');
  }
}

/// Content-addressed cover store: `<support>/artwork/<sha256>.jpg.`
/// Heavy work (read + decode + resize) runs off the main isolate; this class
/// only orchestrates and performs the atomic write.
class ArtworkStore {
  const new();

  /// Ensures the cover embedded in [audioPath] is stored, returns its hash.
  /// hash == null => "no usable cover" (the tile keeps its placeholder).
  Future<({String? hash, String? warning})> storeFromAudio(
    String audioPath,
  ) async {
    final dirPath = artworkDir.path;
    final res = await Isolate.run(() => prepareArtWork(audioPath, dirPath));

    final hash = res.hash;
    final jpeg = res.jpeg;
    if (hash != null && jpeg != null) {
      // Atomic write: fully write a temp file, then rename over the target.
      // A crash mid-write can never leave a half-written `<hash>.jpg` that the
      // UI would later try (and fail) to decode.
      final file = artWorkFileFor(hash);
      final tmp = File('${file.path}.tmp');
      await tmp.writeAsBytes(jpeg, flush: true);
      await tmp.rename(file.path);
    }
    return (hash: hash, warning: res.warning);
  }
}
