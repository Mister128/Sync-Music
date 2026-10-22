import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sync_music/core/design_system/theme/app_spacing.dart';
import 'package:sync_music/core/design_system/widgets/sm_artwork.dart';
import 'package:sync_music/core/design_system/widgets/sm_track_tile.dart';
import 'package:sync_music/core/selection/selection_controller.dart';
import 'package:sync_music/features/library/data/library_providers.dart';
import 'package:sync_music/features/library/presentation/actions/delete_tracks_flow.dart';
import 'package:sync_music/features/player/presentation/controllers/player_controller.dart';
import 'package:sync_music/features/player/presentation/widgets/mini_player_slot.dart';
import 'package:sync_music/features/player/presentation/widgets/track_action_menu.dart';
import 'package:sync_music/i18n/strings.g.dart';

/// Artist detail: header + all tracks grouped by album.
class ArtistPage extends ConsumerWidget {
  const new({required this.artistName, super.key});

  final String artistName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final t = Translations.of(context);
    final tracks = ref.watch(artistTracksProvider(artistName));
    final selection = ref.watch(selectionControllerProvider);
    final inSelectionMode = selection.isNotEmpty;

    return PopScope(
      // Back cancels the selection instead of leaving the page.
      canPop: !inSelectionMode,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) ref.read(selectionControllerProvider.notifier).clear();
      },
      child: Scaffold(
        appBar: AppBar(title: Text(artistName)),
        body: Column(
          children: [
            Expanded(
              child: switch (tracks) {
                AsyncData(:final value) when value.isEmpty => const Center(
                  child: Icon(Icons.person_outline, size: 48),
                ),
                AsyncData(:final value) => Builder(
                  builder: (context) {
                    // Facts from the list itself: no extra queries.
                    final albumCount = {
                      for (final track in value)
                        if (track.albumTitle != null) track.albumTitle,
                    }.length;

                    final artworkHash = value
                        .map((track) => track.artworkHash)
                        .firstWhere((hash) => hash != null, orElse: () => null);

                    return ListView(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      children: [
                        Center(
                          child: Column(
                            children: [
                              SmArtwork(
                                hash: artworkHash,
                                size: 96,
                                borderRadius: 48,
                              ),
                              const SizedBox(height: AppSpacing.md),
                              Text(
                                artistName,
                                style: theme.textTheme.headlineSmall,
                              ),
                              const SizedBox(height: AppSpacing.xs),
                              Text(
                                '${t.library.albumCount(count: albumCount, n: albumCount)} | '
                                '${t.library.trackCount(count: value.length, n: value.length)}',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: scheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xl),
                        for (final (index, track) in value.indexed)
                          SmTrackTile(
                            title: track.title,
                            subtitle: track.albumTitle,
                            durationMs: track.durationMs,
                            artworkHash: track.artworkHash,
                            selected: selection.contains(track.id),
                            onToggleSelect: inSelectionMode
                                ? () => ref
                                      .read(
                                        selectionControllerProvider.notifier,
                                      )
                                      .toggle(track.id)
                                : null,
                            onTap: inSelectionMode
                                ? () => ref
                                      .read(
                                        selectionControllerProvider.notifier,
                                      )
                                      .toggle(track.id)
                                : () => ref
                                      .read(playerControllerProvider.notifier)
                                      .playQueue(value, startIndex: index),
                            onLongPress: () => ref
                                .read(selectionControllerProvider.notifier)
                                .toggle(track.id),
                            trailing: inSelectionMode
                                ? null
                                : TrackActionMenu(track: track),
                          ),
                      ],
                    );
                  },
                ),
                AsyncError(:final error) => Center(child: Text('$error')),
                AsyncLoading() => const Center(
                  child: CircularProgressIndicator(),
                ),
              },
            ),
            MiniPlayerSlot(
              onDeleteSelected: (selected) =>
                  confirmAndDeleteTracks(context, ref, selected),
            ),
          ],
        ),
      ),
    );
  }
}
