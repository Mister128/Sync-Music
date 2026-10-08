import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sync_music/core/design_system/theme/app_spacing.dart';
import 'package:sync_music/core/design_system/widgets/sm_section_header.dart';
import 'package:sync_music/features/settings/presentation/widgets/about_section.dart';
import 'package:sync_music/features/settings/presentation/widgets/appearance_section.dart';
import 'package:sync_music/features/settings/presentation/widgets/debug_section.dart';
import 'package:sync_music/features/settings/presentation/widgets/library_section.dart';
import 'package:sync_music/i18n/strings.g.dart';

class SettingsPage extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Translations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(t.settings.title)),
      body: ListView(
        padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
        children: [
          const AppearanceSection(),

          SmSectionHeader(title: t.settings.library),
          const LibrarySection(),

          if (kDebugMode) const DebugSection(),

          const AboutSection(),
        ],
      ),
    );
  }
}
