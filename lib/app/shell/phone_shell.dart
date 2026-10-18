import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sync_music/app/router/routes.dart';
import 'package:sync_music/app/shell/section_page.dart';
import 'package:sync_music/core/design_system/theme/app_spacing.dart';
import 'package:sync_music/core/design_system/widgets/placeholder_page.dart';
import 'package:sync_music/features/player/domain/entities/player_snapshot.dart';
import 'package:sync_music/features/player/presentation/controllers/player_controller.dart';
import 'package:sync_music/features/player/presentation/widgets/mini_player.dart';
import 'package:sync_music/features/playlists/presentation/widgets/playlist_form_dialog.dart';
import 'package:sync_music/i18n/strings.g.dart';

class PhoneShell extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Translations.of(context);
    final scheme = Theme.of(context).colorScheme;
    const sections = PlaceholderSection.values;

    return DefaultTabController(
      length: sections.length,
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
                        if (tabController.index != PlaceholderSection.playlists.index) {
                          return const SizedBox.shrink();
                        }
                        final t = Translations.of(context);
                        return IconButton(
                            tooltip: t.playlists.create,
                            icon: const Icon(Icons.add),
                            onPressed: () => showPlaylistFormDialog(context),
                        );
                      }
                  );
                }
            ),
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () => context.push(Routes.settings),
            ),
          ],

          bottom: TabBar(
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
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: TabBarView(
                children: [
                  for (final section in sections) buildSectionPage(section),
                ],
              ),
            ),
            if (ref.watch(playerControllerProvider).currentTrack != null)
              const MiniPlayer(),
          ],
        ),
      ),
    );
  }
}
