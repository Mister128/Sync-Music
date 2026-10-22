import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sync_music/core/database/database_provider.dart';
import 'package:sync_music/core/selection/selection_controller.dart';
import 'package:sync_music/features/library/data/library_providers.dart';
import 'package:sync_music/features/library/data/models/track_mapper.dart';
import 'package:sync_music/features/library/domain/entities/track.dart';
import 'package:sync_music/features/player/data/just_audio_playback.dart';
import 'package:sync_music/features/player/data/playback_state_dao.dart';
import 'package:sync_music/features/player/data/playback_state_store.dart';
import 'package:sync_music/features/player/domain/services/playback_service.dart';

final playbackServiceProvider = Provider<PlaybackService>((ref) {
  final service = JustAudioPlayback();
  ref.onDispose(service.dispose);
  return service;
});

final playbackStateDaoProvider = Provider<PlaybackStateDao>(
  (ref) => PlaybackStateDao(ref.watch(databaseProvider)),
);

/// Session persistence.
final playbackStateStoreProvider = Provider<PlaybackStateStore>((ref) {
  final store = PlaybackStateStore(
    engine: ref.watch(playbackServiceProvider),
    dao: ref.watch(playbackStateDaoProvider),
    resolveTracks: (ids) async => [
      for (final row in await ref.watch(libraryDaoProvider).tracksByIds(ids))
        row.toEntity(),
    ],
  );
  ref.onDispose(store.dispose);
  return store;
});

final selectedTracksProvider = FutureProvider<List<Track>>((ref) async {
  final ids = ref.watch(selectionControllerProvider);
  return [
    for (final row
        in await ref.watch(libraryDaoProvider).tracksByIds(ids.toList()))
      row.toEntity(),
  ];
});
