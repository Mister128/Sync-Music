import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';

import 'package:sync_music/core/database/tables/library_roots.dart';
import 'package:sync_music/core/database/tables/playback_states.dart';
import 'package:sync_music/core/database/tables/playlist_tracks.dart';
import 'package:sync_music/core/database/tables/playlists.dart';
import 'package:sync_music/core/database/tables/tracks.dart';
part 'app_database.g.dart';

@DriftDatabase(
  tables: [Tracks, LibraryRoots, PlaybackStates, Playlists, PlaylistTracks],
)
class AppDatabase extends _$AppDatabase {
  /// Production: file-backed DB, drift_flutter handles paths per platform.
  new()
    : super(
        driftDatabase(
          name: 'sync_music',
          native: const DriftNativeOptions(
            databaseDirectory: getApplicationSupportDirectory,
          ),
        ),
      );

  /// Tests: in-memory, no files, fast.
  new forTesting(super.e);

  @override
  int get schemaVersion => 6;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
      // Fresh installs never run onUpgrade - the index must be built here.
      await _createSearchIndex();
    },
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await customStatement(
          'ALTER TABLE tracks RENAME COLUMN delete_at_ms TO deleted_at_ms',
        );
        await customStatement(
          'ALTER TABLE tracks ADD COLUMN track_number INTEGER',
        );
        await customStatement(
          'ALTER TABLE tracks ADD COLUMN disc_number INTEGER',
        );
        await customStatement('ALTER TABLE tracks ADD COLUMN year INTEGER');
        await customStatement('ALTER TABLE tracks ADD COLUMN genre TEXT');
        await customStatement('ALTER TABLE tracks ADD COLUMN bitrate INTEGER');
        await customStatement(
          'ALTER TABLE tracks ADD COLUMN sample_rate INTEGER',
        );
      }

      if (from < 3) {
        await customStatement(
          'ALTER TABLE tracks ADD COLUMN artwork_checked_at_ms INTEGER',
        );
      }
      if (from < 4) {
        await m.createTable(playbackStates);
      }
      if (from < 5) {
        await m.createTable(playlists);
        await m.createTable(playlistTracks);
      }
      if (from < 6) {
        await _createSearchIndex();
        // Rows that predate the index - one-time backfill.
        await customStatement(
          'INSERT INTO tracks_fts(rowid, title, artist_name, album_title) '
          'SELECT rowid, title, artist_name, album_title FROM tracks',
        );
      }
    },
  );

  /// Search index: FTS5 EXTERNAL-CONTENT table over `tracks` plus
  /// sync triggers. Virtual tables and triggers are invisible to drift's
  /// codegen, hence raw SQL - and hence BOTH migration paths call this.
  ///
  /// External content = the index stores no text copies, it points back
  /// at `tracks` by rowid. The triggers cover EVERY write path (insert,
  /// revive, re-tag, tombstone - all INSERT or UPDATE), so no DAO method
  /// can forget to refresh the index.
  Future<void> _createSearchIndex() async {
    await customStatement(
      'CREATE VIRTUAL TABLE IF NOT EXISTS tracks_fts USING fts5( '
      'title, artist_name, album_title, '
      "content='tracks', content_rowid='rowid')",
    );
    await customStatement(
      'CREATE TRIGGER IF NOT EXISTS tracks_fts_ai AFTER INSERT ON tracks '
      'BEGIN '
      'INSERT INTO tracks_fts(rowid, title, artist_name, album_title) '
      'VALUES (new.rowid, new.title, new.artist_name, new.album_title); '
      'END',
    );
    await customStatement(
      'CREATE TRIGGER IF NOT EXISTS tracks_fts_ad AFTER DELETE ON tracks '
      'BEGIN '
      'INSERT INTO tracks_fts(tracks_fts, rowid, title, artist_name, album_title) '
      "VALUES ('delete', old.rowid, old.title, old.artist_name, old.album_title); "
      'END',
    );
    await customStatement(
      'CREATE TRIGGER IF NOT EXISTS tracks_fts_au AFTER UPDATE ON tracks '
      'BEGIN '
      'INSERT INTO tracks_fts(tracks_fts, rowid, title, artist_name, album_title) '
      "VALUES ('delete', old.rowid, old.title, old.artist_name, old.album_title); "
      'INSERT INTO tracks_fts(rowid, title, artist_name, album_title) '
      'VALUES (new.rowid, new.title, new.artist_name, new.album_title); '
      'END',
    );
  }
}
