import 'package:flutter/material.dart';
import 'package:sync_music/core/design_system/widgets/sm_section_header.dart';
import 'package:sync_music/i18n/strings.g.dart';

class AboutSection extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SmSectionHeader(title: t.settings.about),
        ListTile(
          leading: const Icon(Icons.info_outline),
          title: Text(t.app.title),
          // Hardcoded for now; package_info_plus comes at a later stage.
          subtitle: Text('${t.settings.version} 0.1.0'),
        ),
      ],
    );
  }
}
