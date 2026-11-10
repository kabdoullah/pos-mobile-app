// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cash_session.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CashSession {

/// UUID v4 généré côté client.
 String get id;/// Appareil qui a ouvert la session.
 String get deviceId;/// Statut de la session.
 CashSessionStatus get status;/// Fond de caisse à l'ouverture.
 Decimal get openingAmount;/// Date d'ouverture (UTC).
 DateTime get openedAt;/// État de synchronisation.
 CashSyncStatus get syncStatus;/// Le serveur a recalculé un solde théorique différent de l'appareil.
 bool get serverRecalculated;/// Commentaire d'ouverture.
 String? get openingNote;/// Solde théorique retenu par le serveur, null avant clôture.
 Decimal? get expectedAmount;/// Solde théorique calculé sur l'appareil à la clôture.
 Decimal? get clientExpectedAmount;/// Montant compté à la clôture.
 Decimal? get countedAmount;/// Écart (compté moins théorique).
 Decimal? get discrepancyAmount;/// Commentaire de clôture.
 String? get closingNote;/// Date de clôture (UTC), identique à chaque retry.
 DateTime? get closedAt;/// Code du refus serveur, null sinon.
 String? get rejectionCode;
/// Create a copy of CashSession
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CashSessionCopyWith<CashSession> get copyWith => _$CashSessionCopyWithImpl<CashSession>(this as CashSession, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CashSession&&(identical(other.id, id) || other.id == id)&&(identical(other.deviceId, deviceId) || other.deviceId == deviceId)&&(identical(other.status, status) || other.status == status)&&(identical(other.openingAmount, openingAmount) || other.openingAmount == openingAmount)&&(identical(other.openedAt, openedAt) || other.openedAt == openedAt)&&(identical(other.syncStatus, syncStatus) || other.syncStatus == syncStatus)&&(identical(other.serverRecalculated, serverRecalculated) || other.serverRecalculated == serverRecalculated)&&(identical(other.openingNote, openingNote) || other.openingNote == openingNote)&&(identical(other.expectedAmount, expectedAmount) || other.expectedAmount == expectedAmount)&&(identical(other.clientExpectedAmount, clientExpectedAmount) || other.clientExpectedAmount == clientExpectedAmount)&&(identical(other.countedAmount, countedAmount) || other.countedAmount == countedAmount)&&(identical(other.discrepancyAmount, discrepancyAmount) || other.discrepancyAmount == discrepancyAmount)&&(identical(other.closingNote, closingNote) || other.closingNote == closingNote)&&(identical(other.closedAt, closedAt) || other.closedAt == closedAt)&&(identical(other.rejectionCode, rejectionCode) || other.rejectionCode == rejectionCode));
}


@override
int get hashCode => Object.hash(runtimeType,id,deviceId,status,openingAmount,openedAt,syncStatus,serverRecalculated,openingNote,expectedAmount,clientExpectedAmount,countedAmount,discrepancyAmount,closingNote,closedAt,rejectionCode);

@override
String toString() {
  return 'CashSession(id: $id, deviceId: $deviceId, status: $status, openingAmount: $openingAmount, openedAt: $openedAt, syncStatus: $syncStatus, serverRecalculated: $serverRecalculated, openingNote: $openingNote, expectedAmount: $expectedAmount, clientExpectedAmount: $clientExpectedAmount, countedAmount: $countedAmount, discrepancyAmount: $discrepancyAmount, closingNote: $closingNote, closedAt: $closedAt, rejectionCode: $rejectionCode)';
}


}

/// @nodoc
abstract mixin class $CashSessionCopyWith<$Res>  {
  factory $CashSessionCopyWith(CashSession value, $Res Function(CashSession) _then) = _$CashSessionCopyWithImpl;
@useResult
$Res call({
 String id, String deviceId, CashSessionStatus status, Decimal openingAmount, DateTime openedAt, CashSyncStatus syncStatus, bool serverRecalculated, String? openingNote, Decimal? expectedAmount, Decimal? clientExpectedAmount, Decimal? countedAmount, Decimal? discrepancyAmount, String? closingNote, DateTime? closedAt, String? rejectionCode
});




}
/// @nodoc
class _$CashSessionCopyWithImpl<$Res>
    implements $CashSessionCopyWith<$Res> {
  _$CashSessionCopyWithImpl(this._self, this._then);

  final CashSession _self;
  final $Res Function(CashSession) _then;

/// Create a copy of CashSession
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? deviceId = null,Object? status = null,Object? openingAmount = null,Object? openedAt = null,Object? syncStatus = null,Object? serverRecalculated = null,Object? openingNote = freezed,Object? expectedAmount = freezed,Object? clientExpectedAmount = freezed,Object? countedAmount = freezed,Object? discrepancyAmount = freezed,Object? closingNote = freezed,Object? closedAt = freezed,Object? rejectionCode = freezed,}) {
  return _then(CashSession(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,deviceId: null == deviceId ? _self.deviceId : deviceId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as CashSessionStatus,openingAmount: null == openingAmount ? _self.openingAmount : openingAmount // ignore: cast_nullable_to_non_nullable
as Decimal,openedAt: null == openedAt ? _self.openedAt : openedAt // ignore: cast_nullable_to_non_nullable
as DateTime,syncStatus: null == syncStatus ? _self.syncStatus : syncStatus // ignore: cast_nullable_to_non_nullable
as CashSyncStatus,serverRecalculated: null == serverRecalculated ? _self.serverRecalculated : serverRecalculated // ignore: cast_nullable_to_non_nullable
as bool,openingNote: freezed == openingNote ? _self.openingNote : openingNote // ignore: cast_nullable_to_non_nullable
as String?,expectedAmount: freezed == expectedAmount ? _self.expectedAmount : expectedAmount // ignore: cast_nullable_to_non_nullable
as Decimal?,clientExpectedAmount: freezed == clientExpectedAmount ? _self.clientExpectedAmount : clientExpectedAmount // ignore: cast_nullable_to_non_nullable
as Decimal?,countedAmount: freezed == countedAmount ? _self.countedAmount : countedAmount // ignore: cast_nullable_to_non_nullable
as Decimal?,discrepancyAmount: freezed == discrepancyAmount ? _self.discrepancyAmount : discrepancyAmount // ignore: cast_nullable_to_non_nullable
as Decimal?,closingNote: freezed == closingNote ? _self.closingNote : closingNote // ignore: cast_nullable_to_non_nullable
as String?,closedAt: freezed == closedAt ? _self.closedAt : closedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,rejectionCode: freezed == rejectionCode ? _self.rejectionCode : rejectionCode // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CashSession].
extension CashSessionPatterns on CashSession {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CashSession value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CashSession() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CashSession value)  $default,){
final _that = this;
switch (_that) {
case _CashSession():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CashSession value)?  $default,){
final _that = this;
switch (_that) {
case _CashSession() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String deviceId,  CashSessionStatus status,  Decimal openingAmount,  DateTime openedAt,  CashSyncStatus syncStatus,  bool serverRecalculated,  String? openingNote,  Decimal? expectedAmount,  Decimal? clientExpectedAmount,  Decimal? countedAmount,  Decimal? discrepancyAmount,  String? closingNote,  DateTime? closedAt,  String? rejectionCode)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CashSession() when $default != null:
return $default(_that.id,_that.deviceId,_that.status,_that.openingAmount,_that.openedAt,_that.syncStatus,_that.serverRecalculated,_that.openingNote,_that.expectedAmount,_that.clientExpectedAmount,_that.countedAmount,_that.discrepancyAmount,_that.closingNote,_that.closedAt,_that.rejectionCode);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String deviceId,  CashSessionStatus status,  Decimal openingAmount,  DateTime openedAt,  CashSyncStatus syncStatus,  bool serverRecalculated,  String? openingNote,  Decimal? expectedAmount,  Decimal? clientExpectedAmount,  Decimal? countedAmount,  Decimal? discrepancyAmount,  String? closingNote,  DateTime? closedAt,  String? rejectionCode)  $default,) {final _that = this;
switch (_that) {
case _CashSession():
return $default(_that.id,_that.deviceId,_that.status,_that.openingAmount,_that.openedAt,_that.syncStatus,_that.serverRecalculated,_that.openingNote,_that.expectedAmount,_that.clientExpectedAmount,_that.countedAmount,_that.discrepancyAmount,_that.closingNote,_that.closedAt,_that.rejectionCode);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String deviceId,  CashSessionStatus status,  Decimal openingAmount,  DateTime openedAt,  CashSyncStatus syncStatus,  bool serverRecalculated,  String? openingNote,  Decimal? expectedAmount,  Decimal? clientExpectedAmount,  Decimal? countedAmount,  Decimal? discrepancyAmount,  String? closingNote,  DateTime? closedAt,  String? rejectionCode)?  $default,) {final _that = this;
switch (_that) {
case _CashSession() when $default != null:
return $default(_that.id,_that.deviceId,_that.status,_that.openingAmount,_that.openedAt,_that.syncStatus,_that.serverRecalculated,_that.openingNote,_that.expectedAmount,_that.clientExpectedAmount,_that.countedAmount,_that.discrepancyAmount,_that.closingNote,_that.closedAt,_that.rejectionCode);case _:
  return null;

}
}

}

/// @nodoc


class _CashSession implements CashSession {
  const _CashSession({required this.id, required this.deviceId, required this.status, required this.openingAmount, required this.openedAt, required this.syncStatus, required this.serverRecalculated, this.openingNote, this.expectedAmount, this.clientExpectedAmount, this.countedAmount, this.discrepancyAmount, this.closingNote, this.closedAt, this.rejectionCode});
  

/// UUID v4 généré côté client.
@override final  String id;
/// Appareil qui a ouvert la session.
@override final  String deviceId;
/// Statut de la session.
@override final  CashSessionStatus status;
/// Fond de caisse à l'ouverture.
@override final  Decimal openingAmount;
/// Date d'ouverture (UTC).
@override final  DateTime openedAt;
/// État de synchronisation.
@override final  CashSyncStatus syncStatus;
/// Le serveur a recalculé un solde théorique différent de l'appareil.
@override final  bool serverRecalculated;
/// Commentaire d'ouverture.
@override final  String? openingNote;
/// Solde théorique retenu par le serveur, null avant clôture.
@override final  Decimal? expectedAmount;
/// Solde théorique calculé sur l'appareil à la clôture.
@override final  Decimal? clientExpectedAmount;
/// Montant compté à la clôture.
@override final  Decimal? countedAmount;
/// Écart (compté moins théorique).
@override final  Decimal? discrepancyAmount;
/// Commentaire de clôture.
@override final  String? closingNote;
/// Date de clôture (UTC), identique à chaque retry.
@override final  DateTime? closedAt;
/// Code du refus serveur, null sinon.
@override final  String? rejectionCode;

/// Create a copy of CashSession
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CashSessionCopyWith<_CashSession> get copyWith => __$CashSessionCopyWithImpl<_CashSession>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CashSession&&(identical(other.id, id) || other.id == id)&&(identical(other.deviceId, deviceId) || other.deviceId == deviceId)&&(identical(other.status, status) || other.status == status)&&(identical(other.openingAmount, openingAmount) || other.openingAmount == openingAmount)&&(identical(other.openedAt, openedAt) || other.openedAt == openedAt)&&(identical(other.syncStatus, syncStatus) || other.syncStatus == syncStatus)&&(identical(other.serverRecalculated, serverRecalculated) || other.serverRecalculated == serverRecalculated)&&(identical(other.openingNote, openingNote) || other.openingNote == openingNote)&&(identical(other.expectedAmount, expectedAmount) || other.expectedAmount == expectedAmount)&&(identical(other.clientExpectedAmount, clientExpectedAmount) || other.clientExpectedAmount == clientExpectedAmount)&&(identical(other.countedAmount, countedAmount) || other.countedAmount == countedAmount)&&(identical(other.discrepancyAmount, discrepancyAmount) || other.discrepancyAmount == discrepancyAmount)&&(identical(other.closingNote, closingNote) || other.closingNote == closingNote)&&(identical(other.closedAt, closedAt) || other.closedAt == closedAt)&&(identical(other.rejectionCode, rejectionCode) || other.rejectionCode == rejectionCode));
}


@override
int get hashCode => Object.hash(runtimeType,id,deviceId,status,openingAmount,openedAt,syncStatus,serverRecalculated,openingNote,expectedAmount,clientExpectedAmount,countedAmount,discrepancyAmount,closingNote,closedAt,rejectionCode);

@override
String toString() {
  return 'CashSession(id: $id, deviceId: $deviceId, status: $status, openingAmount: $openingAmount, openedAt: $openedAt, syncStatus: $syncStatus, serverRecalculated: $serverRecalculated, openingNote: $openingNote, expectedAmount: $expectedAmount, clientExpectedAmount: $clientExpectedAmount, countedAmount: $countedAmount, discrepancyAmount: $discrepancyAmount, closingNote: $closingNote, closedAt: $closedAt, rejectionCode: $rejectionCode)';
}


}

/// @nodoc
abstract mixin class _$CashSessionCopyWith<$Res> implements $CashSessionCopyWith<$Res> {
  factory _$CashSessionCopyWith(_CashSession value, $Res Function(_CashSession) _then) = __$CashSessionCopyWithImpl;
@override @useResult
$Res call({
 String id, String deviceId, CashSessionStatus status, Decimal openingAmount, DateTime openedAt, CashSyncStatus syncStatus, bool serverRecalculated, String? openingNote, Decimal? expectedAmount, Decimal? clientExpectedAmount, Decimal? countedAmount, Decimal? discrepancyAmount, String? closingNote, DateTime? closedAt, String? rejectionCode
});




}
/// @nodoc
class __$CashSessionCopyWithImpl<$Res>
    implements _$CashSessionCopyWith<$Res> {
  __$CashSessionCopyWithImpl(this._self, this._then);

  final _CashSession _self;
  final $Res Function(_CashSession) _then;

/// Create a copy of CashSession
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? deviceId = null,Object? status = null,Object? openingAmount = null,Object? openedAt = null,Object? syncStatus = null,Object? serverRecalculated = null,Object? openingNote = freezed,Object? expectedAmount = freezed,Object? clientExpectedAmount = freezed,Object? countedAmount = freezed,Object? discrepancyAmount = freezed,Object? closingNote = freezed,Object? closedAt = freezed,Object? rejectionCode = freezed,}) {
  return _then(_CashSession(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,deviceId: null == deviceId ? _self.deviceId : deviceId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as CashSessionStatus,openingAmount: null == openingAmount ? _self.openingAmount : openingAmount // ignore: cast_nullable_to_non_nullable
as Decimal,openedAt: null == openedAt ? _self.openedAt : openedAt // ignore: cast_nullable_to_non_nullable
as DateTime,syncStatus: null == syncStatus ? _self.syncStatus : syncStatus // ignore: cast_nullable_to_non_nullable
as CashSyncStatus,serverRecalculated: null == serverRecalculated ? _self.serverRecalculated : serverRecalculated // ignore: cast_nullable_to_non_nullable
as bool,openingNote: freezed == openingNote ? _self.openingNote : openingNote // ignore: cast_nullable_to_non_nullable
as String?,expectedAmount: freezed == expectedAmount ? _self.expectedAmount : expectedAmount // ignore: cast_nullable_to_non_nullable
as Decimal?,clientExpectedAmount: freezed == clientExpectedAmount ? _self.clientExpectedAmount : clientExpectedAmount // ignore: cast_nullable_to_non_nullable
as Decimal?,countedAmount: freezed == countedAmount ? _self.countedAmount : countedAmount // ignore: cast_nullable_to_non_nullable
as Decimal?,discrepancyAmount: freezed == discrepancyAmount ? _self.discrepancyAmount : discrepancyAmount // ignore: cast_nullable_to_non_nullable
as Decimal?,closingNote: freezed == closingNote ? _self.closingNote : closingNote // ignore: cast_nullable_to_non_nullable
as String?,closedAt: freezed == closedAt ? _self.closedAt : closedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,rejectionCode: freezed == rejectionCode ? _self.rejectionCode : rejectionCode // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
