import 'package:freezed_annotation/freezed_annotation.dart';

part 'album.freezed.dart';

/// An album DERIVED from the tracks table (GROUP BY album TITLE only).
/// Same title by different artists = ONE album (compilations merge);
/// [artistName] is a representative for display, not part of the key.
@freezed
abstract class Album with _$Album {
  const factory({
    required String albumTitle,
    required String artistName,
    required int trackCount,

    /// Cover of ANY track of the album - MIN() ignores NULLs, so one file
    /// with embedded art is enough for the whole card.
    String? artworkHash,
  }) = _Album;
}
