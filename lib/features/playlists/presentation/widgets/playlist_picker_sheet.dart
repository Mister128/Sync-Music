import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sync_music/core/design_system/theme/app_spacing.dart';
import 'package:sync_music/core/design_system/widgets/sm_artwork.dart';
import 'package:sync_music/features/library/domain/entities/track.dart';
import 'package:sync_music/features/playlists/data/playlist_providers.dart';
import 'package:sync_music/features/playlists/presentation/widgets/playlist_form_dialog.dart';
import 'package:sync_music/i18n/strings.g.dart';

/// "Add to playlist" picker. Opens OVER the track action sheet;
/// that sheet closes itself after we return.
/// Takes a BATCH - single-track callers pass a one-element list.
/// Resolves true when the add ran, false when the sheet was dismissed.
Future<bool> showPlaylistPickerSheet(
  BuildContext context,
  List<Track> tracks,
) async =>
    await showModalBottomSheet<bool>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) => _PlaylistPickerSheet(tracks: tracks),
    ) ??
    false;

class _PlaylistPickerSheet extends ConsumerWidget {
  const new({required this.tracks});

  final List<Track> tracks;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Translations.of(context);

    return SafeArea(
      top: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.playlist_play),
            title: Text(t.playlists.create),
            onTap: () => unawaited(_createAndAdd(context, ref)),
          ),
          const Divider(height: 1),
          Flexible(
            child: switch (ref.watch(playlistsProvider)) {
              AsyncData(:final value) when value.isEmpty => Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Text(t.playlists.empty),
              ),
              AsyncData(:final value) => ListView(
                shrinkWrap: true,
                children: [
                  for (final playlist in value)
                    ListTile(
                      leading: SmArtwork(hash: playlist.artworkHash, size: 40),
                      title: Text(
                        playlist.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        t.playlists.trackCount(
                          count: playlist.trackCount,
                          n: playlist.trackCount,
                        ),
                      ),
                      onTap: () => unawaited(_add(context, ref, playlist.id)),
                    ),
                ],
              ),
              AsyncError(:final error) => Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Text('$error'),
              ),
              AsyncLoading() => const Padding(
                padding: EdgeInsets.all(AppSpacing.xl),
                child: Center(child: CircularProgressIndicator()),
              ),
            },
          ),
        ],
      ),
    );
  }

  Future<void> _add(
    BuildContext context,
    WidgetRef ref,
    String playlistId,
  ) async {
    final dao = ref.read(playlistDaoProvider);
    for (final track in tracks) {
      await dao.addTrack(playlistId: playlistId, trackId: track.id);
    }
    if (context.mounted) Navigator.pop(context, true);
  }

  /// Create-then-add: the form dialog resolves with the fresh id.
  Future<void> _createAndAdd(BuildContext context, WidgetRef ref) async {
    final id = await showPlaylistFormDialog(context);
    if (id == null || !context.mounted) return;
    await _add(context, ref, id);
  }
}
