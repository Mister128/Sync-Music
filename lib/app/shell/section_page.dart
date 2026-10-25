import 'package:flutter/widgets.dart';
import 'package:sync_music/app/shell/sections.dart';
import 'package:sync_music/features/library/presentation/pages/albums_page.dart';
import 'package:sync_music/features/library/presentation/pages/artists_page.dart';
import 'package:sync_music/features/library/presentation/pages/tracks_page.dart';
import 'package:sync_music/features/playlists/presentation/pages/favorites_page.dart';
import 'package:sync_music/features/playlists/presentation/pages/playlists_page.dart';

Widget buildSectionPage(AppSection section) => switch (section) {
  AppSection.tracks => const TracksPage(),
  AppSection.albums => const AlbumsPage(),
  AppSection.artists => const ArtistsPage(),
  AppSection.playlists => const PlaylistsPage(),
  AppSection.favorites => const FavoritesPage(),
};
