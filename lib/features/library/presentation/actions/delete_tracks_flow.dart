import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sync_music/core/platform/platform_info.dart';
import 'package:sync_music/features/library/data/library_providers.dart';
import 'package:sync_music/features/library/domain/entities/track.dart';
import 'package:sync_music/i18n/strings.g.dart';

/// The shared "delete forever" UI flow.
/// - desktop: confirm dialog first (batch = ONE dialog for the whole set);
/// - Android: straight to MediaStore.createDeleteRequest - the system
///   sheet IS the confirmation (all-or-nothing by design, rinf#647 era).
///
/// Returns true when the deletion RAN (even if some files failed - the
/// snackbar reports honest counts); false when the user cancelled the
/// dialog. Callers use it to decide whether to exit selection mode.
Future<bool> confirmAndDeleteTracks(
  BuildContext context,
  WidgetRef ref,
  List<Track> tracks,
) async {
  if (tracks.isEmpty) return false;

  final t = Translations.of(context);
  final deleteTracks = ref.read(deleteTracksProvider);
  final messenger = ScaffoldMessenger.of(context);
  final single = tracks.length == 1;

  if (!PlatformInfo.usesSystemMediaLibrary) {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          single
              ? t.library.deleteConfirmTitle
              : t.library.deleteConfirmTitleBatch(
                  n: tracks.length,
                  count: tracks.length,
                ),
        ),
        content: Text(
          single
              ? t.library.deleteConfirmMessage(title: tracks.first.title)
              : t.library.deleteConfirmMessageBatch,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(t.common.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(t.library.deleteConfirmAction),
          ),
        ],
      ),
    );
    if (confirmed != true) return false;
  }

  final result = await deleteTracks(tracks);
  messenger.showSnackBar(
    SnackBar(
      content: Text(switch ((single, result.failed == 0)) {
        (true, true) => t.library.deleted,
        (true, false) => t.library.deleteFailed,
        (false, true) => t.library.deletedBatch(
          n: result.deleted,
          count: result.deleted,
        ),
        (false, false) => t.library.deleteFailedBatch(
          n: result.failed,
          count: result.failed,
        ),
      }),
    ),
  );
  return true;
}
