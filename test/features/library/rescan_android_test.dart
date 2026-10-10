import 'dart:io';

import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

import 'package:sync_music/core/database/app_database.dart';
import 'package:sync_music/core/logging/app_logger.dart';
import 'package:sync_music/features/library/data/datasources/library_dao.dart';
import 'package:sync_music/features/library/data/datasources/library_roots_dao.dart';
import 'package:sync_music/features/library/data/datasources/platform_media_scanner.dart';
import 'package:sync_music/features/library/data/services/rescan_library.dart';
import 'package:sync_music/features/library/domain/entities/file_entry.dart';
import 'package:sync_music/features/library/domain/entities/scan_event.dart';

import 'fake_platform_scanner.dart';
import 'wav_fixture.dart';

/// Fake MediaStore: a settable entry list and a settable permission flag.
/// Real files back the entries so the parse stage runs for real.

void main() {
  setUpAll(AppLogger.init);

  late Directory tempDir;
  late AppDatabase db;
  late LibraryDao tracksDao;
  late LibraryRootsDao rootsDao;

  setUp(() {
    tempDir = Directory.systemTemp.createTempSync('rescan_android');
    db = AppDatabase.forTesting(NativeDatabase.memory());
    tracksDao = LibraryDao(db);
    rootsDao = LibraryRootsDao(db);
  });

  tearDown(() async {
    await db.close();
    tempDir.deleteSync(recursive: true);
  });

  File writeWav(String name, {int fill = 0x80}) =>
      File(p.join(tempDir.path, name))
        ..writeAsBytesSync(buildTinyWav(fill: fill));

  /// android: true forces the MediaStore branch on ANY host OS - that is
  /// exactly why the flag is injectable.
  RescanLibrary rescanWith(PlatformMediaScanner scanner) => RescanLibrary(
    db: db,
    tracksDao: tracksDao,
    rootsDao: rootsDao,
    platformScanner: scanner,
    android: true,
  );

  test('denied permission -> ScanFailed, library untouched', () async {
    // A pre-existing row must survive: denied != "the user deleted everything".
    final now = DateTime.now().millisecondsSinceEpoch;
    await tracksDao.insertAllAtomic([
      TracksCompanion.insert(
        id: 'id-1',
        contentHash: 'ch-1',
        title: 'Survivor',
        addedAtMs: now,
        updatedAtMs: now,
        localPath: const Value('/music/survivor.mp3'),
      ),
    ]);
    final scanner = FakePlatformScanner(granted: false);

    final events = await rescanWith(scanner).call().toList();

    expect(events.whereType<ScanFailed>(), hasLength(1));
    expect(scanner.permissionRequests, 1); // asked exactly once
    expect(await tracksDao.watchTracks().first, hasLength(1)); // untouched
  });

  test('MediaStore entries flow through the SAME pipeline (no roots!)',
          () async {
        final a = writeWav('song_a.wav');
        final b = writeWav('song_b.wav', fill: 0x90);
        final scanner = FakePlatformScanner(entries: [
          FileEntry(path: a.path, sizeBytes: a.lengthSync(), mtimeMs: 1000),
          FileEntry(path: b.path, sizeBytes: b.lengthSync(), mtimeMs: 1000),
        ]);

        // NOTE: no rootsDao.addRoot() anywhere - Android ignores roots entirely.
        var events = await rescanWith(scanner).call().toList();
        var finished = events.whereType<ScanFinished>().single;
        expect((finished.added, finished.changed, finished.removed), (2, 0, 0));
        expect(await tracksDao.watchTracks().first, hasLength(2));

        // --- nothing changed: MediaStore mtime is stable -> ZERO re-parses ---
        events = await rescanWith(scanner).call().toList();
        expect(events.whereType<ScanStarted>().single.toProcess, 0);

        // --- a file disappears from MediaStore -> tombstoned next pass ---
        scanner.entries = [
          FileEntry(path: a.path, sizeBytes: a.lengthSync(), mtimeMs: 1000),
        ];
        events = await rescanWith(scanner).call().toList();
        finished = events.whereType<ScanFinished>().single;
        expect(finished.removed, 1);
        expect(await tracksDao.watchTracks().first, hasLength(1));
      });
}