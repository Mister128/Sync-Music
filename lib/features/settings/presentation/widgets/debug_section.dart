import 'package:flutter/material.dart';
import 'package:sync_music/core/design_system/widgets/sm_section_header.dart';
import 'package:sync_music/core/logging/app_logger.dart';
import 'package:sync_music/i18n/strings.g.dart';
import 'package:talker_flutter/talker_flutter.dart';

class DebugSection extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SmSectionHeader(title: t.settings.debug),
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
    );
  }
}
