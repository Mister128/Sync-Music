import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sync_music/core/design_system/theme/app_spacing.dart';
import 'package:sync_music/core/design_system/widgets/sm_track_tile.dart';
import 'package:sync_music/features/player/presentation/controllers/player_controller.dart';
import 'package:sync_music/features/playlists/data/playlist_providers.dart';
import 'package:sync_music/i18n/strings.g.dart';

/// Playlist detail. Tap = play the playlist as the queue; drag =
/// reorder (persisted as a new fractional key between the future
/// neighbors); X = tombstone the membership.
class PlaylistPage extends ConsumerWidget {
  const new({required this.playlistId, required this.name, super.key});

  final String playlistId;
  final String name;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Translations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final dao = ref.read(playlistDaoProvider);

    return Scaffold(
      appBar: AppBar(title: Text(name)),
      body: switch (ref.watch(playlistTracksProvider(playlistId))) {
        AsyncData(:final value) when value.isEmpty => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.playlist_play,
                size: 48,
                color: scheme.onSurfaceVariant,
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                t.playlists.emptyPlaylist,
                style: theme.textTheme.titleMedium,
              ),
              Text(
                t.playlists.emptyPlaylistHint,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),

        AsyncData(:final value) => ReorderableListView.builder(
          padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
          itemCount: value.length,
          onReorderItem: (oldIndex, newIndex) {
            unawaited(
              dao.moveTrackToIndex(
                playlistId: playlistId,
                trackId: value[oldIndex].id,
                newIndex: newIndex,
              ),
            );
          },
          itemBuilder: (context, index) {
            final track = value[index];
            return SmTrackTile(
              key: ValueKey(track.id),
              title: track.title,
              subtitle: track.artistName,
              durationMs: track.durationMs,
              artworkHash: track.artworkHash,
              onTap: () => ref
                  .read(playerControllerProvider.notifier)
                  .playQueue(value, startIndex: index),
              trailing: Padding(
                padding: const EdgeInsets.only(right: AppSpacing.lg),
                child: IconButton(
                  tooltip: t.playlists.removeFromPlaylist,
                  visualDensity: VisualDensity.compact,
                  icon: const Icon(Icons.close, size: 20),
                  onPressed: () => unawaited(
                    dao.removeTrack(playlistId: playlistId, trackId: track.id),
                  ),
                ),
              ),
            );
          },
        ),

        AsyncError(:final error) => Center(child: Text('$error')),
        AsyncLoading() => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}
