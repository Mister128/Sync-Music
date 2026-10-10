// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'artist.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Artist {

 String get artistName; int get trackCount; int get albumCount;/// Cover of ANY track by this artist - MIN() ignores NULLs, so one file
/// with embedded art is enough for the round avatar.
 String? get artworkHash;
/// Create a copy of Artist
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ArtistCopyWith<Artist> get copyWith => _$ArtistCopyWithImpl<Artist>(this as Artist, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Artist;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Artist&&(identical(other.artistName, _this.artistName) || other.artistName == _this.artistName)&&(identical(other.trackCount, _this.trackCount) || other.trackCount == _this.trackCount)&&(identical(other.albumCount, _this.albumCount) || other.albumCount == _this.albumCount)&&(identical(other.artworkHash, _this.artworkHash) || other.artworkHash == _this.artworkHash));
}


@override
int get hashCode {
  final _this = this as Artist;
  return Object.hash(runtimeType,_this.artistName,_this.trackCount,_this.albumCount,_this.artworkHash);
}

@override
String toString() {
  final _this = this as Artist;
  return 'Artist(artistName: ${_this.artistName}, trackCount: ${_this.trackCount}, albumCount: ${_this.albumCount}, artworkHash: ${_this.artworkHash})';
}


}

/// @nodoc
abstract mixin class $ArtistCopyWith<$Res>  {
  factory $ArtistCopyWith(Artist value, $Res Function(Artist) _then) = _$ArtistCopyWithImpl;
@useResult
$Res call({
 String artistName, int trackCount, int albumCount, String? artworkHash
});




}
/// @nodoc
class _$ArtistCopyWithImpl<$Res>
    implements $ArtistCopyWith<$Res> {
  _$ArtistCopyWithImpl(this._self, this._then);

  final Artist _self;
  final $Res Function(Artist) _then;

/// Create a copy of Artist
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? artistName = null,Object? trackCount = null,Object? albumCount = null,Object? artworkHash = freezed,}) {
  return _then(Artist(
artistName: null == artistName ? _self.artistName : artistName // ignore: cast_nullable_to_non_nullable
as String,trackCount: null == trackCount ? _self.trackCount : trackCount // ignore: cast_nullable_to_non_nullable
as int,albumCount: null == albumCount ? _self.albumCount : albumCount // ignore: cast_nullable_to_non_nullable
as int,artworkHash: freezed == artworkHash ? _self.artworkHash : artworkHash // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Artist].
extension ArtistPatterns on Artist {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Artist value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Artist() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Artist value)  $default,){
final _that = this;
switch (_that) {
case _Artist():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Artist value)?  $default,){
final _that = this;
switch (_that) {
case _Artist() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String artistName,  int trackCount,  int albumCount,  String? artworkHash)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Artist() when $default != null:
return $default(_that.artistName,_that.trackCount,_that.albumCount,_that.artworkHash);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String artistName,  int trackCount,  int albumCount,  String? artworkHash)  $default,) {final _that = this;
switch (_that) {
case _Artist():
return $default(_that.artistName,_that.trackCount,_that.albumCount,_that.artworkHash);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String artistName,  int trackCount,  int albumCount,  String? artworkHash)?  $default,) {final _that = this;
switch (_that) {
case _Artist() when $default != null:
return $default(_that.artistName,_that.trackCount,_that.albumCount,_that.artworkHash);case _:
  return null;

}
}

}

/// @nodoc


class _Artist implements Artist {
  const _Artist({required this.artistName, required this.trackCount, required this.albumCount, this.artworkHash});
  

@override final  String artistName;
@override final  int trackCount;
@override final  int albumCount;
/// Cover of ANY track by this artist - MIN() ignores NULLs, so one file
/// with embedded art is enough for the round avatar.
@override final  String? artworkHash;

/// Create a copy of Artist
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ArtistCopyWith<_Artist> get copyWith => __$ArtistCopyWithImpl<_Artist>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Artist&&(identical(other.artistName, artistName) || other.artistName == artistName)&&(identical(other.trackCount, trackCount) || other.trackCount == trackCount)&&(identical(other.albumCount, albumCount) || other.albumCount == albumCount)&&(identical(other.artworkHash, artworkHash) || other.artworkHash == artworkHash));
}


@override
int get hashCode {
    return Object.hash(runtimeType,artistName,trackCount,albumCount,artworkHash);
}

@override
String toString() {
    return 'Artist(artistName: $artistName, trackCount: $trackCount, albumCount: $albumCount, artworkHash: $artworkHash)';
}


}

/// @nodoc
abstract mixin class _$ArtistCopyWith<$Res> implements $ArtistCopyWith<$Res> {
  factory _$ArtistCopyWith(_Artist value, $Res Function(_Artist) _then) = __$ArtistCopyWithImpl;
@override @useResult
$Res call({
 String artistName, int trackCount, int albumCount, String? artworkHash
});




}
/// @nodoc
class __$ArtistCopyWithImpl<$Res>
    implements _$ArtistCopyWith<$Res> {
  __$ArtistCopyWithImpl(this._self, this._then);

  final _Artist _self;
  final $Res Function(_Artist) _then;

/// Create a copy of Artist
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? artistName = null,Object? trackCount = null,Object? albumCount = null,Object? artworkHash = freezed,}) {
  return _then(_Artist(
artistName: null == artistName ? _self.artistName : artistName // ignore: cast_nullable_to_non_nullable
as String,trackCount: null == trackCount ? _self.trackCount : trackCount // ignore: cast_nullable_to_non_nullable
as int,albumCount: null == albumCount ? _self.albumCount : albumCount // ignore: cast_nullable_to_non_nullable
as int,artworkHash: freezed == artworkHash ? _self.artworkHash : artworkHash // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
