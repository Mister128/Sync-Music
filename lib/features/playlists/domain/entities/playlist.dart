import 'package:freezed_annotation/freezed_annotation.dart';

part 'playlist.freezed.dart';

/// A user playlist. TrackCount and artworkHash are DERIVED by the DAO
/// query (JOiN over alive membership + alive tracks), never stored -
/// the cannot go out of sync, same philosophy as Album/Artist.
@freezed
abstract class Playlist with _$Playlist {
  const factory({
    required String id,
    required String name,
    required int trackCount,

    String? artworkHash,
  }) = _Playlist;
}
