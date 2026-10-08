import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sync_music/app/app.dart';
import 'package:sync_music/core/logging/app_logger.dart';
import 'package:sync_music/features/library/presentation/controllers/library_scan_controller.dart';
import 'package:sync_music/i18n/strings.g.dart';

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();

  AppLogger.init();
  final log = AppLogger.scope('bootstrap')..info('Starting Sync Music');

  if (kDebugMode) {
    final dir = await getApplicationSupportDirectory();
    log.info('DB file: ${dir.path}${Platform.pathSeparator}sync_music.sqlite');
  }

  await LocaleSettings.useDeviceLocale();
  log.info('Device locale: ${LocaleSettings.currentLocale.languageCode}');

  final container = ProviderContainer();

  runApp(
    TranslationProvider(
      child: UncontrolledProviderScope(
        container: container,
        child: const SyncMusicApp(),
      ),
    ),
  );

  // Silent incremental scan right after launch. NOT awaited - the UI comes up
  // while the scan runs in the background; streams will refresh it live
  unawaited(container.read(libraryScanControllerProvider.notifier).startScan());
}
