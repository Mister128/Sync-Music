import 'package:flutter/material.dart';

import 'package:sync_music/core/design_system/theme/app_spacing.dart';
import 'package:sync_music/i18n/strings.g.dart';

/// Section order = TAB order = RAIL order. Single source of truth:
/// reordering tabs means reordering this enum ONLY.
enum PlaceholderSection { favorites, playlists, tracks, albums, artists }

extension PlaceholderSectionX on PlaceholderSection {
  /// Localized tab/rail label.
  String label(Translations t) => switch (this) {
    PlaceholderSection.favorites => t.nav.favorites,
    PlaceholderSection.playlists => t.nav.playlists,
    PlaceholderSection.tracks => t.nav.tracks,
    PlaceholderSection.albums => t.nav.albums,
    PlaceholderSection.artists => t.nav.artists,
  };

  /// Rail icon (tabs on phone are text-only, Samsung style).
  IconData get icon => switch (this) {
    PlaceholderSection.favorites => Icons.favorite,
    PlaceholderSection.playlists => Icons.queue_music,
    PlaceholderSection.tracks => Icons.music_note,
    PlaceholderSection.albums => Icons.album,
    PlaceholderSection.artists => Icons.person,
  };
}

/// Temporary section content. NO Scaffold/AppBar here — the shell owns them.
/// Tab pages are plain content widgets.
class PlaceholderPage extends StatelessWidget {
  const PlaceholderPage({required this.section, super.key});

  final PlaceholderSection section;

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.construction_outlined,
            size: 48,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(section.label(t), style: theme.textTheme.titleMedium),
          const SizedBox(height: AppSpacing.sm),
          Text(
            t.common.inDevelopment,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}