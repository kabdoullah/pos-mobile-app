// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cash_movement.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CashMovement {

/// UUID v4 généré côté client.
 String get id;/// Session de caisse parente.
 String get sessionId;/// Sens du mouvement.
 CashMovementType get type;/// Motif du mouvement.
 CashMovementReason get reason;/// Montant du mouvement.
 Decimal get amount;/// Date du mouvement (UTC).
 DateTime get createdAt;/// État de synchronisation.
 CashSyncStatus get syncStatus;/// Commentaire, obligatoire si le motif est `other`.
 String? get note;/// Code du refus serveur, null sinon.
 String? get rejectionCode;
/// Create a copy of CashMovement
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CashMovementCopyWith<CashMovement> get copyWith => _$CashMovementCopyWithImpl<CashMovement>(this as CashMovement, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CashMovement&&(identical(other.id, id) || other.id == id)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.type, type) || other.type == type)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.syncStatus, syncStatus) || other.syncStatus == syncStatus)&&(identical(other.note, note) || other.note == note)&&(identical(other.rejectionCode, rejectionCode) || other.rejectionCode == rejectionCode));
}


@override
int get hashCode => Object.hash(runtimeType,id,sessionId,type,reason,amount,createdAt,syncStatus,note,rejectionCode);

@override
String toString() {
  return 'CashMovement(id: $id, sessionId: $sessionId, type: $type, reason: $reason, amount: $amount, createdAt: $createdAt, syncStatus: $syncStatus, note: $note, rejectionCode: $rejectionCode)';
}


}

/// @nodoc
abstract mixin class $CashMovementCopyWith<$Res>  {
  factory $CashMovementCopyWith(CashMovement value, $Res Function(CashMovement) _then) = _$CashMovementCopyWithImpl;
@useResult
$Res call({
 String id, String sessionId, CashMovementType type, CashMovementReason reason, Decimal amount, DateTime createdAt, CashSyncStatus syncStatus, String? note, String? rejectionCode
});




}
/// @nodoc
class _$CashMovementCopyWithImpl<$Res>
    implements $CashMovementCopyWith<$Res> {
  _$CashMovementCopyWithImpl(this._self, this._then);

  final CashMovement _self;
  final $Res Function(CashMovement) _then;

/// Create a copy of CashMovement
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? sessionId = null,Object? type = null,Object? reason = null,Object? amount = null,Object? createdAt = null,Object? syncStatus = null,Object? note = freezed,Object? rejectionCode = freezed,}) {
  return _then(CashMovement(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as CashMovementType,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as CashMovementReason,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as Decimal,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,syncStatus: null == syncStatus ? _self.syncStatus : syncStatus // ignore: cast_nullable_to_non_nullable
as CashSyncStatus,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,rejectionCode: freezed == rejectionCode ? _self.rejectionCode : rejectionCode // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CashMovement].
extension CashMovementPatterns on CashMovement {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CashMovement value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CashMovement() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CashMovement value)  $default,){
final _that = this;
switch (_that) {
case _CashMovement():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CashMovement value)?  $default,){
final _that = this;
switch (_that) {
case _CashMovement() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String sessionId,  CashMovementType type,  CashMovementReason reason,  Decimal amount,  DateTime createdAt,  CashSyncStatus syncStatus,  String? note,  String? rejectionCode)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CashMovement() when $default != null:
return $default(_that.id,_that.sessionId,_that.type,_that.reason,_that.amount,_that.createdAt,_that.syncStatus,_that.note,_that.rejectionCode);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String sessionId,  CashMovementType type,  CashMovementReason reason,  Decimal amount,  DateTime createdAt,  CashSyncStatus syncStatus,  String? note,  String? rejectionCode)  $default,) {final _that = this;
switch (_that) {
case _CashMovement():
return $default(_that.id,_that.sessionId,_that.type,_that.reason,_that.amount,_that.createdAt,_that.syncStatus,_that.note,_that.rejectionCode);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String sessionId,  CashMovementType type,  CashMovementReason reason,  Decimal amount,  DateTime createdAt,  CashSyncStatus syncStatus,  String? note,  String? rejectionCode)?  $default,) {final _that = this;
switch (_that) {
case _CashMovement() when $default != null:
return $default(_that.id,_that.sessionId,_that.type,_that.reason,_that.amount,_that.createdAt,_that.syncStatus,_that.note,_that.rejectionCode);case _:
  return null;

}
}

}

/// @nodoc


class _CashMovement implements CashMovement {
  const _CashMovement({required this.id, required this.sessionId, required this.type, required this.reason, required this.amount, required this.createdAt, required this.syncStatus, this.note, this.rejectionCode});
  

/// UUID v4 généré côté client.
@override final  String id;
/// Session de caisse parente.
@override final  String sessionId;
/// Sens du mouvement.
@override final  CashMovementType type;
/// Motif du mouvement.
@override final  CashMovementReason reason;
/// Montant du mouvement.
@override final  Decimal amount;
/// Date du mouvement (UTC).
@override final  DateTime createdAt;
/// État de synchronisation.
@override final  CashSyncStatus syncStatus;
/// Commentaire, obligatoire si le motif est `other`.
@override final  String? note;
/// Code du refus serveur, null sinon.
@override final  String? rejectionCode;

/// Create a copy of CashMovement
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CashMovementCopyWith<_CashMovement> get copyWith => __$CashMovementCopyWithImpl<_CashMovement>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CashMovement&&(identical(other.id, id) || other.id == id)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.type, type) || other.type == type)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.syncStatus, syncStatus) || other.syncStatus == syncStatus)&&(identical(other.note, note) || other.note == note)&&(identical(other.rejectionCode, rejectionCode) || other.rejectionCode == rejectionCode));
}


@override
int get hashCode => Object.hash(runtimeType,id,sessionId,type,reason,amount,createdAt,syncStatus,note,rejectionCode);

@override
String toString() {
  return 'CashMovement(id: $id, sessionId: $sessionId, type: $type, reason: $reason, amount: $amount, createdAt: $createdAt, syncStatus: $syncStatus, note: $note, rejectionCode: $rejectionCode)';
}


}

/// @nodoc
abstract mixin class _$CashMovementCopyWith<$Res> implements $CashMovementCopyWith<$Res> {
  factory _$CashMovementCopyWith(_CashMovement value, $Res Function(_CashMovement) _then) = __$CashMovementCopyWithImpl;
@override @useResult
$Res call({
 String id, String sessionId, CashMovementType type, CashMovementReason reason, Decimal amount, DateTime createdAt, CashSyncStatus syncStatus, String? note, String? rejectionCode
});




}
/// @nodoc
class __$CashMovementCopyWithImpl<$Res>
    implements _$CashMovementCopyWith<$Res> {
  __$CashMovementCopyWithImpl(this._self, this._then);

  final _CashMovement _self;
  final $Res Function(_CashMovement) _then;

/// Create a copy of CashMovement
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? sessionId = null,Object? type = null,Object? reason = null,Object? amount = null,Object? createdAt = null,Object? syncStatus = null,Object? note = freezed,Object? rejectionCode = freezed,}) {
  return _then(_CashMovement(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as CashMovementType,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as CashMovementReason,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as Decimal,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,syncStatus: null == syncStatus ? _self.syncStatus : syncStatus // ignore: cast_nullable_to_non_nullable
as CashSyncStatus,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,rejectionCode: freezed == rejectionCode ? _self.rejectionCode : rejectionCode // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
