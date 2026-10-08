// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'library_scan_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ScanUiState {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ScanUiState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'ScanUiState()';
}


}

/// @nodoc
class $ScanUiStateCopyWith<$Res>  {
$ScanUiStateCopyWith(ScanUiState _, $Res Function(ScanUiState) __);
}


/// Adds pattern-matching-related methods to [ScanUiState].
extension ScanUiStatePatterns on ScanUiState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ScanIdle value)?  idle,TResult Function( ScanRunning value)?  running,TResult Function( ScanUiFailed value)?  failed,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ScanIdle() when idle != null:
return idle(_that);case ScanRunning() when running != null:
return running(_that);case ScanUiFailed() when failed != null:
return failed(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ScanIdle value)  idle,required TResult Function( ScanRunning value)  running,required TResult Function( ScanUiFailed value)  failed,}){
final _that = this;
switch (_that) {
case ScanIdle():
return idle(_that);case ScanRunning():
return running(_that);case ScanUiFailed():
return failed(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ScanIdle value)?  idle,TResult? Function( ScanRunning value)?  running,TResult? Function( ScanUiFailed value)?  failed,}){
final _that = this;
switch (_that) {
case ScanIdle() when idle != null:
return idle(_that);case ScanRunning() when running != null:
return running(_that);case ScanUiFailed() when failed != null:
return failed(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  idle,TResult Function( int processed,  int total)?  running,TResult Function( String message)?  failed,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ScanIdle() when idle != null:
return idle();case ScanRunning() when running != null:
return running(_that.processed,_that.total);case ScanUiFailed() when failed != null:
return failed(_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  idle,required TResult Function( int processed,  int total)  running,required TResult Function( String message)  failed,}) {final _that = this;
switch (_that) {
case ScanIdle():
return idle();case ScanRunning():
return running(_that.processed,_that.total);case ScanUiFailed():
return failed(_that.message);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  idle,TResult? Function( int processed,  int total)?  running,TResult? Function( String message)?  failed,}) {final _that = this;
switch (_that) {
case ScanIdle() when idle != null:
return idle();case ScanRunning() when running != null:
return running(_that.processed,_that.total);case ScanUiFailed() when failed != null:
return failed(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class ScanIdle implements ScanUiState {
  const ScanIdle();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ScanIdle);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'ScanUiState.idle()';
}


}




/// @nodoc


class ScanRunning implements ScanUiState {
  const ScanRunning({required this.processed, required this.total});
  

 final  int processed;
 final  int total;

/// Create a copy of ScanUiState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScanRunningCopyWith<ScanRunning> get copyWith => _$ScanRunningCopyWithImpl<ScanRunning>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ScanRunning&&(identical(other.processed, processed) || other.processed == processed)&&(identical(other.total, total) || other.total == total));
}


@override
int get hashCode {
    return Object.hash(runtimeType,processed,total);
}

@override
String toString() {
    return 'ScanUiState.running(processed: $processed, total: $total)';
}


}

/// @nodoc
abstract mixin class $ScanRunningCopyWith<$Res> implements $ScanUiStateCopyWith<$Res> {
  factory $ScanRunningCopyWith(ScanRunning value, $Res Function(ScanRunning) _then) = _$ScanRunningCopyWithImpl;
@useResult
$Res call({
 int processed, int total
});




}
/// @nodoc
class _$ScanRunningCopyWithImpl<$Res>
    implements $ScanRunningCopyWith<$Res> {
  _$ScanRunningCopyWithImpl(this._self, this._then);

  final ScanRunning _self;
  final $Res Function(ScanRunning) _then;

/// Create a copy of ScanUiState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? processed = null,Object? total = null,}) {
  return _then(ScanRunning(
processed: null == processed ? _self.processed : processed // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class ScanUiFailed implements ScanUiState {
  const ScanUiFailed({required this.message});
  

 final  String message;

/// Create a copy of ScanUiState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScanUiFailedCopyWith<ScanUiFailed> get copyWith => _$ScanUiFailedCopyWithImpl<ScanUiFailed>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ScanUiFailed&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode {
    return Object.hash(runtimeType,message);
}

@override
String toString() {
    return 'ScanUiState.failed(message: $message)';
}


}

/// @nodoc
abstract mixin class $ScanUiFailedCopyWith<$Res> implements $ScanUiStateCopyWith<$Res> {
  factory $ScanUiFailedCopyWith(ScanUiFailed value, $Res Function(ScanUiFailed) _then) = _$ScanUiFailedCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$ScanUiFailedCopyWithImpl<$Res>
    implements $ScanUiFailedCopyWith<$Res> {
  _$ScanUiFailedCopyWithImpl(this._self, this._then);

  final ScanUiFailed _self;
  final $Res Function(ScanUiFailed) _then;

/// Create a copy of ScanUiState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(ScanUiFailed(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
