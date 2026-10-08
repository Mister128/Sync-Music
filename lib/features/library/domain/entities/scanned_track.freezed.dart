// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'scanned_track.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ScannedTrack {

 String get path; int get sizeBytes; int get mtimeMs; String get contentHash; String get title; String get artistName; String? get albumTitle; int? get trackNumber; int? get discNumber; int? get year; String? get genre; int? get durationMs; int? get bitrate; int? get sampleRate;
/// Create a copy of ScannedTrack
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScannedTrackCopyWith<ScannedTrack> get copyWith => _$ScannedTrackCopyWithImpl<ScannedTrack>(this as ScannedTrack, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ScannedTrack;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScannedTrack&&(identical(other.path, _this.path) || other.path == _this.path)&&(identical(other.sizeBytes, _this.sizeBytes) || other.sizeBytes == _this.sizeBytes)&&(identical(other.mtimeMs, _this.mtimeMs) || other.mtimeMs == _this.mtimeMs)&&(identical(other.contentHash, _this.contentHash) || other.contentHash == _this.contentHash)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.artistName, _this.artistName) || other.artistName == _this.artistName)&&(identical(other.albumTitle, _this.albumTitle) || other.albumTitle == _this.albumTitle)&&(identical(other.trackNumber, _this.trackNumber) || other.trackNumber == _this.trackNumber)&&(identical(other.discNumber, _this.discNumber) || other.discNumber == _this.discNumber)&&(identical(other.year, _this.year) || other.year == _this.year)&&(identical(other.genre, _this.genre) || other.genre == _this.genre)&&(identical(other.durationMs, _this.durationMs) || other.durationMs == _this.durationMs)&&(identical(other.bitrate, _this.bitrate) || other.bitrate == _this.bitrate)&&(identical(other.sampleRate, _this.sampleRate) || other.sampleRate == _this.sampleRate));
}


@override
int get hashCode {
  final _this = this as ScannedTrack;
  return Object.hash(runtimeType,_this.path,_this.sizeBytes,_this.mtimeMs,_this.contentHash,_this.title,_this.artistName,_this.albumTitle,_this.trackNumber,_this.discNumber,_this.year,_this.genre,_this.durationMs,_this.bitrate,_this.sampleRate);
}

@override
String toString() {
  final _this = this as ScannedTrack;
  return 'ScannedTrack(path: ${_this.path}, sizeBytes: ${_this.sizeBytes}, mtimeMs: ${_this.mtimeMs}, contentHash: ${_this.contentHash}, title: ${_this.title}, artistName: ${_this.artistName}, albumTitle: ${_this.albumTitle}, trackNumber: ${_this.trackNumber}, discNumber: ${_this.discNumber}, year: ${_this.year}, genre: ${_this.genre}, durationMs: ${_this.durationMs}, bitrate: ${_this.bitrate}, sampleRate: ${_this.sampleRate})';
}


}

/// @nodoc
abstract mixin class $ScannedTrackCopyWith<$Res>  {
  factory $ScannedTrackCopyWith(ScannedTrack value, $Res Function(ScannedTrack) _then) = _$ScannedTrackCopyWithImpl;
@useResult
$Res call({
 String path, int sizeBytes, int mtimeMs, String contentHash, String title, String artistName, String? albumTitle, int? trackNumber, int? discNumber, int? year, String? genre, int? durationMs, int? bitrate, int? sampleRate
});




}
/// @nodoc
class _$ScannedTrackCopyWithImpl<$Res>
    implements $ScannedTrackCopyWith<$Res> {
  _$ScannedTrackCopyWithImpl(this._self, this._then);

  final ScannedTrack _self;
  final $Res Function(ScannedTrack) _then;

/// Create a copy of ScannedTrack
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? path = null,Object? sizeBytes = null,Object? mtimeMs = null,Object? contentHash = null,Object? title = null,Object? artistName = null,Object? albumTitle = freezed,Object? trackNumber = freezed,Object? discNumber = freezed,Object? year = freezed,Object? genre = freezed,Object? durationMs = freezed,Object? bitrate = freezed,Object? sampleRate = freezed,}) {
  return _then(ScannedTrack(
path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,sizeBytes: null == sizeBytes ? _self.sizeBytes : sizeBytes // ignore: cast_nullable_to_non_nullable
as int,mtimeMs: null == mtimeMs ? _self.mtimeMs : mtimeMs // ignore: cast_nullable_to_non_nullable
as int,contentHash: null == contentHash ? _self.contentHash : contentHash // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,artistName: null == artistName ? _self.artistName : artistName // ignore: cast_nullable_to_non_nullable
as String,albumTitle: freezed == albumTitle ? _self.albumTitle : albumTitle // ignore: cast_nullable_to_non_nullable
as String?,trackNumber: freezed == trackNumber ? _self.trackNumber : trackNumber // ignore: cast_nullable_to_non_nullable
as int?,discNumber: freezed == discNumber ? _self.discNumber : discNumber // ignore: cast_nullable_to_non_nullable
as int?,year: freezed == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int?,genre: freezed == genre ? _self.genre : genre // ignore: cast_nullable_to_non_nullable
as String?,durationMs: freezed == durationMs ? _self.durationMs : durationMs // ignore: cast_nullable_to_non_nullable
as int?,bitrate: freezed == bitrate ? _self.bitrate : bitrate // ignore: cast_nullable_to_non_nullable
as int?,sampleRate: freezed == sampleRate ? _self.sampleRate : sampleRate // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [ScannedTrack].
extension ScannedTrackPatterns on ScannedTrack {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ScannedTrack value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ScannedTrack() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ScannedTrack value)  $default,){
final _that = this;
switch (_that) {
case _ScannedTrack():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ScannedTrack value)?  $default,){
final _that = this;
switch (_that) {
case _ScannedTrack() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String path,  int sizeBytes,  int mtimeMs,  String contentHash,  String title,  String artistName,  String? albumTitle,  int? trackNumber,  int? discNumber,  int? year,  String? genre,  int? durationMs,  int? bitrate,  int? sampleRate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ScannedTrack() when $default != null:
return $default(_that.path,_that.sizeBytes,_that.mtimeMs,_that.contentHash,_that.title,_that.artistName,_that.albumTitle,_that.trackNumber,_that.discNumber,_that.year,_that.genre,_that.durationMs,_that.bitrate,_that.sampleRate);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String path,  int sizeBytes,  int mtimeMs,  String contentHash,  String title,  String artistName,  String? albumTitle,  int? trackNumber,  int? discNumber,  int? year,  String? genre,  int? durationMs,  int? bitrate,  int? sampleRate)  $default,) {final _that = this;
switch (_that) {
case _ScannedTrack():
return $default(_that.path,_that.sizeBytes,_that.mtimeMs,_that.contentHash,_that.title,_that.artistName,_that.albumTitle,_that.trackNumber,_that.discNumber,_that.year,_that.genre,_that.durationMs,_that.bitrate,_that.sampleRate);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String path,  int sizeBytes,  int mtimeMs,  String contentHash,  String title,  String artistName,  String? albumTitle,  int? trackNumber,  int? discNumber,  int? year,  String? genre,  int? durationMs,  int? bitrate,  int? sampleRate)?  $default,) {final _that = this;
switch (_that) {
case _ScannedTrack() when $default != null:
return $default(_that.path,_that.sizeBytes,_that.mtimeMs,_that.contentHash,_that.title,_that.artistName,_that.albumTitle,_that.trackNumber,_that.discNumber,_that.year,_that.genre,_that.durationMs,_that.bitrate,_that.sampleRate);case _:
  return null;

}
}

}

/// @nodoc


class _ScannedTrack implements ScannedTrack {
  const _ScannedTrack({required this.path, required this.sizeBytes, required this.mtimeMs, required this.contentHash, required this.title, required this.artistName, this.albumTitle, this.trackNumber, this.discNumber, this.year, this.genre, this.durationMs, this.bitrate, this.sampleRate});
  

@override final  String path;
@override final  int sizeBytes;
@override final  int mtimeMs;
@override final  String contentHash;
@override final  String title;
@override final  String artistName;
@override final  String? albumTitle;
@override final  int? trackNumber;
@override final  int? discNumber;
@override final  int? year;
@override final  String? genre;
@override final  int? durationMs;
@override final  int? bitrate;
@override final  int? sampleRate;

/// Create a copy of ScannedTrack
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ScannedTrackCopyWith<_ScannedTrack> get copyWith => __$ScannedTrackCopyWithImpl<_ScannedTrack>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ScannedTrack&&(identical(other.path, path) || other.path == path)&&(identical(other.sizeBytes, sizeBytes) || other.sizeBytes == sizeBytes)&&(identical(other.mtimeMs, mtimeMs) || other.mtimeMs == mtimeMs)&&(identical(other.contentHash, contentHash) || other.contentHash == contentHash)&&(identical(other.title, title) || other.title == title)&&(identical(other.artistName, artistName) || other.artistName == artistName)&&(identical(other.albumTitle, albumTitle) || other.albumTitle == albumTitle)&&(identical(other.trackNumber, trackNumber) || other.trackNumber == trackNumber)&&(identical(other.discNumber, discNumber) || other.discNumber == discNumber)&&(identical(other.year, year) || other.year == year)&&(identical(other.genre, genre) || other.genre == genre)&&(identical(other.durationMs, durationMs) || other.durationMs == durationMs)&&(identical(other.bitrate, bitrate) || other.bitrate == bitrate)&&(identical(other.sampleRate, sampleRate) || other.sampleRate == sampleRate));
}


@override
int get hashCode {
    return Object.hash(runtimeType,path,sizeBytes,mtimeMs,contentHash,title,artistName,albumTitle,trackNumber,discNumber,year,genre,durationMs,bitrate,sampleRate);
}

@override
String toString() {
    return 'ScannedTrack(path: $path, sizeBytes: $sizeBytes, mtimeMs: $mtimeMs, contentHash: $contentHash, title: $title, artistName: $artistName, albumTitle: $albumTitle, trackNumber: $trackNumber, discNumber: $discNumber, year: $year, genre: $genre, durationMs: $durationMs, bitrate: $bitrate, sampleRate: $sampleRate)';
}


}

/// @nodoc
abstract mixin class _$ScannedTrackCopyWith<$Res> implements $ScannedTrackCopyWith<$Res> {
  factory _$ScannedTrackCopyWith(_ScannedTrack value, $Res Function(_ScannedTrack) _then) = __$ScannedTrackCopyWithImpl;
@override @useResult
$Res call({
 String path, int sizeBytes, int mtimeMs, String contentHash, String title, String artistName, String? albumTitle, int? trackNumber, int? discNumber, int? year, String? genre, int? durationMs, int? bitrate, int? sampleRate
});




}
/// @nodoc
class __$ScannedTrackCopyWithImpl<$Res>
    implements _$ScannedTrackCopyWith<$Res> {
  __$ScannedTrackCopyWithImpl(this._self, this._then);

  final _ScannedTrack _self;
  final $Res Function(_ScannedTrack) _then;

/// Create a copy of ScannedTrack
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? path = null,Object? sizeBytes = null,Object? mtimeMs = null,Object? contentHash = null,Object? title = null,Object? artistName = null,Object? albumTitle = freezed,Object? trackNumber = freezed,Object? discNumber = freezed,Object? year = freezed,Object? genre = freezed,Object? durationMs = freezed,Object? bitrate = freezed,Object? sampleRate = freezed,}) {
  return _then(_ScannedTrack(
path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,sizeBytes: null == sizeBytes ? _self.sizeBytes : sizeBytes // ignore: cast_nullable_to_non_nullable
as int,mtimeMs: null == mtimeMs ? _self.mtimeMs : mtimeMs // ignore: cast_nullable_to_non_nullable
as int,contentHash: null == contentHash ? _self.contentHash : contentHash // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,artistName: null == artistName ? _self.artistName : artistName // ignore: cast_nullable_to_non_nullable
as String,albumTitle: freezed == albumTitle ? _self.albumTitle : albumTitle // ignore: cast_nullable_to_non_nullable
as String?,trackNumber: freezed == trackNumber ? _self.trackNumber : trackNumber // ignore: cast_nullable_to_non_nullable
as int?,discNumber: freezed == discNumber ? _self.discNumber : discNumber // ignore: cast_nullable_to_non_nullable
as int?,year: freezed == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int?,genre: freezed == genre ? _self.genre : genre // ignore: cast_nullable_to_non_nullable
as String?,durationMs: freezed == durationMs ? _self.durationMs : durationMs // ignore: cast_nullable_to_non_nullable
as int?,bitrate: freezed == bitrate ? _self.bitrate : bitrate // ignore: cast_nullable_to_non_nullable
as int?,sampleRate: freezed == sampleRate ? _self.sampleRate : sampleRate // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
