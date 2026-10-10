import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sync_music/app/router/routes.dart';
import 'package:sync_music/app/shell/scaffold_shell.dart';
import 'package:sync_music/features/library/presentation/pages/album_page.dart';
import 'package:sync_music/features/library/presentation/pages/artist_page.dart';
import 'package:sync_music/features/settings/presentation/pages/settings_page.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final rootKey = GlobalKey<NavigatorState>(debugLabel: 'root');

  return GoRouter(
    navigatorKey: rootKey,
    initialLocation: Routes.home,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: Routes.home,
        builder: (context, state) => const ScaffoldShell(),
      ),

      GoRoute(
        path: Routes.settings,
        parentNavigatorKey: rootKey,
        builder: (context, state) => const SettingsPage(),
      ),

      GoRoute(
        path: Routes.albumDetail,
        parentNavigatorKey: rootKey,
        builder: (context, state) {
          return AlbumPage(
            albumTitle: state.uri.queryParameters['title'] ?? '',
          );
        },
      ),
      GoRoute(
        path: Routes.artistDetail,
        parentNavigatorKey: rootKey,
        builder: (context, state) =>
            ArtistPage(artistName: state.uri.queryParameters['name'] ?? ''),
      ),
    ],
  );
});
