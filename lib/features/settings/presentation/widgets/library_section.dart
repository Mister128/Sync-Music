import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:sync_music/core/design_system/theme/app_spacing.dart';
import 'package:sync_music/features/library/data/library_providers.dart';
import 'package:sync_music/i18n/strings.g.dart';

class LibrarySection extends ConsumerWidget {
  const new({super.key});

  /// Opens the system folder picker and persists the chosen path.
  Future<void> _pickFolder(WidgetRef ref, Translations t) async {
    final dao = ref.read(libraryRootsDaoProvider);

    final path = await FilePicker.getDirectoryPath(
      dialogTitle: t.settings.addFolderDialog,
    );
    if (path == null) return;

    await dao.addRoot(path);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Translations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return switch (ref.watch(libraryRootsProvider)) {
      AsyncData(:final value) when value.isEmpty => Column(
        children: [
          Icon(
            Icons.folder_off_outlined,
            size: 40,
            color: scheme.onSurfaceVariant,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(t.settings.libraryEmpty, style: theme.textTheme.titleSmall),
          Text(
            t.settings.libraryEmptyHint,
            style: theme.textTheme.bodySmall?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          _AddFolderButton(onPressed: () => _pickFolder(ref, t)),
        ],
      ),

      AsyncData(:final value) => Column(
        children: [
          for (final root in value)
            ListTile(
              leading: const Icon(Icons.folder_outlined),
              title: Text(root.path),
              subtitle: Text(
                root.lastScannedAtMs == null
                    ? t.settings.notScanned
                    : t.settings.lastScanned(
                        date: _formatLastScanned(root.lastScannedAtMs!),
                      ),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.close),
                tooltip: t.settings.removeFolder,
                onPressed: () =>
                    ref.read(libraryRootsDaoProvider).removeRoot(root.path),
              ),
            ),
          _AddFolderButton(onPressed: () => _pickFolder(ref, t)),
        ],
      ),

      AsyncError(:final error) => ListTile(
        leading: Icon(Icons.error_outline, color: scheme.error),
        title: Text(t.common.error),
        subtitle: Text('$error'),
      ),

      AsyncLoading() => const Padding(
        padding: EdgeInsets.all(AppSpacing.xl),
        child: Center(child: CircularProgressIndicator()),
      ),
    };
  }
}

class _AddFolderButton extends StatelessWidget {
  const new({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    return FilledButton.tonalIcon(
      onPressed: onPressed,
      icon: const Icon(Icons.create_new_folder_outlined),
      label: Text(t.settings.addFolder),
    );
  }
}

String _formatLastScanned(int ms) {
  final locale = LocaleSettings.currentLocale.languageCode;
  return DateFormat.yMMMd(locale)
      .add_Hm()
      .format(DateTime.fromMillisecondsSinceEpoch(ms));
}
