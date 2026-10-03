import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sync_music/core/design_system/theme/app_spacing.dart';
import 'package:sync_music/core/logging/app_logger.dart';
import 'package:sync_music/features/settings/presentation/controllers/theme_controller.dart';
import 'package:sync_music/i18n/strings.g.dart';
import 'package:talker_flutter/talker_flutter.dart';

class SettingsPage extends ConsumerWidget {
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

    return Scaffold(
      appBar: AppBar(title: Text(t.settings.title)),
      body: ListView(
        padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
        children: [
          // ---------------- Appearance ----------------
          _SectionHeader(title: t.settings.appearance),

          _ControlLabel(text: t.settings.theme),
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

          _ControlLabel(text: t.settings.language),
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

          // Collection-if: the whole section is compiled away in release.
          if (kDebugMode) ...[
            _SectionHeader(title: t.settings.debug),
            ListTile(
              leading: const Icon(Icons.bug_report_outlined),
              title: Text(t.settings.debugLogs),
              subtitle: Text(t.settings.debugLogsSubtitle),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // Plain Navigator push is fine for a debug-only screen;
                // it stacks on top of the go_router page without a route entry.
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => TalkerScreen(talker: AppLogger.instance),
                  ),
                );
              },
            ),
          ],

          // ---------------- About ----------------
          _SectionHeader(title: t.settings.about),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(t.app.title),
            // Hardcoded for now; package_info_plus comes at a later stage.
            subtitle: Text('${t.settings.version} 0.1.0'),
          ),
        ],
      ),
    );
  }
}

/// Uppercase section title row, e.g. "APPEARANCE".
class _SectionHeader extends StatelessWidget {
  const new({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.xl,
        AppSpacing.lg,
        AppSpacing.sm,
      ),
      child: Text(
        title.toUpperCase(),
        style: theme.textTheme.labelLarge?.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

/// Small caption above a control ("Theme", "Language").
class _ControlLabel extends StatelessWidget {
  const new({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.sm,
        AppSpacing.lg,
        AppSpacing.sm,
      ),
      child: Text(
        text,
        style: theme.textTheme.titleSmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
