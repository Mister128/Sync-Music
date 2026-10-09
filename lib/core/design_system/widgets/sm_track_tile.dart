import 'package:flutter/material.dart';

import 'package:sync_music/core/design_system/theme/app_spacing.dart';
import 'package:sync_music/core/extensions/duration_x.dart';
import 'package:sync_music/core/storage/artwork_paths.dart';

/// One row in ANY track list.
class SmTrackTile extends StatelessWidget {
  const new({
    required this.title,
    required this.subtitle,
    this.durationMs,
    this.artworkHash,
    this.onTap,
    this.onLongPress,
    super.key,
  });

  final String title;
  final String subtitle;
  final int? durationMs;
  final String? artworkHash; // null -> placeholder icon (covers land in 3.5)
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  static const double _artworkSize = 52;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return ListTile(
      onTap: onTap,
      onLongPress: onLongPress,
      contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      leading: _ArtWork(hash: artworkHash),
      title: Text(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.titleMedium,
      ),
      subtitle: Text(
        subtitle,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.bodySmall?.copyWith(
          color: scheme.onSurfaceVariant,
        ),
      ),
      trailing: durationMs == null
          ? null
          : Text(
              Duration(milliseconds: durationMs!).display,
              style: theme.textTheme.labelSmall?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
    );
  }
}

class _ArtWork extends StatelessWidget {
  const new({this.hash});

  final String? hash;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    if (hash == null) {
      return _ArtWorkPlaceholder(scheme: scheme);
    }

    return RepaintBoundary(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.file(
          artWorkFileFor(hash!),
          width: SmTrackTile._artworkSize,
          height: SmTrackTile._artworkSize,
          fit: BoxFit.cover,
          cacheWidth:
              (SmTrackTile._artworkSize *
                      MediaQuery.devicePixelRatioOf(context))
                  .ceil(),

          gaplessPlayback: true,
          errorBuilder: (context, error, stackTrace) =>
              _ArtWorkPlaceholder(scheme: scheme),
        ),
      ),
    );
  }
}

class _ArtWorkPlaceholder extends StatelessWidget {
  const new({required this.scheme});

  final ColorScheme scheme;

  @override
  Widget build(BuildContext context) => Container(
    width: SmTrackTile._artworkSize,
    height: SmTrackTile._artworkSize,
    decoration: BoxDecoration(
      color: scheme.surfaceContainerHigh,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Icon(Icons.music_note, size: 24, color: scheme.onSurfaceVariant),
  );
}
