import 'dart:io';

import 'package:audio_metadata_reader/audio_metadata_reader.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sync_music/features/library/data/datasources/tag_reader.dart';
import 'package:sync_music/features/library/domain/entities/file_entry.dart';

void main() {
  const entry = FileEntry(
    path: r'D:\Music\Queen\03 - Cool Song.flac',
    sizeBytes: 123,
    mtimeMs: 456,
  );

  group('titleFromFilename', () {
    test('plain name', () {
      expect(titleFromFilename('song.mp3'), 'song');
    });
    test('track number prefix', () {
      expect(titleFromFilename(r'C:\Music\03 - Cool Song.flac'), 'Cool Song');
    });
    test('artist - title', () {
      expect(titleFromFilename('Artist - Title.mp3'), 'Title');
    });
    test('splits on the FIRST dash only', () {
      expect(titleFromFilename('A - B - C.mp3'), 'B - C');
    });
    test('empty tail falls back to the full name', () {
      expect(titleFromFilename('01 - .mp3'), '01 -');
    });
    test('trims whitespace', () {
      expect(titleFromFilename('  spaces  .mp3'), 'spaces');
    });
  });

  group('mapMetadata', () {
    test('maps all fields', () {
      final meta = AudioMetadata(
        file: File('ignored_here.mp3'),
        title: '  Cool Song  ',
        artist: 'Queen',
        album: 'A Night at the Opera',
        trackNumber: 3,
        discNumber: 1,
        year: DateTime(1975),
        duration: const Duration(minutes: 4, seconds: 21),
        bitrate: 320000,
        sampleRate: 44100,
      )..genres = ['Rock', 'Opera']; // NOTE: genres is a settable property,
      // not a constructor parameter

      final track = mapMetadata(meta, entry, 'hash-1');

      expect(track.title, 'Cool Song'); // trimmed
      expect(track.artistName, 'Queen');
      expect(track.albumTitle, 'A Night at the Opera');
      expect(track.trackNumber, 3);
      expect(track.discNumber, 1);
      expect(track.year, 1975);
      expect(track.genre, 'Rock'); // first genre wins
      expect(track.durationMs, 261000);
      expect(track.bitrate, 320000);
      expect(track.sampleRate, 44100);
      // file facts travel from the entry, not from the metadata:
      expect(track.path, entry.path);
      expect(track.sizeBytes, 123);
      expect(track.mtimeMs, 456);
      expect(track.contentHash, 'hash-1');
    });

    test('empty metadata falls back to filename and Unknown artist', () {
      final meta = AudioMetadata(file: File('x.mp3')); // everything null

      final track = mapMetadata(meta, entry, 'hash-2');

      expect(track.title, 'Cool Song'); // from '03 - Cool Song.flac'
      expect(track.artistName, 'Unknown artist');
      expect(track.albumTitle, isNull);
    });

    test('whitespace-only title is treated as missing', () {
      final meta = AudioMetadata(file: File('x.mp3'), title: '   ');

      expect(mapMetadata(meta, entry, 'h').title, 'Cool Song');
    });
  });
}
