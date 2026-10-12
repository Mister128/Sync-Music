import 'dart:isolate';
import 'dart:ui' show Color;

import 'package:flutter_riverpod/misc.dart';
import 'package:riverpod/riverpod.dart';

import 'package:sync_music/core/storage/artwork_paths.dart';
import 'package:sync_music/core/utils/dominant_color.dart';

/// Dominant cover color for the full-player gradient.
///
/// The family caches per artwork hash: every track of an album shares ONE
/// cover file, so switching tracks within an album hits the cache and the
/// background does not even blink. One Color per hash in memory - a
/// non-issue even for thousands of albums.
///
/// Known trade-off (documented, accepted): if the background extraction
/// pass writes the cover AFTER this provider resolved for the hash, the
/// null stays cached until app restart. Covers land right after the scan,
/// long before playback - in practice this window is empty.
final FutureProviderFamily<Color?, String?> artworkColorProvider =
    FutureProvider.family<Color?, String?>((ref, artworkHash) async {
      if (artworkHash == null) return null;
      final file = artWorkFileFor(artworkHash);
      if (!file.existsSync()) return null;

      final bytes = await file.readAsBytes();
      final argb = await Isolate.run(() => dominantColor(bytes));
      return argb == null ? null : Color(argb);
    });
