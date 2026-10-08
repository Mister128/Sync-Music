import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sync_music/core/design_system/theme/app_spacing.dart';
import 'package:sync_music/core/design_system/widgets/sm_section_header.dart';
import 'package:sync_music/features/library/presentation/controllers/library_scan_controller.dart';
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

          SmSectionHeader(
            title: t.settings.library,
            action: const _LibraryScanAction(),
          ),
          const LibrarySection(),

          if (kDebugMode) const DebugSection(),

          const AboutSection(),
        ],
      ),
    );
  }
}

/// Header action: starts a scan; turns into a mini spinner while running.
class _LibraryScanAction extends ConsumerWidget {
  const new();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Translations.of(context);
    final isRunning = ref.watch(libraryScanControllerProvider) is ScanRunning;

    return Padding(
      padding: const EdgeInsets.only(right: AppSpacing.lg),
      child: IconButton(
        tooltip: t.settings.scanNow,
        onPressed: isRunning
            ? null
            : () =>
                  ref.read(libraryScanControllerProvider.notifier).startScan(),
        icon: isRunning
            ? const SizedBox.square(
                dimension: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.refresh),
      ),
    );
  }
}
