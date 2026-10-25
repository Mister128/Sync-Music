import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sync_music/core/design_system/theme/app_spacing.dart';
import 'package:sync_music/core/design_system/widgets/sm_track_tile.dart';
import 'package:sync_music/core/extensions/build_context_x.dart';
import 'package:sync_music/core/selection/selection_controller.dart';
import 'package:sync_music/features/player/presentation/controllers/player_controller.dart';
import 'package:sync_music/features/player/presentation/widgets/track_action_menu.dart';
import 'package:sync_music/features/playlists/data/playlist_providers.dart';
import 'package:sync_music/features/playlists/domain/entities/playlist.dart';
import 'package:sync_music/i18n/strings.g.dart';

/// Favorites section: the SYSTEM playlist rendered as a plain track
/// list. No rename/delete/add chrome - tracks enter and leave through
/// hearts only (full player, ⋮ menu). A tab page: no Scaffold here, the
/// shell owns the chrome, the bottom slot and the selection nav-lock.
class FavoritesPage extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Translations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final tracksAsync = ref.watch(playlistTracksProvider(kFavoritesPlaylistId));
    final selection = ref.watch(selectionControllerProvider);
    final inSelectionMode = selection.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (!context.isCompact) SmTrackTile(title: t.nav.favorites),
        Expanded(
          child: switch (tracksAsync) {
            AsyncData(:final value) when value.isEmpty => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.favorite_border,
                  size: 48,
                  color: scheme.onSurfaceVariant,
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(t.favorites.empty, style: theme.textTheme.titleMedium),
                Text(t.favorites.emptyHint, style: theme.textTheme.labelMedium),
              ],
            ),

            AsyncData(:final value) => ListView.builder(
              itemCount: value.length,
              itemBuilder: (context, index) {
                final track = value[index];
                void toggle() => ref
                    .read(selectionControllerProvider.notifier)
                    .toggle(track.id);

                return SmTrackTile(
                  title: track.title,
                  subtitle: track.artistName,
                  durationMs: track.durationMs,
                  artworkHash: track.artworkHash,
                  selected: selection.contains(track.id),
                  onToggleSelect: inSelectionMode ? toggle : null,
                  onTap: inSelectionMode
                      ? toggle
                      : () => ref
                            .read(playerControllerProvider.notifier)
                            .playQueue(value, startIndex: index),
                  onLongPress: toggle,
                  // playlistId flips the "remove" label to favorites and
                  // hides "delete forever" - same semantics as a playlist.
                  trailing: inSelectionMode
                      ? null
                      : TrackActionMenu(
                          track: track,
                          playlistId: kFavoritesPlaylistId,
                        ),
                );
              },
            ),

            AsyncError(:final error) => Center(child: Text('$error')),
            AsyncLoading() => const Center(child: CircularProgressIndicator()),
          },
        ),
      ],
    );
  }
}
