import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sync_music/core/design_system/widgets/sm_selection_bar.dart';
import 'package:sync_music/core/selection/selection_controller.dart';
import 'package:sync_music/features/library/domain/entities/track.dart';
import 'package:sync_music/features/player/data/player_providers.dart';
import 'package:sync_music/features/player/domain/entities/player_snapshot.dart';
import 'package:sync_music/features/player/domain/services/enqueue_policy.dart';
import 'package:sync_music/features/player/presentation/controllers/player_controller.dart';
import 'package:sync_music/features/player/presentation/widgets/mini_player.dart';
import 'package:sync_music/features/playlists/presentation/widgets/playlist_picker_sheet.dart';

// The ONE bottom slot, shared by the shells and detail pages:
/// SmSelectionBar (multi-select active) > MiniPlayer (track is current) >
/// nothing. The bar REPLACES the player entirely - while a batch action
/// is pending the user's attention belongs to the selection, not music.
class MiniPlayerSlot extends ConsumerWidget {
  const new({this.onDeleteSelected, this.onRemoveSelected, super.key});

  /// Library context (shell tabs, album/artist pages): delete files.
  final Future<bool> Function(List<Track> tracks)? onDeleteSelected;

  /// Playlist context: detach from the playlist, files stay on disk.
  final Future<bool> Function(List<Track> tracks)? onRemoveSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selection = ref.watch(selectionControllerProvider);

    if (selection.isNotEmpty) {
      return SmSelectionBar(
        count: selection.length,
        onCancel: () => ref.read(selectionControllerProvider.notifier).clear(),
        onAddToQueue: () => unawaited(_enqueueSelected(ref)),
        onAddToPlaylist: () => unawaited(_addToPlaylist(context, ref)),
        onDelete: onDeleteSelected == null
            ? null
            : () => unawaited(_runAndMaybeClear(ref, onDeleteSelected!)),
        onRemoveFromPlaylist: onRemoveSelected == null
            ? null
            : () => unawaited(_runAndMaybeClear(ref, onRemoveSelected!)),
      );
    }

    final hasTrack = ref.watch(
      playerControllerProvider.select((state) => state.currentTrack != null),
    );
    return hasTrack ? const MiniPlayer() : const SizedBox.shrink();
  }

  Future<void> _runAndMaybeClear(
    WidgetRef ref,
    Future<bool> Function(List<Track> tracks) action,
  ) async {
    final tracks = await ref.read(selectedTracksProvider.future);
    if (tracks.isEmpty) return;
    if (await action(tracks)) {
      ref.read(selectionControllerProvider.notifier).clear();
    }
  }

  /// Same policy as the single-track menu: empty queue -> play now,
  /// otherwise append. insertNext is unreachable for next:false, the
  /// branch exists for exhaustiveness (reversed = correct final order).
  Future<void> _enqueueSelected(WidgetRef ref) async {
    final tracks = await ref.read(selectedTracksProvider.future);
    if (tracks.isEmpty) return;
    final controller = ref.read(playerControllerProvider.notifier);
    final queueEmpty = ref.read(playerControllerProvider).queue.isEmpty;

    switch (enqueueAction(queueEmpty: queueEmpty, next: false)) {
      case EnqueueAction.playNow:
        await controller.playQueue(tracks);
      case EnqueueAction.insertNext:
        for (final track in tracks) {
          await controller.insertNext(track);
        }
      case EnqueueAction.appendToQueue:
        for (final track in tracks) {
          await controller.addToQueue(track);
        }
    }
    ref.read(selectionControllerProvider.notifier).clear();
  }

  Future<void> _addToPlaylist(BuildContext context, WidgetRef ref) async {
    final tracks = await ref.read(selectedTracksProvider.future);
    if (tracks.isEmpty || !context.mounted) return;
    final added = await showPlaylistPickerSheet(context, tracks);
    if (added) ref.read(selectionControllerProvider.notifier).clear();
  }
}
