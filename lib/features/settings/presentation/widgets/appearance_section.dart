import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sync_music/core/design_system/theme/app_spacing.dart';
import 'package:sync_music/core/design_system/widgets/sm_control_label.dart';
import 'package:sync_music/core/design_system/widgets/sm_section_header.dart';
import 'package:sync_music/features/settings/presentation/controllers/theme_controller.dart';
import 'package:sync_music/i18n/strings.g.dart';

class AppearanceSection extends ConsumerWidget {
  const new({super.key});

  /// Language names are shown as endonyms and are NEVER translated,
  /// so they live here instead of the i18n files.
  static const Map<AppLocale, String> _endonyms = {
    AppLocale.en: 'English',
    AppLocale.ru: 'Русский',
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Translations.of(context);
    final themeMode = ref.watch(themeControllerProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SmSectionHeader(title: t.settings.appearance),

        SmControlLabel(text: t.settings.theme),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: SegmentedButton<ThemeMode>(
            showSelectedIcon: false,
            segments: [
              ButtonSegment(
                value: ThemeMode.system,
                icon: const Icon(Icons.brightness_auto_outlined),
                label: Text(t.settings.themeSystem),
              ),
              ButtonSegment(
                value: ThemeMode.light,
                icon: const Icon(Icons.light_mode_outlined),
                label: Text(t.settings.themeLight),
              ),
              ButtonSegment(
                value: ThemeMode.dark,
                icon: const Icon(Icons.dark_mode_outlined),
                label: Text(t.settings.themeDark),
              ),
            ],
            selected: {themeMode},
            onSelectionChanged: (selection) =>
                ref.read(themeControllerProvider.notifier).mode =
                    selection.first,
          ),
        ),

        const SizedBox(height: AppSpacing.lg),

        SmControlLabel(text: t.settings.language),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: SegmentedButton<AppLocale>(
            showSelectedIcon: false,
            segments: [
              for (final locale in AppLocale.values)
                ButtonSegment(
                  value: locale,
                  label: Text(_endonyms[locale] ?? locale.languageCode),
                ),
            ],
            selected: {LocaleSettings.currentLocale},
            onSelectionChanged: (selection) =>
                LocaleSettings.setLocale(selection.first),
          ),
        ),
      ],
    );
  }
}
