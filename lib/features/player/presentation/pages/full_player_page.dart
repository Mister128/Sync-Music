import 'dart:async';

import 'package:flutter/material.dart' hide RepeatMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:sync_music/app/router/routes.dart';
import 'package:sync_music/core/design_system/theme/app_spacing.dart';
import 'package:sync_music/core/design_system/widgets/sm_artwork.dart';
import 'package:sync_music/core/extensions/duration_x.dart';
import 'package:sync_music/features/library/domain/entities/track.dart';
import 'package:sync_music/features/player/data/artwork_palette.dart';
import 'package:sync_music/features/player/domain/entities/player_snapshot.dart';
import 'package:sync_music/features/player/domain/entities/repeat_mode.dart';
import 'package:sync_music/features/player/presentation/controllers/player_controller.dart';
import 'package:sync_music/features/playlists/presentation/widgets/favorite_button.dart';
import 'package:sync_music/i18n/strings.g.dart';

/// Full-screen "now playing", opened by a tap or a swipe-up on the
/// MiniPlayer (slide-up route in app_router).
///
/// REBUILD DISCIPLINE: this page watches the RARE playerControllerProvider
/// only; the ~10 Hz position ticks are isolated inside _SeekBar.
class FullPlayerPage extends ConsumerWidget {
  const new({super.key});

  static const double _maxContentWidth = 560;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Translations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final snapshot = ref.watch(playerControllerProvider);
    final controller = ref.read(playerControllerProvider.notifier);
    final track = snapshot.currentTrack;

    if (track == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.music_off_outlined,
                size: 48,
                color: scheme.onSurfaceVariant,
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(t.player.queueEmpty, style: theme.textTheme.titleMedium),
            ],
          ),
        ),
      );
    }

    final dominant = ref.watch(artworkColorProvider(track.artworkHash)).value;
    final topColor = dominant == null
        ? scheme.surface
        : Color.alphaBlend(
            dominant.withValues(
              alpha: theme.brightness == Brightness.dark ? 0.45 : 0.30,
            ),
            scheme.surface,
          );

    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [topColor, scheme.surface],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: _maxContentWidth),
              child: Column(
                children: [
                  _TopBar(trackId: track.id),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.xl,
                      ),
                      child: LayoutBuilder(
                        builder: (context, constraints) => Center(
                          child: SmArtwork(
                            hash: track.artworkHash,
                            size: constraints.biggest.shortestSide,
                            borderRadius: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  _TrackMeta(track: track),
                  _SeekBar(duration: snapshot.duration),
                  _TransportRow(snapshot: snapshot, controller: controller),
                  const SizedBox(height: AppSpacing.lg),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Collapse / caption / queue - the only navigating row.
class _TopBar extends StatelessWidget {
  const new({required this.trackId});

  final String trackId;

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final theme = Theme.of(context);

    return Row(
      children: [
        IconButton(
          tooltip: t.player.closePlayer,
          icon: const Icon(Icons.expand_more),
          onPressed: () => context.pop(),
        ),
        Expanded(
          child: Text(
            t.player.nowPlaying.toUpperCase(),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.labelLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              letterSpacing: 1.6,
            ),
          ),
        ),
        FavoriteButton(trackId: trackId),
        IconButton(
          tooltip: t.player.queue,
          icon: const Icon(Icons.queue_music),
          onPressed: () => context.push(Routes.queue),
        ),
      ],
    );
  }
}

class _TrackMeta extends StatelessWidget {
  const new({required this.track});

  final Track track;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      child: Column(
        children: [
          Text(
            track.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.headlineSmall,
          ),
          const SizedBox(height: AppSpacing.xl),
          Text(
            track.artistName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleSmall?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

/// The ONLY widget watching positionProvider (~10 events/s): the cover and
/// the buttons above never rebuild on ticks, only the slider moves.
///
/// `_dragValue` freezes the thumb under the finger - without it every
/// stream tick would fight the ongoing drag.
class _SeekBar extends ConsumerStatefulWidget {
  const new({required this.duration});

  final Duration? duration;

  @override
  ConsumerState<_SeekBar> createState() => _SeekBarState();
}

class _SeekBarState extends ConsumerState<_SeekBar> {
  double? _dragValue;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final labelStyle = theme.textTheme.labelSmall?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
    );

    final position = ref.watch(positionProvider).value ?? Duration.zero;
    final duration = widget.duration ?? Duration.zero;
    final maxMs = duration.inMilliseconds.toDouble();
    final known = maxMs > 0;

    final rawMs = _dragValue ?? position.inMilliseconds.toDouble();
    final currentMs = rawMs.clamp(0.0, maxMs);
    final remaining = Duration(milliseconds: (maxMs - currentMs).round());

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.lg,
        0,
      ),
      child: Column(
        children: [
          Slider(
            value: currentMs,
            max: known ? maxMs : 1,
            onChanged: known ? (v) => setState(() => _dragValue = v) : null,
            onChangeEnd: known
                ? (v) {
                    setState(() => _dragValue = null);
                    unawaited(
                      ref
                          .read(playerControllerProvider.notifier)
                          .seek(Duration(milliseconds: v.round())),
                    );
                  }
                : null,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  known
                      ? Duration(milliseconds: currentMs.round()).display
                      : '--:--',
                  style: labelStyle,
                ),
                Text(
                  known ? '-${remaining.display}' : '--:--',
                  style: labelStyle,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Shuffle / prev / play-pause / next / repeat. The mode buttons read the
/// SAME PlayerSnapshot the notification toggles update - one source of
/// truth for both surfaces, so they can never disagree.
class _TransportRow extends StatelessWidget {
  const new({required this.snapshot, required this.controller});

  final PlayerSnapshot snapshot;
  final PlayerController controller;

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.sm,
        0,
        AppSpacing.sm,
        AppSpacing.xxl,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            tooltip: t.player.shuffle,
            iconSize: 26,
            icon: Icon(
              snapshot.shuffleEnabled ? Icons.shuffle_on : Icons.shuffle,
              color: snapshot.shuffleEnabled
                  ? scheme.primary
                  : scheme.onSurfaceVariant,
            ),
            onPressed: controller.toggleShuffle,
          ),
          IconButton(
            tooltip: t.player.previous,
            iconSize: 36,
            icon: const Icon(Icons.skip_previous),
            onPressed: controller.skipPrevious,
          ),
          SizedBox(
            width: 72,
            height: 72,
            child: FilledButton(
              style: FilledButton.styleFrom(
                padding: EdgeInsets.zero,
                shape: const CircleBorder(),
              ),
              onPressed: controller.togglePlay,
              child: Icon(
                snapshot.isPlaying ? Icons.pause : Icons.play_arrow,
                size: 40,
              ),
            ),
          ),
          IconButton(
            tooltip: t.player.next,
            iconSize: 36,
            icon: const Icon(Icons.skip_next),
            onPressed: controller.skipNext,
          ),
          IconButton(
            tooltip: switch (snapshot.repeatMode) {
              RepeatMode.off => t.player.repeatOff,
              RepeatMode.all => t.player.repeatAll,
              RepeatMode.one => t.player.repeatOne,
            },
            iconSize: 26,
            icon: Icon(
              snapshot.repeatMode == RepeatMode.one
                  ? Icons.repeat_one
                  : Icons.repeat,
              color: snapshot.repeatMode == RepeatMode.off
                  ? scheme.onSurfaceVariant
                  : scheme.primary,
            ),
            onPressed: controller.cycleRepeatMode,
          ),
        ],
      ),
    );
  }
}
