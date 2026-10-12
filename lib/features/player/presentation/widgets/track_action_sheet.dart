import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sync_music/core/design_system/theme/app_spacing.dart';
import 'package:sync_music/core/design_system/widgets/sm_artwork.dart';
import 'package:sync_music/features/library/domain/entities/track.dart';
import 'package:sync_music/features/player/domain/services/enqueue_policy.dart';
import 'package:sync_music/features/player/presentation/controllers/player_controller.dart';
import 'package:sync_music/i18n/strings.g.dart';

/// Long-press menu for a track in ANY list
Future<void> showTrackActionSheet(BuildContext context, Track track) =>
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) => TrackActionSheet(track: track),
    );

class TrackActionSheet extends ConsumerWidget {
  const new({required this.track, super.key});

  final Track track;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Translations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return SafeArea(
      top: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              0,
              AppSpacing.lg,
              AppSpacing.md,
            ),
            child: Row(
              children: [
                SmArtwork(hash: track.artworkHash, size: 48),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        track.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleMedium,
                      ),
                      Text(
                        track.artistName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          _actionTile(
            context,
            ref,
            icon: Icons.playlist_play,
            label: t.player.playNext,
            next: true,
          ),
          _actionTile(
            context,
            ref,
            icon: Icons.queue_music,
            label: t.player.addToQueue,
            next: false,
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
      ),
    );
  }

  Widget _actionTile(
    BuildContext context,
    WidgetRef ref, {
    required IconData icon,
    required String label,
    required bool next,
  }) => ListTile(
    leading: Icon(icon),
    title: Text(label),
    onTap: () {
      final controller = ref.read(playerControllerProvider.notifier);
      final action = enqueueAction(
        queueEmpty: ref.read(playerControllerProvider).queue.isEmpty,
        next: next,
      );
      Navigator.pop(context);
      unawaited(_run(controller, action));
    },
  );

  Future<void> _run(PlayerController controller, EnqueueAction action) =>
      switch (action) {
        EnqueueAction.playNow => controller.playQueue([track]),
        EnqueueAction.insertNext => controller.insertNext(track),
        EnqueueAction.appendToQueue => controller.addToQueue(track),
      };
}
