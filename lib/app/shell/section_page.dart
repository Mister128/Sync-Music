import 'package:flutter/widgets.dart';
import 'package:sync_music/core/design_system/widgets/placeholder_page.dart';
import 'package:sync_music/features/library/presentation/pages/albums_page.dart';
import 'package:sync_music/features/library/presentation/pages/artists_page.dart';
import 'package:sync_music/features/library/presentation/pages/tracks_page.dart';
import 'package:sync_music/features/playlists/presentation/pages/playlists_page.dart';

Widget buildSectionPage(PlaceholderSection section) => switch (section) {
  PlaceholderSection.tracks => const TracksPage(),
  PlaceholderSection.albums => const AlbumsPage(),
  PlaceholderSection.artists => const ArtistsPage(),
  PlaceholderSection.playlists => const PlaylistsPage(),
  PlaceholderSection.favorites => PlaceholderPage(section: section),
};
