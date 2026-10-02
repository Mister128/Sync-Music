import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sync_music/features/settings/presentation/controllers/theme_controller.dart';
import 'package:sync_music/core/design_system/theme/app_theme.dart';
import 'package:sync_music/app/router/app_router.dart';
import 'package:sync_music/i18n/strings.g.dart';

class SyncMusicApp extends ConsumerWidget {
  const SyncMusicApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      onGenerateTitle: (context) => t.app.title,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ref.watch(themeControllerProvider),

      routerConfig: ref.watch(routerProvider),

      locale: TranslationProvider.of(context).flutterLocale,
      supportedLocales: AppLocaleUtils.supportedLocales,
      localizationsDelegates: GlobalMaterialLocalizations.delegates,

      debugShowCheckedModeBanner: false,
    );
  }
}