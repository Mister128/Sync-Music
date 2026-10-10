import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sync_music/core/design_system/theme/app_spacing.dart';
import 'package:sync_music/core/design_system/widgets/sm_artwork.dart';
import 'package:sync_music/core/design_system/widgets/sm_track_tile.dart';
import 'package:sync_music/features/library/data/library_providers.dart';
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

    return Scaffold(
      appBar: AppBar(title: Text(artistName)),
      body: switch (tracks) {
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
                      SmArtwork(hash: artworkHash, size: 96, borderRadius: 48),
                      const SizedBox(height: AppSpacing.md),
                      Text(artistName, style: theme.textTheme.headlineSmall),
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
                for (final track in value)
                  SmTrackTile(
                    title: track.title,
                    subtitle: track.albumTitle,
                    durationMs: track.durationMs,
                    artworkHash: track.artworkHash,
                    onTap: () {}, // TODO(Mister128): play (stage 4)
                  ),
              ],
            );
          },
        ),
        AsyncError(:final error) => Center(child: Text('$error')),
        AsyncLoading() => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}
