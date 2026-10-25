import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sync_music/features/playlists/data/playlist_providers.dart';
import 'package:sync_music/i18n/strings.g.dart';

/// Heart toggle for one track. Watches the shared favorite-ids set,
/// so EVERY heart in the app updates together from one stream. Lives in
/// playlists.
class FavoriteButton extends ConsumerWidget {
  const new({required this.trackId, super.key});

  final String trackId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Translations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final isFavorite =
        ref.watch(favoriteIdsProvider).value?.contains(trackId) ?? false;

    return IconButton(
      tooltip: isFavorite
          ? t.favorites.removeFromFavorites
          : t.favorites.addToFavorites,
      icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
      color: isFavorite ? scheme.primary : null,
      onPressed: () =>
          unawaited(ref.read(playlistDaoProvider).toggleFavorite(trackId)),
    );
  }
}
