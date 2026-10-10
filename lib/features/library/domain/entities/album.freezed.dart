// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'album.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Album {

 String get albumTitle; String get artistName; int get trackCount;/// Cover of ANY track of the album - MIN() ignores NULLs, so one file
/// with embedded art is enough for the whole card.
 String? get artworkHash;
/// Create a copy of Album
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AlbumCopyWith<Album> get copyWith => _$AlbumCopyWithImpl<Album>(this as Album, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Album;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Album&&(identical(other.albumTitle, _this.albumTitle) || other.albumTitle == _this.albumTitle)&&(identical(other.artistName, _this.artistName) || other.artistName == _this.artistName)&&(identical(other.trackCount, _this.trackCount) || other.trackCount == _this.trackCount)&&(identical(other.artworkHash, _this.artworkHash) || other.artworkHash == _this.artworkHash));
}


@override
int get hashCode {
  final _this = this as Album;
  return Object.hash(runtimeType,_this.albumTitle,_this.artistName,_this.trackCount,_this.artworkHash);
}

@override
String toString() {
  final _this = this as Album;
  return 'Album(albumTitle: ${_this.albumTitle}, artistName: ${_this.artistName}, trackCount: ${_this.trackCount}, artworkHash: ${_this.artworkHash})';
}


}

/// @nodoc
abstract mixin class $AlbumCopyWith<$Res>  {
  factory $AlbumCopyWith(Album value, $Res Function(Album) _then) = _$AlbumCopyWithImpl;
@useResult
$Res call({
 String albumTitle, String artistName, int trackCount, String? artworkHash
});




}
/// @nodoc
class _$AlbumCopyWithImpl<$Res>
    implements $AlbumCopyWith<$Res> {
  _$AlbumCopyWithImpl(this._self, this._then);

  final Album _self;
  final $Res Function(Album) _then;

/// Create a copy of Album
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? albumTitle = null,Object? artistName = null,Object? trackCount = null,Object? artworkHash = freezed,}) {
  return _then(Album(
albumTitle: null == albumTitle ? _self.albumTitle : albumTitle // ignore: cast_nullable_to_non_nullable
as String,artistName: null == artistName ? _self.artistName : artistName // ignore: cast_nullable_to_non_nullable
as String,trackCount: null == trackCount ? _self.trackCount : trackCount // ignore: cast_nullable_to_non_nullable
as int,artworkHash: freezed == artworkHash ? _self.artworkHash : artworkHash // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Album].
extension AlbumPatterns on Album {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Album value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Album() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Album value)  $default,){
final _that = this;
switch (_that) {
case _Album():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Album value)?  $default,){
final _that = this;
switch (_that) {
case _Album() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String albumTitle,  String artistName,  int trackCount,  String? artworkHash)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Album() when $default != null:
return $default(_that.albumTitle,_that.artistName,_that.trackCount,_that.artworkHash);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String albumTitle,  String artistName,  int trackCount,  String? artworkHash)  $default,) {final _that = this;
switch (_that) {
case _Album():
return $default(_that.albumTitle,_that.artistName,_that.trackCount,_that.artworkHash);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String albumTitle,  String artistName,  int trackCount,  String? artworkHash)?  $default,) {final _that = this;
switch (_that) {
case _Album() when $default != null:
return $default(_that.albumTitle,_that.artistName,_that.trackCount,_that.artworkHash);case _:
  return null;

}
}

}

/// @nodoc


class _Album implements Album {
  const _Album({required this.albumTitle, required this.artistName, required this.trackCount, this.artworkHash});
  

@override final  String albumTitle;
@override final  String artistName;
@override final  int trackCount;
/// Cover of ANY track of the album - MIN() ignores NULLs, so one file
/// with embedded art is enough for the whole card.
@override final  String? artworkHash;

/// Create a copy of Album
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AlbumCopyWith<_Album> get copyWith => __$AlbumCopyWithImpl<_Album>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Album&&(identical(other.albumTitle, albumTitle) || other.albumTitle == albumTitle)&&(identical(other.artistName, artistName) || other.artistName == artistName)&&(identical(other.trackCount, trackCount) || other.trackCount == trackCount)&&(identical(other.artworkHash, artworkHash) || other.artworkHash == artworkHash));
}


@override
int get hashCode {
    return Object.hash(runtimeType,albumTitle,artistName,trackCount,artworkHash);
}

@override
String toString() {
    return 'Album(albumTitle: $albumTitle, artistName: $artistName, trackCount: $trackCount, artworkHash: $artworkHash)';
}


}

/// @nodoc
abstract mixin class _$AlbumCopyWith<$Res> implements $AlbumCopyWith<$Res> {
  factory _$AlbumCopyWith(_Album value, $Res Function(_Album) _then) = __$AlbumCopyWithImpl;
@override @useResult
$Res call({
 String albumTitle, String artistName, int trackCount, String? artworkHash
});




}
/// @nodoc
class __$AlbumCopyWithImpl<$Res>
    implements _$AlbumCopyWith<$Res> {
  __$AlbumCopyWithImpl(this._self, this._then);

  final _Album _self;
  final $Res Function(_Album) _then;

/// Create a copy of Album
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? albumTitle = null,Object? artistName = null,Object? trackCount = null,Object? artworkHash = freezed,}) {
  return _then(_Album(
albumTitle: null == albumTitle ? _self.albumTitle : albumTitle // ignore: cast_nullable_to_non_nullable
as String,artistName: null == artistName ? _self.artistName : artistName // ignore: cast_nullable_to_non_nullable
as String,trackCount: null == trackCount ? _self.trackCount : trackCount // ignore: cast_nullable_to_non_nullable
as int,artworkHash: freezed == artworkHash ? _self.artworkHash : artworkHash // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
