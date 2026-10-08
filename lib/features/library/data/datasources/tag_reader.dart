import 'dart:io';

import 'package:audio_metadata_reader/audio_metadata_reader.dart';
import 'package:path/path.dart' as p;

import 'package:sync_music/features/library/domain/entities/file_entry.dart';
import 'package:sync_music/features/library/domain/entities/scanned_track.dart';

/// Reads tags for ONE file. Contract: NEVER throws - a single corrupt file
/// must not kill a batch of 50. On parse failure we still register the track
/// with a filename-derived title
ScannedTrack readTrack(FileEntry entry, String contentHash) {
  try {
    final meta = readMetadata(File(entry.path));
    return mapMetadata(meta, entry, contentHash);
  } on Object catch (e) {
    return fallbackTrack(entry, contentHash, e);
  }
}

/// Minimal viable track when tags are unreadable.
ScannedTrack fallbackTrack(FileEntry entry, String contentHash, Object error) {
  return ScannedTrack(
    path: entry.path,
    sizeBytes: entry.sizeBytes,
    mtimeMs: entry.mtimeMs,
    contentHash: contentHash,
    title: titleFromFilename(entry.path),
    artistName: 'Unknown artist',
  );
  // TODO: the orchestrator may want to count/log these — warnings
  // travel as data (no talker inside isolates), decide there.
}

/// Pure mapper: AudioMetadata + file facts -> ScannedTrack.
/// Unit-testable WITHOUT real audio files.
ScannedTrack mapMetadata(AudioMetadata m, FileEntry e, String contentHash) {
  String? clean(String? raw) {
    final trimmed = raw?.trim();
    return (trimmed == null || trimmed.isEmpty) ? null : trimmed;
  }

  return ScannedTrack(
    // --- file fact ---
    path: e.path,
    sizeBytes: e.sizeBytes,
    mtimeMs: e.mtimeMs,
    contentHash: contentHash,
    // --- tags with fallback ---
    title: clean(m.title) ?? titleFromFilename(e.path),
    artistName: clean(m.artist) ?? 'Unknown artist',
    albumTitle: clean(m.album),
    trackNumber: m.trackNumber,
    discNumber: m.discNumber,
    year: m.year?.year,
    genre: m.genres.isNotEmpty ? clean(m.genres.first) : null,
    durationMs: m.duration?.inMilliseconds,
    bitrate: m.bitrate,
    sampleRate: m.sampleRate,
  );
}

String titleFromFilename(String path) {
  const sep = ' - ';
  final filename = p.basenameWithoutExtension(path).trim();
  String title;

  if (filename.contains(sep)) {
    title = filename.substring(filename.indexOf(sep) + sep.length).trim();
  } else {
    title = filename;
  }

  return title;
}
