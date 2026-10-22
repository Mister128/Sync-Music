import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sync_music/core/design_system/theme/app_spacing.dart';
import 'package:sync_music/core/design_system/widgets/sm_artwork.dart';
import 'package:sync_music/core/design_system/widgets/sm_track_tile.dart';
import 'package:sync_music/core/selection/selection_controller.dart';
import 'package:sync_music/features/library/domain/entities/track.dart';
import 'package:sync_music/features/player/presentation/controllers/player_controller.dart';
import 'package:sync_music/features/player/presentation/widgets/mini_player_slot.dart';
import 'package:sync_music/features/player/presentation/widgets/track_action_menu.dart';
import 'package:sync_music/features/playlists/data/playlist_providers.dart';
import 'package:sync_music/features/playlists/domain/entities/playlist.dart';
import 'package:sync_music/features/playlists/presentation/widgets/playlist_form_dialog.dart';
import 'package:sync_music/i18n/strings.g.dart';

/// Playlist detail.
class PlaylistPage extends ConsumerWidget {
  const new({required this.playlistId, required this.name, super.key});

  final String playlistId;

  /// Initial name from the route; the live entity wins once loaded, so a
  /// rename updates the title in place.
  final String name;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Translations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final dao = ref.read(playlistDaoProvider);
    final selection = ref.watch(selectionControllerProvider);
    final inSelectionMode = selection.isNotEmpty;

    final playlist = (ref.watch(playlistsProvider).value ?? const <Playlist>[])
        .firstWhereOrNull((p) => p.id == playlistId);
    final tracksAsync = ref.watch(playlistTracksProvider(playlistId));
    final trackCount = tracksAsync.value?.length ?? playlist?.trackCount ?? 0;

    return PopScope(
      canPop: !inSelectionMode,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) ref.read(selectionControllerProvider.notifier).clear();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(playlist?.name ?? name),
          actions: [
            // No playlist (deleted while open) -> nothing to rename.
            // Hidden in selection mode: no dialogs over a pending batch.
            if (playlist != null && !inSelectionMode)
              PopupMenuButton<_PlaylistMenu>(
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: _PlaylistMenu.rename,
                    child: Text(t.playlists.rename),
                  ),
                ],
                onSelected: (menu) {
                  switch (menu) {
                    case _PlaylistMenu.rename:
                      unawaited(
                        showPlaylistFormDialog(context, existing: playlist),
                      );
                  }
                },
              ),
            const SizedBox(width: AppSpacing.xs),
          ],
        ),
        body: Column(
          children: [
            _PlaylistHeader(
              artworkHash: playlist?.artworkHash,
              name: playlist?.name ?? name,
              trackCount: trackCount,
            ),
            Expanded(
              child: switch (tracksAsync) {
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

                // Combined edit mode: checkboxes toggle, the ⋮⋮ handle
                // drags. Default (whole-tile) handles are OFF - they would
                // fight the long-press and the checkbox taps.
                AsyncData(:final value) when inSelectionMode =>
                  ReorderableListView.builder(
                    buildDefaultDragHandles: false,
                    padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
                    itemCount: value.length,
                    onReorderItem: (oldIndex, newIndex) => unawaited(
                      dao.moveTrackToIndex(
                        playlistId: playlistId,
                        trackId: value[oldIndex].id,
                        newIndex: newIndex,
                      ),
                    ),
                    itemBuilder: (context, index) =>
                        _trackTile(ref, value, index, selection, true),
                  ),

                AsyncData(:final value) => ListView.builder(
                  padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
                  itemCount: value.length,
                  itemBuilder: (context, index) =>
                      _trackTile(ref, value, index, selection, false),
                ),

                AsyncError(:final error) => Center(child: Text('$error')),
                AsyncLoading() => const Center(
                  child: CircularProgressIndicator(),
                ),
              },
            ),
            MiniPlayerSlot(
              // Playlist context: detach from the playlist, files stay.
              onRemoveSelected: (tracks) async {
                for (final track in tracks) {
                  await dao.removeTrack(
                    playlistId: playlistId,
                    trackId: track.id,
                  );
                }
                return true;
              },
            ),
          ],
        ),
      ),
    );
  }

  /// One row, shared by both list modes so the wiring can't drift apart.
  Widget _trackTile(
    WidgetRef ref,
    List<Track> tracks,
    int index,
    Set<String> selection,
    bool inSelectionMode,
  ) {
    final track = tracks[index];
    void toggle() =>
        ref.read(selectionControllerProvider.notifier).toggle(track.id);

    return SmTrackTile(
      // PK (playlistId, trackId): duplicates are impossible,
      // the plain id IS a unique key here.
      key: ValueKey(track.id),
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
                .playQueue(tracks, startIndex: index),
      onLongPress: toggle,
      trailing: inSelectionMode
          ? ReorderableDragStartListener(
              index: index,
              child: const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.md,
                ),
                child: Icon(Icons.drag_handle),
              ),
            )
          // ⋮ menu: queue actions + detach from this playlist.
          : TrackActionMenu(track: track, playlistId: playlistId),
    );
  }
}

enum _PlaylistMenu { rename }

class _PlaylistHeader extends StatelessWidget {
  const new({required this.name, required this.trackCount, this.artworkHash});

  final String? artworkHash;
  final String name;
  final int trackCount;

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.xl,
        AppSpacing.md,
        AppSpacing.xl,
        AppSpacing.lg,
      ),
      child: Column(
        children: [
          SmArtwork(hash: artworkHash, size: 160, borderRadius: 12),
          const SizedBox(height: AppSpacing.lg),
          Text(
            name,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.headlineSmall,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            t.playlists.trackCount(count: trackCount, n: trackCount),
            style: theme.textTheme.labelMedium?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
