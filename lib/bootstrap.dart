import 'dart:async';
import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio_media_kit/just_audio_media_kit.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sync_music/app/app.dart';
import 'package:sync_music/core/logging/app_logger.dart';
import 'package:sync_music/core/storage/artwork_paths.dart';
import 'package:sync_music/features/library/data/library_providers.dart';
import 'package:sync_music/features/library/presentation/controllers/library_scan_controller.dart';
import 'package:sync_music/features/player/data/playback_state_store.dart';
import 'package:sync_music/features/player/data/player_providers.dart';
import 'package:sync_music/features/player/data/sync_music_audio_handler.dart';
import 'package:sync_music/i18n/strings.g.dart';

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();

  AppLogger.init();
  final log = AppLogger.scope('bootstrap')..info('Starting Sync Music');

  if (kDebugMode) {
    final dir = await getApplicationSupportDirectory();
    log.info('DB file: ${dir.path}${Platform.pathSeparator}sync_music.sqlite');
  }

  // Resolve <support>/artwork once so tiles can map hash -> File synchronously
  // in build(). Same support dir drift_flutter uses for the DB.
  final artwork = await initArtWorkDir();
  log.info('Artwork dir: ${artwork.path}');

  await LocaleSettings.useDeviceLocale();
  log.info('Device locale: ${LocaleSettings.currentLocale.languageCode}');

  final container = ProviderContainer();

  if (Platform.isWindows) {
    JustAudioMediaKit.ensureInitialized();
  }

  if (Platform.isAndroid) {
    final engine = container.read(playbackServiceProvider);
    await AudioService.init(
      builder: () => SyncMusicAudioHandler(engine),
      config: const AudioServiceConfig(
        androidNotificationChannelId: 'com.mistery.sync_music.channel.audio',
        androidNotificationChannelName: 'Music playback',
        androidNotificationIcon: 'drawable/ic_stat_music',
      ),
    );
    log.info('audio_service initialized');
  }

  final playbackState = container.read(playbackStateStoreProvider);
  try {
    await playbackState.restore();
  } on Object catch (e) {
    // A broken session (unreadable files after a permission revoke,
    // corrupt row, engine hiccup) must never take the app down before
    // runApp - worst case we start with an empty queue.
    log.warn('session restore failed, starting clean: $e');
  }
  playbackState.startAutoSave();

  // Android may kill the process after backgrounding (a recents swipe also
  // stops the FGS): the lifecycle transition is the last guaranteed write.
  WidgetsBinding.instance.addObserver(_PlaybackFlushObserver(playbackState));

  runApp(
    TranslationProvider(
      child: UncontrolledProviderScope(
        container: container,
        child: const SyncMusicApp(),
      ),
    ),
  );

  // First-launch permission gate
  await WidgetsBinding.instance.endOfFrame;

  if (Platform.isAndroid) {
    if (!await Permission.notification.isGranted) {
      final status = await Permission.notification.request();
      log.info('notification permission: $status');
    }

    final scanner = container.read(platformMediaScannerProvider);
    if (!await scanner.hasPermission()) {
      final granted = await scanner.requestPermission();
      log.info('media permission: $granted');
      // Settings could already be open with a stale "denied" status.
      container.invalidate(audioPermissionProvider);
    }
  }

  // Silent incremental scan right after launch.
  unawaited(container.read(libraryScanControllerProvider.notifier).startScan());
}

/// Flushes the saved session when the app leaves the foreground (4.5).
class _PlaybackFlushObserver with WidgetsBindingObserver {
  new(this._store);

  final PlaybackStateStore _store;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      unawaited(_store.flush());
    }
  }
}
