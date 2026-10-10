import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:sync_music/app/router/routes.dart';
import 'package:sync_music/core/design_system/theme/app_spacing.dart';
import 'package:sync_music/core/design_system/widgets/sm_artwork.dart';
import 'package:sync_music/features/library/data/library_providers.dart';
import 'package:sync_music/features/library/domain/entities/album.dart';
import 'package:sync_music/i18n/strings.g.dart';

/// "Albums" section: responsive grid, cards open the album page.
class AlbumsPage extends ConsumerWidget {
  const new({super.key});

  static const double _maxCardExtent = 180;
  static const double _cardRadius = 12;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Translations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return switch (ref.watch(albumsProvider)) {
      AsyncData(:final value) when value.isEmpty => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.album_outlined, size: 48, color: scheme.onSurfaceVariant),
          const SizedBox(height: AppSpacing.lg),
          Text(t.library.albumsEmpty, style: theme.textTheme.titleMedium),
        ],
      ),

      AsyncData(:final value) => GridView.builder(
        padding: const EdgeInsets.all(AppSpacing.lg),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: _maxCardExtent,
          mainAxisSpacing: AppSpacing.lg,
          crossAxisSpacing: AppSpacing.lg,
          // Square cover + two text lines under it.
          childAspectRatio: 0.74,
        ),
        itemCount: value.length,
        itemBuilder: (context, index) =>
            _AlbumCard(album: value[index], radius: _cardRadius),
      ),

      AsyncError(:final error) => Center(child: Text('$error')),
      AsyncLoading() => const Center(child: CircularProgressIndicator()),
    };
  }
}

class _AlbumCard extends StatelessWidget {
  const new({required this.album, required this.radius});

  final Album album;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final t = Translations.of(context);

    return InkWell(
      borderRadius: BorderRadius.circular(radius),
      onTap: () => context.push(Routes.albumPath(albumTitle: album.albumTitle)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) => Center(
                child: SmArtwork(
                  hash: album.artworkHash,
                  // Square that fits WHATEVER the cell gives us - no overflow
                  // when the aspect ratio guess is off on odd window sizes.
                  size: constraints.biggest.shortestSide,
                  borderRadius: radius,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            album.albumTitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleSmall,
          ),
          Text(
            '${album.artistName} | '
            '${t.library.trackCount(count: album.trackCount, n: album.trackCount)}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
