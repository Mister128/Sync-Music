import 'package:freezed_annotation/freezed_annotation.dart';

part 'artist.freezed.dart';

/// An artist DERIVED from the tracks table (GROUP BY artist_name).
@freezed
abstract class Artist with _$Artist {
  const factory({
    required String artistName,
    required int trackCount,
    required int albumCount,

    /// Cover of ANY track by this artist - MIN() ignores NULLs, so one file
    /// with embedded art is enough for the round avatar.
    String? artworkHash,
  }) = _Artist;
}
