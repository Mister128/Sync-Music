import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sync_music/core/design_system/widgets/sm_track_tile.dart';
import 'package:sync_music/features/library/domain/library_providers.dart';
import 'package:sync_music/features/library/presentation/controllers/library_scan_controller.dart';
import 'package:sync_music/i18n/strings.g.dart';

class TracksPage extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Translations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return switch (ref.watch(tracksProvider)) {
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
          Text(t.library.tracksEmptyHint, style: theme.textTheme.labelMedium),
        ],
      ),

      AsyncData(:final value) => RefreshIndicator(
        onRefresh: () =>
            ref.read(libraryScanControllerProvider.notifier).startScan(),
        child: ListView.builder(
          itemCount: value.length,
          itemBuilder: (context, index) {
            final track = value[index];
            return SmTrackTile(
              title: track.title,
              subtitle: track.artistName,
              durationMs: track.durationMs,
              artworkHash: track.artworkHash,
              onTap: () {},
              // TODO(Mister128): play
              onLongPress: () {}, // TODO(Mister128): action
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
    };
  }
}
