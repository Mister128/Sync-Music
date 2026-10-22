import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sync_music/core/design_system/theme/app_spacing.dart';
import 'package:sync_music/core/design_system/widgets/sm_track_tile.dart';
import 'package:sync_music/core/selection/selection_controller.dart';
import 'package:sync_music/features/library/data/library_providers.dart';
import 'package:sync_music/features/library/presentation/controllers/library_scan_controller.dart';
import 'package:sync_music/features/player/presentation/controllers/player_controller.dart';
import 'package:sync_music/features/player/presentation/widgets/track_action_menu.dart';
import 'package:sync_music/i18n/strings.g.dart';

class TracksPage extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Translations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final scanState = ref.watch(libraryScanControllerProvider);
    final selection = ref.watch(selectionControllerProvider);
    final inSelectionMode = selection.isNotEmpty;

    return Column(
      children: [
        if (scanState case ScanRunning(:final processed, :final total))
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.sm,
              AppSpacing.md,
              0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  t.library.scanning(processed: processed, total: total),
                  style: theme.textTheme.labelMedium,
                ),
                const SizedBox(height: AppSpacing.xs),
                LinearProgressIndicator(
                  value: total == 0 ? null : processed / total,
                ),
              ],
            ),
          ),
        Expanded(
          child: switch (ref.watch(tracksProvider)) {
            AsyncData(:final value) when value.isEmpty => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Icon(
                    Icons.queue_music,
                    size: 48,
                    color: scheme.onSurfaceVariant,
                  ),
                ),
                Text(t.library.tracksEmpty, style: theme.textTheme.titleMedium),
                Text(
                  t.library.tracksEmptyHint,
                  style: theme.textTheme.labelMedium,
                ),
              ],
            ),

            AsyncData(:final value) => RefreshIndicator(
              onRefresh: () =>
                  ref.read(libraryScanControllerProvider.notifier).startScan(),
              child: ListView.builder(
                itemCount: value.length,
                itemBuilder: (context, index) {
                  final track = value[index];
                  void toggle() => ref
                      .read(selectionControllerProvider.notifier)
                      .toggle(track.id);

                  return SmTrackTile(
                    title: track.title,
                    subtitle: track.artistName,
                    durationMs: track.durationMs,
                    artworkHash: track.artworkHash,
                    selected: selection.contains(track.id),
                    onToggleSelect: inSelectionMode ? toggle : null,
                    // In selection mode tap toggles instead of playing.
                    onTap: inSelectionMode
                        ? toggle
                        : () => ref
                              .read(playerControllerProvider.notifier)
                              .playQueue(value, startIndex: index),
                    // Long-press both ENTERS the mode and adds the track.
                    onLongPress: toggle,
                    trailing: inSelectionMode
                        ? null
                        : TrackActionMenu(track: track),
                  );
                },
              ),
            ),

            AsyncError(:final error) => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(child: Text(t.common.error)),
                Text('$error'),
              ],
            ),
            AsyncLoading() => const Center(child: CircularProgressIndicator()),
          },
        ),
      ],
    );
  }
}
