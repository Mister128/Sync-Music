import 'package:freezed_annotation/freezed_annotation.dart';

part 'album.freezed.dart';

/// An album DERIVED from the tracks table (GROUP BY album + artist).
/// There is no albums table by design: the grid can never go out of sync
/// with the library, and the album disappears with its last track.
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
