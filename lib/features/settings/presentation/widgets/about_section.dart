import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sync_music/core/design_system/widgets/sm_section_header.dart';
import 'package:sync_music/features/settings/data/app_info_provider.dart';
import 'package:sync_music/i18n/strings.g.dart';

class AboutSection extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Translations.of(context);
    final version = ref.watch(appVersionProvider).value;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SmSectionHeader(title: t.settings.about),
        ListTile(
          leading: const Icon(Icons.info_outline),
          title: Text(t.app.title),
          subtitle: Text(
            version == null
                ? t.settings.version
                : '${t.settings.version} $version',
          ),
        ),
      ],
    );
  }
}
