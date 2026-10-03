import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sync_music/core/logging/app_logger.dart';
import 'package:sync_music/i18n/strings.g.dart';
import 'package:sync_music/app/app.dart';

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();

  AppLogger.init();
  final log = AppLogger.scope('bootstrap');
  log.info('Starting Sync Music');

  if (kDebugMode) {
    final dir = await getApplicationSupportDirectory();
    AppLogger.scope('storage').info('DB file: ${dir.path}${Platform.pathSeparator}sync_music.sqlite');
  }

  LocaleSettings.useDeviceLocale();

  final container = ProviderContainer();

  runApp(
    TranslationProvider(
      child: UncontrolledProviderScope(
        container: container,
        child: const SyncMusicApp(),
      ),
    ),
  );
}