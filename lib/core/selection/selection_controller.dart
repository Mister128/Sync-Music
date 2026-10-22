import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Global multi-select state. Stores ONLY track ids - core does
/// not import features; the bottom slot resolves ids to Tracks when an
/// action fires (selectedTracksProvider, ADR-0008 supplement 3).
///
/// Navigation is LOCKED while a selection is active (shells + PopScope),
/// so at most one page's context is ever live - the controller needs no
/// notion of "where" the selection started.
class SelectionController extends Notifier<Set<String>> {
  @override
  Set<String> build() => const {};

  bool get isActive => state.isNotEmpty;

  void toggle(String id) {
    final next = {...state};
    if (next.contains(id)) {
      next.remove(id);
    } else {
      next.add(id);
    }

    state = next;
  }

  void selectAll(Iterable<String> ids) => state = Set<String>.of(ids);

  void clear() => state = const {};
}

final selectionControllerProvider =
    NotifierProvider<SelectionController, Set<String>>(SelectionController.new);
