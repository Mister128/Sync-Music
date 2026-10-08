import 'package:sync_music/core/database/app_database.dart' as db;
import 'package:sync_music/features/library/data/datasources/library_dao.dart';
import 'package:sync_music/features/library/data/models/track_mapper.dart';
import 'package:sync_music/features/library/domain/entities/track.dart';
import 'package:sync_music/features/library/domain/repositories/library_repository.dart';

class LibraryRepositoryImpl implements LibraryRepository {
  new(this._dao);

  final LibraryDao _dao;

  @override
  Stream<List<Track>> watchTracks() => _dao.watchTracks().map(
    (rows) => [for (final db.Track row in rows) row.toEntity()],
  );
}
