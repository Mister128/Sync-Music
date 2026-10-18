import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sync_music/features/playlists/data/playlist_providers.dart';
import 'package:sync_music/features/playlists/domain/entities/playlist.dart';
import 'package:sync_music/i18n/strings.g.dart';

/// Create/rename dialog: [existing] == null means "create".
/// Resolves with the playlist id (created or renamed) - the picker chains
/// create-then-add with it; callers that don't care ignore the result.
Future<String?> showPlaylistFormDialog(
  BuildContext context, {
  Playlist? existing,
}) => showDialog<String>(
  context: context,
  builder: (dialogContext) => _PlaylistFormDialog(existing: existing),
);

class _PlaylistFormDialog extends ConsumerStatefulWidget {
  const new({this.existing});

  final Playlist? existing;

  @override
  ConsumerState<_PlaylistFormDialog> createState() =>
      _PlaylistFormDialogState();
}

class _PlaylistFormDialogState extends ConsumerState<_PlaylistFormDialog> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.existing?.name ?? '',
  );
  bool _showEmptyError = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final name = _controller.text.trim();
    if (name.isEmpty) {
      setState(() => _showEmptyError = true);
      return;
    }
    final dao = ref.read(playlistDaoProvider);
    final existing = widget.existing;
    final String id;
    if (existing == null) {
      id = await dao.createPlaylist(name);
    } else {
      await dao.renamePlaylist(existing.id, name);
      id = existing.id;
    }
    if (mounted) Navigator.pop(context, id);
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);

    return AlertDialog(
      title: Text(
        widget.existing == null ? t.playlists.create : t.playlists.rename,
      ),
      content: TextField(
        controller: _controller,
        autofocus: true,
        textCapitalization: TextCapitalization.sentences,
        onSubmitted: (_) => unawaited(_save()),
        decoration: InputDecoration(
          labelText: t.playlists.nameLabel,
          errorText: _showEmptyError ? t.playlists.nameEmpty : null,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(t.common.cancel),
        ),
        FilledButton(
          onPressed: () => unawaited(_save()),
          child: Text(t.common.save),
        ),
      ],
    );
  }
}
