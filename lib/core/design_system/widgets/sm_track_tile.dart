import 'package:flutter/material.dart';

import 'package:sync_music/core/design_system/theme/app_spacing.dart';
import 'package:sync_music/core/design_system/widgets/sm_artwork.dart';
import 'package:sync_music/core/extensions/duration_x.dart';

/// One row in ANY track list.
///
/// Selection mode: when [onToggleSelect] is non-null the tile
/// grows a checkbox LEFT of the artwork (duration stays where it was).
/// [selected] drives both the checkbox and the title tint - QueuePage
/// reuses it as the "now playing" highlight WITHOUT a checkbox.
class SmTrackTile extends StatelessWidget {
  const new({
    required this.title,
    this.subtitle,
    this.durationMs,
    this.artworkHash,
    this.onTap,
    this.onLongPress,
    this.selected = false,
    this.onToggleSelect,
    this.selectionEnabled = true,
    this.trailing,
    super.key,
  });

  final String title;
  final String? subtitle;
  final int? durationMs;
  final String? artworkHash; // null -> placeholder icon (covers land in 3.5)
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool selected;

  /// Non-null = selection mode ON: checkbox appears left of the artwork.
  /// The checkbox toggles itself; pages wire [onTap] to the same closure.
  final VoidCallback? onToggleSelect;

  /// False = the checkbox renders DISABLED (the row looks picked but is
  /// not toggleable - the add-tracks page uses it for tracks that are
  /// already in the playlist).
  final bool selectionEnabled;

  /// Extra control (⋮ menu, drag handle). Pages hide it in selection mode.
  final Widget? trailing;

  static const double _artworkSize = 52;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final toggle = onToggleSelect;

    return ListTile(
      onTap: onTap,
      onLongPress: onLongPress,
      contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      leading: toggle == null
          ? SmArtwork(hash: artworkHash, size: _artworkSize)
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Checkbox(
                  value: selected,
                  onChanged: selectionEnabled ? (_) => toggle() : null,
                  visualDensity: VisualDensity.compact,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                const SizedBox(width: AppSpacing.xs),
                SmArtwork(hash: artworkHash, size: _artworkSize),
              ],
            ),
      title: Text(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.titleMedium?.copyWith(
          color: selected ? scheme.primary : null,
        ),
      ),
      subtitle: subtitle == null
          ? null
          : Text(
              subtitle!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
      trailing: trailing == null && durationMs == null
          ? null
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (durationMs != null)
                  Text(
                    Duration(milliseconds: durationMs!).display,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ?trailing,
              ],
            ),
    );
  }
}
