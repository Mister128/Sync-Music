import 'dart:io';
import 'dart:typed_data';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

import 'package:sync_music/core/database/app_database.dart';
import 'package:sync_music/core/logging/app_logger.dart';
import 'package:sync_music/features/library/data/datasources/library_dao.dart';
import 'package:sync_music/features/library/data/datasources/library_roots_dao.dart';
import 'package:sync_music/features/library/data/datasources/tag_reader.dart';
import 'package:sync_music/features/library/data/services/rescan_library.dart';
import 'package:sync_music/features/library/domain/entities/file_entry.dart';
import 'package:sync_music/features/library/domain/entities/scan_event.dart';

import 'fake_platform_scanner.dart';
import 'wav_fixture.dart';

/// Builds a minimal valid WAV: canonical 44-byte header + 100 silent samples
/// (8-bit PCM, mono, 8kHz). No INFO tags inside - on purpose, so the scan
/// exercises the filename-fallback path with a REAL file.

void main() {
  setUpAll(AppLogger.init);

  late Directory tempDir;
  late AppDatabase db;
  late LibraryDao tracksDao;
  late LibraryRootsDao rootsDao;
  late RescanLibrary rescan;

  setUp(() {
    tempDir = Directory.systemTemp.createTempSync('rescan_test');
    db = AppDatabase.forTesting(NativeDatabase.memory());
    tracksDao = LibraryDao(db);
    rootsDao = LibraryRootsDao(db);
    rescan = RescanLibrary(
      db: db,
      tracksDao: tracksDao,
      rootsDao: rootsDao,
      platformScanner: FakePlatformScanner(),
      android: false
    );
  });

  tearDown(() async {
    await db.close();
    tempDir.deleteSync(recursive: true);
  });

  File writeWav(String name, {int fill = 0x80}) =>
      File(p.join(tempDir.path, name))
        ..writeAsBytesSync(buildTinyWav(fill: fill));

  test('parseTrackBatch reads a real generated audio file', () {
    final f = writeWav('01 - Real Song.wav');

    final result = parseTrackBatch([
      FileEntry(path: f.path, sizeBytes: f.lengthSync(), mtimeMs: 1),
    ]);

    expect(result.skipped, 0);
    expect(result.warnings, isEmpty);
    // Tiny WAV has no tags -> title comes from the filename fallback:
    expect(result.tracks.single.title, 'Real Song');
    expect(result.tracks.single.artistName, 'Unknown artist');
    expect(result.tracks.single.durationMs, isNotNull); // from the RIFF header
    expect(result.tracks.single.contentHash, hasLength(64));
  });

  test('full pipeline: add -> no-op rescan -> remove -> change', () async {
    final a = writeWav('song_a.wav');
    final b = writeWav('song_b.wav', fill: 0x90);
    await rootsDao.addRoot(tempDir.path);

    // --- scan #1: both files are new ---
    var events = await rescan().toList();
    var finished = events.whereType<ScanFinished>().single;
    expect(finished.added, 2);
    expect((finished.changed, finished.removed, finished.skipped), (0, 0, 0));

    final rows = await tracksDao.getAllOnce();
    expect(rows, hasLength(2));
    expect(rows.map((r) => r.title).toSet(), {'song_a', 'song_b'});

    // the root got stamped
    expect((await rootsDao.getAllOnce()).single.lastScannedAtMs, isNotNull);

    // --- scan #2: nothing changed -> ZERO work (this is what diff buys us) ---
    events = await rescan().toList();
    expect(events.whereType<ScanStarted>().single.toProcess, 0);
    finished = events.whereType<ScanFinished>().single;
    expect((finished.added, finished.changed, finished.removed), (0, 0, 0));

    // --- delete a file -> tombstone ---
    a.deleteSync();
    events = await rescan().toList();
    finished = events.whereType<ScanFinished>().single;
    expect(finished.removed, 1);

    final alive = await tracksDao.watchTracks().first; // filters tombstones
    expect(alive, hasLength(1));
    expect(
      await tracksDao.getAllOnce(),
      hasLength(2),
    ); // soft delete: row survives!

    // --- modify the other file: append one byte ---
    // Size change guarantees detection even if mtime lands in the same ms.
    b.writeAsBytesSync([...b.readAsBytesSync(), 0]);
    events = await rescan().toList();
    finished = events.whereType<ScanFinished>().single;
    expect(finished.changed, 1);
  });

  test('duplicate content in two files: first wins (v1 policy)', () async {
    writeWav('copy_a.wav'); // identical bytes on purpose
    writeWav('copy_b.wav');
    await rootsDao.addRoot(tempDir.path);

    final events = await rescan().toList();
    final finished = events.whereType<ScanFinished>().single;

    // The duplicate is skipped entirely: not inserted, not counted.
    // `added` is an HONEST count of inserted/revived rows (it used to
    // count attempts back in the insertOrIgnore era).
    expect(finished.added, 1);
    expect(await tracksDao.getAllOnce(), hasLength(1)); // first copy wins
  });

  test('deleted file restored later comes back to life', () async {
    final f = writeWav('zombie.wav');
    await rootsDao.addRoot(tempDir.path);
    await rescan().toList();
    expect(await tracksDao.getAllOnce(), hasLength(1));

    f.deleteSync();
    await rescan().toList();
    expect(await tracksDao.watchTracks().first, isEmpty);

    writeWav('zombie.wav'); // user restores the file
    final events = await rescan().toList();
    expect(events.whereType<ScanFinished>().single.added, 1);

    final alive = await tracksDao.watchTracks().first;
    expect(alive, hasLength(1));
    expect(await tracksDao.getAllOnce(), hasLength(1));
  });

  test('missing root folder does NOT tombstone its tracks', () async {
    final musicDir = Directory(p.join(tempDir.path, 'music'))..createSync();
    File(p.join(musicDir.path, 'song.wav')).writeAsBytesSync(buildTinyWav());
    await rootsDao.addRoot(musicDir.path);
    await rescan().toList();
    expect(await tracksDao.getAllOnce(), hasLength(1));

    // "External drive unplugged": folder gone, root still registered.
    musicDir.deleteSync(recursive: true);
    final events = await rescan().toList();

    expect(events.whereType<ScanFinished>().single.removed, 0); // <- protection
    expect(await tracksDao.watchTracks().first, hasLength(1)); // track survives
  });

  test('removing a root tombstones its tracks on the next scan', () async {
    final song = writeWav('doomed.wav');
    await rootsDao.addRoot(tempDir.path);
    await rescan().toList();
    expect(await tracksDao.getAllOnce(), hasLength(1));

    await rootsDao.removeRoot(tempDir.path); // user action, file stays on disk
    final events = await rescan().toList();

    expect(events.whereType<ScanFinished>().single.removed, 1);
    expect(await tracksDao.watchTracks().first, isEmpty);
    expect(song.existsSync(), isTrue); // we never delete user files
  });
}
