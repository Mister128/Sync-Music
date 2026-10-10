import 'package:sync_music/core/database/app_database.dart' as db;
import 'package:sync_music/features/library/data/datasources/library_dao.dart';
import 'package:sync_music/features/library/data/models/track_mapper.dart';
import 'package:sync_music/features/library/data/repositories/library_repository.dart';
import 'package:sync_music/features/library/domain/entities/album.dart';
import 'package:sync_music/features/library/domain/entities/artist.dart';
import 'package:sync_music/features/library/domain/entities/track.dart';

class LibraryRepositoryImpl implements LibraryRepository {
  new(this._dao);

  final LibraryDao _dao;

  @override
  Stream<List<Track>> watchTracks() => _dao.watchTracks().map(_toEntities);

  @override
  Stream<List<Album>> watchAlbums() => _dao.watchAlbums();

  @override
  Stream<List<Artist>> watchArtists() => _dao.watchArtists();

  @override
  Stream<List<Track>> watchAlbumTracks(String albumTitle) =>
      _dao.watchAlbumTracks(albumTitle).map(_toEntities);

  @override
  Stream<List<Track>> watchArtistTracks(String artistName) =>
      _dao.watchArtistTracks(artistName).map(_toEntities);

  List<Track> _toEntities(List<db.Track> rows) => [
    for (final db.Track row in rows) row.toEntity(),
  ];
}
