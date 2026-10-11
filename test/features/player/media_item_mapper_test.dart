import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'package:sync_music/core/storage/artwork_paths.dart';
import 'package:sync_music/features/library/domain/entities/track.dart';
import 'package:sync_music/features/player/data/media_item_mapper.dart';

void main() {
  late Directory tempBase;

  setUp(() async {
    // initArtWorkDir(base:) exists exactly for this: point the
    // content-addressed store at a temp dir, never at the real one.
    tempBase = await Directory.systemTemp.createTemp('artwork_mapper_test');
    await initArtWorkDir(base: tempBase);
  });

  tearDown(() async {
    if (tempBase.existsSync()) {
      await tempBase.delete(recursive: true);
    }
  });

  const track = Track(
    id: 'id-1',
    contentHash: 'hash-1',
    title: 'Song',
    artistName: 'Artist',
    albumTitle: 'Album',
    durationMs: 217000,
  );

  group('trackToMediaItem', () {
    test('maps identity, text tags and duration', () {
      final item = trackToMediaItem(track);

      expect(item.id, 'id-1');
      expect(item.title, 'Song');
      expect(item.artist, 'Artist');
      expect(item.album, 'Album');
      expect(item.duration, const Duration(milliseconds: 217000));
    });

    test('unknown duration stays null (system hides the seek bar)', () {
      final item = trackToMediaItem(
        const Track(
          id: 'id-2',
          contentHash: 'hash-2',
          title: 'Song',
          artistName: 'Artist',
        ),
      );

      expect(item.duration, isNull);
    });

    test('artwork hash becomes a file URI into the artwork store', () {
      final item = trackToMediaItem(
        const Track(
          id: 'id-3',
          contentHash: 'hash-3',
          title: 'Song',
          artistName: 'Artist',
          artworkHash: 'abc123',
        ),
      );

      expect(item.artUri, artWorkFileFor('abc123').uri);
      expect(item.artUri!.scheme, 'file');
    });

    test('no artwork hash -> no artUri (placeholder on the system side)', () {
      expect(trackToMediaItem(track).artUri, isNull);
    });
  });
}
