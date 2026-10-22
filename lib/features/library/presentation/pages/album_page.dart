import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:sync_music/app/router/routes.dart';
import 'package:sync_music/core/design_system/theme/app_spacing.dart';
import 'package:sync_music/core/design_system/widgets/sm_artwork.dart';
import 'package:sync_music/core/design_system/widgets/sm_track_tile.dart';
import 'package:sync_music/core/extensions/duration_x.dart';
import 'package:sync_music/core/selection/selection_controller.dart';
import 'package:sync_music/features/library/data/library_providers.dart';
import 'package:sync_music/features/library/domain/entities/track.dart';
import 'package:sync_music/features/library/presentation/actions/delete_tracks_flow.dart';
import 'package:sync_music/features/player/presentation/controllers/player_controller.dart';
import 'package:sync_music/features/player/presentation/widgets/mini_player_slot.dart';
import 'package:sync_music/features/player/presentation/widgets/track_action_menu.dart';
import 'package:sync_music/i18n/strings.g.dart';

/// Album detail: header (cover + meta) and tracks in playing order.
/// The album title is the whole key - compilations include every artist.
class AlbumPage extends ConsumerWidget {
  const new({required this.albumTitle, super.key});

  final String albumTitle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tracks = ref.watch(albumTracksProvider(albumTitle));
    final inSelectionMode = ref.watch(
      selectionControllerProvider.select((selection) => selection.isNotEmpty),
    );

    return PopScope(
      // Back cancels the selection instead of leaving the page.
      canPop: !inSelectionMode,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) ref.read(selectionControllerProvider.notifier).clear();
      },
      child: Scaffold(
        appBar: AppBar(title: Text(albumTitle)),
        body: Column(
          children: [
            Expanded(
              child: switch (tracks) {
                AsyncData(:final value) when value.isEmpty => const Center(
                  child: Icon(Icons.album_outlined, size: 48),
                ),
                AsyncData(:final value) => _AlbumBody(
                  albumTitle: albumTitle,
                  tracks: value,
                  onPlayTrack: (index) => ref
                      .read(playerControllerProvider.notifier)
                      .playQueue(value, startIndex: index),
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

class _AlbumBody extends ConsumerWidget {
  const new({
    required this.albumTitle,
    required this.tracks,
    required this.onPlayTrack,
  });

  final String albumTitle;
  final List<Track> tracks; // guaranteed non-empty by the caller
  final void Function(int) onPlayTrack;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final t = Translations.of(context);
    final selection = ref.watch(selectionControllerProvider);
    final inSelectionMode = selection.isNotEmpty;

    String? artworkHash;
    var artistName = tracks.first.artistName;
    int? year;
    var totalMs = 0;
    for (final track in tracks) {
      artworkHash ??= track.artworkHash;
      if (track.artistName.compareTo(artistName) < 0) {
        artistName = track.artistName;
      }
      final y = track.year;
      if (y != null && (year == null || y > year)) year = y;
      totalMs += track.durationMs ?? 0;
    }

    final meta = <String>[
      if (year != null) '$year',
      t.library.trackCount(count: tracks.length, n: tracks.length),
      if (totalMs > 0) Duration(milliseconds: totalMs).display,
    ].join(' | ');

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SmArtwork(hash: artworkHash, size: 140, borderRadius: 12),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(albumTitle, style: theme.textTheme.headlineSmall),
                  const SizedBox(height: AppSpacing.xs),
                  // Representative artist - a link to the artist page.
                  InkWell(
                    // No page switches while a selection is pending.
                    onTap: inSelectionMode
                        ? null
                        : () => context.push(Routes.artistPath(artistName)),
                    child: Text(
                      artistName,
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: scheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    meta,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        for (final (i, track) in tracks.indexed)
          SmTrackTile(
            title: track.title,
            subtitle: track.artistName != artistName
                ? track.artistName
                : track.trackNumber == null
                ? null
                : '#${track.trackNumber}',
            durationMs: track.durationMs,
            artworkHash: track.artworkHash,
            selected: selection.contains(track.id),
            onToggleSelect: inSelectionMode
                ? () => ref
                      .read(selectionControllerProvider.notifier)
                      .toggle(track.id)
                : null,
            onTap: inSelectionMode
                ? () => ref
                      .read(selectionControllerProvider.notifier)
                      .toggle(track.id)
                : () => onPlayTrack(i),
            onLongPress: () =>
                ref.read(selectionControllerProvider.notifier).toggle(track.id),
            trailing: inSelectionMode ? null : TrackActionMenu(track: track),
          ),
      ],
    );
  }
}
