import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Debounced search query. The TextField calls
/// onQueryChanged on EVERY keystroke, but the state - and therefore the
/// searchResultsProvider family - only moves after the user pauses.
class SearchQueryController extends Notifier<String> {
  static const _debounce = Duration(milliseconds: 250);

  Timer? _timer;

  @override
  String build() {
    ref.onDispose(() => _timer?.cancel());
    return '';
  }

  void onQueryChanged(String raw) {
    _timer?.cancel();
    _timer = Timer(_debounce, () => state = raw.trim());
  }

  /// Immediate commit - keyboard "search" button and the clear button
  /// must not wait out the debounce.
  void commit(String raw) {
    _timer?.cancel();
    state = raw.trim();
  }
}

final searchQueryProvider = NotifierProvider<SearchQueryController, String>(
  SearchQueryController.new,
);
