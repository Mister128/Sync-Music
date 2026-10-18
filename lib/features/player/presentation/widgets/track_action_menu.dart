import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sync_music/features/library/domain/entities/track.dart';
import 'package:sync_music/features/player/domain/services/enqueue_policy.dart';
import 'package:sync_music/features/player/presentation/controllers/player_controller.dart';
import 'package:sync_music/features/playlists/data/playlist_providers.dart';
import 'package:sync_music/features/playlists/presentation/widgets/playlist_picker_sheet.dart';
import 'package:sync_music/i18n/strings.g.dart';

class TrackActionMenu extends ConsumerWidget {
  const new({required this.track, this.playlistId, super.key});

  final Track track;
  final String? playlistId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Translations.of(context);

    return PopupMenuButton<_TrackAction>(
      icon: const Icon(Icons.more_vert),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: _TrackAction.playNext,
          child: Text(t.player.playNext),
        ),
        PopupMenuItem(
          value: _TrackAction.addToQueue,
          child: Text(t.player.addToQueue),
        ),
        PopupMenuItem(
          value: _TrackAction.addToPlaylist,
          child: Text(t.playlists.addToPlaylist),
        ),
        if (playlistId != null)
          PopupMenuItem(
            value: _TrackAction.removeFromPlaylist,
            child: Text(t.playlists.removeFromPlaylist),
          ),
      ],
      onSelected: (action) => _onSelected(context, ref, action),
    );
  }

  void _onSelected(BuildContext context, WidgetRef ref, _TrackAction action) {
    // onSelected fires after the popup route closed - the button itself is
    // still mounted, but guard anyway (the row could have been recycled)
    if (!context.mounted) return;

    switch (action) {
      case _TrackAction.playNext:
      case _TrackAction.addToQueue:
        final controller = ref.read(playerControllerProvider.notifier);
        final resolved = enqueueAction(
          queueEmpty: ref.read(playerControllerProvider).queue.isEmpty,
          next: action == _TrackAction.playNext,
        );
        unawaited(_run(controller, resolved));

      case _TrackAction.addToPlaylist:
        unawaited(showPlaylistPickerSheet(context, track));

      case _TrackAction.removeFromPlaylist:
        unawaited(
          ref
              .read(playlistDaoProvider)
              .removeTrack(playlistId: playlistId!, trackId: track.id),
        );
    }
  }

  Future<void> _run(PlayerController controller, EnqueueAction action) =>
      switch (action) {
        EnqueueAction.playNow => controller.playQueue([track]),
        EnqueueAction.insertNext => controller.insertNext(track),
        EnqueueAction.appendToQueue => controller.addToQueue(track),
      };
}

enum _TrackAction { playNext, addToQueue, addToPlaylist, removeFromPlaylist }
