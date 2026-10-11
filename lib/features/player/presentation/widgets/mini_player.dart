import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sync_music/core/design_system/theme/app_spacing.dart';
import 'package:sync_music/core/design_system/widgets/sm_artwork.dart';
import 'package:sync_music/features/player/domain/entities/player_snapshot.dart';
import 'package:sync_music/features/player/presentation/controllers/player_controller.dart';
import 'package:sync_music/features/player/presentation/widgets/mini_player_placeholder.dart';
import 'package:sync_music/i18n/strings.g.dart';

/// The permanent bar in the shell
class MiniPlayer extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = ref.watch(playerControllerProvider);
    final track = snapshot.currentTrack;

    if (track == null) {
      return const MiniPlayerPlaceholder();
    }

    final t = Translations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final controller = ref.read(playerControllerProvider.notifier);

    return Container(
      height: AppSpacing.miniPlayerHeight,
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHigh,
        border: Border(top: BorderSide(color: scheme.outlineVariant)),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: AppSpacing.sm),
            child: SmArtwork(hash: track.artworkHash, size: 48),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  track.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleSmall,
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
          IconButton(
            tooltip: t.player.previous,
            icon: const Icon(Icons.skip_previous),
            onPressed: controller.skipPrevious,
          ),
          IconButton(
            tooltip: snapshot.isPlaying ? t.player.pause : t.player.play,
            icon: Icon(snapshot.isPlaying ? Icons.pause : Icons.play_arrow),
            onPressed: controller.togglePlay,
          ),
          IconButton(
            tooltip: t.player.next,
            icon: const Icon(Icons.skip_next),
            onPressed: controller.skipNext,
          ),
          const SizedBox(width: AppSpacing.xs),
        ],
      ),
    );
  }
}
