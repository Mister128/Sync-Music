import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:sync_music/features/library/data/library_providers.dart';
import 'package:sync_music/features/library/domain/entities/scan_event.dart';

part 'library_scan_controller.freezed.dart';

/// UI-facing scan state. Distinct from ScanEvent (that's the low-level
/// protocol; this is what widgets render).
@freezed
sealed class ScanUiState with _$ScanUiState {
  const factory idle() = ScanIdle;

  const factory running({required int processed, required int total}) =
      ScanRunning;

  const factory failed({required String message}) = ScanUiFailed;
}

/// Single entry point for ALL scan triggers (startup, new folder, manual).
class LibraryScanController extends Notifier<ScanUiState> {
  bool _rerunRequested = false;

  @override
  ScanUiState build() => const ScanUiState.idle();

  Future<void> startScan() async {
    if (state is ScanRunning) {
      // A scan is already going: don't start a second one, but remember
      _rerunRequested = true;
      return;
    }
    state = const ScanUiState.running(processed: 0, total: 0);

    await for (final event in ref.read(rescanLibraryProvider)()) {
      state = switch (event) {
        ScanStarted(:final toProcess) => ScanUiState.running(
          processed: 0,
          total: toProcess,
        ),
        ScanProgress(:final processed, :final total) => ScanUiState.running(
          processed: processed,
          total: total,
        ),
        ScanFinished() => const ScanUiState.idle(),
        ScanFailed(:final message) => ScanUiState.failed(message: message),
      };
    }

    // Coalesced request: something changed while we were scanning.
    if (_rerunRequested) {
      _rerunRequested = false;
      await startScan();
    }
  }
}

final libraryScanControllerProvider =
    NotifierProvider<LibraryScanController, ScanUiState>(
      LibraryScanController.new,
    );
