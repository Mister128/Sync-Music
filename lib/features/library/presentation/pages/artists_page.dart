import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:sync_music/app/router/routes.dart';
import 'package:sync_music/core/design_system/theme/app_spacing.dart';
import 'package:sync_music/core/design_system/widgets/sm_artwork.dart';
import 'package:sync_music/features/library/data/library_providers.dart';
import 'package:sync_music/i18n/strings.g.dart';

/// "Artists" section: plain list, rows open the artist page.
class ArtistsPage extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Translations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return switch (ref.watch(artistsProvider)) {
      AsyncData(:final value) when value.isEmpty => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person_outline, size: 48, color: scheme.onSurfaceVariant),
          const SizedBox(height: AppSpacing.lg),
          Text(t.library.artistsEmpty, style: theme.textTheme.titleMedium),
        ],
      ),

      AsyncData(:final value) => ListView.builder(
        itemCount: value.length,
        itemBuilder: (context, index) {
          final artist = value[index];
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
            ),
            leading: SmArtwork(
              hash: artist.artworkHash,
              size: 52,
              borderRadius: 26,
            ),
            title: Text(
              artist.artistName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              '${t.library.albumCount(count: artist.albumCount, n: artist.albumCount)} | '
              '${t.library.trackCount(count: artist.trackCount, n: artist.trackCount)}',
            ),
            onTap: () => context.push(Routes.artistPath(artist.artistName)),
          );
        },
      ),

      AsyncError(:final error) => Center(child: Text('$error')),
      AsyncLoading() => const Center(child: CircularProgressIndicator()),
    };
  }
}
