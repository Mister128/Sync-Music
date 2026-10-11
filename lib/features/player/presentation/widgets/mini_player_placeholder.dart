import 'package:flutter/material.dart';

import 'package:sync_music/core/design_system/theme/app_spacing.dart';
import 'package:sync_music/i18n/strings.g.dart';

/// The muted slot before anything has been played.
class MiniPlayerPlaceholder extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final scheme = Theme.of(context).colorScheme;
    return Container(
      height: AppSpacing.miniPlayerHeight,
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHigh,
        border: Border(top: BorderSide(color: scheme.outlineVariant)),
      ),
      child: Center(
        child: Text(
          t.player.miniPlayerEmpty,
          style: Theme.of(context).textTheme.labelSmall
              ?.copyWith(color: scheme.onSurfaceVariant),
        ),
      ),
    );
  }
}
