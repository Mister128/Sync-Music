import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';

import 'package:sync_music/core/database/database_provider.dart';
import 'package:sync_music/features/library/domain/entities/track.dart';
import 'package:sync_music/features/playlists/data/datasources/playlist_dao.dart';
import 'package:sync_music/features/playlists/domain/entities/playlist.dart';

final playlistDaoProvider = Provider<PlaylistDao>(
  (ref) => PlaylistDao(ref.watch(databaseProvider)),
);

final playlistsProvider = StreamProvider<List<Playlist>>(
  (ref) => ref.watch(playlistDaoProvider).watchPlaylists(),
);

/// Tracks of one playlist, live, in sort_key order
final StreamProviderFamily<List<Track>, String> playlistTracksProvider =
    StreamProvider.family<List<Track>, String>(
      (ref, playlistId) =>
          ref.watch(playlistDaoProvider).watchPlaylistTracks(playlistId),
    );
