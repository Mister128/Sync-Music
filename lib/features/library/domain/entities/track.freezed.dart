// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'track.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Track {

 String get id; String get contentHash; String get title; String get artistName; String? get albumTitle; int? get trackNumber; int? get discNumber; int? get durationMs; String? get genre; int? get year; String? get artworkHash; String? get localPath;
/// Create a copy of Track
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TrackCopyWith<Track> get copyWith => _$TrackCopyWithImpl<Track>(this as Track, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Track;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Track&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.contentHash, _this.contentHash) || other.contentHash == _this.contentHash)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.artistName, _this.artistName) || other.artistName == _this.artistName)&&(identical(other.albumTitle, _this.albumTitle) || other.albumTitle == _this.albumTitle)&&(identical(other.trackNumber, _this.trackNumber) || other.trackNumber == _this.trackNumber)&&(identical(other.discNumber, _this.discNumber) || other.discNumber == _this.discNumber)&&(identical(other.durationMs, _this.durationMs) || other.durationMs == _this.durationMs)&&(identical(other.genre, _this.genre) || other.genre == _this.genre)&&(identical(other.year, _this.year) || other.year == _this.year)&&(identical(other.artworkHash, _this.artworkHash) || other.artworkHash == _this.artworkHash)&&(identical(other.localPath, _this.localPath) || other.localPath == _this.localPath));
}


@override
int get hashCode {
  final _this = this as Track;
  return Object.hash(runtimeType,_this.id,_this.contentHash,_this.title,_this.artistName,_this.albumTitle,_this.trackNumber,_this.discNumber,_this.durationMs,_this.genre,_this.year,_this.artworkHash,_this.localPath);
}

@override
String toString() {
  final _this = this as Track;
  return 'Track(id: ${_this.id}, contentHash: ${_this.contentHash}, title: ${_this.title}, artistName: ${_this.artistName}, albumTitle: ${_this.albumTitle}, trackNumber: ${_this.trackNumber}, discNumber: ${_this.discNumber}, durationMs: ${_this.durationMs}, genre: ${_this.genre}, year: ${_this.year}, artworkHash: ${_this.artworkHash}, localPath: ${_this.localPath})';
}


}

/// @nodoc
abstract mixin class $TrackCopyWith<$Res>  {
  factory $TrackCopyWith(Track value, $Res Function(Track) _then) = _$TrackCopyWithImpl;
@useResult
$Res call({
 String id, String contentHash, String title, String artistName, String? albumTitle, int? trackNumber, int? discNumber, int? durationMs, String? genre, int? year, String? artworkHash, String? localPath
});




}
/// @nodoc
class _$TrackCopyWithImpl<$Res>
    implements $TrackCopyWith<$Res> {
  _$TrackCopyWithImpl(this._self, this._then);

  final Track _self;
  final $Res Function(Track) _then;

/// Create a copy of Track
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? contentHash = null,Object? title = null,Object? artistName = null,Object? albumTitle = freezed,Object? trackNumber = freezed,Object? discNumber = freezed,Object? durationMs = freezed,Object? genre = freezed,Object? year = freezed,Object? artworkHash = freezed,Object? localPath = freezed,}) {
  return _then(Track(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,contentHash: null == contentHash ? _self.contentHash : contentHash // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,artistName: null == artistName ? _self.artistName : artistName // ignore: cast_nullable_to_non_nullable
as String,albumTitle: freezed == albumTitle ? _self.albumTitle : albumTitle // ignore: cast_nullable_to_non_nullable
as String?,trackNumber: freezed == trackNumber ? _self.trackNumber : trackNumber // ignore: cast_nullable_to_non_nullable
as int?,discNumber: freezed == discNumber ? _self.discNumber : discNumber // ignore: cast_nullable_to_non_nullable
as int?,durationMs: freezed == durationMs ? _self.durationMs : durationMs // ignore: cast_nullable_to_non_nullable
as int?,genre: freezed == genre ? _self.genre : genre // ignore: cast_nullable_to_non_nullable
as String?,year: freezed == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int?,artworkHash: freezed == artworkHash ? _self.artworkHash : artworkHash // ignore: cast_nullable_to_non_nullable
as String?,localPath: freezed == localPath ? _self.localPath : localPath // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Track].
extension TrackPatterns on Track {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Track value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Track() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Track value)  $default,){
final _that = this;
switch (_that) {
case _Track():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Track value)?  $default,){
final _that = this;
switch (_that) {
case _Track() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String contentHash,  String title,  String artistName,  String? albumTitle,  int? trackNumber,  int? discNumber,  int? durationMs,  String? genre,  int? year,  String? artworkHash,  String? localPath)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Track() when $default != null:
return $default(_that.id,_that.contentHash,_that.title,_that.artistName,_that.albumTitle,_that.trackNumber,_that.discNumber,_that.durationMs,_that.genre,_that.year,_that.artworkHash,_that.localPath);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String contentHash,  String title,  String artistName,  String? albumTitle,  int? trackNumber,  int? discNumber,  int? durationMs,  String? genre,  int? year,  String? artworkHash,  String? localPath)  $default,) {final _that = this;
switch (_that) {
case _Track():
return $default(_that.id,_that.contentHash,_that.title,_that.artistName,_that.albumTitle,_that.trackNumber,_that.discNumber,_that.durationMs,_that.genre,_that.year,_that.artworkHash,_that.localPath);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String contentHash,  String title,  String artistName,  String? albumTitle,  int? trackNumber,  int? discNumber,  int? durationMs,  String? genre,  int? year,  String? artworkHash,  String? localPath)?  $default,) {final _that = this;
switch (_that) {
case _Track() when $default != null:
return $default(_that.id,_that.contentHash,_that.title,_that.artistName,_that.albumTitle,_that.trackNumber,_that.discNumber,_that.durationMs,_that.genre,_that.year,_that.artworkHash,_that.localPath);case _:
  return null;

}
}

}

/// @nodoc


class _Track implements Track {
  const _Track({required this.id, required this.contentHash, required this.title, required this.artistName, this.albumTitle, this.trackNumber, this.discNumber, this.durationMs, this.genre, this.year, this.artworkHash, this.localPath});
  

@override final  String id;
@override final  String contentHash;
@override final  String title;
@override final  String artistName;
@override final  String? albumTitle;
@override final  int? trackNumber;
@override final  int? discNumber;
@override final  int? durationMs;
@override final  String? genre;
@override final  int? year;
@override final  String? artworkHash;
@override final  String? localPath;

/// Create a copy of Track
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TrackCopyWith<_Track> get copyWith => __$TrackCopyWithImpl<_Track>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Track&&(identical(other.id, id) || other.id == id)&&(identical(other.contentHash, contentHash) || other.contentHash == contentHash)&&(identical(other.title, title) || other.title == title)&&(identical(other.artistName, artistName) || other.artistName == artistName)&&(identical(other.albumTitle, albumTitle) || other.albumTitle == albumTitle)&&(identical(other.trackNumber, trackNumber) || other.trackNumber == trackNumber)&&(identical(other.discNumber, discNumber) || other.discNumber == discNumber)&&(identical(other.durationMs, durationMs) || other.durationMs == durationMs)&&(identical(other.genre, genre) || other.genre == genre)&&(identical(other.year, year) || other.year == year)&&(identical(other.artworkHash, artworkHash) || other.artworkHash == artworkHash)&&(identical(other.localPath, localPath) || other.localPath == localPath));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,contentHash,title,artistName,albumTitle,trackNumber,discNumber,durationMs,genre,year,artworkHash,localPath);
}

@override
String toString() {
    return 'Track(id: $id, contentHash: $contentHash, title: $title, artistName: $artistName, albumTitle: $albumTitle, trackNumber: $trackNumber, discNumber: $discNumber, durationMs: $durationMs, genre: $genre, year: $year, artworkHash: $artworkHash, localPath: $localPath)';
}


}

/// @nodoc
abstract mixin class _$TrackCopyWith<$Res> implements $TrackCopyWith<$Res> {
  factory _$TrackCopyWith(_Track value, $Res Function(_Track) _then) = __$TrackCopyWithImpl;
@override @useResult
$Res call({
 String id, String contentHash, String title, String artistName, String? albumTitle, int? trackNumber, int? discNumber, int? durationMs, String? genre, int? year, String? artworkHash, String? localPath
});




}
/// @nodoc
class __$TrackCopyWithImpl<$Res>
    implements _$TrackCopyWith<$Res> {
  __$TrackCopyWithImpl(this._self, this._then);

  final _Track _self;
  final $Res Function(_Track) _then;

/// Create a copy of Track
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? contentHash = null,Object? title = null,Object? artistName = null,Object? albumTitle = freezed,Object? trackNumber = freezed,Object? discNumber = freezed,Object? durationMs = freezed,Object? genre = freezed,Object? year = freezed,Object? artworkHash = freezed,Object? localPath = freezed,}) {
  return _then(_Track(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,contentHash: null == contentHash ? _self.contentHash : contentHash // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,artistName: null == artistName ? _self.artistName : artistName // ignore: cast_nullable_to_non_nullable
as String,albumTitle: freezed == albumTitle ? _self.albumTitle : albumTitle // ignore: cast_nullable_to_non_nullable
as String?,trackNumber: freezed == trackNumber ? _self.trackNumber : trackNumber // ignore: cast_nullable_to_non_nullable
as int?,discNumber: freezed == discNumber ? _self.discNumber : discNumber // ignore: cast_nullable_to_non_nullable
as int?,durationMs: freezed == durationMs ? _self.durationMs : durationMs // ignore: cast_nullable_to_non_nullable
as int?,genre: freezed == genre ? _self.genre : genre // ignore: cast_nullable_to_non_nullable
as String?,year: freezed == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int?,artworkHash: freezed == artworkHash ? _self.artworkHash : artworkHash // ignore: cast_nullable_to_non_nullable
as String?,localPath: freezed == localPath ? _self.localPath : localPath // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
