import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sync_music/app/router/routes.dart';
import 'package:sync_music/app/shell/mini_player_placeholder.dart';
import 'package:sync_music/app/shell/section_page.dart';
import 'package:sync_music/core/design_system/theme/app_spacing.dart';
import 'package:sync_music/core/design_system/widgets/placeholder_page.dart';
import 'package:sync_music/i18n/strings.g.dart';

class PhoneShell extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
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
                  for (final section in sections)
                    buildSectionPage(section),
                ],
              ),
            ),
            const MiniPlayerPlaceholder(),
          ],
        ),
      ),
    );
  }
}
