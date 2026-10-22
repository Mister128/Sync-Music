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
import 'package:sync_music/features/playlists/presentation/widgets/playlist_form_dialog.dart';
import 'package:sync_music/i18n/strings.g.dart';

/// Phone shell: tabs + the shared bottom slot.
///
/// Selection mode LOCKS the shell: tabs don't switch (tap AND
/// swipe), settings is disabled, system back cancels the selection -
/// the user must never wander between pages with a pending batch action.
class PhoneShell extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Translations.of(context);
    final scheme = Theme.of(context).colorScheme;
    const sections = PlaceholderSection.values;
    final inSelectionMode = ref.watch(
      selectionControllerProvider.select((selection) => selection.isNotEmpty),
    );

    final tabBar = TabBar(
      isScrollable: true,
      tabAlignment: TabAlignment.center,
      dividerColor: Colors.transparent,
      labelColor: scheme.primary,
      unselectedLabelColor: scheme.onSurfaceVariant,
      indicatorColor: scheme.primary,
      indicatorSize: TabBarIndicatorSize.label,
      indicatorWeight: 3,
      tabs: [
        for (final section in sections)
          Tab(text: section.label(t), icon: Icon(section.icon)),
      ],
    );

    return DefaultTabController(
      length: sections.length,
      child: PopScope(
        // Back exits selection mode instead of leaving the app/page.
        canPop: !inSelectionMode,
        onPopInvokedWithResult: (didPop, result) {
          if (!didPop) ref.read(selectionControllerProvider.notifier).clear();
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(t.app.title),
            actionsPadding: const EdgeInsets.only(right: AppSpacing.sm),
            actions: [
              Builder(
                builder: (context) {
                  final tabController = DefaultTabController.of(context);
                  return AnimatedBuilder(
                    animation: tabController,
                    builder: (context, _) {
                      if (inSelectionMode ||
                          tabController.index !=
                              PlaceholderSection.playlists.index) {
                        return const SizedBox.shrink();
                      }
                      final t = Translations.of(context);
                      return IconButton(
                        tooltip: t.playlists.create,
                        icon: const Icon(Icons.add),
                        onPressed: () => showPlaylistFormDialog(context),
                      );
                    },
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: inSelectionMode
                    ? null
                    : () => context.push(Routes.settings),
              ),
            ],

            bottom: PreferredSize(
              preferredSize: tabBar.preferredSize,
              child: IgnorePointer(
                ignoring: inSelectionMode,
                child: AnimatedOpacity(
                  opacity: inSelectionMode ? 0.4 : 1,
                  duration: const Duration(milliseconds: 150),
                  child: tabBar,
                ),
              ),
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: TabBarView(
                  // No swipe between sections while selecting.
                  physics: inSelectionMode
                      ? const NeverScrollableScrollPhysics()
                      : null,
                  children: [
                    for (final section in sections) buildSectionPage(section),
                  ],
                ),
              ),
              // The ONE bottom slot: selection bar > mini player > nothing.
              MiniPlayerSlot(
                onDeleteSelected: (tracks) =>
                    confirmAndDeleteTracks(context, ref, tracks),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
