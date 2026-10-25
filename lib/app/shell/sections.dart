import 'package:flutter/material.dart';

import 'package:sync_music/i18n/strings.g.dart';

/// Section order = TAB order = RAIL order. Single source of truth:
/// reordering tabs means reordering this enum ONLY.
enum AppSection { favorites, playlists, tracks, albums, artists }

extension AppSectionX on AppSection {
  /// Localized tab/rail label.
  String label(Translations t) => switch (this) {
    AppSection.favorites => t.nav.favorites,
    AppSection.playlists => t.nav.playlists,
    AppSection.tracks => t.nav.tracks,
    AppSection.albums => t.nav.albums,
    AppSection.artists => t.nav.artists,
  };

  /// Rail icon (tabs on phone are text-only, Samsung style).
  IconData get icon => switch (this) {
    AppSection.favorites => Icons.favorite,
    AppSection.playlists => Icons.queue_music,
    AppSection.tracks => Icons.music_note,
    AppSection.albums => Icons.album,
    AppSection.artists => Icons.person,
  };
}
