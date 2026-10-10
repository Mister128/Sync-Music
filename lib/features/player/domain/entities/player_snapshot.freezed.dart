// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'player_snapshot.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PlayerSnapshot {

 List<Track> get queue; int? get currentIndex; bool get isPlaying;/// Duration of the CURRENT track (null until it is loaded).
 Duration? get duration; RepeatMode get repeatMode; bool get shuffleEnabled;
/// Create a copy of PlayerSnapshot
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlayerSnapshotCopyWith<PlayerSnapshot> get copyWith => _$PlayerSnapshotCopyWithImpl<PlayerSnapshot>(this as PlayerSnapshot, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as PlayerSnapshot;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlayerSnapshot&&const DeepCollectionEquality().equals(other.queue, _this.queue)&&(identical(other.currentIndex, _this.currentIndex) || other.currentIndex == _this.currentIndex)&&(identical(other.isPlaying, _this.isPlaying) || other.isPlaying == _this.isPlaying)&&(identical(other.duration, _this.duration) || other.duration == _this.duration)&&(identical(other.repeatMode, _this.repeatMode) || other.repeatMode == _this.repeatMode)&&(identical(other.shuffleEnabled, _this.shuffleEnabled) || other.shuffleEnabled == _this.shuffleEnabled));
}


@override
int get hashCode {
  final _this = this as PlayerSnapshot;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.queue),_this.currentIndex,_this.isPlaying,_this.duration,_this.repeatMode,_this.shuffleEnabled);
}

@override
String toString() {
  final _this = this as PlayerSnapshot;
  return 'PlayerSnapshot(queue: ${_this.queue}, currentIndex: ${_this.currentIndex}, isPlaying: ${_this.isPlaying}, duration: ${_this.duration}, repeatMode: ${_this.repeatMode}, shuffleEnabled: ${_this.shuffleEnabled})';
}


}

/// @nodoc
abstract mixin class $PlayerSnapshotCopyWith<$Res>  {
  factory $PlayerSnapshotCopyWith(PlayerSnapshot value, $Res Function(PlayerSnapshot) _then) = _$PlayerSnapshotCopyWithImpl;
@useResult
$Res call({
 List<Track> queue, int? currentIndex, bool isPlaying, Duration? duration, RepeatMode repeatMode, bool shuffleEnabled
});




}
/// @nodoc
class _$PlayerSnapshotCopyWithImpl<$Res>
    implements $PlayerSnapshotCopyWith<$Res> {
  _$PlayerSnapshotCopyWithImpl(this._self, this._then);

  final PlayerSnapshot _self;
  final $Res Function(PlayerSnapshot) _then;

/// Create a copy of PlayerSnapshot
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? queue = null,Object? currentIndex = freezed,Object? isPlaying = null,Object? duration = freezed,Object? repeatMode = null,Object? shuffleEnabled = null,}) {
  return _then(PlayerSnapshot(
queue: null == queue ? _self.queue : queue // ignore: cast_nullable_to_non_nullable
as List<Track>,currentIndex: freezed == currentIndex ? _self.currentIndex : currentIndex // ignore: cast_nullable_to_non_nullable
as int?,isPlaying: null == isPlaying ? _self.isPlaying : isPlaying // ignore: cast_nullable_to_non_nullable
as bool,duration: freezed == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as Duration?,repeatMode: null == repeatMode ? _self.repeatMode : repeatMode // ignore: cast_nullable_to_non_nullable
as RepeatMode,shuffleEnabled: null == shuffleEnabled ? _self.shuffleEnabled : shuffleEnabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [PlayerSnapshot].
extension PlayerSnapshotPatterns on PlayerSnapshot {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlayerSnapshot value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlayerSnapshot() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlayerSnapshot value)  $default,){
final _that = this;
switch (_that) {
case _PlayerSnapshot():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlayerSnapshot value)?  $default,){
final _that = this;
switch (_that) {
case _PlayerSnapshot() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Track> queue,  int? currentIndex,  bool isPlaying,  Duration? duration,  RepeatMode repeatMode,  bool shuffleEnabled)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlayerSnapshot() when $default != null:
return $default(_that.queue,_that.currentIndex,_that.isPlaying,_that.duration,_that.repeatMode,_that.shuffleEnabled);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Track> queue,  int? currentIndex,  bool isPlaying,  Duration? duration,  RepeatMode repeatMode,  bool shuffleEnabled)  $default,) {final _that = this;
switch (_that) {
case _PlayerSnapshot():
return $default(_that.queue,_that.currentIndex,_that.isPlaying,_that.duration,_that.repeatMode,_that.shuffleEnabled);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Track> queue,  int? currentIndex,  bool isPlaying,  Duration? duration,  RepeatMode repeatMode,  bool shuffleEnabled)?  $default,) {final _that = this;
switch (_that) {
case _PlayerSnapshot() when $default != null:
return $default(_that.queue,_that.currentIndex,_that.isPlaying,_that.duration,_that.repeatMode,_that.shuffleEnabled);case _:
  return null;

}
}

}

/// @nodoc


class _PlayerSnapshot implements PlayerSnapshot {
  const _PlayerSnapshot({required  List<Track> queue, required this.currentIndex, required this.isPlaying, required this.duration, required this.repeatMode, required this.shuffleEnabled}): _queue = queue;
  

 final  List<Track> _queue;
@override List<Track> get queue {
  if (_queue is EqualUnmodifiableListView) return _queue;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_queue);
}

@override final  int? currentIndex;
@override final  bool isPlaying;
/// Duration of the CURRENT track (null until it is loaded).
@override final  Duration? duration;
@override final  RepeatMode repeatMode;
@override final  bool shuffleEnabled;

/// Create a copy of PlayerSnapshot
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlayerSnapshotCopyWith<_PlayerSnapshot> get copyWith => __$PlayerSnapshotCopyWithImpl<_PlayerSnapshot>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlayerSnapshot&&const DeepCollectionEquality().equals(other.queue, _queue)&&(identical(other.currentIndex, currentIndex) || other.currentIndex == currentIndex)&&(identical(other.isPlaying, isPlaying) || other.isPlaying == isPlaying)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.repeatMode, repeatMode) || other.repeatMode == repeatMode)&&(identical(other.shuffleEnabled, shuffleEnabled) || other.shuffleEnabled == shuffleEnabled));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_queue),currentIndex,isPlaying,duration,repeatMode,shuffleEnabled);
}

@override
String toString() {
    return 'PlayerSnapshot(queue: $queue, currentIndex: $currentIndex, isPlaying: $isPlaying, duration: $duration, repeatMode: $repeatMode, shuffleEnabled: $shuffleEnabled)';
}


}

/// @nodoc
abstract mixin class _$PlayerSnapshotCopyWith<$Res> implements $PlayerSnapshotCopyWith<$Res> {
  factory _$PlayerSnapshotCopyWith(_PlayerSnapshot value, $Res Function(_PlayerSnapshot) _then) = __$PlayerSnapshotCopyWithImpl;
@override @useResult
$Res call({
 List<Track> queue, int? currentIndex, bool isPlaying, Duration? duration, RepeatMode repeatMode, bool shuffleEnabled
});




}
/// @nodoc
class __$PlayerSnapshotCopyWithImpl<$Res>
    implements _$PlayerSnapshotCopyWith<$Res> {
  __$PlayerSnapshotCopyWithImpl(this._self, this._then);

  final _PlayerSnapshot _self;
  final $Res Function(_PlayerSnapshot) _then;

/// Create a copy of PlayerSnapshot
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? queue = null,Object? currentIndex = freezed,Object? isPlaying = null,Object? duration = freezed,Object? repeatMode = null,Object? shuffleEnabled = null,}) {
  return _then(_PlayerSnapshot(
queue: null == queue ? _self._queue : queue // ignore: cast_nullable_to_non_nullable
as List<Track>,currentIndex: freezed == currentIndex ? _self.currentIndex : currentIndex // ignore: cast_nullable_to_non_nullable
as int?,isPlaying: null == isPlaying ? _self.isPlaying : isPlaying // ignore: cast_nullable_to_non_nullable
as bool,duration: freezed == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as Duration?,repeatMode: null == repeatMode ? _self.repeatMode : repeatMode // ignore: cast_nullable_to_non_nullable
as RepeatMode,shuffleEnabled: null == shuffleEnabled ? _self.shuffleEnabled : shuffleEnabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
