import 'package:flutter/material.dart';

import 'package:sync_music/core/storage/artwork_paths.dart';

/// Content-addressed cover art (`<support>/artwork/<hash>.jpg`) - the single
/// implementation for track tiles, album cards and detail headers.
///
/// - [size] is in LOGICAL pixels; the bitmap decodes at size x devicePixel
///   Ratio (cacheWidth), never at the full 600px source - THE scrolling
///   performance lever.
/// - Missing/corrupt file -> branded placeholder via errorBuilder. No
///   existsSync() in build(): no sync IO on every rebuild.
class SmArtwork extends StatelessWidget {
  const new({required this.size, this.hash, this.borderRadius = 8, super.key});

  final String? hash;
  final double size;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final hash = this.hash;

    if (hash == null) {
      return _placeholder(scheme);
    }

    return RepaintBoundary(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Image.file(
          artWorkFileFor(hash),
          width: size,
          height: size,
          fit: BoxFit.cover,
          cacheWidth: (size * MediaQuery.devicePixelRatioOf(context)).ceil(),
          gaplessPlayback: true,
          errorBuilder: (context, error, stackTrace) => _placeholder(scheme),
        ),
      ),
    );
  }

  Widget _placeholder(ColorScheme scheme) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      color: scheme.surfaceContainerHigh,
      borderRadius: BorderRadius.circular(borderRadius),
    ),
    child: Icon(
      Icons.music_note,
      size: size * 0.45,
      color: scheme.onSurfaceVariant,
    ),
  );
}
