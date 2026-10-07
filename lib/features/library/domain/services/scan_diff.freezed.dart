// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'scan_diff.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ScanDiff {

 List<FileEntry> get added; List<FileEntry> get changed; List<String> get removedPaths;
/// Create a copy of ScanDiff
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScanDiffCopyWith<ScanDiff> get copyWith => _$ScanDiffCopyWithImpl<ScanDiff>(this as ScanDiff, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ScanDiff;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScanDiff&&const DeepCollectionEquality().equals(other.added, _this.added)&&const DeepCollectionEquality().equals(other.changed, _this.changed)&&const DeepCollectionEquality().equals(other.removedPaths, _this.removedPaths));
}


@override
int get hashCode {
  final _this = this as ScanDiff;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.added),const DeepCollectionEquality().hash(_this.changed),const DeepCollectionEquality().hash(_this.removedPaths));
}

@override
String toString() {
  final _this = this as ScanDiff;
  return 'ScanDiff(added: ${_this.added}, changed: ${_this.changed}, removedPaths: ${_this.removedPaths})';
}


}

/// @nodoc
abstract mixin class $ScanDiffCopyWith<$Res>  {
  factory $ScanDiffCopyWith(ScanDiff value, $Res Function(ScanDiff) _then) = _$ScanDiffCopyWithImpl;
@useResult
$Res call({
 List<FileEntry> added, List<FileEntry> changed, List<String> removedPaths
});




}
/// @nodoc
class _$ScanDiffCopyWithImpl<$Res>
    implements $ScanDiffCopyWith<$Res> {
  _$ScanDiffCopyWithImpl(this._self, this._then);

  final ScanDiff _self;
  final $Res Function(ScanDiff) _then;

/// Create a copy of ScanDiff
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? added = null,Object? changed = null,Object? removedPaths = null,}) {
  return _then(ScanDiff(
added: null == added ? _self.added : added // ignore: cast_nullable_to_non_nullable
as List<FileEntry>,changed: null == changed ? _self.changed : changed // ignore: cast_nullable_to_non_nullable
as List<FileEntry>,removedPaths: null == removedPaths ? _self.removedPaths : removedPaths // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [ScanDiff].
extension ScanDiffPatterns on ScanDiff {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ScanDiff value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ScanDiff() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ScanDiff value)  $default,){
final _that = this;
switch (_that) {
case _ScanDiff():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ScanDiff value)?  $default,){
final _that = this;
switch (_that) {
case _ScanDiff() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<FileEntry> added,  List<FileEntry> changed,  List<String> removedPaths)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ScanDiff() when $default != null:
return $default(_that.added,_that.changed,_that.removedPaths);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<FileEntry> added,  List<FileEntry> changed,  List<String> removedPaths)  $default,) {final _that = this;
switch (_that) {
case _ScanDiff():
return $default(_that.added,_that.changed,_that.removedPaths);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<FileEntry> added,  List<FileEntry> changed,  List<String> removedPaths)?  $default,) {final _that = this;
switch (_that) {
case _ScanDiff() when $default != null:
return $default(_that.added,_that.changed,_that.removedPaths);case _:
  return null;

}
}

}

/// @nodoc


class _ScanDiff implements ScanDiff {
  const _ScanDiff({required  List<FileEntry> added, required  List<FileEntry> changed, required  List<String> removedPaths}): _added = added,_changed = changed,_removedPaths = removedPaths;
  

 final  List<FileEntry> _added;
@override List<FileEntry> get added {
  if (_added is EqualUnmodifiableListView) return _added;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_added);
}

 final  List<FileEntry> _changed;
@override List<FileEntry> get changed {
  if (_changed is EqualUnmodifiableListView) return _changed;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_changed);
}

 final  List<String> _removedPaths;
@override List<String> get removedPaths {
  if (_removedPaths is EqualUnmodifiableListView) return _removedPaths;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_removedPaths);
}


/// Create a copy of ScanDiff
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ScanDiffCopyWith<_ScanDiff> get copyWith => __$ScanDiffCopyWithImpl<_ScanDiff>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ScanDiff&&const DeepCollectionEquality().equals(other.added, _added)&&const DeepCollectionEquality().equals(other.changed, _changed)&&const DeepCollectionEquality().equals(other.removedPaths, _removedPaths));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_added),const DeepCollectionEquality().hash(_changed),const DeepCollectionEquality().hash(_removedPaths));
}

@override
String toString() {
    return 'ScanDiff(added: $added, changed: $changed, removedPaths: $removedPaths)';
}


}

/// @nodoc
abstract mixin class _$ScanDiffCopyWith<$Res> implements $ScanDiffCopyWith<$Res> {
  factory _$ScanDiffCopyWith(_ScanDiff value, $Res Function(_ScanDiff) _then) = __$ScanDiffCopyWithImpl;
@override @useResult
$Res call({
 List<FileEntry> added, List<FileEntry> changed, List<String> removedPaths
});




}
/// @nodoc
class __$ScanDiffCopyWithImpl<$Res>
    implements _$ScanDiffCopyWith<$Res> {
  __$ScanDiffCopyWithImpl(this._self, this._then);

  final _ScanDiff _self;
  final $Res Function(_ScanDiff) _then;

/// Create a copy of ScanDiff
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? added = null,Object? changed = null,Object? removedPaths = null,}) {
  return _then(_ScanDiff(
added: null == added ? _self._added : added // ignore: cast_nullable_to_non_nullable
as List<FileEntry>,changed: null == changed ? _self._changed : changed // ignore: cast_nullable_to_non_nullable
as List<FileEntry>,removedPaths: null == removedPaths ? _self._removedPaths : removedPaths // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
