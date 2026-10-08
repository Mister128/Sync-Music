import 'package:sync_music/core/database/app_database.dart' as db;
import 'package:sync_music/features/library/domain/entities/track.dart';

/// drift row -> domain entity. One direction for now; the reverse
/// (entity -> Companion) already lives inside LibraryDao.insertScanned.
extension DbTrackToEntity on db.Track {
  Track toEntity() => Track(
    id: id,
    contentHash: contentHash,
    title: title,
    artistName: artistName,
    albumTitle: albumTitle,
    trackNumber: trackNumber,
    discNumber: discNumber,
    durationMs: durationMs,
    genre: genre,
    year: year,
    artworkHash: artworkHash,
    localPath: localPath,
  );
}
