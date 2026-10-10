import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:sync_music/app/router/routes.dart';
import 'package:sync_music/core/design_system/theme/app_spacing.dart';
import 'package:sync_music/core/design_system/widgets/sm_artwork.dart';
import 'package:sync_music/core/design_system/widgets/sm_track_tile.dart';
import 'package:sync_music/core/extensions/duration_x.dart';
import 'package:sync_music/features/library/data/library_providers.dart';
import 'package:sync_music/features/library/domain/entities/track.dart';
import 'package:sync_music/i18n/strings.g.dart';

/// Album detail: header (cover + meta) and tracks in playing order.
/// The album title is the whole key - compilations include every artist.
class AlbumPage extends ConsumerWidget {
  const new({required this.albumTitle, super.key});

  final String albumTitle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tracks = ref.watch(albumTracksProvider(albumTitle));

    return Scaffold(
      appBar: AppBar(title: Text(albumTitle)),
      body: switch (tracks) {
      // The album can legitimately vanish between the tap and the push
      // (a rescan tombstoned its last track) - the stream answers with [].
        AsyncData(:final value) when value.isEmpty =>
        const Center(child: Icon(Icons.album_outlined, size: 48)),
        AsyncData(:final value) =>
            _AlbumBody(
              albumTitle: albumTitle,
              tracks: value,
            ),
        AsyncError(:final error) => Center(child: Text('$error')),
        AsyncLoading() => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}

class _AlbumBody extends StatelessWidget {
  const new({required this.albumTitle, required this.tracks});

  final String albumTitle;
  final List<Track> tracks; // guaranteed non-empty by the caller

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final t = Translations.of(context);

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
                    onTap: () => context.push(Routes.artistPath(artistName)),
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
        for (final track in tracks)
          SmTrackTile(
            title: track.title,
            // Compilations: show whose track this is. On a single-artist
            // album the artist is redundant - show the track number instead.
            subtitle: track.artistName != artistName
                ? track.artistName
                : track.trackNumber == null
                ? null
                : '#${track.trackNumber}',
            durationMs: track.durationMs,
            artworkHash: track.artworkHash,
            onTap: () {}, // TODO(Mister128): play
          ),
      ],
    );
  }
}
