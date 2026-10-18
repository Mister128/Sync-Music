import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sync_music/features/player/domain/entities/player_snapshot.dart';
import 'package:sync_music/features/player/presentation/controllers/player_controller.dart';
import 'package:sync_music/features/player/presentation/widgets/mini_player.dart';

/// Bottom slot for pages OUTSIDE the shell (playlist / album / artist):
/// the MiniPlayer when something is current, nothing otherwise - the same
/// guard the shells use.
class MiniPlayerSlot extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasTrack = ref.watch(
      playerControllerProvider.select((state) => state.currentTrack != null),
    );
    return hasTrack ? const MiniPlayer() : const SizedBox.shrink();
  }
}
