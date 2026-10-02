import 'package:flutter/material.dart';

import 'package:sync_music/core/design_system/theme/app_spacing.dart';

/// Reserves the mini-player slot. Stage 4 replaces the body with the real
/// MiniPlayer. It lives in the SHELL (outside branches) — that's exactly why
/// playback controls won't flicker or restart on tab switches.
class MiniPlayerPlaceholder extends StatelessWidget {
  const MiniPlayerPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      height: AppSpacing.miniPlayerHeight,
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHigh,
        border: Border(top: BorderSide(color: scheme.outlineVariant)),
      ),
      child: Center(
        child: Text(
          'mini player',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: scheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}