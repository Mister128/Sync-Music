import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sync_music/core/design_system/theme/app_spacing.dart';
import 'package:sync_music/core/design_system/widgets/sm_artwork.dart';
import 'package:sync_music/core/design_system/widgets/sm_section_header.dart';
import 'package:sync_music/core/extensions/build_context_x.dart';
import 'package:sync_music/features/playlists/data/playlist_providers.dart';
import 'package:sync_music/features/playlists/domain/entities/playlist.dart';
import 'package:sync_music/features/playlists/presentation/widgets/playlist_form_dialog.dart';
import 'package:sync_music/i18n/strings.g.dart';

class PlaylistsPage extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Translations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (!context.isCompact)
          SmSectionHeader(
            title: t.nav.playlists,
            action: IconButton(
              tooltip: t.playlists.create,
              icon: const Icon(Icons.add),
              onPressed: () => showPlaylistFormDialog(context),
            ),
          ),
        Expanded(
          child: switch (ref.watch(playlistsProvider)) {
            AsyncData(:final value) when value.isEmpty => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.queue_music,
                  size: 48,
                  color: scheme.onSurfaceVariant,
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(t.playlists.empty, style: theme.textTheme.titleMedium),
                Text(
                  t.playlists.emptyHint,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                FilledButton.tonalIcon(
                  onPressed: () => showPlaylistFormDialog(context),
                  icon: const Icon(Icons.add),
                  label: Text(t.playlists.create),
                ),
              ],
            ),

            AsyncData(:final value) => ListView.builder(
              itemCount: value.length,
              itemBuilder: (context, index) =>
                  _PlaylistTile(playlist: value[index]),
            ),

            AsyncError(:final error) => Center(child: Text('$error')),
            AsyncLoading() => const Center(child: CircularProgressIndicator()),
          },
        ),
      ],
    );
  }
}

enum _PlaylistAction { rename, delete }

class _PlaylistTile extends ConsumerWidget {
  const new({required this.playlist});

  final Playlist playlist;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Translations.of(context);

    return ListTile(
      leading: SmArtwork(hash: playlist.artworkHash, size: 52),
      title: Text(playlist.name, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text(
        t.playlists.trackCount(
          count: playlist.trackCount,
          n: playlist.trackCount,
        ),
      ),
      trailing: PopupMenuButton<_PlaylistAction>(
        icon: const Icon(Icons.more_vert),
        itemBuilder: (context) => [
          PopupMenuItem(
            value: _PlaylistAction.rename,
            child: Text(t.playlists.rename),
          ),
          PopupMenuItem(
            value: _PlaylistAction.delete,
            child: Text(t.playlists.delete),
          ),
        ],
        onSelected: (action) => _onAction(context, ref, action),
      ),
    );
  }

  void _onAction(BuildContext context, WidgetRef ref, _PlaylistAction action) {
    switch (action) {
      case _PlaylistAction.rename:
        unawaited(showPlaylistFormDialog(context, existing: playlist));
      case _PlaylistAction.delete:
        unawaited(_delete(context, ref));
    }
  }

  Future<void> _delete(BuildContext context, WidgetRef ref) async {
    final t = Translations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(t.playlists.deleteConfirmTitle),
        content: Text(t.playlists.deleteConfirmMessage(name: playlist.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(t.common.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(t.playlists.deleteConfirmAction),
          ),
        ],
      ),
    );
    // Context/ref after an await gap - the guard keeps the linter (and
    // the user) safe: the dialog could have outlived this widget.
    if (confirmed != true || !context.mounted) return;
    await ref.read(playlistDaoProvider).deletePlaylist(playlist.id);
  }
}
