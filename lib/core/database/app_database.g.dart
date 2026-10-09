// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $TracksTable extends Tracks with TableInfo<$TracksTable, Track> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TracksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contentHashMeta = const VerificationMeta(
    'contentHash',
  );
  @override
  late final GeneratedColumn<String> contentHash = GeneratedColumn<String>(
    'content_hash',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _artistNameMeta = const VerificationMeta(
    'artistName',
  );
  @override
  late final GeneratedColumn<String> artistName = GeneratedColumn<String>(
    'artist_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Unknown artist'),
  );
  static const VerificationMeta _albumTitleMeta = const VerificationMeta(
    'albumTitle',
  );
  @override
  late final GeneratedColumn<String> albumTitle = GeneratedColumn<String>(
    'album_title',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _durationMsMeta = const VerificationMeta(
    'durationMs',
  );
  @override
  late final GeneratedColumn<int> durationMs = GeneratedColumn<int>(
    'duration_ms',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _localPathMeta = const VerificationMeta(
    'localPath',
  );
  @override
  late final GeneratedColumn<String> localPath = GeneratedColumn<String>(
    'local_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sizeBytesMeta = const VerificationMeta(
    'sizeBytes',
  );
  @override
  late final GeneratedColumn<int> sizeBytes = GeneratedColumn<int>(
    'size_bytes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _fileMtimeMsMeta = const VerificationMeta(
    'fileMtimeMs',
  );
  @override
  late final GeneratedColumn<int> fileMtimeMs = GeneratedColumn<int>(
    'file_mtime_ms',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _artworkHashMeta = const VerificationMeta(
    'artworkHash',
  );
  @override
  late final GeneratedColumn<String> artworkHash = GeneratedColumn<String>(
    'artwork_hash',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _artworkCheckedAtMsMeta =
      const VerificationMeta('artworkCheckedAtMs');
  @override
  late final GeneratedColumn<int> artworkCheckedAtMs = GeneratedColumn<int>(
    'artwork_checked_at_ms',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _addedAtMsMeta = const VerificationMeta(
    'addedAtMs',
  );
  @override
  late final GeneratedColumn<int> addedAtMs = GeneratedColumn<int>(
    'added_at_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMsMeta = const VerificationMeta(
    'updatedAtMs',
  );
  @override
  late final GeneratedColumn<int> updatedAtMs = GeneratedColumn<int>(
    'updated_at_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMsMeta = const VerificationMeta(
    'deletedAtMs',
  );
  @override
  late final GeneratedColumn<int> deletedAtMs = GeneratedColumn<int>(
    'deleted_at_ms',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _trackNumberMeta = const VerificationMeta(
    'trackNumber',
  );
  @override
  late final GeneratedColumn<int> trackNumber = GeneratedColumn<int>(
    'track_number',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _discNumberMeta = const VerificationMeta(
    'discNumber',
  );
  @override
  late final GeneratedColumn<int> discNumber = GeneratedColumn<int>(
    'disc_number',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bitrateMeta = const VerificationMeta(
    'bitrate',
  );
  @override
  late final GeneratedColumn<int> bitrate = GeneratedColumn<int>(
    'bitrate',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sampleRateMeta = const VerificationMeta(
    'sampleRate',
  );
  @override
  late final GeneratedColumn<int> sampleRate = GeneratedColumn<int>(
    'sample_rate',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _yearMeta = const VerificationMeta('year');
  @override
  late final GeneratedColumn<int> year = GeneratedColumn<int>(
    'year',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _genreMeta = const VerificationMeta('genre');
  @override
  late final GeneratedColumn<String> genre = GeneratedColumn<String>(
    'genre',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    contentHash,
    title,
    artistName,
    albumTitle,
    durationMs,
    localPath,
    sizeBytes,
    fileMtimeMs,
    artworkHash,
    artworkCheckedAtMs,
    addedAtMs,
    updatedAtMs,
    deletedAtMs,
    trackNumber,
    discNumber,
    bitrate,
    sampleRate,
    year,
    genre,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tracks';
  @override
  VerificationContext validateIntegrity(
    Insertable<Track> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('content_hash')) {
      context.handle(
        _contentHashMeta,
        contentHash.isAcceptableOrUnknown(
          data['content_hash']!,
          _contentHashMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_contentHashMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('artist_name')) {
      context.handle(
        _artistNameMeta,
        artistName.isAcceptableOrUnknown(data['artist_name']!, _artistNameMeta),
      );
    }
    if (data.containsKey('album_title')) {
      context.handle(
        _albumTitleMeta,
        albumTitle.isAcceptableOrUnknown(data['album_title']!, _albumTitleMeta),
      );
    }
    if (data.containsKey('duration_ms')) {
      context.handle(
        _durationMsMeta,
        durationMs.isAcceptableOrUnknown(data['duration_ms']!, _durationMsMeta),
      );
    }
    if (data.containsKey('local_path')) {
      context.handle(
        _localPathMeta,
        localPath.isAcceptableOrUnknown(data['local_path']!, _localPathMeta),
      );
    }
    if (data.containsKey('size_bytes')) {
      context.handle(
        _sizeBytesMeta,
        sizeBytes.isAcceptableOrUnknown(data['size_bytes']!, _sizeBytesMeta),
      );
    }
    if (data.containsKey('file_mtime_ms')) {
      context.handle(
        _fileMtimeMsMeta,
        fileMtimeMs.isAcceptableOrUnknown(
          data['file_mtime_ms']!,
          _fileMtimeMsMeta,
        ),
      );
    }
    if (data.containsKey('artwork_hash')) {
      context.handle(
        _artworkHashMeta,
        artworkHash.isAcceptableOrUnknown(
          data['artwork_hash']!,
          _artworkHashMeta,
        ),
      );
    }
    if (data.containsKey('artwork_checked_at_ms')) {
      context.handle(
        _artworkCheckedAtMsMeta,
        artworkCheckedAtMs.isAcceptableOrUnknown(
          data['artwork_checked_at_ms']!,
          _artworkCheckedAtMsMeta,
        ),
      );
    }
    if (data.containsKey('added_at_ms')) {
      context.handle(
        _addedAtMsMeta,
        addedAtMs.isAcceptableOrUnknown(data['added_at_ms']!, _addedAtMsMeta),
      );
    } else if (isInserting) {
      context.missing(_addedAtMsMeta);
    }
    if (data.containsKey('updated_at_ms')) {
      context.handle(
        _updatedAtMsMeta,
        updatedAtMs.isAcceptableOrUnknown(
          data['updated_at_ms']!,
          _updatedAtMsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMsMeta);
    }
    if (data.containsKey('deleted_at_ms')) {
      context.handle(
        _deletedAtMsMeta,
        deletedAtMs.isAcceptableOrUnknown(
          data['deleted_at_ms']!,
          _deletedAtMsMeta,
        ),
      );
    }
    if (data.containsKey('track_number')) {
      context.handle(
        _trackNumberMeta,
        trackNumber.isAcceptableOrUnknown(
          data['track_number']!,
          _trackNumberMeta,
        ),
      );
    }
    if (data.containsKey('disc_number')) {
      context.handle(
        _discNumberMeta,
        discNumber.isAcceptableOrUnknown(data['disc_number']!, _discNumberMeta),
      );
    }
    if (data.containsKey('bitrate')) {
      context.handle(
        _bitrateMeta,
        bitrate.isAcceptableOrUnknown(data['bitrate']!, _bitrateMeta),
      );
    }
    if (data.containsKey('sample_rate')) {
      context.handle(
        _sampleRateMeta,
        sampleRate.isAcceptableOrUnknown(data['sample_rate']!, _sampleRateMeta),
      );
    }
    if (data.containsKey('year')) {
      context.handle(
        _yearMeta,
        year.isAcceptableOrUnknown(data['year']!, _yearMeta),
      );
    }
    if (data.containsKey('genre')) {
      context.handle(
        _genreMeta,
        genre.isAcceptableOrUnknown(data['genre']!, _genreMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Track map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Track(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      contentHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content_hash'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      artistName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}artist_name'],
      )!,
      albumTitle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}album_title'],
      ),
      durationMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_ms'],
      ),
      localPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_path'],
      ),
      sizeBytes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}size_bytes'],
      )!,
      fileMtimeMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}file_mtime_ms'],
      ),
      artworkHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}artwork_hash'],
      ),
      artworkCheckedAtMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}artwork_checked_at_ms'],
      ),
      addedAtMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}added_at_ms'],
      )!,
      updatedAtMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at_ms'],
      )!,
      deletedAtMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}deleted_at_ms'],
      ),
      trackNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}track_number'],
      ),
      discNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}disc_number'],
      ),
      bitrate: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}bitrate'],
      ),
      sampleRate: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sample_rate'],
      ),
      year: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}year'],
      ),
      genre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}genre'],
      ),
    );
  }

  @override
  $TracksTable createAlias(String alias) {
    return $TracksTable(attachedDatabase, alias);
  }
}

class Track extends DataClass implements Insertable<Track> {
  final String id;
  final String contentHash;
  final String title;
  final String artistName;
  final String? albumTitle;
  final int? durationMs;
  final String? localPath;
  final int sizeBytes;
  final int? fileMtimeMs;
  final String? artworkHash;
  final int? artworkCheckedAtMs;
  final int addedAtMs;
  final int updatedAtMs;
  final int? deletedAtMs;
  final int? trackNumber;
  final int? discNumber;
  final int? bitrate;
  final int? sampleRate;
  final int? year;
  final String? genre;
  const Track({
    required this.id,
    required this.contentHash,
    required this.title,
    required this.artistName,
    this.albumTitle,
    this.durationMs,
    this.localPath,
    required this.sizeBytes,
    this.fileMtimeMs,
    this.artworkHash,
    this.artworkCheckedAtMs,
    required this.addedAtMs,
    required this.updatedAtMs,
    this.deletedAtMs,
    this.trackNumber,
    this.discNumber,
    this.bitrate,
    this.sampleRate,
    this.year,
    this.genre,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['content_hash'] = Variable<String>(contentHash);
    map['title'] = Variable<String>(title);
    map['artist_name'] = Variable<String>(artistName);
    if (!nullToAbsent || albumTitle != null) {
      map['album_title'] = Variable<String>(albumTitle);
    }
    if (!nullToAbsent || durationMs != null) {
      map['duration_ms'] = Variable<int>(durationMs);
    }
    if (!nullToAbsent || localPath != null) {
      map['local_path'] = Variable<String>(localPath);
    }
    map['size_bytes'] = Variable<int>(sizeBytes);
    if (!nullToAbsent || fileMtimeMs != null) {
      map['file_mtime_ms'] = Variable<int>(fileMtimeMs);
    }
    if (!nullToAbsent || artworkHash != null) {
      map['artwork_hash'] = Variable<String>(artworkHash);
    }
    if (!nullToAbsent || artworkCheckedAtMs != null) {
      map['artwork_checked_at_ms'] = Variable<int>(artworkCheckedAtMs);
    }
    map['added_at_ms'] = Variable<int>(addedAtMs);
    map['updated_at_ms'] = Variable<int>(updatedAtMs);
    if (!nullToAbsent || deletedAtMs != null) {
      map['deleted_at_ms'] = Variable<int>(deletedAtMs);
    }
    if (!nullToAbsent || trackNumber != null) {
      map['track_number'] = Variable<int>(trackNumber);
    }
    if (!nullToAbsent || discNumber != null) {
      map['disc_number'] = Variable<int>(discNumber);
    }
    if (!nullToAbsent || bitrate != null) {
      map['bitrate'] = Variable<int>(bitrate);
    }
    if (!nullToAbsent || sampleRate != null) {
      map['sample_rate'] = Variable<int>(sampleRate);
    }
    if (!nullToAbsent || year != null) {
      map['year'] = Variable<int>(year);
    }
    if (!nullToAbsent || genre != null) {
      map['genre'] = Variable<String>(genre);
    }
    return map;
  }

  TracksCompanion toCompanion(bool nullToAbsent) {
    return TracksCompanion(
      id: Value(id),
      contentHash: Value(contentHash),
      title: Value(title),
      artistName: Value(artistName),
      albumTitle: albumTitle == null && nullToAbsent
          ? const Value.absent()
          : Value(albumTitle),
      durationMs: durationMs == null && nullToAbsent
          ? const Value.absent()
          : Value(durationMs),
      localPath: localPath == null && nullToAbsent
          ? const Value.absent()
          : Value(localPath),
      sizeBytes: Value(sizeBytes),
      fileMtimeMs: fileMtimeMs == null && nullToAbsent
          ? const Value.absent()
          : Value(fileMtimeMs),
      artworkHash: artworkHash == null && nullToAbsent
          ? const Value.absent()
          : Value(artworkHash),
      artworkCheckedAtMs: artworkCheckedAtMs == null && nullToAbsent
          ? const Value.absent()
          : Value(artworkCheckedAtMs),
      addedAtMs: Value(addedAtMs),
      updatedAtMs: Value(updatedAtMs),
      deletedAtMs: deletedAtMs == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAtMs),
      trackNumber: trackNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(trackNumber),
      discNumber: discNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(discNumber),
      bitrate: bitrate == null && nullToAbsent
          ? const Value.absent()
          : Value(bitrate),
      sampleRate: sampleRate == null && nullToAbsent
          ? const Value.absent()
          : Value(sampleRate),
      year: year == null && nullToAbsent ? const Value.absent() : Value(year),
      genre: genre == null && nullToAbsent
          ? const Value.absent()
          : Value(genre),
    );
  }

  factory Track.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Track(
      id: serializer.fromJson<String>(json['id']),
      contentHash: serializer.fromJson<String>(json['contentHash']),
      title: serializer.fromJson<String>(json['title']),
      artistName: serializer.fromJson<String>(json['artistName']),
      albumTitle: serializer.fromJson<String?>(json['albumTitle']),
      durationMs: serializer.fromJson<int?>(json['durationMs']),
      localPath: serializer.fromJson<String?>(json['localPath']),
      sizeBytes: serializer.fromJson<int>(json['sizeBytes']),
      fileMtimeMs: serializer.fromJson<int?>(json['fileMtimeMs']),
      artworkHash: serializer.fromJson<String?>(json['artworkHash']),
      artworkCheckedAtMs: serializer.fromJson<int?>(json['artworkCheckedAtMs']),
      addedAtMs: serializer.fromJson<int>(json['addedAtMs']),
      updatedAtMs: serializer.fromJson<int>(json['updatedAtMs']),
      deletedAtMs: serializer.fromJson<int?>(json['deletedAtMs']),
      trackNumber: serializer.fromJson<int?>(json['trackNumber']),
      discNumber: serializer.fromJson<int?>(json['discNumber']),
      bitrate: serializer.fromJson<int?>(json['bitrate']),
      sampleRate: serializer.fromJson<int?>(json['sampleRate']),
      year: serializer.fromJson<int?>(json['year']),
      genre: serializer.fromJson<String?>(json['genre']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'contentHash': serializer.toJson<String>(contentHash),
      'title': serializer.toJson<String>(title),
      'artistName': serializer.toJson<String>(artistName),
      'albumTitle': serializer.toJson<String?>(albumTitle),
      'durationMs': serializer.toJson<int?>(durationMs),
      'localPath': serializer.toJson<String?>(localPath),
      'sizeBytes': serializer.toJson<int>(sizeBytes),
      'fileMtimeMs': serializer.toJson<int?>(fileMtimeMs),
      'artworkHash': serializer.toJson<String?>(artworkHash),
      'artworkCheckedAtMs': serializer.toJson<int?>(artworkCheckedAtMs),
      'addedAtMs': serializer.toJson<int>(addedAtMs),
      'updatedAtMs': serializer.toJson<int>(updatedAtMs),
      'deletedAtMs': serializer.toJson<int?>(deletedAtMs),
      'trackNumber': serializer.toJson<int?>(trackNumber),
      'discNumber': serializer.toJson<int?>(discNumber),
      'bitrate': serializer.toJson<int?>(bitrate),
      'sampleRate': serializer.toJson<int?>(sampleRate),
      'year': serializer.toJson<int?>(year),
      'genre': serializer.toJson<String?>(genre),
    };
  }

  Track copyWith({
    String? id,
    String? contentHash,
    String? title,
    String? artistName,
    Value<String?> albumTitle = const Value.absent(),
    Value<int?> durationMs = const Value.absent(),
    Value<String?> localPath = const Value.absent(),
    int? sizeBytes,
    Value<int?> fileMtimeMs = const Value.absent(),
    Value<String?> artworkHash = const Value.absent(),
    Value<int?> artworkCheckedAtMs = const Value.absent(),
    int? addedAtMs,
    int? updatedAtMs,
    Value<int?> deletedAtMs = const Value.absent(),
    Value<int?> trackNumber = const Value.absent(),
    Value<int?> discNumber = const Value.absent(),
    Value<int?> bitrate = const Value.absent(),
    Value<int?> sampleRate = const Value.absent(),
    Value<int?> year = const Value.absent(),
    Value<String?> genre = const Value.absent(),
  }) => Track(
    id: id ?? this.id,
    contentHash: contentHash ?? this.contentHash,
    title: title ?? this.title,
    artistName: artistName ?? this.artistName,
    albumTitle: albumTitle.present ? albumTitle.value : this.albumTitle,
    durationMs: durationMs.present ? durationMs.value : this.durationMs,
    localPath: localPath.present ? localPath.value : this.localPath,
    sizeBytes: sizeBytes ?? this.sizeBytes,
    fileMtimeMs: fileMtimeMs.present ? fileMtimeMs.value : this.fileMtimeMs,
    artworkHash: artworkHash.present ? artworkHash.value : this.artworkHash,
    artworkCheckedAtMs: artworkCheckedAtMs.present
        ? artworkCheckedAtMs.value
        : this.artworkCheckedAtMs,
    addedAtMs: addedAtMs ?? this.addedAtMs,
    updatedAtMs: updatedAtMs ?? this.updatedAtMs,
    deletedAtMs: deletedAtMs.present ? deletedAtMs.value : this.deletedAtMs,
    trackNumber: trackNumber.present ? trackNumber.value : this.trackNumber,
    discNumber: discNumber.present ? discNumber.value : this.discNumber,
    bitrate: bitrate.present ? bitrate.value : this.bitrate,
    sampleRate: sampleRate.present ? sampleRate.value : this.sampleRate,
    year: year.present ? year.value : this.year,
    genre: genre.present ? genre.value : this.genre,
  );
  Track copyWithCompanion(TracksCompanion data) {
    return Track(
      id: data.id.present ? data.id.value : this.id,
      contentHash: data.contentHash.present
          ? data.contentHash.value
          : this.contentHash,
      title: data.title.present ? data.title.value : this.title,
      artistName: data.artistName.present
          ? data.artistName.value
          : this.artistName,
      albumTitle: data.albumTitle.present
          ? data.albumTitle.value
          : this.albumTitle,
      durationMs: data.durationMs.present
          ? data.durationMs.value
          : this.durationMs,
      localPath: data.localPath.present ? data.localPath.value : this.localPath,
      sizeBytes: data.sizeBytes.present ? data.sizeBytes.value : this.sizeBytes,
      fileMtimeMs: data.fileMtimeMs.present
          ? data.fileMtimeMs.value
          : this.fileMtimeMs,
      artworkHash: data.artworkHash.present
          ? data.artworkHash.value
          : this.artworkHash,
      artworkCheckedAtMs: data.artworkCheckedAtMs.present
          ? data.artworkCheckedAtMs.value
          : this.artworkCheckedAtMs,
      addedAtMs: data.addedAtMs.present ? data.addedAtMs.value : this.addedAtMs,
      updatedAtMs: data.updatedAtMs.present
          ? data.updatedAtMs.value
          : this.updatedAtMs,
      deletedAtMs: data.deletedAtMs.present
          ? data.deletedAtMs.value
          : this.deletedAtMs,
      trackNumber: data.trackNumber.present
          ? data.trackNumber.value
          : this.trackNumber,
      discNumber: data.discNumber.present
          ? data.discNumber.value
          : this.discNumber,
      bitrate: data.bitrate.present ? data.bitrate.value : this.bitrate,
      sampleRate: data.sampleRate.present
          ? data.sampleRate.value
          : this.sampleRate,
      year: data.year.present ? data.year.value : this.year,
      genre: data.genre.present ? data.genre.value : this.genre,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Track(')
          ..write('id: $id, ')
          ..write('contentHash: $contentHash, ')
          ..write('title: $title, ')
          ..write('artistName: $artistName, ')
          ..write('albumTitle: $albumTitle, ')
          ..write('durationMs: $durationMs, ')
          ..write('localPath: $localPath, ')
          ..write('sizeBytes: $sizeBytes, ')
          ..write('fileMtimeMs: $fileMtimeMs, ')
          ..write('artworkHash: $artworkHash, ')
          ..write('artworkCheckedAtMs: $artworkCheckedAtMs, ')
          ..write('addedAtMs: $addedAtMs, ')
          ..write('updatedAtMs: $updatedAtMs, ')
          ..write('deletedAtMs: $deletedAtMs, ')
          ..write('trackNumber: $trackNumber, ')
          ..write('discNumber: $discNumber, ')
          ..write('bitrate: $bitrate, ')
          ..write('sampleRate: $sampleRate, ')
          ..write('year: $year, ')
          ..write('genre: $genre')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    contentHash,
    title,
    artistName,
    albumTitle,
    durationMs,
    localPath,
    sizeBytes,
    fileMtimeMs,
    artworkHash,
    artworkCheckedAtMs,
    addedAtMs,
    updatedAtMs,
    deletedAtMs,
    trackNumber,
    discNumber,
    bitrate,
    sampleRate,
    year,
    genre,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Track &&
          other.id == this.id &&
          other.contentHash == this.contentHash &&
          other.title == this.title &&
          other.artistName == this.artistName &&
          other.albumTitle == this.albumTitle &&
          other.durationMs == this.durationMs &&
          other.localPath == this.localPath &&
          other.sizeBytes == this.sizeBytes &&
          other.fileMtimeMs == this.fileMtimeMs &&
          other.artworkHash == this.artworkHash &&
          other.artworkCheckedAtMs == this.artworkCheckedAtMs &&
          other.addedAtMs == this.addedAtMs &&
          other.updatedAtMs == this.updatedAtMs &&
          other.deletedAtMs == this.deletedAtMs &&
          other.trackNumber == this.trackNumber &&
          other.discNumber == this.discNumber &&
          other.bitrate == this.bitrate &&
          other.sampleRate == this.sampleRate &&
          other.year == this.year &&
          other.genre == this.genre);
}

class TracksCompanion extends UpdateCompanion<Track> {
  final Value<String> id;
  final Value<String> contentHash;
  final Value<String> title;
  final Value<String> artistName;
  final Value<String?> albumTitle;
  final Value<int?> durationMs;
  final Value<String?> localPath;
  final Value<int> sizeBytes;
  final Value<int?> fileMtimeMs;
  final Value<String?> artworkHash;
  final Value<int?> artworkCheckedAtMs;
  final Value<int> addedAtMs;
  final Value<int> updatedAtMs;
  final Value<int?> deletedAtMs;
  final Value<int?> trackNumber;
  final Value<int?> discNumber;
  final Value<int?> bitrate;
  final Value<int?> sampleRate;
  final Value<int?> year;
  final Value<String?> genre;
  final Value<int> rowid;
  const TracksCompanion({
    this.id = const Value.absent(),
    this.contentHash = const Value.absent(),
    this.title = const Value.absent(),
    this.artistName = const Value.absent(),
    this.albumTitle = const Value.absent(),
    this.durationMs = const Value.absent(),
    this.localPath = const Value.absent(),
    this.sizeBytes = const Value.absent(),
    this.fileMtimeMs = const Value.absent(),
    this.artworkHash = const Value.absent(),
    this.artworkCheckedAtMs = const Value.absent(),
    this.addedAtMs = const Value.absent(),
    this.updatedAtMs = const Value.absent(),
    this.deletedAtMs = const Value.absent(),
    this.trackNumber = const Value.absent(),
    this.discNumber = const Value.absent(),
    this.bitrate = const Value.absent(),
    this.sampleRate = const Value.absent(),
    this.year = const Value.absent(),
    this.genre = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TracksCompanion.insert({
    required String id,
    required String contentHash,
    required String title,
    this.artistName = const Value.absent(),
    this.albumTitle = const Value.absent(),
    this.durationMs = const Value.absent(),
    this.localPath = const Value.absent(),
    this.sizeBytes = const Value.absent(),
    this.fileMtimeMs = const Value.absent(),
    this.artworkHash = const Value.absent(),
    this.artworkCheckedAtMs = const Value.absent(),
    required int addedAtMs,
    required int updatedAtMs,
    this.deletedAtMs = const Value.absent(),
    this.trackNumber = const Value.absent(),
    this.discNumber = const Value.absent(),
    this.bitrate = const Value.absent(),
    this.sampleRate = const Value.absent(),
    this.year = const Value.absent(),
    this.genre = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       contentHash = Value(contentHash),
       title = Value(title),
       addedAtMs = Value(addedAtMs),
       updatedAtMs = Value(updatedAtMs);
  static Insertable<Track> custom({
    Expression<String>? id,
    Expression<String>? contentHash,
    Expression<String>? title,
    Expression<String>? artistName,
    Expression<String>? albumTitle,
    Expression<int>? durationMs,
    Expression<String>? localPath,
    Expression<int>? sizeBytes,
    Expression<int>? fileMtimeMs,
    Expression<String>? artworkHash,
    Expression<int>? artworkCheckedAtMs,
    Expression<int>? addedAtMs,
    Expression<int>? updatedAtMs,
    Expression<int>? deletedAtMs,
    Expression<int>? trackNumber,
    Expression<int>? discNumber,
    Expression<int>? bitrate,
    Expression<int>? sampleRate,
    Expression<int>? year,
    Expression<String>? genre,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (contentHash != null) 'content_hash': contentHash,
      if (title != null) 'title': title,
      if (artistName != null) 'artist_name': artistName,
      if (albumTitle != null) 'album_title': albumTitle,
      if (durationMs != null) 'duration_ms': durationMs,
      if (localPath != null) 'local_path': localPath,
      if (sizeBytes != null) 'size_bytes': sizeBytes,
      if (fileMtimeMs != null) 'file_mtime_ms': fileMtimeMs,
      if (artworkHash != null) 'artwork_hash': artworkHash,
      if (artworkCheckedAtMs != null)
        'artwork_checked_at_ms': artworkCheckedAtMs,
      if (addedAtMs != null) 'added_at_ms': addedAtMs,
      if (updatedAtMs != null) 'updated_at_ms': updatedAtMs,
      if (deletedAtMs != null) 'deleted_at_ms': deletedAtMs,
      if (trackNumber != null) 'track_number': trackNumber,
      if (discNumber != null) 'disc_number': discNumber,
      if (bitrate != null) 'bitrate': bitrate,
      if (sampleRate != null) 'sample_rate': sampleRate,
      if (year != null) 'year': year,
      if (genre != null) 'genre': genre,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TracksCompanion copyWith({
    Value<String>? id,
    Value<String>? contentHash,
    Value<String>? title,
    Value<String>? artistName,
    Value<String?>? albumTitle,
    Value<int?>? durationMs,
    Value<String?>? localPath,
    Value<int>? sizeBytes,
    Value<int?>? fileMtimeMs,
    Value<String?>? artworkHash,
    Value<int?>? artworkCheckedAtMs,
    Value<int>? addedAtMs,
    Value<int>? updatedAtMs,
    Value<int?>? deletedAtMs,
    Value<int?>? trackNumber,
    Value<int?>? discNumber,
    Value<int?>? bitrate,
    Value<int?>? sampleRate,
    Value<int?>? year,
    Value<String?>? genre,
    Value<int>? rowid,
  }) {
    return TracksCompanion(
      id: id ?? this.id,
      contentHash: contentHash ?? this.contentHash,
      title: title ?? this.title,
      artistName: artistName ?? this.artistName,
      albumTitle: albumTitle ?? this.albumTitle,
      durationMs: durationMs ?? this.durationMs,
      localPath: localPath ?? this.localPath,
      sizeBytes: sizeBytes ?? this.sizeBytes,
      fileMtimeMs: fileMtimeMs ?? this.fileMtimeMs,
      artworkHash: artworkHash ?? this.artworkHash,
      artworkCheckedAtMs: artworkCheckedAtMs ?? this.artworkCheckedAtMs,
      addedAtMs: addedAtMs ?? this.addedAtMs,
      updatedAtMs: updatedAtMs ?? this.updatedAtMs,
      deletedAtMs: deletedAtMs ?? this.deletedAtMs,
      trackNumber: trackNumber ?? this.trackNumber,
      discNumber: discNumber ?? this.discNumber,
      bitrate: bitrate ?? this.bitrate,
      sampleRate: sampleRate ?? this.sampleRate,
      year: year ?? this.year,
      genre: genre ?? this.genre,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (contentHash.present) {
      map['content_hash'] = Variable<String>(contentHash.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (artistName.present) {
      map['artist_name'] = Variable<String>(artistName.value);
    }
    if (albumTitle.present) {
      map['album_title'] = Variable<String>(albumTitle.value);
    }
    if (durationMs.present) {
      map['duration_ms'] = Variable<int>(durationMs.value);
    }
    if (localPath.present) {
      map['local_path'] = Variable<String>(localPath.value);
    }
    if (sizeBytes.present) {
      map['size_bytes'] = Variable<int>(sizeBytes.value);
    }
    if (fileMtimeMs.present) {
      map['file_mtime_ms'] = Variable<int>(fileMtimeMs.value);
    }
    if (artworkHash.present) {
      map['artwork_hash'] = Variable<String>(artworkHash.value);
    }
    if (artworkCheckedAtMs.present) {
      map['artwork_checked_at_ms'] = Variable<int>(artworkCheckedAtMs.value);
    }
    if (addedAtMs.present) {
      map['added_at_ms'] = Variable<int>(addedAtMs.value);
    }
    if (updatedAtMs.present) {
      map['updated_at_ms'] = Variable<int>(updatedAtMs.value);
    }
    if (deletedAtMs.present) {
      map['deleted_at_ms'] = Variable<int>(deletedAtMs.value);
    }
    if (trackNumber.present) {
      map['track_number'] = Variable<int>(trackNumber.value);
    }
    if (discNumber.present) {
      map['disc_number'] = Variable<int>(discNumber.value);
    }
    if (bitrate.present) {
      map['bitrate'] = Variable<int>(bitrate.value);
    }
    if (sampleRate.present) {
      map['sample_rate'] = Variable<int>(sampleRate.value);
    }
    if (year.present) {
      map['year'] = Variable<int>(year.value);
    }
    if (genre.present) {
      map['genre'] = Variable<String>(genre.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TracksCompanion(')
          ..write('id: $id, ')
          ..write('contentHash: $contentHash, ')
          ..write('title: $title, ')
          ..write('artistName: $artistName, ')
          ..write('albumTitle: $albumTitle, ')
          ..write('durationMs: $durationMs, ')
          ..write('localPath: $localPath, ')
          ..write('sizeBytes: $sizeBytes, ')
          ..write('fileMtimeMs: $fileMtimeMs, ')
          ..write('artworkHash: $artworkHash, ')
          ..write('artworkCheckedAtMs: $artworkCheckedAtMs, ')
          ..write('addedAtMs: $addedAtMs, ')
          ..write('updatedAtMs: $updatedAtMs, ')
          ..write('deletedAtMs: $deletedAtMs, ')
          ..write('trackNumber: $trackNumber, ')
          ..write('discNumber: $discNumber, ')
          ..write('bitrate: $bitrate, ')
          ..write('sampleRate: $sampleRate, ')
          ..write('year: $year, ')
          ..write('genre: $genre, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LibraryRootsTable extends LibraryRoots
    with TableInfo<$LibraryRootsTable, LibraryRoot> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LibraryRootsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _pathMeta = const VerificationMeta('path');
  @override
  late final GeneratedColumn<String> path = GeneratedColumn<String>(
    'path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _addedAtMsMeta = const VerificationMeta(
    'addedAtMs',
  );
  @override
  late final GeneratedColumn<int> addedAtMs = GeneratedColumn<int>(
    'added_at_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastScannedAtMsMeta = const VerificationMeta(
    'lastScannedAtMs',
  );
  @override
  late final GeneratedColumn<int> lastScannedAtMs = GeneratedColumn<int>(
    'last_scanned_at_ms',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [path, addedAtMs, lastScannedAtMs];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'library_roots';
  @override
  VerificationContext validateIntegrity(
    Insertable<LibraryRoot> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('path')) {
      context.handle(
        _pathMeta,
        path.isAcceptableOrUnknown(data['path']!, _pathMeta),
      );
    } else if (isInserting) {
      context.missing(_pathMeta);
    }
    if (data.containsKey('added_at_ms')) {
      context.handle(
        _addedAtMsMeta,
        addedAtMs.isAcceptableOrUnknown(data['added_at_ms']!, _addedAtMsMeta),
      );
    } else if (isInserting) {
      context.missing(_addedAtMsMeta);
    }
    if (data.containsKey('last_scanned_at_ms')) {
      context.handle(
        _lastScannedAtMsMeta,
        lastScannedAtMs.isAcceptableOrUnknown(
          data['last_scanned_at_ms']!,
          _lastScannedAtMsMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {path};
  @override
  LibraryRoot map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LibraryRoot(
      path: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}path'],
      )!,
      addedAtMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}added_at_ms'],
      )!,
      lastScannedAtMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_scanned_at_ms'],
      ),
    );
  }

  @override
  $LibraryRootsTable createAlias(String alias) {
    return $LibraryRootsTable(attachedDatabase, alias);
  }
}

class LibraryRoot extends DataClass implements Insertable<LibraryRoot> {
  final String path;
  final int addedAtMs;
  final int? lastScannedAtMs;
  const LibraryRoot({
    required this.path,
    required this.addedAtMs,
    this.lastScannedAtMs,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['path'] = Variable<String>(path);
    map['added_at_ms'] = Variable<int>(addedAtMs);
    if (!nullToAbsent || lastScannedAtMs != null) {
      map['last_scanned_at_ms'] = Variable<int>(lastScannedAtMs);
    }
    return map;
  }

  LibraryRootsCompanion toCompanion(bool nullToAbsent) {
    return LibraryRootsCompanion(
      path: Value(path),
      addedAtMs: Value(addedAtMs),
      lastScannedAtMs: lastScannedAtMs == null && nullToAbsent
          ? const Value.absent()
          : Value(lastScannedAtMs),
    );
  }

  factory LibraryRoot.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LibraryRoot(
      path: serializer.fromJson<String>(json['path']),
      addedAtMs: serializer.fromJson<int>(json['addedAtMs']),
      lastScannedAtMs: serializer.fromJson<int?>(json['lastScannedAtMs']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'path': serializer.toJson<String>(path),
      'addedAtMs': serializer.toJson<int>(addedAtMs),
      'lastScannedAtMs': serializer.toJson<int?>(lastScannedAtMs),
    };
  }

  LibraryRoot copyWith({
    String? path,
    int? addedAtMs,
    Value<int?> lastScannedAtMs = const Value.absent(),
  }) => LibraryRoot(
    path: path ?? this.path,
    addedAtMs: addedAtMs ?? this.addedAtMs,
    lastScannedAtMs: lastScannedAtMs.present
        ? lastScannedAtMs.value
        : this.lastScannedAtMs,
  );
  LibraryRoot copyWithCompanion(LibraryRootsCompanion data) {
    return LibraryRoot(
      path: data.path.present ? data.path.value : this.path,
      addedAtMs: data.addedAtMs.present ? data.addedAtMs.value : this.addedAtMs,
      lastScannedAtMs: data.lastScannedAtMs.present
          ? data.lastScannedAtMs.value
          : this.lastScannedAtMs,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LibraryRoot(')
          ..write('path: $path, ')
          ..write('addedAtMs: $addedAtMs, ')
          ..write('lastScannedAtMs: $lastScannedAtMs')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(path, addedAtMs, lastScannedAtMs);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LibraryRoot &&
          other.path == this.path &&
          other.addedAtMs == this.addedAtMs &&
          other.lastScannedAtMs == this.lastScannedAtMs);
}

class LibraryRootsCompanion extends UpdateCompanion<LibraryRoot> {
  final Value<String> path;
  final Value<int> addedAtMs;
  final Value<int?> lastScannedAtMs;
  final Value<int> rowid;
  const LibraryRootsCompanion({
    this.path = const Value.absent(),
    this.addedAtMs = const Value.absent(),
    this.lastScannedAtMs = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LibraryRootsCompanion.insert({
    required String path,
    required int addedAtMs,
    this.lastScannedAtMs = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : path = Value(path),
       addedAtMs = Value(addedAtMs);
  static Insertable<LibraryRoot> custom({
    Expression<String>? path,
    Expression<int>? addedAtMs,
    Expression<int>? lastScannedAtMs,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (path != null) 'path': path,
      if (addedAtMs != null) 'added_at_ms': addedAtMs,
      if (lastScannedAtMs != null) 'last_scanned_at_ms': lastScannedAtMs,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LibraryRootsCompanion copyWith({
    Value<String>? path,
    Value<int>? addedAtMs,
    Value<int?>? lastScannedAtMs,
    Value<int>? rowid,
  }) {
    return LibraryRootsCompanion(
      path: path ?? this.path,
      addedAtMs: addedAtMs ?? this.addedAtMs,
      lastScannedAtMs: lastScannedAtMs ?? this.lastScannedAtMs,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (path.present) {
      map['path'] = Variable<String>(path.value);
    }
    if (addedAtMs.present) {
      map['added_at_ms'] = Variable<int>(addedAtMs.value);
    }
    if (lastScannedAtMs.present) {
      map['last_scanned_at_ms'] = Variable<int>(lastScannedAtMs.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LibraryRootsCompanion(')
          ..write('path: $path, ')
          ..write('addedAtMs: $addedAtMs, ')
          ..write('lastScannedAtMs: $lastScannedAtMs, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $TracksTable tracks = $TracksTable(this);
  late final $LibraryRootsTable libraryRoots = $LibraryRootsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [tracks, libraryRoots];
}

typedef $$TracksTableCreateCompanionBuilder = TracksCompanion Function({
  required String id,
  required String contentHash,
  required String title,
  Value<String> artistName,
  Value<String?> albumTitle,
  Value<int?> durationMs,
  Value<String?> localPath,
  Value<int> sizeBytes,
  Value<int?> fileMtimeMs,
  Value<String?> artworkHash,
  Value<int?> artworkCheckedAtMs,
  required int addedAtMs,
  required int updatedAtMs,
  Value<int?> deletedAtMs,
  Value<int?> trackNumber,
  Value<int?> discNumber,
  Value<int?> bitrate,
  Value<int?> sampleRate,
  Value<int?> year,
  Value<String?> genre,
  Value<int> rowid,
});
typedef $$TracksTableUpdateCompanionBuilder = TracksCompanion Function({
  Value<String> id,
  Value<String> contentHash,
  Value<String> title,
  Value<String> artistName,
  Value<String?> albumTitle,
  Value<int?> durationMs,
  Value<String?> localPath,
  Value<int> sizeBytes,
  Value<int?> fileMtimeMs,
  Value<String?> artworkHash,
  Value<int?> artworkCheckedAtMs,
  Value<int> addedAtMs,
  Value<int> updatedAtMs,
  Value<int?> deletedAtMs,
  Value<int?> trackNumber,
  Value<int?> discNumber,
  Value<int?> bitrate,
  Value<int?> sampleRate,
  Value<int?> year,
  Value<String?> genre,
  Value<int> rowid,
});

class $$TracksTableFilterComposer
    extends Composer<_$AppDatabase, $TracksTable> {
  $$TracksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contentHash => $composableBuilder(
    column: $table.contentHash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get artistName => $composableBuilder(
    column: $table.artistName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get albumTitle => $composableBuilder(
    column: $table.albumTitle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localPath => $composableBuilder(
    column: $table.localPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sizeBytes => $composableBuilder(
    column: $table.sizeBytes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get fileMtimeMs => $composableBuilder(
    column: $table.fileMtimeMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get artworkHash => $composableBuilder(
    column: $table.artworkHash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get artworkCheckedAtMs => $composableBuilder(
    column: $table.artworkCheckedAtMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get addedAtMs => $composableBuilder(
    column: $table.addedAtMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAtMs => $composableBuilder(
    column: $table.updatedAtMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get deletedAtMs => $composableBuilder(
    column: $table.deletedAtMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get trackNumber => $composableBuilder(
    column: $table.trackNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get discNumber => $composableBuilder(
    column: $table.discNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get bitrate => $composableBuilder(
    column: $table.bitrate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sampleRate => $composableBuilder(
    column: $table.sampleRate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get genre => $composableBuilder(
    column: $table.genre,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TracksTableOrderingComposer
    extends Composer<_$AppDatabase, $TracksTable> {
  $$TracksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contentHash => $composableBuilder(
    column: $table.contentHash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get artistName => $composableBuilder(
    column: $table.artistName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get albumTitle => $composableBuilder(
    column: $table.albumTitle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localPath => $composableBuilder(
    column: $table.localPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sizeBytes => $composableBuilder(
    column: $table.sizeBytes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get fileMtimeMs => $composableBuilder(
    column: $table.fileMtimeMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get artworkHash => $composableBuilder(
    column: $table.artworkHash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get artworkCheckedAtMs => $composableBuilder(
    column: $table.artworkCheckedAtMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get addedAtMs => $composableBuilder(
    column: $table.addedAtMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAtMs => $composableBuilder(
    column: $table.updatedAtMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get deletedAtMs => $composableBuilder(
    column: $table.deletedAtMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get trackNumber => $composableBuilder(
    column: $table.trackNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get discNumber => $composableBuilder(
    column: $table.discNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get bitrate => $composableBuilder(
    column: $table.bitrate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sampleRate => $composableBuilder(
    column: $table.sampleRate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get genre => $composableBuilder(
    column: $table.genre,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TracksTableAnnotationComposer
    extends Composer<_$AppDatabase, $TracksTable> {
  $$TracksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get contentHash => $composableBuilder(
    column: $table.contentHash,
    builder: (column) => column,
  );

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get artistName => $composableBuilder(
    column: $table.artistName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get albumTitle => $composableBuilder(
    column: $table.albumTitle,
    builder: (column) => column,
  );

  GeneratedColumn<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => column,
  );

  GeneratedColumn<String> get localPath =>
      $composableBuilder(column: $table.localPath, builder: (column) => column);

  GeneratedColumn<int> get sizeBytes =>
      $composableBuilder(column: $table.sizeBytes, builder: (column) => column);

  GeneratedColumn<int> get fileMtimeMs => $composableBuilder(
    column: $table.fileMtimeMs,
    builder: (column) => column,
  );

  GeneratedColumn<String> get artworkHash => $composableBuilder(
    column: $table.artworkHash,
    builder: (column) => column,
  );

  GeneratedColumn<int> get artworkCheckedAtMs => $composableBuilder(
    column: $table.artworkCheckedAtMs,
    builder: (column) => column,
  );

  GeneratedColumn<int> get addedAtMs =>
      $composableBuilder(column: $table.addedAtMs, builder: (column) => column);

  GeneratedColumn<int> get updatedAtMs => $composableBuilder(
    column: $table.updatedAtMs,
    builder: (column) => column,
  );

  GeneratedColumn<int> get deletedAtMs => $composableBuilder(
    column: $table.deletedAtMs,
    builder: (column) => column,
  );

  GeneratedColumn<int> get trackNumber => $composableBuilder(
    column: $table.trackNumber,
    builder: (column) => column,
  );

  GeneratedColumn<int> get discNumber => $composableBuilder(
    column: $table.discNumber,
    builder: (column) => column,
  );

  GeneratedColumn<int> get bitrate =>
      $composableBuilder(column: $table.bitrate, builder: (column) => column);

  GeneratedColumn<int> get sampleRate => $composableBuilder(
    column: $table.sampleRate,
    builder: (column) => column,
  );

  GeneratedColumn<int> get year =>
      $composableBuilder(column: $table.year, builder: (column) => column);

  GeneratedColumn<String> get genre =>
      $composableBuilder(column: $table.genre, builder: (column) => column);
}

class $$TracksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TracksTable,
          Track,
          $$TracksTableFilterComposer,
          $$TracksTableOrderingComposer,
          $$TracksTableAnnotationComposer,
          $$TracksTableCreateCompanionBuilder,
          $$TracksTableUpdateCompanionBuilder,
          (Track, BaseReferences<_$AppDatabase, $TracksTable, Track>),
          Track,
          PrefetchHooks Function()
        > {
  $$TracksTableTableManager(_$AppDatabase db, $TracksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TracksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TracksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TracksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> contentHash = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> artistName = const Value.absent(),
                Value<String?> albumTitle = const Value.absent(),
                Value<int?> durationMs = const Value.absent(),
                Value<String?> localPath = const Value.absent(),
                Value<int> sizeBytes = const Value.absent(),
                Value<int?> fileMtimeMs = const Value.absent(),
                Value<String?> artworkHash = const Value.absent(),
                Value<int?> artworkCheckedAtMs = const Value.absent(),
                Value<int> addedAtMs = const Value.absent(),
                Value<int> updatedAtMs = const Value.absent(),
                Value<int?> deletedAtMs = const Value.absent(),
                Value<int?> trackNumber = const Value.absent(),
                Value<int?> discNumber = const Value.absent(),
                Value<int?> bitrate = const Value.absent(),
                Value<int?> sampleRate = const Value.absent(),
                Value<int?> year = const Value.absent(),
                Value<String?> genre = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TracksCompanion(
                id: id,
                contentHash: contentHash,
                title: title,
                artistName: artistName,
                albumTitle: albumTitle,
                durationMs: durationMs,
                localPath: localPath,
                sizeBytes: sizeBytes,
                fileMtimeMs: fileMtimeMs,
                artworkHash: artworkHash,
                artworkCheckedAtMs: artworkCheckedAtMs,
                addedAtMs: addedAtMs,
                updatedAtMs: updatedAtMs,
                deletedAtMs: deletedAtMs,
                trackNumber: trackNumber,
                discNumber: discNumber,
                bitrate: bitrate,
                sampleRate: sampleRate,
                year: year,
                genre: genre,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String contentHash,
                required String title,
                Value<String> artistName = const Value.absent(),
                Value<String?> albumTitle = const Value.absent(),
                Value<int?> durationMs = const Value.absent(),
                Value<String?> localPath = const Value.absent(),
                Value<int> sizeBytes = const Value.absent(),
                Value<int?> fileMtimeMs = const Value.absent(),
                Value<String?> artworkHash = const Value.absent(),
                Value<int?> artworkCheckedAtMs = const Value.absent(),
                required int addedAtMs,
                required int updatedAtMs,
                Value<int?> deletedAtMs = const Value.absent(),
                Value<int?> trackNumber = const Value.absent(),
                Value<int?> discNumber = const Value.absent(),
                Value<int?> bitrate = const Value.absent(),
                Value<int?> sampleRate = const Value.absent(),
                Value<int?> year = const Value.absent(),
                Value<String?> genre = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TracksCompanion.insert(
                id: id,
                contentHash: contentHash,
                title: title,
                artistName: artistName,
                albumTitle: albumTitle,
                durationMs: durationMs,
                localPath: localPath,
                sizeBytes: sizeBytes,
                fileMtimeMs: fileMtimeMs,
                artworkHash: artworkHash,
                artworkCheckedAtMs: artworkCheckedAtMs,
                addedAtMs: addedAtMs,
                updatedAtMs: updatedAtMs,
                deletedAtMs: deletedAtMs,
                trackNumber: trackNumber,
                discNumber: discNumber,
                bitrate: bitrate,
                sampleRate: sampleRate,
                year: year,
                genre: genre,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TracksTable, Track>(table),
                  BaseReferences<_$AppDatabase, $TracksTable, Track>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TracksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TracksTable,
      Track,
      $$TracksTableFilterComposer,
      $$TracksTableOrderingComposer,
      $$TracksTableAnnotationComposer,
      $$TracksTableCreateCompanionBuilder,
      $$TracksTableUpdateCompanionBuilder,
      (Track, BaseReferences<_$AppDatabase, $TracksTable, Track>),
      Track,
      PrefetchHooks Function()
    >;
typedef $$LibraryRootsTableCreateCompanionBuilder =
    LibraryRootsCompanion Function({
      required String path,
      required int addedAtMs,
      Value<int?> lastScannedAtMs,
      Value<int> rowid,
    });
typedef $$LibraryRootsTableUpdateCompanionBuilder =
    LibraryRootsCompanion Function({
      Value<String> path,
      Value<int> addedAtMs,
      Value<int?> lastScannedAtMs,
      Value<int> rowid,
    });

class $$LibraryRootsTableFilterComposer
    extends Composer<_$AppDatabase, $LibraryRootsTable> {
  $$LibraryRootsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get path => $composableBuilder(
    column: $table.path,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get addedAtMs => $composableBuilder(
    column: $table.addedAtMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lastScannedAtMs => $composableBuilder(
    column: $table.lastScannedAtMs,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LibraryRootsTableOrderingComposer
    extends Composer<_$AppDatabase, $LibraryRootsTable> {
  $$LibraryRootsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get path => $composableBuilder(
    column: $table.path,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get addedAtMs => $composableBuilder(
    column: $table.addedAtMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastScannedAtMs => $composableBuilder(
    column: $table.lastScannedAtMs,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LibraryRootsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LibraryRootsTable> {
  $$LibraryRootsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get path =>
      $composableBuilder(column: $table.path, builder: (column) => column);

  GeneratedColumn<int> get addedAtMs =>
      $composableBuilder(column: $table.addedAtMs, builder: (column) => column);

  GeneratedColumn<int> get lastScannedAtMs => $composableBuilder(
    column: $table.lastScannedAtMs,
    builder: (column) => column,
  );
}

class $$LibraryRootsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LibraryRootsTable,
          LibraryRoot,
          $$LibraryRootsTableFilterComposer,
          $$LibraryRootsTableOrderingComposer,
          $$LibraryRootsTableAnnotationComposer,
          $$LibraryRootsTableCreateCompanionBuilder,
          $$LibraryRootsTableUpdateCompanionBuilder,
          (
            LibraryRoot,
            BaseReferences<_$AppDatabase, $LibraryRootsTable, LibraryRoot>,
          ),
          LibraryRoot,
          PrefetchHooks Function()
        > {
  $$LibraryRootsTableTableManager(_$AppDatabase db, $LibraryRootsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LibraryRootsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LibraryRootsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LibraryRootsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> path = const Value.absent(),
                Value<int> addedAtMs = const Value.absent(),
                Value<int?> lastScannedAtMs = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LibraryRootsCompanion(
                path: path,
                addedAtMs: addedAtMs,
                lastScannedAtMs: lastScannedAtMs,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String path,
                required int addedAtMs,
                Value<int?> lastScannedAtMs = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LibraryRootsCompanion.insert(
                path: path,
                addedAtMs: addedAtMs,
                lastScannedAtMs: lastScannedAtMs,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$LibraryRootsTable, LibraryRoot>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $LibraryRootsTable,
                    LibraryRoot
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LibraryRootsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LibraryRootsTable,
      LibraryRoot,
      $$LibraryRootsTableFilterComposer,
      $$LibraryRootsTableOrderingComposer,
      $$LibraryRootsTableAnnotationComposer,
      $$LibraryRootsTableCreateCompanionBuilder,
      $$LibraryRootsTableUpdateCompanionBuilder,
      (
        LibraryRoot,
        BaseReferences<_$AppDatabase, $LibraryRootsTable, LibraryRoot>,
      ),
      LibraryRoot,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$TracksTableTableManager get tracks =>
      $$TracksTableTableManager(_db, _db.tracks);
  $$LibraryRootsTableTableManager get libraryRoots =>
      $$LibraryRootsTableTableManager(_db, _db.libraryRoots);
}
