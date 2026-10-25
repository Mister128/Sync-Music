import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sync_music/core/design_system/theme/app_spacing.dart';
import 'package:sync_music/core/design_system/widgets/sm_track_tile.dart';
import 'package:sync_music/features/library/data/library_providers.dart';
import 'package:sync_music/features/library/domain/entities/track.dart';
import 'package:sync_music/features/player/presentation/widgets/mini_player_slot.dart';
import 'package:sync_music/features/playlists/data/playlist_providers.dart';
import 'package:sync_music/i18n/strings.g.dart';

/// "Add tracks" picker: the whole library with checkboxes.
/// Tracks already in the playlist render checked + DISABLED - re-adding
/// a live membership would revive it AT THE END (DAO semantics), which
/// a picker tap must never do.
///
/// Selection here is deliberately LOCAL state, not the global
/// SelectionController: on this route the bottom slot must stay the
/// MiniPlayer (music keeps playing while you browse), and the only
/// action is the AppBar's "Add (N)" - the batch bar would be wrong.
class AddTracksPage extends ConsumerStatefulWidget {
  const new({required this.playlistId, super.key});

  final String playlistId;

  @override
  ConsumerState<AddTracksPage> createState() => _AddTracksPageState();
}

class _AddTracksPageState extends ConsumerState<AddTracksPage> {
  final Set<String> _selected = {};
  String _filter = '';

  void _toggle(String id) => setState(() {
    if (!_selected.remove(id)) _selected.add(id);
  });

  /// Adds in LIBRARY order (the order the user sees), not tap order.
  /// Pops with the number added - the caller shows the snackbar.
  Future<void> _addSelected(List<Track> tracks) async {
    final dao = ref.read(playlistDaoProvider);
    var added = 0;
    for (final track in tracks) {
      if (!_selected.contains(track.id)) continue;
      await dao.addTrack(playlistId: widget.playlistId, trackId: track.id);
      added++;
    }
    if (mounted) Navigator.pop(context, added);
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final tracksAsync = ref.watch(tracksProvider);
    final tracks = tracksAsync.value ?? const <Track>[];
    final existingIds = {
      for (final track
          in ref.watch(playlistTracksProvider(widget.playlistId)).value ??
              const <Track>[])
        track.id,
    };
    final filter = _filter.trim().toLowerCase();
    final visible = filter.isEmpty
        ? tracks
        : tracks
              .where(
                (track) =>
                    track.title.toLowerCase().contains(filter) ||
                    track.artistName.toLowerCase().contains(filter),
              )
              .toList();

    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.sm),
            child: TextButton(
              onPressed: _selected.isEmpty
                  ? null
                  : () => unawaited(_addSelected(tracks)),
              child: Text(
                t.playlists.addTracksCount(
                  n: _selected.length,
                  count: _selected.length,
                ),
              ),
            ),
          ),
        ],
      ),
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
              hintText: t.search.filterTracks,
              onChanged: (value) => setState(() => _filter = value),
            ),
          ),
          Expanded(
            child: switch (tracksAsync) {
              AsyncData(:final value) when value.isEmpty => Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.queue_music,
                    size: 48,
                    color: scheme.onSurfaceVariant,
                  ),
                  Text(
                    t.library.tracksEmpty,
                    style: theme.textTheme.titleMedium,
                  ),
                  Text(
                    t.library.tracksEmptyHint,
                    style: theme.textTheme.labelMedium,
                  ),
                ],
              ),

              // Library is not empty, but the FILTER matched nothing.
              AsyncData() when visible.isEmpty => Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search_off,
                    size: 48,
                    color: scheme.onSurfaceVariant,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    t.search.noResults(query: _filter),
                    style: theme.textTheme.titleMedium,
                  ),
                ],
              ),

              AsyncData() => ListView.builder(
                itemCount: visible.length,
                itemBuilder: (context, index) {
                  final track = visible[index];
                  final alreadyAdded = existingIds.contains(track.id);

                  return SmTrackTile(
                    title: track.title,
                    subtitle: track.artistName,
                    durationMs: track.durationMs,
                    artworkHash: track.artworkHash,
                    selected: alreadyAdded || _selected.contains(track.id),
                    selectionEnabled: !alreadyAdded,
                    onToggleSelect: () => _toggle(track.id),
                    onTap: alreadyAdded ? null : () => _toggle(track.id),
                  );
                },
              ),

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
