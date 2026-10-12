import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;

import 'package:sync_music/core/storage/artwork_paths.dart';
import 'package:sync_music/features/player/data/artwork_palette.dart';

void main() {
  late Directory tempBase;
  late ProviderContainer container;

  setUp(() async {
    tempBase = await Directory.systemTemp.createTemp('artwork_palette_test');
    await initArtWorkDir(base: tempBase);
    container = ProviderContainer();
  });

  tearDown(() async {
    container.dispose();
    if (tempBase.existsSync()) {
      await tempBase.delete(recursive: true);
    }
  });

  test('null hash and missing file resolve to null', () async {
    expect(await container.read(artworkColorProvider(null).future), isNull);
    expect(
      await container.read(artworkColorProvider('no-such-hash').future),
      isNull,
    );
  });

  test('extracts the dominant color of a stored cover', () async {
    const hash = 'test-hash';
    final image = img.Image(width: 48, height: 48);
    img.fill(image, color: img.ColorRgb8(200, 40, 40));
    await artWorkFileFor(hash).writeAsBytes(img.encodeJpg(image));

    final color = await container.read(artworkColorProvider(hash).future);

    expect(color, isNotNull);
    expect(color!.r, greaterThan(0.55));
    expect(color.g, lessThan(0.45));
    expect(color.b, lessThan(0.45));
  });

  test('the same hash hits the family cache', () async {
    const hash = 'cached-hash';
    final image = img.Image(width: 16, height: 16);
    img.fill(image, color: img.ColorRgb8(20, 160, 90));
    await artWorkFileFor(hash).writeAsBytes(img.encodeJpg(image));

    final first = await container.read(artworkColorProvider(hash).future);
    // Delete the file: a cached entry still resolves to the same Color,
    // proving the second read never touched the disk again.
    artWorkFileFor(hash).deleteSync();
    final second = await container.read(artworkColorProvider(hash).future);

    expect(second, first);
  });
}
