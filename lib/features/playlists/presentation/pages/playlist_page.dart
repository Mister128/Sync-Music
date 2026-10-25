import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sync_music/app/router/routes.dart';
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
///
/// Selection mode is the COMBINED edit mode:
/// checkboxes + explicit drag handles + the action bar instead of the
/// MiniPlayer. The plain list is a regular ListView - long-press must be
/// free to ENTER selection mode. Route pops are intercepted: back
/// cancels selection first.
class PlaylistPage extends ConsumerStatefulWidget {
  const new({required this.playlistId, required this.name, super.key});

  final String playlistId;

  /// Initial name from the route; the live entity wins once loaded, so a
  /// rename updates the title in place.
  final String name;

  @override
  ConsumerState<PlaylistPage> createState() => _PlaylistPageState();
}

class _PlaylistPageState extends ConsumerState<PlaylistPage> {
  static const _optimisticTtl = Duration(seconds: 3);

  /// Track ids in the just-dragged order, kept until the DB stream
  /// catches up (exact match) or the safety timer fires (failed write).
  List<String>? _optimisticOrder;
  Timer? _optimisticTimeout;

  String get playlistId => widget.playlistId;

  @override
  void dispose() {
    _optimisticTimeout?.cancel();
    super.dispose();
  }

  void _onReorder(List<Track> displayed, int oldIndex, int newIndex) {
    // Reorder LOCALLY first - this is what kills the flash.
    final reordered = [...displayed];
    final moved = reordered.removeAt(oldIndex);
    // onReorderItem normalizes newIndex itself: it is the FINAL position.
    reordered.insert(newIndex, moved);

    setState(() {
      _optimisticOrder = [for (final track in reordered) track.id];
    });
    _optimisticTimeout?.cancel();
    // Safety net: never hold a stale overlay forever (failed write).
    _optimisticTimeout = Timer(_optimisticTtl, () {
      if (mounted) setState(() => _optimisticOrder = null);
    });

    // Then persist. The stream emission matching the overlay clears it
    // (see ref.listen in build).
    unawaited(
      ref
          .read(playlistDaoProvider)
          .moveTrackToIndex(
            playlistId: playlistId,
            trackId: displayed[oldIndex].id,
            newIndex: newIndex,
          ),
    );
  }

  /// Stream value re-sorted into the optimistic order: ids that vanished
  /// drop out; tracks that appeared meanwhile append at the end.
  List<Track> _displayed(List<Track> value) {
    final order = _optimisticOrder;
    if (order == null) return value;
    final byId = {for (final track in value) track.id: track};
    return [for (final id in order) ?byId.remove(id), ...byId.values];
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final selection = ref.watch(selectionControllerProvider);
    final inSelectionMode = selection.isNotEmpty;

    final playlist = (ref.watch(playlistsProvider).value ?? const <Playlist>[])
        .firstWhereOrNull((p) => p.id == playlistId);
    final tracksAsync = ref.watch(playlistTracksProvider(playlistId));
    final trackCount = tracksAsync.value?.length ?? playlist?.trackCount ?? 0;

    // The DB caught up with the drag - drop the overlay, the stream is
    // the truth again.
    ref.listen(playlistTracksProvider(playlistId), (previous, next) {
      final order = _optimisticOrder;
      final value = next.value;
      if (order == null || value == null) return;
      final ids = [for (final track in value) track.id];
      if (const ListEquality<String>().equals(ids, order)) {
        _optimisticTimeout?.cancel();
        setState(() => _optimisticOrder = null);
      }
    });

    final displayed = switch (tracksAsync) {
      AsyncData(:final value) => _displayed(value),
      _ => const <Track>[],
    };

    return PopScope(
      canPop: !inSelectionMode,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) ref.read(selectionControllerProvider.notifier).clear();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(playlist?.name ?? widget.name),
          actions: [
            // No playlist (deleted while open) -> nothing to add to/rename.
            // Both hidden in selection mode: pushing a route IS navigation.
            if (playlist != null && !inSelectionMode)
              IconButton(
                tooltip: t.playlists.addTracks,
                icon: const Icon(Icons.playlist_add),
                onPressed: () => unawaited(_openAddTracks(context)),
              ),
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
              name: playlist?.name ?? widget.name,
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

                // Combined edit mode: checkboxes toggle, the "more" handle
                // drags. Default (whole-tile) handles are OFF - they
                // would fight the long-press and the checkbox taps.
                AsyncData() when inSelectionMode => ReorderableListView.builder(
                  buildDefaultDragHandles: false,
                  padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
                  itemCount: displayed.length,
                  onReorderItem: (oldIndex, newIndex) =>
                      _onReorder(displayed, oldIndex, newIndex),
                  itemBuilder: (context, index) =>
                      _trackTile(displayed, index, selection, true),
                ),

                AsyncData() => ListView.builder(
                  padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
                  itemCount: displayed.length,
                  itemBuilder: (context, index) =>
                      _trackTile(displayed, index, selection, false),
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
                final dao = ref.read(playlistDaoProvider);
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

  /// Pushes the library picker; on return reports how many
  /// tracks were added (null = backed out without adding).
  Future<void> _openAddTracks(BuildContext context) async {
    final added = await context.push<int>(Routes.addTracksPath(playlistId));
    if (added == null || added == 0 || !context.mounted) return;
    final t = Translations.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(t.playlists.addedCount(n: added, count: added)),
      ),
    );
  }

  /// One row, shared by both list modes so the wiring can't drift apart.
  Widget _trackTile(
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
