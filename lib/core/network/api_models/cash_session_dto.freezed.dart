// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cash_session_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CashSessionDto {

 String get id;@JsonKey(name: 'device_id') String get deviceId; String get status;@JsonKey(name: 'opening_amount') String get openingAmount;@JsonKey(name: 'opening_note') String? get openingNote;@JsonKey(name: 'opened_at') String get openedAt;@JsonKey(name: 'opened_by') String? get openedBy;@JsonKey(name: 'expected_amount') String? get expectedAmount;@JsonKey(name: 'client_expected_amount') String? get clientExpectedAmount;@JsonKey(name: 'counted_amount') String? get countedAmount;@JsonKey(name: 'discrepancy_amount') String? get discrepancyAmount;@JsonKey(name: 'closing_note') String? get closingNote;@JsonKey(name: 'closed_at') String? get closedAt;@JsonKey(name: 'closed_by') String? get closedBy;
/// Create a copy of CashSessionDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CashSessionDtoCopyWith<CashSessionDto> get copyWith => _$CashSessionDtoCopyWithImpl<CashSessionDto>(this as CashSessionDto, _$identity);

  /// Serializes this CashSessionDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CashSessionDto&&(identical(other.id, id) || other.id == id)&&(identical(other.deviceId, deviceId) || other.deviceId == deviceId)&&(identical(other.status, status) || other.status == status)&&(identical(other.openingAmount, openingAmount) || other.openingAmount == openingAmount)&&(identical(other.openingNote, openingNote) || other.openingNote == openingNote)&&(identical(other.openedAt, openedAt) || other.openedAt == openedAt)&&(identical(other.openedBy, openedBy) || other.openedBy == openedBy)&&(identical(other.expectedAmount, expectedAmount) || other.expectedAmount == expectedAmount)&&(identical(other.clientExpectedAmount, clientExpectedAmount) || other.clientExpectedAmount == clientExpectedAmount)&&(identical(other.countedAmount, countedAmount) || other.countedAmount == countedAmount)&&(identical(other.discrepancyAmount, discrepancyAmount) || other.discrepancyAmount == discrepancyAmount)&&(identical(other.closingNote, closingNote) || other.closingNote == closingNote)&&(identical(other.closedAt, closedAt) || other.closedAt == closedAt)&&(identical(other.closedBy, closedBy) || other.closedBy == closedBy));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,deviceId,status,openingAmount,openingNote,openedAt,openedBy,expectedAmount,clientExpectedAmount,countedAmount,discrepancyAmount,closingNote,closedAt,closedBy);

@override
String toString() {
  return 'CashSessionDto(id: $id, deviceId: $deviceId, status: $status, openingAmount: $openingAmount, openingNote: $openingNote, openedAt: $openedAt, openedBy: $openedBy, expectedAmount: $expectedAmount, clientExpectedAmount: $clientExpectedAmount, countedAmount: $countedAmount, discrepancyAmount: $discrepancyAmount, closingNote: $closingNote, closedAt: $closedAt, closedBy: $closedBy)';
}


}

/// @nodoc
abstract mixin class $CashSessionDtoCopyWith<$Res>  {
  factory $CashSessionDtoCopyWith(CashSessionDto value, $Res Function(CashSessionDto) _then) = _$CashSessionDtoCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'device_id') String deviceId, String status,@JsonKey(name: 'opening_amount') String openingAmount,@JsonKey(name: 'opening_note') String? openingNote,@JsonKey(name: 'opened_at') String openedAt,@JsonKey(name: 'opened_by') String? openedBy,@JsonKey(name: 'expected_amount') String? expectedAmount,@JsonKey(name: 'client_expected_amount') String? clientExpectedAmount,@JsonKey(name: 'counted_amount') String? countedAmount,@JsonKey(name: 'discrepancy_amount') String? discrepancyAmount,@JsonKey(name: 'closing_note') String? closingNote,@JsonKey(name: 'closed_at') String? closedAt,@JsonKey(name: 'closed_by') String? closedBy
});




}
/// @nodoc
class _$CashSessionDtoCopyWithImpl<$Res>
    implements $CashSessionDtoCopyWith<$Res> {
  _$CashSessionDtoCopyWithImpl(this._self, this._then);

  final CashSessionDto _self;
  final $Res Function(CashSessionDto) _then;

/// Create a copy of CashSessionDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? deviceId = null,Object? status = null,Object? openingAmount = null,Object? openingNote = freezed,Object? openedAt = null,Object? openedBy = freezed,Object? expectedAmount = freezed,Object? clientExpectedAmount = freezed,Object? countedAmount = freezed,Object? discrepancyAmount = freezed,Object? closingNote = freezed,Object? closedAt = freezed,Object? closedBy = freezed,}) {
  return _then(CashSessionDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,deviceId: null == deviceId ? _self.deviceId : deviceId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,openingAmount: null == openingAmount ? _self.openingAmount : openingAmount // ignore: cast_nullable_to_non_nullable
as String,openingNote: freezed == openingNote ? _self.openingNote : openingNote // ignore: cast_nullable_to_non_nullable
as String?,openedAt: null == openedAt ? _self.openedAt : openedAt // ignore: cast_nullable_to_non_nullable
as String,openedBy: freezed == openedBy ? _self.openedBy : openedBy // ignore: cast_nullable_to_non_nullable
as String?,expectedAmount: freezed == expectedAmount ? _self.expectedAmount : expectedAmount // ignore: cast_nullable_to_non_nullable
as String?,clientExpectedAmount: freezed == clientExpectedAmount ? _self.clientExpectedAmount : clientExpectedAmount // ignore: cast_nullable_to_non_nullable
as String?,countedAmount: freezed == countedAmount ? _self.countedAmount : countedAmount // ignore: cast_nullable_to_non_nullable
as String?,discrepancyAmount: freezed == discrepancyAmount ? _self.discrepancyAmount : discrepancyAmount // ignore: cast_nullable_to_non_nullable
as String?,closingNote: freezed == closingNote ? _self.closingNote : closingNote // ignore: cast_nullable_to_non_nullable
as String?,closedAt: freezed == closedAt ? _self.closedAt : closedAt // ignore: cast_nullable_to_non_nullable
as String?,closedBy: freezed == closedBy ? _self.closedBy : closedBy // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CashSessionDto].
extension CashSessionDtoPatterns on CashSessionDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CashSessionDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CashSessionDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CashSessionDto value)  $default,){
final _that = this;
switch (_that) {
case _CashSessionDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CashSessionDto value)?  $default,){
final _that = this;
switch (_that) {
case _CashSessionDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'device_id')  String deviceId,  String status, @JsonKey(name: 'opening_amount')  String openingAmount, @JsonKey(name: 'opening_note')  String? openingNote, @JsonKey(name: 'opened_at')  String openedAt, @JsonKey(name: 'opened_by')  String? openedBy, @JsonKey(name: 'expected_amount')  String? expectedAmount, @JsonKey(name: 'client_expected_amount')  String? clientExpectedAmount, @JsonKey(name: 'counted_amount')  String? countedAmount, @JsonKey(name: 'discrepancy_amount')  String? discrepancyAmount, @JsonKey(name: 'closing_note')  String? closingNote, @JsonKey(name: 'closed_at')  String? closedAt, @JsonKey(name: 'closed_by')  String? closedBy)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CashSessionDto() when $default != null:
return $default(_that.id,_that.deviceId,_that.status,_that.openingAmount,_that.openingNote,_that.openedAt,_that.openedBy,_that.expectedAmount,_that.clientExpectedAmount,_that.countedAmount,_that.discrepancyAmount,_that.closingNote,_that.closedAt,_that.closedBy);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'device_id')  String deviceId,  String status, @JsonKey(name: 'opening_amount')  String openingAmount, @JsonKey(name: 'opening_note')  String? openingNote, @JsonKey(name: 'opened_at')  String openedAt, @JsonKey(name: 'opened_by')  String? openedBy, @JsonKey(name: 'expected_amount')  String? expectedAmount, @JsonKey(name: 'client_expected_amount')  String? clientExpectedAmount, @JsonKey(name: 'counted_amount')  String? countedAmount, @JsonKey(name: 'discrepancy_amount')  String? discrepancyAmount, @JsonKey(name: 'closing_note')  String? closingNote, @JsonKey(name: 'closed_at')  String? closedAt, @JsonKey(name: 'closed_by')  String? closedBy)  $default,) {final _that = this;
switch (_that) {
case _CashSessionDto():
return $default(_that.id,_that.deviceId,_that.status,_that.openingAmount,_that.openingNote,_that.openedAt,_that.openedBy,_that.expectedAmount,_that.clientExpectedAmount,_that.countedAmount,_that.discrepancyAmount,_that.closingNote,_that.closedAt,_that.closedBy);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'device_id')  String deviceId,  String status, @JsonKey(name: 'opening_amount')  String openingAmount, @JsonKey(name: 'opening_note')  String? openingNote, @JsonKey(name: 'opened_at')  String openedAt, @JsonKey(name: 'opened_by')  String? openedBy, @JsonKey(name: 'expected_amount')  String? expectedAmount, @JsonKey(name: 'client_expected_amount')  String? clientExpectedAmount, @JsonKey(name: 'counted_amount')  String? countedAmount, @JsonKey(name: 'discrepancy_amount')  String? discrepancyAmount, @JsonKey(name: 'closing_note')  String? closingNote, @JsonKey(name: 'closed_at')  String? closedAt, @JsonKey(name: 'closed_by')  String? closedBy)?  $default,) {final _that = this;
switch (_that) {
case _CashSessionDto() when $default != null:
return $default(_that.id,_that.deviceId,_that.status,_that.openingAmount,_that.openingNote,_that.openedAt,_that.openedBy,_that.expectedAmount,_that.clientExpectedAmount,_that.countedAmount,_that.discrepancyAmount,_that.closingNote,_that.closedAt,_that.closedBy);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CashSessionDto implements CashSessionDto {
  const _CashSessionDto({required this.id, @JsonKey(name: 'device_id') required this.deviceId, required this.status, @JsonKey(name: 'opening_amount') required this.openingAmount, @JsonKey(name: 'opening_note') this.openingNote, @JsonKey(name: 'opened_at') required this.openedAt, @JsonKey(name: 'opened_by') this.openedBy, @JsonKey(name: 'expected_amount') this.expectedAmount, @JsonKey(name: 'client_expected_amount') this.clientExpectedAmount, @JsonKey(name: 'counted_amount') this.countedAmount, @JsonKey(name: 'discrepancy_amount') this.discrepancyAmount, @JsonKey(name: 'closing_note') this.closingNote, @JsonKey(name: 'closed_at') this.closedAt, @JsonKey(name: 'closed_by') this.closedBy});
  factory _CashSessionDto.fromJson(Map<String, dynamic> json) => _$CashSessionDtoFromJson(json);

@override final  String id;
@override@JsonKey(name: 'device_id') final  String deviceId;
@override final  String status;
@override@JsonKey(name: 'opening_amount') final  String openingAmount;
@override@JsonKey(name: 'opening_note') final  String? openingNote;
@override@JsonKey(name: 'opened_at') final  String openedAt;
@override@JsonKey(name: 'opened_by') final  String? openedBy;
@override@JsonKey(name: 'expected_amount') final  String? expectedAmount;
@override@JsonKey(name: 'client_expected_amount') final  String? clientExpectedAmount;
@override@JsonKey(name: 'counted_amount') final  String? countedAmount;
@override@JsonKey(name: 'discrepancy_amount') final  String? discrepancyAmount;
@override@JsonKey(name: 'closing_note') final  String? closingNote;
@override@JsonKey(name: 'closed_at') final  String? closedAt;
@override@JsonKey(name: 'closed_by') final  String? closedBy;

/// Create a copy of CashSessionDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CashSessionDtoCopyWith<_CashSessionDto> get copyWith => __$CashSessionDtoCopyWithImpl<_CashSessionDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CashSessionDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CashSessionDto&&(identical(other.id, id) || other.id == id)&&(identical(other.deviceId, deviceId) || other.deviceId == deviceId)&&(identical(other.status, status) || other.status == status)&&(identical(other.openingAmount, openingAmount) || other.openingAmount == openingAmount)&&(identical(other.openingNote, openingNote) || other.openingNote == openingNote)&&(identical(other.openedAt, openedAt) || other.openedAt == openedAt)&&(identical(other.openedBy, openedBy) || other.openedBy == openedBy)&&(identical(other.expectedAmount, expectedAmount) || other.expectedAmount == expectedAmount)&&(identical(other.clientExpectedAmount, clientExpectedAmount) || other.clientExpectedAmount == clientExpectedAmount)&&(identical(other.countedAmount, countedAmount) || other.countedAmount == countedAmount)&&(identical(other.discrepancyAmount, discrepancyAmount) || other.discrepancyAmount == discrepancyAmount)&&(identical(other.closingNote, closingNote) || other.closingNote == closingNote)&&(identical(other.closedAt, closedAt) || other.closedAt == closedAt)&&(identical(other.closedBy, closedBy) || other.closedBy == closedBy));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,deviceId,status,openingAmount,openingNote,openedAt,openedBy,expectedAmount,clientExpectedAmount,countedAmount,discrepancyAmount,closingNote,closedAt,closedBy);

@override
String toString() {
  return 'CashSessionDto(id: $id, deviceId: $deviceId, status: $status, openingAmount: $openingAmount, openingNote: $openingNote, openedAt: $openedAt, openedBy: $openedBy, expectedAmount: $expectedAmount, clientExpectedAmount: $clientExpectedAmount, countedAmount: $countedAmount, discrepancyAmount: $discrepancyAmount, closingNote: $closingNote, closedAt: $closedAt, closedBy: $closedBy)';
}


}

/// @nodoc
abstract mixin class _$CashSessionDtoCopyWith<$Res> implements $CashSessionDtoCopyWith<$Res> {
  factory _$CashSessionDtoCopyWith(_CashSessionDto value, $Res Function(_CashSessionDto) _then) = __$CashSessionDtoCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'device_id') String deviceId, String status,@JsonKey(name: 'opening_amount') String openingAmount,@JsonKey(name: 'opening_note') String? openingNote,@JsonKey(name: 'opened_at') String openedAt,@JsonKey(name: 'opened_by') String? openedBy,@JsonKey(name: 'expected_amount') String? expectedAmount,@JsonKey(name: 'client_expected_amount') String? clientExpectedAmount,@JsonKey(name: 'counted_amount') String? countedAmount,@JsonKey(name: 'discrepancy_amount') String? discrepancyAmount,@JsonKey(name: 'closing_note') String? closingNote,@JsonKey(name: 'closed_at') String? closedAt,@JsonKey(name: 'closed_by') String? closedBy
});




}
/// @nodoc
class __$CashSessionDtoCopyWithImpl<$Res>
    implements _$CashSessionDtoCopyWith<$Res> {
  __$CashSessionDtoCopyWithImpl(this._self, this._then);

  final _CashSessionDto _self;
  final $Res Function(_CashSessionDto) _then;

/// Create a copy of CashSessionDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? deviceId = null,Object? status = null,Object? openingAmount = null,Object? openingNote = freezed,Object? openedAt = null,Object? openedBy = freezed,Object? expectedAmount = freezed,Object? clientExpectedAmount = freezed,Object? countedAmount = freezed,Object? discrepancyAmount = freezed,Object? closingNote = freezed,Object? closedAt = freezed,Object? closedBy = freezed,}) {
  return _then(_CashSessionDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,deviceId: null == deviceId ? _self.deviceId : deviceId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,openingAmount: null == openingAmount ? _self.openingAmount : openingAmount // ignore: cast_nullable_to_non_nullable
as String,openingNote: freezed == openingNote ? _self.openingNote : openingNote // ignore: cast_nullable_to_non_nullable
as String?,openedAt: null == openedAt ? _self.openedAt : openedAt // ignore: cast_nullable_to_non_nullable
as String,openedBy: freezed == openedBy ? _self.openedBy : openedBy // ignore: cast_nullable_to_non_nullable
as String?,expectedAmount: freezed == expectedAmount ? _self.expectedAmount : expectedAmount // ignore: cast_nullable_to_non_nullable
as String?,clientExpectedAmount: freezed == clientExpectedAmount ? _self.clientExpectedAmount : clientExpectedAmount // ignore: cast_nullable_to_non_nullable
as String?,countedAmount: freezed == countedAmount ? _self.countedAmount : countedAmount // ignore: cast_nullable_to_non_nullable
as String?,discrepancyAmount: freezed == discrepancyAmount ? _self.discrepancyAmount : discrepancyAmount // ignore: cast_nullable_to_non_nullable
as String?,closingNote: freezed == closingNote ? _self.closingNote : closingNote // ignore: cast_nullable_to_non_nullable
as String?,closedAt: freezed == closedAt ? _self.closedAt : closedAt // ignore: cast_nullable_to_non_nullable
as String?,closedBy: freezed == closedBy ? _self.closedBy : closedBy // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$CashMovementDto {

 String get id;@JsonKey(name: 'session_id') String get sessionId; String get type; String get reason; String get amount; String? get note;@JsonKey(name: 'created_at') String get createdAt;@JsonKey(name: 'created_by') String? get createdBy;@JsonKey(name: 'synced_at') String get syncedAt;
/// Create a copy of CashMovementDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CashMovementDtoCopyWith<CashMovementDto> get copyWith => _$CashMovementDtoCopyWithImpl<CashMovementDto>(this as CashMovementDto, _$identity);

  /// Serializes this CashMovementDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CashMovementDto&&(identical(other.id, id) || other.id == id)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.type, type) || other.type == type)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.note, note) || other.note == note)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.syncedAt, syncedAt) || other.syncedAt == syncedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,sessionId,type,reason,amount,note,createdAt,createdBy,syncedAt);

@override
String toString() {
  return 'CashMovementDto(id: $id, sessionId: $sessionId, type: $type, reason: $reason, amount: $amount, note: $note, createdAt: $createdAt, createdBy: $createdBy, syncedAt: $syncedAt)';
}


}

/// @nodoc
abstract mixin class $CashMovementDtoCopyWith<$Res>  {
  factory $CashMovementDtoCopyWith(CashMovementDto value, $Res Function(CashMovementDto) _then) = _$CashMovementDtoCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'session_id') String sessionId, String type, String reason, String amount, String? note,@JsonKey(name: 'created_at') String createdAt,@JsonKey(name: 'created_by') String? createdBy,@JsonKey(name: 'synced_at') String syncedAt
});




}
/// @nodoc
class _$CashMovementDtoCopyWithImpl<$Res>
    implements $CashMovementDtoCopyWith<$Res> {
  _$CashMovementDtoCopyWithImpl(this._self, this._then);

  final CashMovementDto _self;
  final $Res Function(CashMovementDto) _then;

/// Create a copy of CashMovementDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? sessionId = null,Object? type = null,Object? reason = null,Object? amount = null,Object? note = freezed,Object? createdAt = null,Object? createdBy = freezed,Object? syncedAt = null,}) {
  return _then(CashMovementDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as String,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,createdBy: freezed == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String?,syncedAt: null == syncedAt ? _self.syncedAt : syncedAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CashMovementDto].
extension CashMovementDtoPatterns on CashMovementDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CashMovementDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CashMovementDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CashMovementDto value)  $default,){
final _that = this;
switch (_that) {
case _CashMovementDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CashMovementDto value)?  $default,){
final _that = this;
switch (_that) {
case _CashMovementDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'session_id')  String sessionId,  String type,  String reason,  String amount,  String? note, @JsonKey(name: 'created_at')  String createdAt, @JsonKey(name: 'created_by')  String? createdBy, @JsonKey(name: 'synced_at')  String syncedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CashMovementDto() when $default != null:
return $default(_that.id,_that.sessionId,_that.type,_that.reason,_that.amount,_that.note,_that.createdAt,_that.createdBy,_that.syncedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'session_id')  String sessionId,  String type,  String reason,  String amount,  String? note, @JsonKey(name: 'created_at')  String createdAt, @JsonKey(name: 'created_by')  String? createdBy, @JsonKey(name: 'synced_at')  String syncedAt)  $default,) {final _that = this;
switch (_that) {
case _CashMovementDto():
return $default(_that.id,_that.sessionId,_that.type,_that.reason,_that.amount,_that.note,_that.createdAt,_that.createdBy,_that.syncedAt);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'session_id')  String sessionId,  String type,  String reason,  String amount,  String? note, @JsonKey(name: 'created_at')  String createdAt, @JsonKey(name: 'created_by')  String? createdBy, @JsonKey(name: 'synced_at')  String syncedAt)?  $default,) {final _that = this;
switch (_that) {
case _CashMovementDto() when $default != null:
return $default(_that.id,_that.sessionId,_that.type,_that.reason,_that.amount,_that.note,_that.createdAt,_that.createdBy,_that.syncedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CashMovementDto implements CashMovementDto {
  const _CashMovementDto({required this.id, @JsonKey(name: 'session_id') required this.sessionId, required this.type, required this.reason, required this.amount, this.note, @JsonKey(name: 'created_at') required this.createdAt, @JsonKey(name: 'created_by') this.createdBy, @JsonKey(name: 'synced_at') required this.syncedAt});
  factory _CashMovementDto.fromJson(Map<String, dynamic> json) => _$CashMovementDtoFromJson(json);

@override final  String id;
@override@JsonKey(name: 'session_id') final  String sessionId;
@override final  String type;
@override final  String reason;
@override final  String amount;
@override final  String? note;
@override@JsonKey(name: 'created_at') final  String createdAt;
@override@JsonKey(name: 'created_by') final  String? createdBy;
@override@JsonKey(name: 'synced_at') final  String syncedAt;

/// Create a copy of CashMovementDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CashMovementDtoCopyWith<_CashMovementDto> get copyWith => __$CashMovementDtoCopyWithImpl<_CashMovementDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CashMovementDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CashMovementDto&&(identical(other.id, id) || other.id == id)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.type, type) || other.type == type)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.note, note) || other.note == note)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.syncedAt, syncedAt) || other.syncedAt == syncedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,sessionId,type,reason,amount,note,createdAt,createdBy,syncedAt);

@override
String toString() {
  return 'CashMovementDto(id: $id, sessionId: $sessionId, type: $type, reason: $reason, amount: $amount, note: $note, createdAt: $createdAt, createdBy: $createdBy, syncedAt: $syncedAt)';
}


}

/// @nodoc
abstract mixin class _$CashMovementDtoCopyWith<$Res> implements $CashMovementDtoCopyWith<$Res> {
  factory _$CashMovementDtoCopyWith(_CashMovementDto value, $Res Function(_CashMovementDto) _then) = __$CashMovementDtoCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'session_id') String sessionId, String type, String reason, String amount, String? note,@JsonKey(name: 'created_at') String createdAt,@JsonKey(name: 'created_by') String? createdBy,@JsonKey(name: 'synced_at') String syncedAt
});




}
/// @nodoc
class __$CashMovementDtoCopyWithImpl<$Res>
    implements _$CashMovementDtoCopyWith<$Res> {
  __$CashMovementDtoCopyWithImpl(this._self, this._then);

  final _CashMovementDto _self;
  final $Res Function(_CashMovementDto) _then;

/// Create a copy of CashMovementDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? sessionId = null,Object? type = null,Object? reason = null,Object? amount = null,Object? note = freezed,Object? createdAt = null,Object? createdBy = freezed,Object? syncedAt = null,}) {
  return _then(_CashMovementDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as String,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,createdBy: freezed == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String?,syncedAt: null == syncedAt ? _self.syncedAt : syncedAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$CashSummaryDto {

@JsonKey(name: 'opening_amount') String get openingAmount;@JsonKey(name: 'cash_sales') String get cashSales;@JsonKey(name: 'cash_sales_count') int get cashSalesCount;@JsonKey(name: 'mobile_money_sales') String get mobileMoneySales;@JsonKey(name: 'cash_in') String get cashIn;@JsonKey(name: 'cash_out') String get cashOut;@JsonKey(name: 'cash_refunds') String get cashRefunds;@JsonKey(name: 'expected_amount') String get expectedAmount;@JsonKey(name: 'late_impact') String get lateImpact;@JsonKey(name: 'server_recalculated') bool get serverRecalculated;
/// Create a copy of CashSummaryDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CashSummaryDtoCopyWith<CashSummaryDto> get copyWith => _$CashSummaryDtoCopyWithImpl<CashSummaryDto>(this as CashSummaryDto, _$identity);

  /// Serializes this CashSummaryDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CashSummaryDto&&(identical(other.openingAmount, openingAmount) || other.openingAmount == openingAmount)&&(identical(other.cashSales, cashSales) || other.cashSales == cashSales)&&(identical(other.cashSalesCount, cashSalesCount) || other.cashSalesCount == cashSalesCount)&&(identical(other.mobileMoneySales, mobileMoneySales) || other.mobileMoneySales == mobileMoneySales)&&(identical(other.cashIn, cashIn) || other.cashIn == cashIn)&&(identical(other.cashOut, cashOut) || other.cashOut == cashOut)&&(identical(other.cashRefunds, cashRefunds) || other.cashRefunds == cashRefunds)&&(identical(other.expectedAmount, expectedAmount) || other.expectedAmount == expectedAmount)&&(identical(other.lateImpact, lateImpact) || other.lateImpact == lateImpact)&&(identical(other.serverRecalculated, serverRecalculated) || other.serverRecalculated == serverRecalculated));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,openingAmount,cashSales,cashSalesCount,mobileMoneySales,cashIn,cashOut,cashRefunds,expectedAmount,lateImpact,serverRecalculated);

@override
String toString() {
  return 'CashSummaryDto(openingAmount: $openingAmount, cashSales: $cashSales, cashSalesCount: $cashSalesCount, mobileMoneySales: $mobileMoneySales, cashIn: $cashIn, cashOut: $cashOut, cashRefunds: $cashRefunds, expectedAmount: $expectedAmount, lateImpact: $lateImpact, serverRecalculated: $serverRecalculated)';
}


}

/// @nodoc
abstract mixin class $CashSummaryDtoCopyWith<$Res>  {
  factory $CashSummaryDtoCopyWith(CashSummaryDto value, $Res Function(CashSummaryDto) _then) = _$CashSummaryDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'opening_amount') String openingAmount,@JsonKey(name: 'cash_sales') String cashSales,@JsonKey(name: 'cash_sales_count') int cashSalesCount,@JsonKey(name: 'mobile_money_sales') String mobileMoneySales,@JsonKey(name: 'cash_in') String cashIn,@JsonKey(name: 'cash_out') String cashOut,@JsonKey(name: 'cash_refunds') String cashRefunds,@JsonKey(name: 'expected_amount') String expectedAmount,@JsonKey(name: 'late_impact') String lateImpact,@JsonKey(name: 'server_recalculated') bool serverRecalculated
});




}
/// @nodoc
class _$CashSummaryDtoCopyWithImpl<$Res>
    implements $CashSummaryDtoCopyWith<$Res> {
  _$CashSummaryDtoCopyWithImpl(this._self, this._then);

  final CashSummaryDto _self;
  final $Res Function(CashSummaryDto) _then;

/// Create a copy of CashSummaryDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? openingAmount = null,Object? cashSales = null,Object? cashSalesCount = null,Object? mobileMoneySales = null,Object? cashIn = null,Object? cashOut = null,Object? cashRefunds = null,Object? expectedAmount = null,Object? lateImpact = null,Object? serverRecalculated = null,}) {
  return _then(CashSummaryDto(
openingAmount: null == openingAmount ? _self.openingAmount : openingAmount // ignore: cast_nullable_to_non_nullable
as String,cashSales: null == cashSales ? _self.cashSales : cashSales // ignore: cast_nullable_to_non_nullable
as String,cashSalesCount: null == cashSalesCount ? _self.cashSalesCount : cashSalesCount // ignore: cast_nullable_to_non_nullable
as int,mobileMoneySales: null == mobileMoneySales ? _self.mobileMoneySales : mobileMoneySales // ignore: cast_nullable_to_non_nullable
as String,cashIn: null == cashIn ? _self.cashIn : cashIn // ignore: cast_nullable_to_non_nullable
as String,cashOut: null == cashOut ? _self.cashOut : cashOut // ignore: cast_nullable_to_non_nullable
as String,cashRefunds: null == cashRefunds ? _self.cashRefunds : cashRefunds // ignore: cast_nullable_to_non_nullable
as String,expectedAmount: null == expectedAmount ? _self.expectedAmount : expectedAmount // ignore: cast_nullable_to_non_nullable
as String,lateImpact: null == lateImpact ? _self.lateImpact : lateImpact // ignore: cast_nullable_to_non_nullable
as String,serverRecalculated: null == serverRecalculated ? _self.serverRecalculated : serverRecalculated // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [CashSummaryDto].
extension CashSummaryDtoPatterns on CashSummaryDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CashSummaryDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CashSummaryDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CashSummaryDto value)  $default,){
final _that = this;
switch (_that) {
case _CashSummaryDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CashSummaryDto value)?  $default,){
final _that = this;
switch (_that) {
case _CashSummaryDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'opening_amount')  String openingAmount, @JsonKey(name: 'cash_sales')  String cashSales, @JsonKey(name: 'cash_sales_count')  int cashSalesCount, @JsonKey(name: 'mobile_money_sales')  String mobileMoneySales, @JsonKey(name: 'cash_in')  String cashIn, @JsonKey(name: 'cash_out')  String cashOut, @JsonKey(name: 'cash_refunds')  String cashRefunds, @JsonKey(name: 'expected_amount')  String expectedAmount, @JsonKey(name: 'late_impact')  String lateImpact, @JsonKey(name: 'server_recalculated')  bool serverRecalculated)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CashSummaryDto() when $default != null:
return $default(_that.openingAmount,_that.cashSales,_that.cashSalesCount,_that.mobileMoneySales,_that.cashIn,_that.cashOut,_that.cashRefunds,_that.expectedAmount,_that.lateImpact,_that.serverRecalculated);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'opening_amount')  String openingAmount, @JsonKey(name: 'cash_sales')  String cashSales, @JsonKey(name: 'cash_sales_count')  int cashSalesCount, @JsonKey(name: 'mobile_money_sales')  String mobileMoneySales, @JsonKey(name: 'cash_in')  String cashIn, @JsonKey(name: 'cash_out')  String cashOut, @JsonKey(name: 'cash_refunds')  String cashRefunds, @JsonKey(name: 'expected_amount')  String expectedAmount, @JsonKey(name: 'late_impact')  String lateImpact, @JsonKey(name: 'server_recalculated')  bool serverRecalculated)  $default,) {final _that = this;
switch (_that) {
case _CashSummaryDto():
return $default(_that.openingAmount,_that.cashSales,_that.cashSalesCount,_that.mobileMoneySales,_that.cashIn,_that.cashOut,_that.cashRefunds,_that.expectedAmount,_that.lateImpact,_that.serverRecalculated);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'opening_amount')  String openingAmount, @JsonKey(name: 'cash_sales')  String cashSales, @JsonKey(name: 'cash_sales_count')  int cashSalesCount, @JsonKey(name: 'mobile_money_sales')  String mobileMoneySales, @JsonKey(name: 'cash_in')  String cashIn, @JsonKey(name: 'cash_out')  String cashOut, @JsonKey(name: 'cash_refunds')  String cashRefunds, @JsonKey(name: 'expected_amount')  String expectedAmount, @JsonKey(name: 'late_impact')  String lateImpact, @JsonKey(name: 'server_recalculated')  bool serverRecalculated)?  $default,) {final _that = this;
switch (_that) {
case _CashSummaryDto() when $default != null:
return $default(_that.openingAmount,_that.cashSales,_that.cashSalesCount,_that.mobileMoneySales,_that.cashIn,_that.cashOut,_that.cashRefunds,_that.expectedAmount,_that.lateImpact,_that.serverRecalculated);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CashSummaryDto implements CashSummaryDto {
  const _CashSummaryDto({@JsonKey(name: 'opening_amount') required this.openingAmount, @JsonKey(name: 'cash_sales') required this.cashSales, @JsonKey(name: 'cash_sales_count') required this.cashSalesCount, @JsonKey(name: 'mobile_money_sales') required this.mobileMoneySales, @JsonKey(name: 'cash_in') required this.cashIn, @JsonKey(name: 'cash_out') required this.cashOut, @JsonKey(name: 'cash_refunds') required this.cashRefunds, @JsonKey(name: 'expected_amount') required this.expectedAmount, @JsonKey(name: 'late_impact') required this.lateImpact, @JsonKey(name: 'server_recalculated') required this.serverRecalculated});
  factory _CashSummaryDto.fromJson(Map<String, dynamic> json) => _$CashSummaryDtoFromJson(json);

@override@JsonKey(name: 'opening_amount') final  String openingAmount;
@override@JsonKey(name: 'cash_sales') final  String cashSales;
@override@JsonKey(name: 'cash_sales_count') final  int cashSalesCount;
@override@JsonKey(name: 'mobile_money_sales') final  String mobileMoneySales;
@override@JsonKey(name: 'cash_in') final  String cashIn;
@override@JsonKey(name: 'cash_out') final  String cashOut;
@override@JsonKey(name: 'cash_refunds') final  String cashRefunds;
@override@JsonKey(name: 'expected_amount') final  String expectedAmount;
@override@JsonKey(name: 'late_impact') final  String lateImpact;
@override@JsonKey(name: 'server_recalculated') final  bool serverRecalculated;

/// Create a copy of CashSummaryDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CashSummaryDtoCopyWith<_CashSummaryDto> get copyWith => __$CashSummaryDtoCopyWithImpl<_CashSummaryDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CashSummaryDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CashSummaryDto&&(identical(other.openingAmount, openingAmount) || other.openingAmount == openingAmount)&&(identical(other.cashSales, cashSales) || other.cashSales == cashSales)&&(identical(other.cashSalesCount, cashSalesCount) || other.cashSalesCount == cashSalesCount)&&(identical(other.mobileMoneySales, mobileMoneySales) || other.mobileMoneySales == mobileMoneySales)&&(identical(other.cashIn, cashIn) || other.cashIn == cashIn)&&(identical(other.cashOut, cashOut) || other.cashOut == cashOut)&&(identical(other.cashRefunds, cashRefunds) || other.cashRefunds == cashRefunds)&&(identical(other.expectedAmount, expectedAmount) || other.expectedAmount == expectedAmount)&&(identical(other.lateImpact, lateImpact) || other.lateImpact == lateImpact)&&(identical(other.serverRecalculated, serverRecalculated) || other.serverRecalculated == serverRecalculated));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,openingAmount,cashSales,cashSalesCount,mobileMoneySales,cashIn,cashOut,cashRefunds,expectedAmount,lateImpact,serverRecalculated);

@override
String toString() {
  return 'CashSummaryDto(openingAmount: $openingAmount, cashSales: $cashSales, cashSalesCount: $cashSalesCount, mobileMoneySales: $mobileMoneySales, cashIn: $cashIn, cashOut: $cashOut, cashRefunds: $cashRefunds, expectedAmount: $expectedAmount, lateImpact: $lateImpact, serverRecalculated: $serverRecalculated)';
}


}

/// @nodoc
abstract mixin class _$CashSummaryDtoCopyWith<$Res> implements $CashSummaryDtoCopyWith<$Res> {
  factory _$CashSummaryDtoCopyWith(_CashSummaryDto value, $Res Function(_CashSummaryDto) _then) = __$CashSummaryDtoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'opening_amount') String openingAmount,@JsonKey(name: 'cash_sales') String cashSales,@JsonKey(name: 'cash_sales_count') int cashSalesCount,@JsonKey(name: 'mobile_money_sales') String mobileMoneySales,@JsonKey(name: 'cash_in') String cashIn,@JsonKey(name: 'cash_out') String cashOut,@JsonKey(name: 'cash_refunds') String cashRefunds,@JsonKey(name: 'expected_amount') String expectedAmount,@JsonKey(name: 'late_impact') String lateImpact,@JsonKey(name: 'server_recalculated') bool serverRecalculated
});




}
/// @nodoc
class __$CashSummaryDtoCopyWithImpl<$Res>
    implements _$CashSummaryDtoCopyWith<$Res> {
  __$CashSummaryDtoCopyWithImpl(this._self, this._then);

  final _CashSummaryDto _self;
  final $Res Function(_CashSummaryDto) _then;

/// Create a copy of CashSummaryDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? openingAmount = null,Object? cashSales = null,Object? cashSalesCount = null,Object? mobileMoneySales = null,Object? cashIn = null,Object? cashOut = null,Object? cashRefunds = null,Object? expectedAmount = null,Object? lateImpact = null,Object? serverRecalculated = null,}) {
  return _then(_CashSummaryDto(
openingAmount: null == openingAmount ? _self.openingAmount : openingAmount // ignore: cast_nullable_to_non_nullable
as String,cashSales: null == cashSales ? _self.cashSales : cashSales // ignore: cast_nullable_to_non_nullable
as String,cashSalesCount: null == cashSalesCount ? _self.cashSalesCount : cashSalesCount // ignore: cast_nullable_to_non_nullable
as int,mobileMoneySales: null == mobileMoneySales ? _self.mobileMoneySales : mobileMoneySales // ignore: cast_nullable_to_non_nullable
as String,cashIn: null == cashIn ? _self.cashIn : cashIn // ignore: cast_nullable_to_non_nullable
as String,cashOut: null == cashOut ? _self.cashOut : cashOut // ignore: cast_nullable_to_non_nullable
as String,cashRefunds: null == cashRefunds ? _self.cashRefunds : cashRefunds // ignore: cast_nullable_to_non_nullable
as String,expectedAmount: null == expectedAmount ? _self.expectedAmount : expectedAmount // ignore: cast_nullable_to_non_nullable
as String,lateImpact: null == lateImpact ? _self.lateImpact : lateImpact // ignore: cast_nullable_to_non_nullable
as String,serverRecalculated: null == serverRecalculated ? _self.serverRecalculated : serverRecalculated // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$CashCountLineDto {

@JsonKey(name: 'denomination_type') String get denominationType; String get denomination; int get quantity; String get subtotal;
/// Create a copy of CashCountLineDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CashCountLineDtoCopyWith<CashCountLineDto> get copyWith => _$CashCountLineDtoCopyWithImpl<CashCountLineDto>(this as CashCountLineDto, _$identity);

  /// Serializes this CashCountLineDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CashCountLineDto&&(identical(other.denominationType, denominationType) || other.denominationType == denominationType)&&(identical(other.denomination, denomination) || other.denomination == denomination)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.subtotal, subtotal) || other.subtotal == subtotal));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,denominationType,denomination,quantity,subtotal);

@override
String toString() {
  return 'CashCountLineDto(denominationType: $denominationType, denomination: $denomination, quantity: $quantity, subtotal: $subtotal)';
}


}

/// @nodoc
abstract mixin class $CashCountLineDtoCopyWith<$Res>  {
  factory $CashCountLineDtoCopyWith(CashCountLineDto value, $Res Function(CashCountLineDto) _then) = _$CashCountLineDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'denomination_type') String denominationType, String denomination, int quantity, String subtotal
});




}
/// @nodoc
class _$CashCountLineDtoCopyWithImpl<$Res>
    implements $CashCountLineDtoCopyWith<$Res> {
  _$CashCountLineDtoCopyWithImpl(this._self, this._then);

  final CashCountLineDto _self;
  final $Res Function(CashCountLineDto) _then;

/// Create a copy of CashCountLineDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? denominationType = null,Object? denomination = null,Object? quantity = null,Object? subtotal = null,}) {
  return _then(CashCountLineDto(
denominationType: null == denominationType ? _self.denominationType : denominationType // ignore: cast_nullable_to_non_nullable
as String,denomination: null == denomination ? _self.denomination : denomination // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,subtotal: null == subtotal ? _self.subtotal : subtotal // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CashCountLineDto].
extension CashCountLineDtoPatterns on CashCountLineDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CashCountLineDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CashCountLineDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CashCountLineDto value)  $default,){
final _that = this;
switch (_that) {
case _CashCountLineDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CashCountLineDto value)?  $default,){
final _that = this;
switch (_that) {
case _CashCountLineDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'denomination_type')  String denominationType,  String denomination,  int quantity,  String subtotal)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CashCountLineDto() when $default != null:
return $default(_that.denominationType,_that.denomination,_that.quantity,_that.subtotal);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'denomination_type')  String denominationType,  String denomination,  int quantity,  String subtotal)  $default,) {final _that = this;
switch (_that) {
case _CashCountLineDto():
return $default(_that.denominationType,_that.denomination,_that.quantity,_that.subtotal);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'denomination_type')  String denominationType,  String denomination,  int quantity,  String subtotal)?  $default,) {final _that = this;
switch (_that) {
case _CashCountLineDto() when $default != null:
return $default(_that.denominationType,_that.denomination,_that.quantity,_that.subtotal);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CashCountLineDto implements CashCountLineDto {
  const _CashCountLineDto({@JsonKey(name: 'denomination_type') required this.denominationType, required this.denomination, required this.quantity, required this.subtotal});
  factory _CashCountLineDto.fromJson(Map<String, dynamic> json) => _$CashCountLineDtoFromJson(json);

@override@JsonKey(name: 'denomination_type') final  String denominationType;
@override final  String denomination;
@override final  int quantity;
@override final  String subtotal;

/// Create a copy of CashCountLineDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CashCountLineDtoCopyWith<_CashCountLineDto> get copyWith => __$CashCountLineDtoCopyWithImpl<_CashCountLineDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CashCountLineDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CashCountLineDto&&(identical(other.denominationType, denominationType) || other.denominationType == denominationType)&&(identical(other.denomination, denomination) || other.denomination == denomination)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.subtotal, subtotal) || other.subtotal == subtotal));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,denominationType,denomination,quantity,subtotal);

@override
String toString() {
  return 'CashCountLineDto(denominationType: $denominationType, denomination: $denomination, quantity: $quantity, subtotal: $subtotal)';
}


}

/// @nodoc
abstract mixin class _$CashCountLineDtoCopyWith<$Res> implements $CashCountLineDtoCopyWith<$Res> {
  factory _$CashCountLineDtoCopyWith(_CashCountLineDto value, $Res Function(_CashCountLineDto) _then) = __$CashCountLineDtoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'denomination_type') String denominationType, String denomination, int quantity, String subtotal
});




}
/// @nodoc
class __$CashCountLineDtoCopyWithImpl<$Res>
    implements _$CashCountLineDtoCopyWith<$Res> {
  __$CashCountLineDtoCopyWithImpl(this._self, this._then);

  final _CashCountLineDto _self;
  final $Res Function(_CashCountLineDto) _then;

/// Create a copy of CashCountLineDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? denominationType = null,Object? denomination = null,Object? quantity = null,Object? subtotal = null,}) {
  return _then(_CashCountLineDto(
denominationType: null == denominationType ? _self.denominationType : denominationType // ignore: cast_nullable_to_non_nullable
as String,denomination: null == denomination ? _self.denomination : denomination // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,subtotal: null == subtotal ? _self.subtotal : subtotal // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$CashCountDto {

 List<CashCountLineDto> get lines;@JsonKey(name: 'bills_total') String get billsTotal;@JsonKey(name: 'coins_total') String get coinsTotal; String get total;
/// Create a copy of CashCountDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CashCountDtoCopyWith<CashCountDto> get copyWith => _$CashCountDtoCopyWithImpl<CashCountDto>(this as CashCountDto, _$identity);

  /// Serializes this CashCountDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CashCountDto&&const DeepCollectionEquality().equals(other.lines, lines)&&(identical(other.billsTotal, billsTotal) || other.billsTotal == billsTotal)&&(identical(other.coinsTotal, coinsTotal) || other.coinsTotal == coinsTotal)&&(identical(other.total, total) || other.total == total));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(lines),billsTotal,coinsTotal,total);

@override
String toString() {
  return 'CashCountDto(lines: $lines, billsTotal: $billsTotal, coinsTotal: $coinsTotal, total: $total)';
}


}

/// @nodoc
abstract mixin class $CashCountDtoCopyWith<$Res>  {
  factory $CashCountDtoCopyWith(CashCountDto value, $Res Function(CashCountDto) _then) = _$CashCountDtoCopyWithImpl;
@useResult
$Res call({
 List<CashCountLineDto> lines,@JsonKey(name: 'bills_total') String billsTotal,@JsonKey(name: 'coins_total') String coinsTotal, String total
});




}
/// @nodoc
class _$CashCountDtoCopyWithImpl<$Res>
    implements $CashCountDtoCopyWith<$Res> {
  _$CashCountDtoCopyWithImpl(this._self, this._then);

  final CashCountDto _self;
  final $Res Function(CashCountDto) _then;

/// Create a copy of CashCountDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? lines = null,Object? billsTotal = null,Object? coinsTotal = null,Object? total = null,}) {
  return _then(CashCountDto(
lines: null == lines ? _self.lines : lines // ignore: cast_nullable_to_non_nullable
as List<CashCountLineDto>,billsTotal: null == billsTotal ? _self.billsTotal : billsTotal // ignore: cast_nullable_to_non_nullable
as String,coinsTotal: null == coinsTotal ? _self.coinsTotal : coinsTotal // ignore: cast_nullable_to_non_nullable
as String,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CashCountDto].
extension CashCountDtoPatterns on CashCountDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CashCountDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CashCountDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CashCountDto value)  $default,){
final _that = this;
switch (_that) {
case _CashCountDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CashCountDto value)?  $default,){
final _that = this;
switch (_that) {
case _CashCountDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<CashCountLineDto> lines, @JsonKey(name: 'bills_total')  String billsTotal, @JsonKey(name: 'coins_total')  String coinsTotal,  String total)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CashCountDto() when $default != null:
return $default(_that.lines,_that.billsTotal,_that.coinsTotal,_that.total);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<CashCountLineDto> lines, @JsonKey(name: 'bills_total')  String billsTotal, @JsonKey(name: 'coins_total')  String coinsTotal,  String total)  $default,) {final _that = this;
switch (_that) {
case _CashCountDto():
return $default(_that.lines,_that.billsTotal,_that.coinsTotal,_that.total);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<CashCountLineDto> lines, @JsonKey(name: 'bills_total')  String billsTotal, @JsonKey(name: 'coins_total')  String coinsTotal,  String total)?  $default,) {final _that = this;
switch (_that) {
case _CashCountDto() when $default != null:
return $default(_that.lines,_that.billsTotal,_that.coinsTotal,_that.total);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CashCountDto implements CashCountDto {
  const _CashCountDto({required  List<CashCountLineDto> lines, @JsonKey(name: 'bills_total') required this.billsTotal, @JsonKey(name: 'coins_total') required this.coinsTotal, required this.total}): _lines = lines;
  factory _CashCountDto.fromJson(Map<String, dynamic> json) => _$CashCountDtoFromJson(json);

 final  List<CashCountLineDto> _lines;
@override List<CashCountLineDto> get lines {
  if (_lines is EqualUnmodifiableListView) return _lines;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_lines);
}

@override@JsonKey(name: 'bills_total') final  String billsTotal;
@override@JsonKey(name: 'coins_total') final  String coinsTotal;
@override final  String total;

/// Create a copy of CashCountDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CashCountDtoCopyWith<_CashCountDto> get copyWith => __$CashCountDtoCopyWithImpl<_CashCountDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CashCountDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CashCountDto&&const DeepCollectionEquality().equals(other._lines, _lines)&&(identical(other.billsTotal, billsTotal) || other.billsTotal == billsTotal)&&(identical(other.coinsTotal, coinsTotal) || other.coinsTotal == coinsTotal)&&(identical(other.total, total) || other.total == total));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_lines),billsTotal,coinsTotal,total);

@override
String toString() {
  return 'CashCountDto(lines: $lines, billsTotal: $billsTotal, coinsTotal: $coinsTotal, total: $total)';
}


}

/// @nodoc
abstract mixin class _$CashCountDtoCopyWith<$Res> implements $CashCountDtoCopyWith<$Res> {
  factory _$CashCountDtoCopyWith(_CashCountDto value, $Res Function(_CashCountDto) _then) = __$CashCountDtoCopyWithImpl;
@override @useResult
$Res call({
 List<CashCountLineDto> lines,@JsonKey(name: 'bills_total') String billsTotal,@JsonKey(name: 'coins_total') String coinsTotal, String total
});




}
/// @nodoc
class __$CashCountDtoCopyWithImpl<$Res>
    implements _$CashCountDtoCopyWith<$Res> {
  __$CashCountDtoCopyWithImpl(this._self, this._then);

  final _CashCountDto _self;
  final $Res Function(_CashCountDto) _then;

/// Create a copy of CashCountDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? lines = null,Object? billsTotal = null,Object? coinsTotal = null,Object? total = null,}) {
  return _then(_CashCountDto(
lines: null == lines ? _self._lines : lines // ignore: cast_nullable_to_non_nullable
as List<CashCountLineDto>,billsTotal: null == billsTotal ? _self.billsTotal : billsTotal // ignore: cast_nullable_to_non_nullable
as String,coinsTotal: null == coinsTotal ? _self.coinsTotal : coinsTotal // ignore: cast_nullable_to_non_nullable
as String,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$CashSessionDetailDto {

 CashSessionDto get session; CashSummaryDto get summary; List<CashMovementDto> get movements;@JsonKey(name: 'opening_count') CashCountDto? get openingCount;@JsonKey(name: 'closing_count') CashCountDto? get closingCount;
/// Create a copy of CashSessionDetailDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CashSessionDetailDtoCopyWith<CashSessionDetailDto> get copyWith => _$CashSessionDetailDtoCopyWithImpl<CashSessionDetailDto>(this as CashSessionDetailDto, _$identity);

  /// Serializes this CashSessionDetailDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CashSessionDetailDto&&(identical(other.session, session) || other.session == session)&&(identical(other.summary, summary) || other.summary == summary)&&const DeepCollectionEquality().equals(other.movements, movements)&&(identical(other.openingCount, openingCount) || other.openingCount == openingCount)&&(identical(other.closingCount, closingCount) || other.closingCount == closingCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,session,summary,const DeepCollectionEquality().hash(movements),openingCount,closingCount);

@override
String toString() {
  return 'CashSessionDetailDto(session: $session, summary: $summary, movements: $movements, openingCount: $openingCount, closingCount: $closingCount)';
}


}

/// @nodoc
abstract mixin class $CashSessionDetailDtoCopyWith<$Res>  {
  factory $CashSessionDetailDtoCopyWith(CashSessionDetailDto value, $Res Function(CashSessionDetailDto) _then) = _$CashSessionDetailDtoCopyWithImpl;
@useResult
$Res call({
 CashSessionDto session, CashSummaryDto summary, List<CashMovementDto> movements,@JsonKey(name: 'opening_count') CashCountDto? openingCount,@JsonKey(name: 'closing_count') CashCountDto? closingCount
});


$CashSessionDtoCopyWith<$Res> get session;$CashSummaryDtoCopyWith<$Res> get summary;$CashCountDtoCopyWith<$Res>? get openingCount;$CashCountDtoCopyWith<$Res>? get closingCount;

}
/// @nodoc
class _$CashSessionDetailDtoCopyWithImpl<$Res>
    implements $CashSessionDetailDtoCopyWith<$Res> {
  _$CashSessionDetailDtoCopyWithImpl(this._self, this._then);

  final CashSessionDetailDto _self;
  final $Res Function(CashSessionDetailDto) _then;

/// Create a copy of CashSessionDetailDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? session = null,Object? summary = null,Object? movements = null,Object? openingCount = freezed,Object? closingCount = freezed,}) {
  return _then(CashSessionDetailDto(
session: null == session ? _self.session : session // ignore: cast_nullable_to_non_nullable
as CashSessionDto,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as CashSummaryDto,movements: null == movements ? _self.movements : movements // ignore: cast_nullable_to_non_nullable
as List<CashMovementDto>,openingCount: freezed == openingCount ? _self.openingCount : openingCount // ignore: cast_nullable_to_non_nullable
as CashCountDto?,closingCount: freezed == closingCount ? _self.closingCount : closingCount // ignore: cast_nullable_to_non_nullable
as CashCountDto?,
  ));
}
/// Create a copy of CashSessionDetailDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CashSessionDtoCopyWith<$Res> get session {
  
  return $CashSessionDtoCopyWith<$Res>(_self.session, (value) {
    return _then(_self.copyWith(session: value));
  });
}/// Create a copy of CashSessionDetailDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CashSummaryDtoCopyWith<$Res> get summary {
  
  return $CashSummaryDtoCopyWith<$Res>(_self.summary, (value) {
    return _then(_self.copyWith(summary: value));
  });
}/// Create a copy of CashSessionDetailDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CashCountDtoCopyWith<$Res>? get openingCount {
    if (_self.openingCount == null) {
    return null;
  }

  return $CashCountDtoCopyWith<$Res>(_self.openingCount!, (value) {
    return _then(_self.copyWith(openingCount: value));
  });
}/// Create a copy of CashSessionDetailDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CashCountDtoCopyWith<$Res>? get closingCount {
    if (_self.closingCount == null) {
    return null;
  }

  return $CashCountDtoCopyWith<$Res>(_self.closingCount!, (value) {
    return _then(_self.copyWith(closingCount: value));
  });
}
}


/// Adds pattern-matching-related methods to [CashSessionDetailDto].
extension CashSessionDetailDtoPatterns on CashSessionDetailDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CashSessionDetailDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CashSessionDetailDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CashSessionDetailDto value)  $default,){
final _that = this;
switch (_that) {
case _CashSessionDetailDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CashSessionDetailDto value)?  $default,){
final _that = this;
switch (_that) {
case _CashSessionDetailDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( CashSessionDto session,  CashSummaryDto summary,  List<CashMovementDto> movements, @JsonKey(name: 'opening_count')  CashCountDto? openingCount, @JsonKey(name: 'closing_count')  CashCountDto? closingCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CashSessionDetailDto() when $default != null:
return $default(_that.session,_that.summary,_that.movements,_that.openingCount,_that.closingCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( CashSessionDto session,  CashSummaryDto summary,  List<CashMovementDto> movements, @JsonKey(name: 'opening_count')  CashCountDto? openingCount, @JsonKey(name: 'closing_count')  CashCountDto? closingCount)  $default,) {final _that = this;
switch (_that) {
case _CashSessionDetailDto():
return $default(_that.session,_that.summary,_that.movements,_that.openingCount,_that.closingCount);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( CashSessionDto session,  CashSummaryDto summary,  List<CashMovementDto> movements, @JsonKey(name: 'opening_count')  CashCountDto? openingCount, @JsonKey(name: 'closing_count')  CashCountDto? closingCount)?  $default,) {final _that = this;
switch (_that) {
case _CashSessionDetailDto() when $default != null:
return $default(_that.session,_that.summary,_that.movements,_that.openingCount,_that.closingCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CashSessionDetailDto implements CashSessionDetailDto {
  const _CashSessionDetailDto({required this.session, required this.summary, required  List<CashMovementDto> movements, @JsonKey(name: 'opening_count') this.openingCount, @JsonKey(name: 'closing_count') this.closingCount}): _movements = movements;
  factory _CashSessionDetailDto.fromJson(Map<String, dynamic> json) => _$CashSessionDetailDtoFromJson(json);

@override final  CashSessionDto session;
@override final  CashSummaryDto summary;
 final  List<CashMovementDto> _movements;
@override List<CashMovementDto> get movements {
  if (_movements is EqualUnmodifiableListView) return _movements;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_movements);
}

@override@JsonKey(name: 'opening_count') final  CashCountDto? openingCount;
@override@JsonKey(name: 'closing_count') final  CashCountDto? closingCount;

/// Create a copy of CashSessionDetailDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CashSessionDetailDtoCopyWith<_CashSessionDetailDto> get copyWith => __$CashSessionDetailDtoCopyWithImpl<_CashSessionDetailDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CashSessionDetailDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CashSessionDetailDto&&(identical(other.session, session) || other.session == session)&&(identical(other.summary, summary) || other.summary == summary)&&const DeepCollectionEquality().equals(other._movements, _movements)&&(identical(other.openingCount, openingCount) || other.openingCount == openingCount)&&(identical(other.closingCount, closingCount) || other.closingCount == closingCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,session,summary,const DeepCollectionEquality().hash(_movements),openingCount,closingCount);

@override
String toString() {
  return 'CashSessionDetailDto(session: $session, summary: $summary, movements: $movements, openingCount: $openingCount, closingCount: $closingCount)';
}


}

/// @nodoc
abstract mixin class _$CashSessionDetailDtoCopyWith<$Res> implements $CashSessionDetailDtoCopyWith<$Res> {
  factory _$CashSessionDetailDtoCopyWith(_CashSessionDetailDto value, $Res Function(_CashSessionDetailDto) _then) = __$CashSessionDetailDtoCopyWithImpl;
@override @useResult
$Res call({
 CashSessionDto session, CashSummaryDto summary, List<CashMovementDto> movements,@JsonKey(name: 'opening_count') CashCountDto? openingCount,@JsonKey(name: 'closing_count') CashCountDto? closingCount
});


@override $CashSessionDtoCopyWith<$Res> get session;@override $CashSummaryDtoCopyWith<$Res> get summary;@override $CashCountDtoCopyWith<$Res>? get openingCount;@override $CashCountDtoCopyWith<$Res>? get closingCount;

}
/// @nodoc
class __$CashSessionDetailDtoCopyWithImpl<$Res>
    implements _$CashSessionDetailDtoCopyWith<$Res> {
  __$CashSessionDetailDtoCopyWithImpl(this._self, this._then);

  final _CashSessionDetailDto _self;
  final $Res Function(_CashSessionDetailDto) _then;

/// Create a copy of CashSessionDetailDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? session = null,Object? summary = null,Object? movements = null,Object? openingCount = freezed,Object? closingCount = freezed,}) {
  return _then(_CashSessionDetailDto(
session: null == session ? _self.session : session // ignore: cast_nullable_to_non_nullable
as CashSessionDto,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as CashSummaryDto,movements: null == movements ? _self._movements : movements // ignore: cast_nullable_to_non_nullable
as List<CashMovementDto>,openingCount: freezed == openingCount ? _self.openingCount : openingCount // ignore: cast_nullable_to_non_nullable
as CashCountDto?,closingCount: freezed == closingCount ? _self.closingCount : closingCount // ignore: cast_nullable_to_non_nullable
as CashCountDto?,
  ));
}

/// Create a copy of CashSessionDetailDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CashSessionDtoCopyWith<$Res> get session {
  
  return $CashSessionDtoCopyWith<$Res>(_self.session, (value) {
    return _then(_self.copyWith(session: value));
  });
}/// Create a copy of CashSessionDetailDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CashSummaryDtoCopyWith<$Res> get summary {
  
  return $CashSummaryDtoCopyWith<$Res>(_self.summary, (value) {
    return _then(_self.copyWith(summary: value));
  });
}/// Create a copy of CashSessionDetailDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CashCountDtoCopyWith<$Res>? get openingCount {
    if (_self.openingCount == null) {
    return null;
  }

  return $CashCountDtoCopyWith<$Res>(_self.openingCount!, (value) {
    return _then(_self.copyWith(openingCount: value));
  });
}/// Create a copy of CashSessionDetailDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CashCountDtoCopyWith<$Res>? get closingCount {
    if (_self.closingCount == null) {
    return null;
  }

  return $CashCountDtoCopyWith<$Res>(_self.closingCount!, (value) {
    return _then(_self.copyWith(closingCount: value));
  });
}
}


/// @nodoc
mixin _$CashSessionPageDto {

 List<CashSessionDto> get items;@JsonKey(name: 'next_cursor') String? get nextCursor;@JsonKey(name: 'has_more') bool get hasMore;
/// Create a copy of CashSessionPageDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CashSessionPageDtoCopyWith<CashSessionPageDto> get copyWith => _$CashSessionPageDtoCopyWithImpl<CashSessionPageDto>(this as CashSessionPageDto, _$identity);

  /// Serializes this CashSessionPageDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CashSessionPageDto&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(items),nextCursor,hasMore);

@override
String toString() {
  return 'CashSessionPageDto(items: $items, nextCursor: $nextCursor, hasMore: $hasMore)';
}


}

/// @nodoc
abstract mixin class $CashSessionPageDtoCopyWith<$Res>  {
  factory $CashSessionPageDtoCopyWith(CashSessionPageDto value, $Res Function(CashSessionPageDto) _then) = _$CashSessionPageDtoCopyWithImpl;
@useResult
$Res call({
 List<CashSessionDto> items,@JsonKey(name: 'next_cursor') String? nextCursor,@JsonKey(name: 'has_more') bool hasMore
});




}
/// @nodoc
class _$CashSessionPageDtoCopyWithImpl<$Res>
    implements $CashSessionPageDtoCopyWith<$Res> {
  _$CashSessionPageDtoCopyWithImpl(this._self, this._then);

  final CashSessionPageDto _self;
  final $Res Function(CashSessionPageDto) _then;

/// Create a copy of CashSessionPageDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? nextCursor = freezed,Object? hasMore = null,}) {
  return _then(CashSessionPageDto(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<CashSessionDto>,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [CashSessionPageDto].
extension CashSessionPageDtoPatterns on CashSessionPageDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CashSessionPageDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CashSessionPageDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CashSessionPageDto value)  $default,){
final _that = this;
switch (_that) {
case _CashSessionPageDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CashSessionPageDto value)?  $default,){
final _that = this;
switch (_that) {
case _CashSessionPageDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<CashSessionDto> items, @JsonKey(name: 'next_cursor')  String? nextCursor, @JsonKey(name: 'has_more')  bool hasMore)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CashSessionPageDto() when $default != null:
return $default(_that.items,_that.nextCursor,_that.hasMore);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<CashSessionDto> items, @JsonKey(name: 'next_cursor')  String? nextCursor, @JsonKey(name: 'has_more')  bool hasMore)  $default,) {final _that = this;
switch (_that) {
case _CashSessionPageDto():
return $default(_that.items,_that.nextCursor,_that.hasMore);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<CashSessionDto> items, @JsonKey(name: 'next_cursor')  String? nextCursor, @JsonKey(name: 'has_more')  bool hasMore)?  $default,) {final _that = this;
switch (_that) {
case _CashSessionPageDto() when $default != null:
return $default(_that.items,_that.nextCursor,_that.hasMore);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CashSessionPageDto implements CashSessionPageDto {
  const _CashSessionPageDto({required  List<CashSessionDto> items, @JsonKey(name: 'next_cursor') this.nextCursor, @JsonKey(name: 'has_more') required this.hasMore}): _items = items;
  factory _CashSessionPageDto.fromJson(Map<String, dynamic> json) => _$CashSessionPageDtoFromJson(json);

 final  List<CashSessionDto> _items;
@override List<CashSessionDto> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override@JsonKey(name: 'next_cursor') final  String? nextCursor;
@override@JsonKey(name: 'has_more') final  bool hasMore;

/// Create a copy of CashSessionPageDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CashSessionPageDtoCopyWith<_CashSessionPageDto> get copyWith => __$CashSessionPageDtoCopyWithImpl<_CashSessionPageDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CashSessionPageDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CashSessionPageDto&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),nextCursor,hasMore);

@override
String toString() {
  return 'CashSessionPageDto(items: $items, nextCursor: $nextCursor, hasMore: $hasMore)';
}


}

/// @nodoc
abstract mixin class _$CashSessionPageDtoCopyWith<$Res> implements $CashSessionPageDtoCopyWith<$Res> {
  factory _$CashSessionPageDtoCopyWith(_CashSessionPageDto value, $Res Function(_CashSessionPageDto) _then) = __$CashSessionPageDtoCopyWithImpl;
@override @useResult
$Res call({
 List<CashSessionDto> items,@JsonKey(name: 'next_cursor') String? nextCursor,@JsonKey(name: 'has_more') bool hasMore
});




}
/// @nodoc
class __$CashSessionPageDtoCopyWithImpl<$Res>
    implements _$CashSessionPageDtoCopyWith<$Res> {
  __$CashSessionPageDtoCopyWithImpl(this._self, this._then);

  final _CashSessionPageDto _self;
  final $Res Function(_CashSessionPageDto) _then;

/// Create a copy of CashSessionPageDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? nextCursor = freezed,Object? hasMore = null,}) {
  return _then(_CashSessionPageDto(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<CashSessionDto>,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$CashSessionOpenRequestDto {

 String get id;@JsonKey(name: 'device_id') String get deviceId;@JsonKey(name: 'opening_amount') String get openingAmount;@JsonKey(name: 'opening_note') String? get openingNote;@JsonKey(name: 'opened_at') String get openedAt;@JsonKey(name: 'opening_count', includeIfNull: false) List<CashCountLineRequestDto>? get openingCount;
/// Create a copy of CashSessionOpenRequestDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CashSessionOpenRequestDtoCopyWith<CashSessionOpenRequestDto> get copyWith => _$CashSessionOpenRequestDtoCopyWithImpl<CashSessionOpenRequestDto>(this as CashSessionOpenRequestDto, _$identity);

  /// Serializes this CashSessionOpenRequestDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CashSessionOpenRequestDto&&(identical(other.id, id) || other.id == id)&&(identical(other.deviceId, deviceId) || other.deviceId == deviceId)&&(identical(other.openingAmount, openingAmount) || other.openingAmount == openingAmount)&&(identical(other.openingNote, openingNote) || other.openingNote == openingNote)&&(identical(other.openedAt, openedAt) || other.openedAt == openedAt)&&const DeepCollectionEquality().equals(other.openingCount, openingCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,deviceId,openingAmount,openingNote,openedAt,const DeepCollectionEquality().hash(openingCount));

@override
String toString() {
  return 'CashSessionOpenRequestDto(id: $id, deviceId: $deviceId, openingAmount: $openingAmount, openingNote: $openingNote, openedAt: $openedAt, openingCount: $openingCount)';
}


}

/// @nodoc
abstract mixin class $CashSessionOpenRequestDtoCopyWith<$Res>  {
  factory $CashSessionOpenRequestDtoCopyWith(CashSessionOpenRequestDto value, $Res Function(CashSessionOpenRequestDto) _then) = _$CashSessionOpenRequestDtoCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'device_id') String deviceId,@JsonKey(name: 'opening_amount') String openingAmount,@JsonKey(name: 'opening_note') String? openingNote,@JsonKey(name: 'opened_at') String openedAt,@JsonKey(name: 'opening_count', includeIfNull: false) List<CashCountLineRequestDto>? openingCount
});




}
/// @nodoc
class _$CashSessionOpenRequestDtoCopyWithImpl<$Res>
    implements $CashSessionOpenRequestDtoCopyWith<$Res> {
  _$CashSessionOpenRequestDtoCopyWithImpl(this._self, this._then);

  final CashSessionOpenRequestDto _self;
  final $Res Function(CashSessionOpenRequestDto) _then;

/// Create a copy of CashSessionOpenRequestDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? deviceId = null,Object? openingAmount = null,Object? openingNote = freezed,Object? openedAt = null,Object? openingCount = freezed,}) {
  return _then(CashSessionOpenRequestDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,deviceId: null == deviceId ? _self.deviceId : deviceId // ignore: cast_nullable_to_non_nullable
as String,openingAmount: null == openingAmount ? _self.openingAmount : openingAmount // ignore: cast_nullable_to_non_nullable
as String,openingNote: freezed == openingNote ? _self.openingNote : openingNote // ignore: cast_nullable_to_non_nullable
as String?,openedAt: null == openedAt ? _self.openedAt : openedAt // ignore: cast_nullable_to_non_nullable
as String,openingCount: freezed == openingCount ? _self.openingCount : openingCount // ignore: cast_nullable_to_non_nullable
as List<CashCountLineRequestDto>?,
  ));
}

}


/// Adds pattern-matching-related methods to [CashSessionOpenRequestDto].
extension CashSessionOpenRequestDtoPatterns on CashSessionOpenRequestDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CashSessionOpenRequestDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CashSessionOpenRequestDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CashSessionOpenRequestDto value)  $default,){
final _that = this;
switch (_that) {
case _CashSessionOpenRequestDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CashSessionOpenRequestDto value)?  $default,){
final _that = this;
switch (_that) {
case _CashSessionOpenRequestDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'device_id')  String deviceId, @JsonKey(name: 'opening_amount')  String openingAmount, @JsonKey(name: 'opening_note')  String? openingNote, @JsonKey(name: 'opened_at')  String openedAt, @JsonKey(name: 'opening_count', includeIfNull: false)  List<CashCountLineRequestDto>? openingCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CashSessionOpenRequestDto() when $default != null:
return $default(_that.id,_that.deviceId,_that.openingAmount,_that.openingNote,_that.openedAt,_that.openingCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'device_id')  String deviceId, @JsonKey(name: 'opening_amount')  String openingAmount, @JsonKey(name: 'opening_note')  String? openingNote, @JsonKey(name: 'opened_at')  String openedAt, @JsonKey(name: 'opening_count', includeIfNull: false)  List<CashCountLineRequestDto>? openingCount)  $default,) {final _that = this;
switch (_that) {
case _CashSessionOpenRequestDto():
return $default(_that.id,_that.deviceId,_that.openingAmount,_that.openingNote,_that.openedAt,_that.openingCount);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'device_id')  String deviceId, @JsonKey(name: 'opening_amount')  String openingAmount, @JsonKey(name: 'opening_note')  String? openingNote, @JsonKey(name: 'opened_at')  String openedAt, @JsonKey(name: 'opening_count', includeIfNull: false)  List<CashCountLineRequestDto>? openingCount)?  $default,) {final _that = this;
switch (_that) {
case _CashSessionOpenRequestDto() when $default != null:
return $default(_that.id,_that.deviceId,_that.openingAmount,_that.openingNote,_that.openedAt,_that.openingCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CashSessionOpenRequestDto implements CashSessionOpenRequestDto {
  const _CashSessionOpenRequestDto({required this.id, @JsonKey(name: 'device_id') required this.deviceId, @JsonKey(name: 'opening_amount') required this.openingAmount, @JsonKey(name: 'opening_note') this.openingNote, @JsonKey(name: 'opened_at') required this.openedAt, @JsonKey(name: 'opening_count', includeIfNull: false)  List<CashCountLineRequestDto>? openingCount}): _openingCount = openingCount;
  factory _CashSessionOpenRequestDto.fromJson(Map<String, dynamic> json) => _$CashSessionOpenRequestDtoFromJson(json);

@override final  String id;
@override@JsonKey(name: 'device_id') final  String deviceId;
@override@JsonKey(name: 'opening_amount') final  String openingAmount;
@override@JsonKey(name: 'opening_note') final  String? openingNote;
@override@JsonKey(name: 'opened_at') final  String openedAt;
 final  List<CashCountLineRequestDto>? _openingCount;
@override@JsonKey(name: 'opening_count', includeIfNull: false) List<CashCountLineRequestDto>? get openingCount {
  final value = _openingCount;
  if (value == null) return null;
  if (_openingCount is EqualUnmodifiableListView) return _openingCount;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of CashSessionOpenRequestDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CashSessionOpenRequestDtoCopyWith<_CashSessionOpenRequestDto> get copyWith => __$CashSessionOpenRequestDtoCopyWithImpl<_CashSessionOpenRequestDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CashSessionOpenRequestDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CashSessionOpenRequestDto&&(identical(other.id, id) || other.id == id)&&(identical(other.deviceId, deviceId) || other.deviceId == deviceId)&&(identical(other.openingAmount, openingAmount) || other.openingAmount == openingAmount)&&(identical(other.openingNote, openingNote) || other.openingNote == openingNote)&&(identical(other.openedAt, openedAt) || other.openedAt == openedAt)&&const DeepCollectionEquality().equals(other._openingCount, _openingCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,deviceId,openingAmount,openingNote,openedAt,const DeepCollectionEquality().hash(_openingCount));

@override
String toString() {
  return 'CashSessionOpenRequestDto(id: $id, deviceId: $deviceId, openingAmount: $openingAmount, openingNote: $openingNote, openedAt: $openedAt, openingCount: $openingCount)';
}


}

/// @nodoc
abstract mixin class _$CashSessionOpenRequestDtoCopyWith<$Res> implements $CashSessionOpenRequestDtoCopyWith<$Res> {
  factory _$CashSessionOpenRequestDtoCopyWith(_CashSessionOpenRequestDto value, $Res Function(_CashSessionOpenRequestDto) _then) = __$CashSessionOpenRequestDtoCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'device_id') String deviceId,@JsonKey(name: 'opening_amount') String openingAmount,@JsonKey(name: 'opening_note') String? openingNote,@JsonKey(name: 'opened_at') String openedAt,@JsonKey(name: 'opening_count', includeIfNull: false) List<CashCountLineRequestDto>? openingCount
});




}
/// @nodoc
class __$CashSessionOpenRequestDtoCopyWithImpl<$Res>
    implements _$CashSessionOpenRequestDtoCopyWith<$Res> {
  __$CashSessionOpenRequestDtoCopyWithImpl(this._self, this._then);

  final _CashSessionOpenRequestDto _self;
  final $Res Function(_CashSessionOpenRequestDto) _then;

/// Create a copy of CashSessionOpenRequestDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? deviceId = null,Object? openingAmount = null,Object? openingNote = freezed,Object? openedAt = null,Object? openingCount = freezed,}) {
  return _then(_CashSessionOpenRequestDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,deviceId: null == deviceId ? _self.deviceId : deviceId // ignore: cast_nullable_to_non_nullable
as String,openingAmount: null == openingAmount ? _self.openingAmount : openingAmount // ignore: cast_nullable_to_non_nullable
as String,openingNote: freezed == openingNote ? _self.openingNote : openingNote // ignore: cast_nullable_to_non_nullable
as String?,openedAt: null == openedAt ? _self.openedAt : openedAt // ignore: cast_nullable_to_non_nullable
as String,openingCount: freezed == openingCount ? _self._openingCount : openingCount // ignore: cast_nullable_to_non_nullable
as List<CashCountLineRequestDto>?,
  ));
}


}


/// @nodoc
mixin _$CashMovementCreateRequestDto {

 String get id; String get type; String get reason; String get amount; String? get note;@JsonKey(name: 'created_at') String get createdAt;
/// Create a copy of CashMovementCreateRequestDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CashMovementCreateRequestDtoCopyWith<CashMovementCreateRequestDto> get copyWith => _$CashMovementCreateRequestDtoCopyWithImpl<CashMovementCreateRequestDto>(this as CashMovementCreateRequestDto, _$identity);

  /// Serializes this CashMovementCreateRequestDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CashMovementCreateRequestDto&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.note, note) || other.note == note)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,reason,amount,note,createdAt);

@override
String toString() {
  return 'CashMovementCreateRequestDto(id: $id, type: $type, reason: $reason, amount: $amount, note: $note, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $CashMovementCreateRequestDtoCopyWith<$Res>  {
  factory $CashMovementCreateRequestDtoCopyWith(CashMovementCreateRequestDto value, $Res Function(CashMovementCreateRequestDto) _then) = _$CashMovementCreateRequestDtoCopyWithImpl;
@useResult
$Res call({
 String id, String type, String reason, String amount, String? note,@JsonKey(name: 'created_at') String createdAt
});




}
/// @nodoc
class _$CashMovementCreateRequestDtoCopyWithImpl<$Res>
    implements $CashMovementCreateRequestDtoCopyWith<$Res> {
  _$CashMovementCreateRequestDtoCopyWithImpl(this._self, this._then);

  final CashMovementCreateRequestDto _self;
  final $Res Function(CashMovementCreateRequestDto) _then;

/// Create a copy of CashMovementCreateRequestDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? type = null,Object? reason = null,Object? amount = null,Object? note = freezed,Object? createdAt = null,}) {
  return _then(CashMovementCreateRequestDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as String,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CashMovementCreateRequestDto].
extension CashMovementCreateRequestDtoPatterns on CashMovementCreateRequestDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CashMovementCreateRequestDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CashMovementCreateRequestDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CashMovementCreateRequestDto value)  $default,){
final _that = this;
switch (_that) {
case _CashMovementCreateRequestDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CashMovementCreateRequestDto value)?  $default,){
final _that = this;
switch (_that) {
case _CashMovementCreateRequestDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String type,  String reason,  String amount,  String? note, @JsonKey(name: 'created_at')  String createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CashMovementCreateRequestDto() when $default != null:
return $default(_that.id,_that.type,_that.reason,_that.amount,_that.note,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String type,  String reason,  String amount,  String? note, @JsonKey(name: 'created_at')  String createdAt)  $default,) {final _that = this;
switch (_that) {
case _CashMovementCreateRequestDto():
return $default(_that.id,_that.type,_that.reason,_that.amount,_that.note,_that.createdAt);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String type,  String reason,  String amount,  String? note, @JsonKey(name: 'created_at')  String createdAt)?  $default,) {final _that = this;
switch (_that) {
case _CashMovementCreateRequestDto() when $default != null:
return $default(_that.id,_that.type,_that.reason,_that.amount,_that.note,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CashMovementCreateRequestDto implements CashMovementCreateRequestDto {
  const _CashMovementCreateRequestDto({required this.id, required this.type, required this.reason, required this.amount, this.note, @JsonKey(name: 'created_at') required this.createdAt});
  factory _CashMovementCreateRequestDto.fromJson(Map<String, dynamic> json) => _$CashMovementCreateRequestDtoFromJson(json);

@override final  String id;
@override final  String type;
@override final  String reason;
@override final  String amount;
@override final  String? note;
@override@JsonKey(name: 'created_at') final  String createdAt;

/// Create a copy of CashMovementCreateRequestDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CashMovementCreateRequestDtoCopyWith<_CashMovementCreateRequestDto> get copyWith => __$CashMovementCreateRequestDtoCopyWithImpl<_CashMovementCreateRequestDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CashMovementCreateRequestDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CashMovementCreateRequestDto&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.note, note) || other.note == note)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,reason,amount,note,createdAt);

@override
String toString() {
  return 'CashMovementCreateRequestDto(id: $id, type: $type, reason: $reason, amount: $amount, note: $note, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$CashMovementCreateRequestDtoCopyWith<$Res> implements $CashMovementCreateRequestDtoCopyWith<$Res> {
  factory _$CashMovementCreateRequestDtoCopyWith(_CashMovementCreateRequestDto value, $Res Function(_CashMovementCreateRequestDto) _then) = __$CashMovementCreateRequestDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, String type, String reason, String amount, String? note,@JsonKey(name: 'created_at') String createdAt
});




}
/// @nodoc
class __$CashMovementCreateRequestDtoCopyWithImpl<$Res>
    implements _$CashMovementCreateRequestDtoCopyWith<$Res> {
  __$CashMovementCreateRequestDtoCopyWithImpl(this._self, this._then);

  final _CashMovementCreateRequestDto _self;
  final $Res Function(_CashMovementCreateRequestDto) _then;

/// Create a copy of CashMovementCreateRequestDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? type = null,Object? reason = null,Object? amount = null,Object? note = freezed,Object? createdAt = null,}) {
  return _then(_CashMovementCreateRequestDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as String,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$CashSessionCloseRequestDto {

@JsonKey(name: 'counted_amount') String get countedAmount;@JsonKey(name: 'client_expected_amount') String get clientExpectedAmount;@JsonKey(name: 'closing_note') String? get closingNote;@JsonKey(name: 'closed_at') String get closedAt;@JsonKey(name: 'closing_count', includeIfNull: false) List<CashCountLineRequestDto>? get closingCount;
/// Create a copy of CashSessionCloseRequestDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CashSessionCloseRequestDtoCopyWith<CashSessionCloseRequestDto> get copyWith => _$CashSessionCloseRequestDtoCopyWithImpl<CashSessionCloseRequestDto>(this as CashSessionCloseRequestDto, _$identity);

  /// Serializes this CashSessionCloseRequestDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CashSessionCloseRequestDto&&(identical(other.countedAmount, countedAmount) || other.countedAmount == countedAmount)&&(identical(other.clientExpectedAmount, clientExpectedAmount) || other.clientExpectedAmount == clientExpectedAmount)&&(identical(other.closingNote, closingNote) || other.closingNote == closingNote)&&(identical(other.closedAt, closedAt) || other.closedAt == closedAt)&&const DeepCollectionEquality().equals(other.closingCount, closingCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,countedAmount,clientExpectedAmount,closingNote,closedAt,const DeepCollectionEquality().hash(closingCount));

@override
String toString() {
  return 'CashSessionCloseRequestDto(countedAmount: $countedAmount, clientExpectedAmount: $clientExpectedAmount, closingNote: $closingNote, closedAt: $closedAt, closingCount: $closingCount)';
}


}

/// @nodoc
abstract mixin class $CashSessionCloseRequestDtoCopyWith<$Res>  {
  factory $CashSessionCloseRequestDtoCopyWith(CashSessionCloseRequestDto value, $Res Function(CashSessionCloseRequestDto) _then) = _$CashSessionCloseRequestDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'counted_amount') String countedAmount,@JsonKey(name: 'client_expected_amount') String clientExpectedAmount,@JsonKey(name: 'closing_note') String? closingNote,@JsonKey(name: 'closed_at') String closedAt,@JsonKey(name: 'closing_count', includeIfNull: false) List<CashCountLineRequestDto>? closingCount
});




}
/// @nodoc
class _$CashSessionCloseRequestDtoCopyWithImpl<$Res>
    implements $CashSessionCloseRequestDtoCopyWith<$Res> {
  _$CashSessionCloseRequestDtoCopyWithImpl(this._self, this._then);

  final CashSessionCloseRequestDto _self;
  final $Res Function(CashSessionCloseRequestDto) _then;

/// Create a copy of CashSessionCloseRequestDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? countedAmount = null,Object? clientExpectedAmount = null,Object? closingNote = freezed,Object? closedAt = null,Object? closingCount = freezed,}) {
  return _then(CashSessionCloseRequestDto(
countedAmount: null == countedAmount ? _self.countedAmount : countedAmount // ignore: cast_nullable_to_non_nullable
as String,clientExpectedAmount: null == clientExpectedAmount ? _self.clientExpectedAmount : clientExpectedAmount // ignore: cast_nullable_to_non_nullable
as String,closingNote: freezed == closingNote ? _self.closingNote : closingNote // ignore: cast_nullable_to_non_nullable
as String?,closedAt: null == closedAt ? _self.closedAt : closedAt // ignore: cast_nullable_to_non_nullable
as String,closingCount: freezed == closingCount ? _self.closingCount : closingCount // ignore: cast_nullable_to_non_nullable
as List<CashCountLineRequestDto>?,
  ));
}

}


/// Adds pattern-matching-related methods to [CashSessionCloseRequestDto].
extension CashSessionCloseRequestDtoPatterns on CashSessionCloseRequestDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CashSessionCloseRequestDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CashSessionCloseRequestDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CashSessionCloseRequestDto value)  $default,){
final _that = this;
switch (_that) {
case _CashSessionCloseRequestDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CashSessionCloseRequestDto value)?  $default,){
final _that = this;
switch (_that) {
case _CashSessionCloseRequestDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'counted_amount')  String countedAmount, @JsonKey(name: 'client_expected_amount')  String clientExpectedAmount, @JsonKey(name: 'closing_note')  String? closingNote, @JsonKey(name: 'closed_at')  String closedAt, @JsonKey(name: 'closing_count', includeIfNull: false)  List<CashCountLineRequestDto>? closingCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CashSessionCloseRequestDto() when $default != null:
return $default(_that.countedAmount,_that.clientExpectedAmount,_that.closingNote,_that.closedAt,_that.closingCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'counted_amount')  String countedAmount, @JsonKey(name: 'client_expected_amount')  String clientExpectedAmount, @JsonKey(name: 'closing_note')  String? closingNote, @JsonKey(name: 'closed_at')  String closedAt, @JsonKey(name: 'closing_count', includeIfNull: false)  List<CashCountLineRequestDto>? closingCount)  $default,) {final _that = this;
switch (_that) {
case _CashSessionCloseRequestDto():
return $default(_that.countedAmount,_that.clientExpectedAmount,_that.closingNote,_that.closedAt,_that.closingCount);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'counted_amount')  String countedAmount, @JsonKey(name: 'client_expected_amount')  String clientExpectedAmount, @JsonKey(name: 'closing_note')  String? closingNote, @JsonKey(name: 'closed_at')  String closedAt, @JsonKey(name: 'closing_count', includeIfNull: false)  List<CashCountLineRequestDto>? closingCount)?  $default,) {final _that = this;
switch (_that) {
case _CashSessionCloseRequestDto() when $default != null:
return $default(_that.countedAmount,_that.clientExpectedAmount,_that.closingNote,_that.closedAt,_that.closingCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CashSessionCloseRequestDto implements CashSessionCloseRequestDto {
  const _CashSessionCloseRequestDto({@JsonKey(name: 'counted_amount') required this.countedAmount, @JsonKey(name: 'client_expected_amount') required this.clientExpectedAmount, @JsonKey(name: 'closing_note') this.closingNote, @JsonKey(name: 'closed_at') required this.closedAt, @JsonKey(name: 'closing_count', includeIfNull: false)  List<CashCountLineRequestDto>? closingCount}): _closingCount = closingCount;
  factory _CashSessionCloseRequestDto.fromJson(Map<String, dynamic> json) => _$CashSessionCloseRequestDtoFromJson(json);

@override@JsonKey(name: 'counted_amount') final  String countedAmount;
@override@JsonKey(name: 'client_expected_amount') final  String clientExpectedAmount;
@override@JsonKey(name: 'closing_note') final  String? closingNote;
@override@JsonKey(name: 'closed_at') final  String closedAt;
 final  List<CashCountLineRequestDto>? _closingCount;
@override@JsonKey(name: 'closing_count', includeIfNull: false) List<CashCountLineRequestDto>? get closingCount {
  final value = _closingCount;
  if (value == null) return null;
  if (_closingCount is EqualUnmodifiableListView) return _closingCount;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of CashSessionCloseRequestDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CashSessionCloseRequestDtoCopyWith<_CashSessionCloseRequestDto> get copyWith => __$CashSessionCloseRequestDtoCopyWithImpl<_CashSessionCloseRequestDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CashSessionCloseRequestDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CashSessionCloseRequestDto&&(identical(other.countedAmount, countedAmount) || other.countedAmount == countedAmount)&&(identical(other.clientExpectedAmount, clientExpectedAmount) || other.clientExpectedAmount == clientExpectedAmount)&&(identical(other.closingNote, closingNote) || other.closingNote == closingNote)&&(identical(other.closedAt, closedAt) || other.closedAt == closedAt)&&const DeepCollectionEquality().equals(other._closingCount, _closingCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,countedAmount,clientExpectedAmount,closingNote,closedAt,const DeepCollectionEquality().hash(_closingCount));

@override
String toString() {
  return 'CashSessionCloseRequestDto(countedAmount: $countedAmount, clientExpectedAmount: $clientExpectedAmount, closingNote: $closingNote, closedAt: $closedAt, closingCount: $closingCount)';
}


}

/// @nodoc
abstract mixin class _$CashSessionCloseRequestDtoCopyWith<$Res> implements $CashSessionCloseRequestDtoCopyWith<$Res> {
  factory _$CashSessionCloseRequestDtoCopyWith(_CashSessionCloseRequestDto value, $Res Function(_CashSessionCloseRequestDto) _then) = __$CashSessionCloseRequestDtoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'counted_amount') String countedAmount,@JsonKey(name: 'client_expected_amount') String clientExpectedAmount,@JsonKey(name: 'closing_note') String? closingNote,@JsonKey(name: 'closed_at') String closedAt,@JsonKey(name: 'closing_count', includeIfNull: false) List<CashCountLineRequestDto>? closingCount
});




}
/// @nodoc
class __$CashSessionCloseRequestDtoCopyWithImpl<$Res>
    implements _$CashSessionCloseRequestDtoCopyWith<$Res> {
  __$CashSessionCloseRequestDtoCopyWithImpl(this._self, this._then);

  final _CashSessionCloseRequestDto _self;
  final $Res Function(_CashSessionCloseRequestDto) _then;

/// Create a copy of CashSessionCloseRequestDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? countedAmount = null,Object? clientExpectedAmount = null,Object? closingNote = freezed,Object? closedAt = null,Object? closingCount = freezed,}) {
  return _then(_CashSessionCloseRequestDto(
countedAmount: null == countedAmount ? _self.countedAmount : countedAmount // ignore: cast_nullable_to_non_nullable
as String,clientExpectedAmount: null == clientExpectedAmount ? _self.clientExpectedAmount : clientExpectedAmount // ignore: cast_nullable_to_non_nullable
as String,closingNote: freezed == closingNote ? _self.closingNote : closingNote // ignore: cast_nullable_to_non_nullable
as String?,closedAt: null == closedAt ? _self.closedAt : closedAt // ignore: cast_nullable_to_non_nullable
as String,closingCount: freezed == closingCount ? _self._closingCount : closingCount // ignore: cast_nullable_to_non_nullable
as List<CashCountLineRequestDto>?,
  ));
}


}


/// @nodoc
mixin _$CashCountLineRequestDto {

@JsonKey(name: 'denomination_type') String get denominationType; int get denomination; int get quantity;
/// Create a copy of CashCountLineRequestDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CashCountLineRequestDtoCopyWith<CashCountLineRequestDto> get copyWith => _$CashCountLineRequestDtoCopyWithImpl<CashCountLineRequestDto>(this as CashCountLineRequestDto, _$identity);

  /// Serializes this CashCountLineRequestDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CashCountLineRequestDto&&(identical(other.denominationType, denominationType) || other.denominationType == denominationType)&&(identical(other.denomination, denomination) || other.denomination == denomination)&&(identical(other.quantity, quantity) || other.quantity == quantity));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,denominationType,denomination,quantity);

@override
String toString() {
  return 'CashCountLineRequestDto(denominationType: $denominationType, denomination: $denomination, quantity: $quantity)';
}


}

/// @nodoc
abstract mixin class $CashCountLineRequestDtoCopyWith<$Res>  {
  factory $CashCountLineRequestDtoCopyWith(CashCountLineRequestDto value, $Res Function(CashCountLineRequestDto) _then) = _$CashCountLineRequestDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'denomination_type') String denominationType, int denomination, int quantity
});




}
/// @nodoc
class _$CashCountLineRequestDtoCopyWithImpl<$Res>
    implements $CashCountLineRequestDtoCopyWith<$Res> {
  _$CashCountLineRequestDtoCopyWithImpl(this._self, this._then);

  final CashCountLineRequestDto _self;
  final $Res Function(CashCountLineRequestDto) _then;

/// Create a copy of CashCountLineRequestDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? denominationType = null,Object? denomination = null,Object? quantity = null,}) {
  return _then(CashCountLineRequestDto(
denominationType: null == denominationType ? _self.denominationType : denominationType // ignore: cast_nullable_to_non_nullable
as String,denomination: null == denomination ? _self.denomination : denomination // ignore: cast_nullable_to_non_nullable
as int,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [CashCountLineRequestDto].
extension CashCountLineRequestDtoPatterns on CashCountLineRequestDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CashCountLineRequestDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CashCountLineRequestDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CashCountLineRequestDto value)  $default,){
final _that = this;
switch (_that) {
case _CashCountLineRequestDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CashCountLineRequestDto value)?  $default,){
final _that = this;
switch (_that) {
case _CashCountLineRequestDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'denomination_type')  String denominationType,  int denomination,  int quantity)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CashCountLineRequestDto() when $default != null:
return $default(_that.denominationType,_that.denomination,_that.quantity);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'denomination_type')  String denominationType,  int denomination,  int quantity)  $default,) {final _that = this;
switch (_that) {
case _CashCountLineRequestDto():
return $default(_that.denominationType,_that.denomination,_that.quantity);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'denomination_type')  String denominationType,  int denomination,  int quantity)?  $default,) {final _that = this;
switch (_that) {
case _CashCountLineRequestDto() when $default != null:
return $default(_that.denominationType,_that.denomination,_that.quantity);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CashCountLineRequestDto implements CashCountLineRequestDto {
  const _CashCountLineRequestDto({@JsonKey(name: 'denomination_type') required this.denominationType, required this.denomination, required this.quantity});
  factory _CashCountLineRequestDto.fromJson(Map<String, dynamic> json) => _$CashCountLineRequestDtoFromJson(json);

@override@JsonKey(name: 'denomination_type') final  String denominationType;
@override final  int denomination;
@override final  int quantity;

/// Create a copy of CashCountLineRequestDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CashCountLineRequestDtoCopyWith<_CashCountLineRequestDto> get copyWith => __$CashCountLineRequestDtoCopyWithImpl<_CashCountLineRequestDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CashCountLineRequestDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CashCountLineRequestDto&&(identical(other.denominationType, denominationType) || other.denominationType == denominationType)&&(identical(other.denomination, denomination) || other.denomination == denomination)&&(identical(other.quantity, quantity) || other.quantity == quantity));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,denominationType,denomination,quantity);

@override
String toString() {
  return 'CashCountLineRequestDto(denominationType: $denominationType, denomination: $denomination, quantity: $quantity)';
}


}

/// @nodoc
abstract mixin class _$CashCountLineRequestDtoCopyWith<$Res> implements $CashCountLineRequestDtoCopyWith<$Res> {
  factory _$CashCountLineRequestDtoCopyWith(_CashCountLineRequestDto value, $Res Function(_CashCountLineRequestDto) _then) = __$CashCountLineRequestDtoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'denomination_type') String denominationType, int denomination, int quantity
});




}
/// @nodoc
class __$CashCountLineRequestDtoCopyWithImpl<$Res>
    implements _$CashCountLineRequestDtoCopyWith<$Res> {
  __$CashCountLineRequestDtoCopyWithImpl(this._self, this._then);

  final _CashCountLineRequestDto _self;
  final $Res Function(_CashCountLineRequestDto) _then;

/// Create a copy of CashCountLineRequestDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? denominationType = null,Object? denomination = null,Object? quantity = null,}) {
  return _then(_CashCountLineRequestDto(
denominationType: null == denominationType ? _self.denominationType : denominationType // ignore: cast_nullable_to_non_nullable
as String,denomination: null == denomination ? _self.denomination : denomination // ignore: cast_nullable_to_non_nullable
as int,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
