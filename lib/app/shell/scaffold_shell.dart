import 'package:flutter/material.dart';

import 'package:sync_music/app/shell/phone_shell.dart';
import 'package:sync_music/app/shell/wide_shell.dart';
import 'package:sync_music/core/extensions/build_context_x.dart';

class ScaffoldShell extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return context.isCompact ? const PhoneShell() : const WideShell();
  }
}
