import 'dart:io';

import 'package:audio_metadata_reader/audio_metadata_reader.dart';
import 'package:path/path.dart' as p;
import 'package:sync_music/core/utils/hashing.dart';

import 'package:sync_music/features/library/domain/entities/file_entry.dart';
import 'package:sync_music/features/library/domain/entities/scanned_track.dart';

/// Reads tags for ONE file. Contract: never throws.
/// Returns the track (fallback if tags are broken) + an optional warning
/// that travels as DATA - the orchestrator logs it on the main isolate.
({ScannedTrack track, String? warning}) readTrack(
  FileEntry entry,
  String contentHash,
) {
  try {
    final meta = readMetadata(File(entry.path));
    return (track: mapMetadata(meta, entry, contentHash), warning: null);
  } on Object catch (e) {
    return (
      track: fallbackTrack(entry, contentHash),
      warning:
          '${p.basename(entry.path)}: tags unreadable, title from filename ($e)',
    );
  }
}

/// Result of parsing one batch inside a worker isolate.
/// Same philosophy as WalkResult: warnings travel as data.
typedef ParseBatchResult = ({
  List<ScannedTrack> tracks,
  List<String> warnings,
  int skipped,
});

/// Runs INSIDE a worker isolate: hash + parse one batch. Top-level,
/// no captured state, sendable args and results only.
ParseBatchResult parseTrackBatch(List<FileEntry> batch) {
  final tracks = <ScannedTrack>[];
  final warnings = <String>[];
  var skipped = 0;

  for (final entry in batch) {
    try {
      final hash = fastHashFile(entry.path);
      final result = readTrack(entry, hash);
      tracks.add(result.track);
      if (result.warning != null) warnings.add(result.warning!);
    } on Object catch (e) {
      skipped++;
      warnings.add('${entry.path}: skipped ($e)');
    }
  }

  return (tracks: tracks, warnings: warnings, skipped: skipped);
}

/// Minimal viable track when tags are unreadable.
ScannedTrack fallbackTrack(FileEntry entry, String contentHash) {
  return ScannedTrack(
    path: entry.path,
    sizeBytes: entry.sizeBytes,
    mtimeMs: entry.mtimeMs,
    contentHash: contentHash,
    title: titleFromFilename(entry.path),
    artistName: 'Unknown artist',
  );
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
