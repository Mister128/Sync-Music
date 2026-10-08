// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'scan_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ScanEvent {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ScanEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'ScanEvent()';
}


}

/// @nodoc
class $ScanEventCopyWith<$Res>  {
$ScanEventCopyWith(ScanEvent _, $Res Function(ScanEvent) __);
}


/// Adds pattern-matching-related methods to [ScanEvent].
extension ScanEventPatterns on ScanEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ScanStarted value)?  started,TResult Function( ScanProgress value)?  progress,TResult Function( ScanFinished value)?  finished,TResult Function( ScanFailed value)?  failed,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ScanStarted() when started != null:
return started(_that);case ScanProgress() when progress != null:
return progress(_that);case ScanFinished() when finished != null:
return finished(_that);case ScanFailed() when failed != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ScanStarted value)  started,required TResult Function( ScanProgress value)  progress,required TResult Function( ScanFinished value)  finished,required TResult Function( ScanFailed value)  failed,}){
final _that = this;
switch (_that) {
case ScanStarted():
return started(_that);case ScanProgress():
return progress(_that);case ScanFinished():
return finished(_that);case ScanFailed():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ScanStarted value)?  started,TResult? Function( ScanProgress value)?  progress,TResult? Function( ScanFinished value)?  finished,TResult? Function( ScanFailed value)?  failed,}){
final _that = this;
switch (_that) {
case ScanStarted() when started != null:
return started(_that);case ScanProgress() when progress != null:
return progress(_that);case ScanFinished() when finished != null:
return finished(_that);case ScanFailed() when failed != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( int filesFound,  int toProcess)?  started,TResult Function( int processed,  int total)?  progress,TResult Function( int added,  int changed,  int removed,  int skipped)?  finished,TResult Function( String message)?  failed,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ScanStarted() when started != null:
return started(_that.filesFound,_that.toProcess);case ScanProgress() when progress != null:
return progress(_that.processed,_that.total);case ScanFinished() when finished != null:
return finished(_that.added,_that.changed,_that.removed,_that.skipped);case ScanFailed() when failed != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( int filesFound,  int toProcess)  started,required TResult Function( int processed,  int total)  progress,required TResult Function( int added,  int changed,  int removed,  int skipped)  finished,required TResult Function( String message)  failed,}) {final _that = this;
switch (_that) {
case ScanStarted():
return started(_that.filesFound,_that.toProcess);case ScanProgress():
return progress(_that.processed,_that.total);case ScanFinished():
return finished(_that.added,_that.changed,_that.removed,_that.skipped);case ScanFailed():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( int filesFound,  int toProcess)?  started,TResult? Function( int processed,  int total)?  progress,TResult? Function( int added,  int changed,  int removed,  int skipped)?  finished,TResult? Function( String message)?  failed,}) {final _that = this;
switch (_that) {
case ScanStarted() when started != null:
return started(_that.filesFound,_that.toProcess);case ScanProgress() when progress != null:
return progress(_that.processed,_that.total);case ScanFinished() when finished != null:
return finished(_that.added,_that.changed,_that.removed,_that.skipped);case ScanFailed() when failed != null:
return failed(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class ScanStarted implements ScanEvent {
  const ScanStarted({required this.filesFound, required this.toProcess});
  

 final  int filesFound;
 final  int toProcess;

/// Create a copy of ScanEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScanStartedCopyWith<ScanStarted> get copyWith => _$ScanStartedCopyWithImpl<ScanStarted>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ScanStarted&&(identical(other.filesFound, filesFound) || other.filesFound == filesFound)&&(identical(other.toProcess, toProcess) || other.toProcess == toProcess));
}


@override
int get hashCode {
    return Object.hash(runtimeType,filesFound,toProcess);
}

@override
String toString() {
    return 'ScanEvent.started(filesFound: $filesFound, toProcess: $toProcess)';
}


}

/// @nodoc
abstract mixin class $ScanStartedCopyWith<$Res> implements $ScanEventCopyWith<$Res> {
  factory $ScanStartedCopyWith(ScanStarted value, $Res Function(ScanStarted) _then) = _$ScanStartedCopyWithImpl;
@useResult
$Res call({
 int filesFound, int toProcess
});




}
/// @nodoc
class _$ScanStartedCopyWithImpl<$Res>
    implements $ScanStartedCopyWith<$Res> {
  _$ScanStartedCopyWithImpl(this._self, this._then);

  final ScanStarted _self;
  final $Res Function(ScanStarted) _then;

/// Create a copy of ScanEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? filesFound = null,Object? toProcess = null,}) {
  return _then(ScanStarted(
filesFound: null == filesFound ? _self.filesFound : filesFound // ignore: cast_nullable_to_non_nullable
as int,toProcess: null == toProcess ? _self.toProcess : toProcess // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class ScanProgress implements ScanEvent {
  const ScanProgress({required this.processed, required this.total});
  

 final  int processed;
 final  int total;

/// Create a copy of ScanEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScanProgressCopyWith<ScanProgress> get copyWith => _$ScanProgressCopyWithImpl<ScanProgress>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ScanProgress&&(identical(other.processed, processed) || other.processed == processed)&&(identical(other.total, total) || other.total == total));
}


@override
int get hashCode {
    return Object.hash(runtimeType,processed,total);
}

@override
String toString() {
    return 'ScanEvent.progress(processed: $processed, total: $total)';
}


}

/// @nodoc
abstract mixin class $ScanProgressCopyWith<$Res> implements $ScanEventCopyWith<$Res> {
  factory $ScanProgressCopyWith(ScanProgress value, $Res Function(ScanProgress) _then) = _$ScanProgressCopyWithImpl;
@useResult
$Res call({
 int processed, int total
});




}
/// @nodoc
class _$ScanProgressCopyWithImpl<$Res>
    implements $ScanProgressCopyWith<$Res> {
  _$ScanProgressCopyWithImpl(this._self, this._then);

  final ScanProgress _self;
  final $Res Function(ScanProgress) _then;

/// Create a copy of ScanEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? processed = null,Object? total = null,}) {
  return _then(ScanProgress(
processed: null == processed ? _self.processed : processed // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class ScanFinished implements ScanEvent {
  const ScanFinished({required this.added, required this.changed, required this.removed, required this.skipped});
  

 final  int added;
 final  int changed;
 final  int removed;
 final  int skipped;

/// Create a copy of ScanEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScanFinishedCopyWith<ScanFinished> get copyWith => _$ScanFinishedCopyWithImpl<ScanFinished>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ScanFinished&&(identical(other.added, added) || other.added == added)&&(identical(other.changed, changed) || other.changed == changed)&&(identical(other.removed, removed) || other.removed == removed)&&(identical(other.skipped, skipped) || other.skipped == skipped));
}


@override
int get hashCode {
    return Object.hash(runtimeType,added,changed,removed,skipped);
}

@override
String toString() {
    return 'ScanEvent.finished(added: $added, changed: $changed, removed: $removed, skipped: $skipped)';
}


}

/// @nodoc
abstract mixin class $ScanFinishedCopyWith<$Res> implements $ScanEventCopyWith<$Res> {
  factory $ScanFinishedCopyWith(ScanFinished value, $Res Function(ScanFinished) _then) = _$ScanFinishedCopyWithImpl;
@useResult
$Res call({
 int added, int changed, int removed, int skipped
});




}
/// @nodoc
class _$ScanFinishedCopyWithImpl<$Res>
    implements $ScanFinishedCopyWith<$Res> {
  _$ScanFinishedCopyWithImpl(this._self, this._then);

  final ScanFinished _self;
  final $Res Function(ScanFinished) _then;

/// Create a copy of ScanEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? added = null,Object? changed = null,Object? removed = null,Object? skipped = null,}) {
  return _then(ScanFinished(
added: null == added ? _self.added : added // ignore: cast_nullable_to_non_nullable
as int,changed: null == changed ? _self.changed : changed // ignore: cast_nullable_to_non_nullable
as int,removed: null == removed ? _self.removed : removed // ignore: cast_nullable_to_non_nullable
as int,skipped: null == skipped ? _self.skipped : skipped // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class ScanFailed implements ScanEvent {
  const ScanFailed({required this.message});
  

 final  String message;

/// Create a copy of ScanEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScanFailedCopyWith<ScanFailed> get copyWith => _$ScanFailedCopyWithImpl<ScanFailed>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ScanFailed&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode {
    return Object.hash(runtimeType,message);
}

@override
String toString() {
    return 'ScanEvent.failed(message: $message)';
}


}

/// @nodoc
abstract mixin class $ScanFailedCopyWith<$Res> implements $ScanEventCopyWith<$Res> {
  factory $ScanFailedCopyWith(ScanFailed value, $Res Function(ScanFailed) _then) = _$ScanFailedCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$ScanFailedCopyWithImpl<$Res>
    implements $ScanFailedCopyWith<$Res> {
  _$ScanFailedCopyWithImpl(this._self, this._then);

  final ScanFailed _self;
  final $Res Function(ScanFailed) _then;

/// Create a copy of ScanEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(ScanFailed(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
