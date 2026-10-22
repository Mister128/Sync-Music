import 'package:flutter/material.dart';

import 'package:sync_music/core/design_system/theme/app_spacing.dart';
import 'package:sync_music/i18n/strings.g.dart';

/// Bottom action bar shown INSTEAD of the MiniPlayer while multi-select
/// is active. Pure design-system widget: count + callbacks, no
/// feature imports - the wiring lives in MiniPlayerSlot.
/// Metrics mirror MiniPlayer so the swap doesn't jump.
class SmSelectionBar extends StatelessWidget {
  const new({
    required this.count,
    required this.onCancel,
    this.onAddToQueue,
    this.onAddToPlaylist,
    this.onDelete,
    this.onRemoveFromPlaylist,
    super.key,
  });

  final int count;
  final VoidCallback onCancel;
  final VoidCallback? onAddToQueue;
  final VoidCallback? onAddToPlaylist;

  /// Library context: delete files permanently.
  final VoidCallback? onDelete;

  /// Playlist context: detach from the playlist, files stay on disk.
  final VoidCallback? onRemoveFromPlaylist;

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Container(
      height:
          AppSpacing.miniPlayerHeight +
          MediaQuery.viewPaddingOf(context).bottom,
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHigh,
        border: Border(top: BorderSide(color: scheme.outlineVariant)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.viewPaddingOf(context).bottom,
      ),
      child: SizedBox(
        height: AppSpacing.miniPlayerHeight,
        child: Row(
          children: [
            IconButton(
              tooltip: t.common.cancel,
              visualDensity: VisualDensity.compact,
              icon: const Icon(Icons.close),
              onPressed: onCancel,
            ),
            const SizedBox(width: AppSpacing.xs),
            Expanded(
              child: Text(
                t.selection.selectedCount(count: count),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: scheme.primary,
                ),
              ),
            ),
            if (onAddToQueue != null)
              IconButton(
                tooltip: t.player.addToQueue,
                visualDensity: VisualDensity.compact,
                icon: const Icon(Icons.queue_music),
                onPressed: onAddToQueue,
              ),
            if (onAddToPlaylist != null)
              IconButton(
                tooltip: t.playlists.addToPlaylist,
                visualDensity: VisualDensity.compact,
                icon: const Icon(Icons.playlist_add),
                onPressed: onAddToPlaylist,
              ),
            if (onDelete != null)
              IconButton(
                tooltip: t.common.delete,
                visualDensity: VisualDensity.compact,
                icon: Icon(Icons.delete_outline, color: scheme.error),
                onPressed: onDelete,
              ),
            if (onRemoveFromPlaylist != null)
              IconButton(
                tooltip: t.playlists.removeFromPlaylist,
                visualDensity: VisualDensity.compact,
                icon: const Icon(Icons.playlist_remove),
                onPressed: onRemoveFromPlaylist,
              ),
            const SizedBox(width: AppSpacing.xs),
          ],
        ),
      ),
    );
  }
}
