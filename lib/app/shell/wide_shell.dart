import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sync_music/app/router/routes.dart';
import 'package:sync_music/app/shell/section_page.dart';
import 'package:sync_music/core/design_system/theme/app_spacing.dart';
import 'package:sync_music/core/design_system/widgets/placeholder_page.dart';
import 'package:sync_music/core/selection/selection_controller.dart';
import 'package:sync_music/features/library/presentation/actions/delete_tracks_flow.dart';
import 'package:sync_music/features/player/presentation/widgets/mini_player_slot.dart';
import 'package:sync_music/i18n/strings.g.dart';

/// Wide shell: rail + IndexedStack + the shared bottom slot.
/// Selection mode locks the rail exactly like PhoneShell locks the tabs.
class WideShell extends ConsumerStatefulWidget {
  const new({super.key});

  @override
  ConsumerState<WideShell> createState() => _WideShellState();
}

class _WideShellState extends ConsumerState<WideShell> {
  int _index = 0;
  static const double _railWidth = 100;

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    const sections = PlaceholderSection.values;
    final inSelectionMode = ref.watch(
      selectionControllerProvider.select((selection) => selection.isNotEmpty),
    );

    return PopScope(
      canPop: !inSelectionMode,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) ref.read(selectionControllerProvider.notifier).clear();
      },
      child: Scaffold(
        body: Row(
          children: [
            SizedBox(
              width: _railWidth,
              child: Column(
                children: [
                  const SizedBox(height: AppSpacing.lg),
                  for (final section in sections) ...[
                    _RailTile(
                      icon: section.icon,
                      label: section.label(t),
                      selected: section.index == _index,
                      // Navigation is LOCKED in selection mode.
                      onTap: inSelectionMode
                          ? null
                          : () => setState(() => _index = section.index),
                    ),

                    const SizedBox(height: AppSpacing.sm),
                  ],
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                    child: IconButton(
                      onPressed: inSelectionMode
                          ? null
                          : () => context.push(Routes.settings),
                      icon: const Icon(Icons.settings),
                    ),
                  ),
                ],
              ),
            ),
            const VerticalDivider(width: 1, thickness: 1),
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: IndexedStack(
                      index: _index,
                      children: [
                        for (final section in sections)
                          buildSectionPage(section),
                      ],
                    ),
                  ),
                  // The ONE bottom slot: selection bar > mini player.
                  MiniPlayerSlot(
                    onDeleteSelected: (tracks) =>
                        confirmAndDeleteTracks(context, ref, tracks),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// One navigation item. [onTap] == null = disabled (selection mode).
class _RailTile extends StatelessWidget {
  const new({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final color = selected
        ? scheme.primary
        : onTap == null
        ? scheme.onSurfaceVariant.withValues(alpha: 0.38)
        : scheme.onSurfaceVariant;

    return Semantics(
      button: true,
      selected: selected,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        // TODO(Mister128): if this radius starts repeating across the app,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.md,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color),
              const SizedBox(height: AppSpacing.xs),
              Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: color,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
