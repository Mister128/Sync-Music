import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sync_music/features/player/data/just_audio_playback.dart';
import 'package:sync_music/features/player/domain/services/playback_service.dart';

final playbackServiceProvider = Provider<PlaybackService>((ref) {
  final service = JustAudioPlayback();
  ref.onDispose(service.dispose);
  return service;
});
