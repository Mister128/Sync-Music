import 'package:freezed_annotation/freezed_annotation.dart';

part 'track.freezed.dart';

/// A track in the user's library - the domain entity the UI works with.
@freezed
abstract class Track with _$Track {
  const factory({
    required String id,
    required String contentHash,
    required String title,
    required String artistName,
    String? albumTitle,
    int? trackNumber,
    int? discNumber,
    int? durationMs,
    String? genre,
    int? year,
    String? artworkHash,
    String? localPath,
  }) = _Track;
}
