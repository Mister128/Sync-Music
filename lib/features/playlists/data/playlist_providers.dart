import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sync_music/core/database/database_provider.dart';
import 'package:sync_music/features/playlists/data/datasources/playlist_dao.dart';
import 'package:sync_music/features/playlists/domain/entities/playlist.dart';

final playlistDaoProvider = Provider<PlaylistDao>(
  (ref) => PlaylistDao(ref.watch(databaseProvider)),
);

final playlistsProvider = StreamProvider<List<Playlist>>(
  (ref) => ref.watch(playlistDaoProvider).watchPlaylists(),
);
