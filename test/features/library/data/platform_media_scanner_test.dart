import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sync_music/features/library/data/datasources/platform_media_scanner.dart';
import 'package:sync_music/features/library/domain/entities/file_entry.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channel = MethodChannel('sync_music/media_store');
  const scanner = MediaStoreScanner();

  /// What the platform side "returns" - swapped per test.
  List<Object?>? payload;

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
      expect(call.method, 'queryAudioFiles');
      return payload;
    });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('decodes the platform payload into FileEntry', () async {
    payload = <Object?>[
      <Object?, Object?>{
        'path': '/music/a.mp3',
        'sizeBytes': 100,
        'mtimeMs': 1500,
      },
      <Object?, Object?>{
        'path': '/music/b.flac',
        'sizeBytes': 200,
        'mtimeMs': 2500,
      },
    ];

    expect(await scanner.queryAudioFiles(), const [
      FileEntry(path: '/music/a.mp3', sizeBytes: 100, mtimeMs: 1500),
      FileEntry(path: '/music/b.flac', sizeBytes: 200, mtimeMs: 2500),
    ]);
  });

  test('null payload -> empty list (fresh device, no music yet)', () async {
    payload = null;

    expect(await scanner.queryAudioFiles(), isEmpty);
  });
}