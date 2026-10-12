import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sync_music/core/design_system/theme/app_spacing.dart';
import 'package:sync_music/core/design_system/widgets/sm_track_tile.dart';
import 'package:sync_music/features/player/presentation/controllers/player_controller.dart';
import 'package:sync_music/i18n/strings.g.dart';

/// The live playback queue
class QueuePage extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Translations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final snapshot = ref.watch(playerControllerProvider);
    final controller = ref.read(playerControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: Text(t.player.queue)),
      body: snapshot.queue.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.queue_music,
                    size: 48,
                    color: scheme.onSurfaceVariant,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(t.player.queueEmpty, style: theme.textTheme.titleMedium),
                ],
              ),
            )
          : ReorderableListView.builder(
              padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
              itemCount: snapshot.queue.length,
              onReorderItem: (oldIndex, newIndex) {
                unawaited(controller.moveQueueItem(oldIndex, newIndex));
              },
              itemBuilder: (context, index) {
                final track = snapshot.queue[index];
                return SmTrackTile(
                  // The same track CAN appear twice in the queue, so the id
                  // alone is not a unique key - mix in the position.
                  // Trade-off: reorder animates as remove+insert instead of
                  // a slide.
                  key: ValueKey('queue-$index-${track.id}'),
                  title: track.title,
                  subtitle: track.artistName,
                  durationMs: track.durationMs,
                  artworkHash: track.artworkHash,
                  selected: index == snapshot.currentIndex,
                  onTap: () => unawaited(controller.playAtIndex(index)),
                  trailing: IconButton(
                    tooltip: t.player.removeFromQueue,
                    visualDensity: VisualDensity.compact,
                    icon: const Icon(Icons.close, size: 28),
                    onPressed: () =>
                        unawaited(controller.removeQueueItem(index)),
                  ),
                );
              },
            ),
    );
  }
}
