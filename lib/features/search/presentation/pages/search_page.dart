import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:sync_music/app/router/routes.dart';
import 'package:sync_music/core/design_system/theme/app_spacing.dart';
import 'package:sync_music/core/design_system/widgets/sm_artwork.dart';
import 'package:sync_music/core/design_system/widgets/sm_track_tile.dart';
import 'package:sync_music/features/player/presentation/controllers/player_controller.dart';
import 'package:sync_music/features/player/presentation/widgets/mini_player_slot.dart';
import 'package:sync_music/features/player/presentation/widgets/track_action_menu.dart';
import 'package:sync_music/features/search/data/search_providers.dart';
import 'package:sync_music/features/search/domain/search_results.dart';
import 'package:sync_music/features/search/presentation/controllers/search_query_controller.dart';
import 'package:sync_music/i18n/strings.g.dart';

/// Library search: M3 SearchBar -> debounced query -> three
/// sections in one scroll view.
class SearchPage extends ConsumerStatefulWidget {
  const new({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final TextEditingController _input = TextEditingController();

  @override
  void dispose() {
    _input.dispose();
    super.dispose();
  }

  void _clear() {
    _input.clear();
    ref.read(searchQueryProvider.notifier).commit('');
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final query = ref.watch(searchQueryProvider);
    final results = ref.watch(searchResultsProvider(query));

    return Scaffold(
      appBar: AppBar(title: Text(t.search.title)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.sm,
              AppSpacing.lg,
              AppSpacing.sm,
            ),
            child: SearchBar(
              controller: _input,
              autoFocus: true,
              hintText: t.search.hint,
              onChanged: (value) =>
                  ref.read(searchQueryProvider.notifier).onQueryChanged(value),
              onSubmitted: (value) =>
                  ref.read(searchQueryProvider.notifier).commit(value),
              trailing: [
                ListenableBuilder(
                  listenable: _input,
                  builder: (context, _) => _input.text.isEmpty
                      ? const SizedBox.shrink()
                      : IconButton(
                          tooltip: t.search.clear,
                          icon: const Icon(Icons.close),
                          onPressed: _clear,
                        ),
                ),
              ],
            ),
          ),

          Expanded(
            child: switch (results) {
              AsyncData() when query.isEmpty => _EmptyState(
                icon: Icons.search,
                text: t.search.startHint,
              ),
              AsyncData(:final value) when value.isEmpty => _EmptyState(
                icon: Icons.search_off,
                text: t.search.noResults(query: query),
              ),
              AsyncData(:final value) => _ResultsList(results: value),
              AsyncError(:final error) => Center(child: Text('$error')),
              AsyncLoading() => const Center(
                child: CircularProgressIndicator(),
              ),
            },
          ),
          const MiniPlayerSlot(),
        ],
      ),
    );
  }
}

class _ResultsList extends ConsumerWidget {
  const new({required this.results});

  final SearchResults results;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Translations.of(context);

    return ListView(
      padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
      children: [
        if (results.tracks.isNotEmpty) ...[
          _SectionLabel(text: t.nav.tracks),
          for (final (index, track) in results.tracks.indexed)
            SmTrackTile(
              title: track.title,
              subtitle: track.artistName,
              durationMs: track.durationMs,
              artworkHash: track.artworkHash,
              // The result list itself is the play queue.
              onTap: () => ref
                  .read(playerControllerProvider.notifier)
                  .playQueue(results.tracks, startIndex: index),
              trailing: TrackActionMenu(track: track),
            ),
        ],
        if (results.albums.isNotEmpty) ...[
          _SectionLabel(text: t.nav.albums),
          for (final album in results.albums)
            ListTile(
              leading: SmArtwork(hash: album.artworkHash, size: 52),
              title: Text(
                album.albumTitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(
                t.library.trackCount(
                  count: album.trackCount,
                  n: album.trackCount,
                ),
              ),
              onTap: () =>
                  context.push(Routes.albumPath(albumTitle: album.albumTitle)),
            ),
        ],
        if (results.artists.isNotEmpty) ...[
          _SectionLabel(text: t.nav.artists),
          for (final artist in results.artists)
            ListTile(
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
            ),
        ],
      ],
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const new({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.xs,
      ),
      child: Text(
        text.toUpperCase(),
        style: theme.textTheme.labelMedium?.copyWith(
          color: theme.colorScheme.primary,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const new({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 48, color: theme.colorScheme.onSurfaceVariant),
          const SizedBox(height: AppSpacing.lg),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium,
            ),
          ),
        ],
      ),
    );
  }
}
