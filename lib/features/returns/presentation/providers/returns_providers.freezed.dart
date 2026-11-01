// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'returns_providers.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ReturnDraftState {

/// Id du retour, généré une fois par écran (idempotence).
 String get returnId;/// Quantité choisie par ligne de vente (absente = 0).
 Map<String, int> get quantities;/// État choisi par ligne de vente (absent = revendable).
 Map<String, ItemCondition> get conditions; ReturnReason? get reason; String get note; RefundMethod get refundMethod;/// Retour enregistré : l'écran affiche la confirmation.
 SaleReturn? get saved;
/// Create a copy of ReturnDraftState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReturnDraftStateCopyWith<ReturnDraftState> get copyWith => _$ReturnDraftStateCopyWithImpl<ReturnDraftState>(this as ReturnDraftState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReturnDraftState&&(identical(other.returnId, returnId) || other.returnId == returnId)&&const DeepCollectionEquality().equals(other.quantities, quantities)&&const DeepCollectionEquality().equals(other.conditions, conditions)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.note, note) || other.note == note)&&(identical(other.refundMethod, refundMethod) || other.refundMethod == refundMethod)&&(identical(other.saved, saved) || other.saved == saved));
}


@override
int get hashCode => Object.hash(runtimeType,returnId,const DeepCollectionEquality().hash(quantities),const DeepCollectionEquality().hash(conditions),reason,note,refundMethod,saved);

@override
String toString() {
  return 'ReturnDraftState(returnId: $returnId, quantities: $quantities, conditions: $conditions, reason: $reason, note: $note, refundMethod: $refundMethod, saved: $saved)';
}


}

/// @nodoc
abstract mixin class $ReturnDraftStateCopyWith<$Res>  {
  factory $ReturnDraftStateCopyWith(ReturnDraftState value, $Res Function(ReturnDraftState) _then) = _$ReturnDraftStateCopyWithImpl;
@useResult
$Res call({
 String returnId, Map<String, int> quantities, Map<String, ItemCondition> conditions, ReturnReason? reason, String note, RefundMethod refundMethod, SaleReturn? saved
});


$SaleReturnCopyWith<$Res>? get saved;

}
/// @nodoc
class _$ReturnDraftStateCopyWithImpl<$Res>
    implements $ReturnDraftStateCopyWith<$Res> {
  _$ReturnDraftStateCopyWithImpl(this._self, this._then);

  final ReturnDraftState _self;
  final $Res Function(ReturnDraftState) _then;

/// Create a copy of ReturnDraftState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? returnId = null,Object? quantities = null,Object? conditions = null,Object? reason = freezed,Object? note = null,Object? refundMethod = null,Object? saved = freezed,}) {
  return _then(ReturnDraftState(
returnId: null == returnId ? _self.returnId : returnId // ignore: cast_nullable_to_non_nullable
as String,quantities: null == quantities ? _self.quantities : quantities // ignore: cast_nullable_to_non_nullable
as Map<String, int>,conditions: null == conditions ? _self.conditions : conditions // ignore: cast_nullable_to_non_nullable
as Map<String, ItemCondition>,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as ReturnReason?,note: null == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String,refundMethod: null == refundMethod ? _self.refundMethod : refundMethod // ignore: cast_nullable_to_non_nullable
as RefundMethod,saved: freezed == saved ? _self.saved : saved // ignore: cast_nullable_to_non_nullable
as SaleReturn?,
  ));
}
/// Create a copy of ReturnDraftState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SaleReturnCopyWith<$Res>? get saved {
    if (_self.saved == null) {
    return null;
  }

  return $SaleReturnCopyWith<$Res>(_self.saved!, (value) {
    return _then(_self.copyWith(saved: value));
  });
}
}


/// Adds pattern-matching-related methods to [ReturnDraftState].
extension ReturnDraftStatePatterns on ReturnDraftState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReturnDraftState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReturnDraftState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReturnDraftState value)  $default,){
final _that = this;
switch (_that) {
case _ReturnDraftState():
return $default(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReturnDraftState value)?  $default,){
final _that = this;
switch (_that) {
case _ReturnDraftState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String returnId,  Map<String, int> quantities,  Map<String, ItemCondition> conditions,  ReturnReason? reason,  String note,  RefundMethod refundMethod,  SaleReturn? saved)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReturnDraftState() when $default != null:
return $default(_that.returnId,_that.quantities,_that.conditions,_that.reason,_that.note,_that.refundMethod,_that.saved);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String returnId,  Map<String, int> quantities,  Map<String, ItemCondition> conditions,  ReturnReason? reason,  String note,  RefundMethod refundMethod,  SaleReturn? saved)  $default,) {final _that = this;
switch (_that) {
case _ReturnDraftState():
return $default(_that.returnId,_that.quantities,_that.conditions,_that.reason,_that.note,_that.refundMethod,_that.saved);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String returnId,  Map<String, int> quantities,  Map<String, ItemCondition> conditions,  ReturnReason? reason,  String note,  RefundMethod refundMethod,  SaleReturn? saved)?  $default,) {final _that = this;
switch (_that) {
case _ReturnDraftState() when $default != null:
return $default(_that.returnId,_that.quantities,_that.conditions,_that.reason,_that.note,_that.refundMethod,_that.saved);case _:
  return null;

}
}

}

/// @nodoc


class _ReturnDraftState extends ReturnDraftState {
  const _ReturnDraftState({required this.returnId,  Map<String, int> quantities = const <String, int>{},  Map<String, ItemCondition> conditions = const <String, ItemCondition>{}, this.reason, this.note = '', required this.refundMethod, this.saved}): _quantities = quantities,_conditions = conditions,super._();
  

/// Id du retour, généré une fois par écran (idempotence).
@override final  String returnId;
/// Quantité choisie par ligne de vente (absente = 0).
 final  Map<String, int> _quantities;
/// Quantité choisie par ligne de vente (absente = 0).
@override@JsonKey() Map<String, int> get quantities {
  if (_quantities is EqualUnmodifiableMapView) return _quantities;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_quantities);
}

/// État choisi par ligne de vente (absent = revendable).
 final  Map<String, ItemCondition> _conditions;
/// État choisi par ligne de vente (absent = revendable).
@override@JsonKey() Map<String, ItemCondition> get conditions {
  if (_conditions is EqualUnmodifiableMapView) return _conditions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_conditions);
}

@override final  ReturnReason? reason;
@override@JsonKey() final  String note;
@override final  RefundMethod refundMethod;
/// Retour enregistré : l'écran affiche la confirmation.
@override final  SaleReturn? saved;

/// Create a copy of ReturnDraftState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReturnDraftStateCopyWith<_ReturnDraftState> get copyWith => __$ReturnDraftStateCopyWithImpl<_ReturnDraftState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReturnDraftState&&(identical(other.returnId, returnId) || other.returnId == returnId)&&const DeepCollectionEquality().equals(other._quantities, _quantities)&&const DeepCollectionEquality().equals(other._conditions, _conditions)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.note, note) || other.note == note)&&(identical(other.refundMethod, refundMethod) || other.refundMethod == refundMethod)&&(identical(other.saved, saved) || other.saved == saved));
}


@override
int get hashCode => Object.hash(runtimeType,returnId,const DeepCollectionEquality().hash(_quantities),const DeepCollectionEquality().hash(_conditions),reason,note,refundMethod,saved);

@override
String toString() {
  return 'ReturnDraftState(returnId: $returnId, quantities: $quantities, conditions: $conditions, reason: $reason, note: $note, refundMethod: $refundMethod, saved: $saved)';
}


}

/// @nodoc
abstract mixin class _$ReturnDraftStateCopyWith<$Res> implements $ReturnDraftStateCopyWith<$Res> {
  factory _$ReturnDraftStateCopyWith(_ReturnDraftState value, $Res Function(_ReturnDraftState) _then) = __$ReturnDraftStateCopyWithImpl;
@override @useResult
$Res call({
 String returnId, Map<String, int> quantities, Map<String, ItemCondition> conditions, ReturnReason? reason, String note, RefundMethod refundMethod, SaleReturn? saved
});


@override $SaleReturnCopyWith<$Res>? get saved;

}
/// @nodoc
class __$ReturnDraftStateCopyWithImpl<$Res>
    implements _$ReturnDraftStateCopyWith<$Res> {
  __$ReturnDraftStateCopyWithImpl(this._self, this._then);

  final _ReturnDraftState _self;
  final $Res Function(_ReturnDraftState) _then;

/// Create a copy of ReturnDraftState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? returnId = null,Object? quantities = null,Object? conditions = null,Object? reason = freezed,Object? note = null,Object? refundMethod = null,Object? saved = freezed,}) {
  return _then(_ReturnDraftState(
returnId: null == returnId ? _self.returnId : returnId // ignore: cast_nullable_to_non_nullable
as String,quantities: null == quantities ? _self._quantities : quantities // ignore: cast_nullable_to_non_nullable
as Map<String, int>,conditions: null == conditions ? _self._conditions : conditions // ignore: cast_nullable_to_non_nullable
as Map<String, ItemCondition>,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as ReturnReason?,note: null == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String,refundMethod: null == refundMethod ? _self.refundMethod : refundMethod // ignore: cast_nullable_to_non_nullable
as RefundMethod,saved: freezed == saved ? _self.saved : saved // ignore: cast_nullable_to_non_nullable
as SaleReturn?,
  ));
}

/// Create a copy of ReturnDraftState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SaleReturnCopyWith<$Res>? get saved {
    if (_self.saved == null) {
    return null;
  }

  return $SaleReturnCopyWith<$Res>(_self.saved!, (value) {
    return _then(_self.copyWith(saved: value));
  });
}
}

// dart format on
