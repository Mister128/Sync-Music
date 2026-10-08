import 'package:freezed_annotation/freezed_annotation.dart';

part 'track.freezed.dart';

/// A track in the user's library - the domain entity the UI works with.
/// Deliberately has NO drift types: presentation must not know about the DB.
/// localPath == null means "remote-only" (file lives on another device - stage 10).
@freezed
abstract class Track with _$Track {
  const factory Track({
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