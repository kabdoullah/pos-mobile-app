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
mixin _$CashSessionDetailDto {

 CashSessionDto get session; CashSummaryDto get summary; List<CashMovementDto> get movements;
/// Create a copy of CashSessionDetailDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CashSessionDetailDtoCopyWith<CashSessionDetailDto> get copyWith => _$CashSessionDetailDtoCopyWithImpl<CashSessionDetailDto>(this as CashSessionDetailDto, _$identity);

  /// Serializes this CashSessionDetailDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CashSessionDetailDto&&(identical(other.session, session) || other.session == session)&&(identical(other.summary, summary) || other.summary == summary)&&const DeepCollectionEquality().equals(other.movements, movements));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,session,summary,const DeepCollectionEquality().hash(movements));

@override
String toString() {
  return 'CashSessionDetailDto(session: $session, summary: $summary, movements: $movements)';
}


}

/// @nodoc
abstract mixin class $CashSessionDetailDtoCopyWith<$Res>  {
  factory $CashSessionDetailDtoCopyWith(CashSessionDetailDto value, $Res Function(CashSessionDetailDto) _then) = _$CashSessionDetailDtoCopyWithImpl;
@useResult
$Res call({
 CashSessionDto session, CashSummaryDto summary, List<CashMovementDto> movements
});


$CashSessionDtoCopyWith<$Res> get session;$CashSummaryDtoCopyWith<$Res> get summary;

}
/// @nodoc
class _$CashSessionDetailDtoCopyWithImpl<$Res>
    implements $CashSessionDetailDtoCopyWith<$Res> {
  _$CashSessionDetailDtoCopyWithImpl(this._self, this._then);

  final CashSessionDetailDto _self;
  final $Res Function(CashSessionDetailDto) _then;

/// Create a copy of CashSessionDetailDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? session = null,Object? summary = null,Object? movements = null,}) {
  return _then(CashSessionDetailDto(
session: null == session ? _self.session : session // ignore: cast_nullable_to_non_nullable
as CashSessionDto,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as CashSummaryDto,movements: null == movements ? _self.movements : movements // ignore: cast_nullable_to_non_nullable
as List<CashMovementDto>,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( CashSessionDto session,  CashSummaryDto summary,  List<CashMovementDto> movements)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CashSessionDetailDto() when $default != null:
return $default(_that.session,_that.summary,_that.movements);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( CashSessionDto session,  CashSummaryDto summary,  List<CashMovementDto> movements)  $default,) {final _that = this;
switch (_that) {
case _CashSessionDetailDto():
return $default(_that.session,_that.summary,_that.movements);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( CashSessionDto session,  CashSummaryDto summary,  List<CashMovementDto> movements)?  $default,) {final _that = this;
switch (_that) {
case _CashSessionDetailDto() when $default != null:
return $default(_that.session,_that.summary,_that.movements);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CashSessionDetailDto implements CashSessionDetailDto {
  const _CashSessionDetailDto({required this.session, required this.summary, required  List<CashMovementDto> movements}): _movements = movements;
  factory _CashSessionDetailDto.fromJson(Map<String, dynamic> json) => _$CashSessionDetailDtoFromJson(json);

@override final  CashSessionDto session;
@override final  CashSummaryDto summary;
 final  List<CashMovementDto> _movements;
@override List<CashMovementDto> get movements {
  if (_movements is EqualUnmodifiableListView) return _movements;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_movements);
}


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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CashSessionDetailDto&&(identical(other.session, session) || other.session == session)&&(identical(other.summary, summary) || other.summary == summary)&&const DeepCollectionEquality().equals(other._movements, _movements));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,session,summary,const DeepCollectionEquality().hash(_movements));

@override
String toString() {
  return 'CashSessionDetailDto(session: $session, summary: $summary, movements: $movements)';
}


}

/// @nodoc
abstract mixin class _$CashSessionDetailDtoCopyWith<$Res> implements $CashSessionDetailDtoCopyWith<$Res> {
  factory _$CashSessionDetailDtoCopyWith(_CashSessionDetailDto value, $Res Function(_CashSessionDetailDto) _then) = __$CashSessionDetailDtoCopyWithImpl;
@override @useResult
$Res call({
 CashSessionDto session, CashSummaryDto summary, List<CashMovementDto> movements
});


@override $CashSessionDtoCopyWith<$Res> get session;@override $CashSummaryDtoCopyWith<$Res> get summary;

}
/// @nodoc
class __$CashSessionDetailDtoCopyWithImpl<$Res>
    implements _$CashSessionDetailDtoCopyWith<$Res> {
  __$CashSessionDetailDtoCopyWithImpl(this._self, this._then);

  final _CashSessionDetailDto _self;
  final $Res Function(_CashSessionDetailDto) _then;

/// Create a copy of CashSessionDetailDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? session = null,Object? summary = null,Object? movements = null,}) {
  return _then(_CashSessionDetailDto(
session: null == session ? _self.session : session // ignore: cast_nullable_to_non_nullable
as CashSessionDto,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as CashSummaryDto,movements: null == movements ? _self._movements : movements // ignore: cast_nullable_to_non_nullable
as List<CashMovementDto>,
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

 String get id;@JsonKey(name: 'device_id') String get deviceId;@JsonKey(name: 'opening_amount') String get openingAmount;@JsonKey(name: 'opening_note') String? get openingNote;@JsonKey(name: 'opened_at') String get openedAt;
/// Create a copy of CashSessionOpenRequestDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CashSessionOpenRequestDtoCopyWith<CashSessionOpenRequestDto> get copyWith => _$CashSessionOpenRequestDtoCopyWithImpl<CashSessionOpenRequestDto>(this as CashSessionOpenRequestDto, _$identity);

  /// Serializes this CashSessionOpenRequestDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CashSessionOpenRequestDto&&(identical(other.id, id) || other.id == id)&&(identical(other.deviceId, deviceId) || other.deviceId == deviceId)&&(identical(other.openingAmount, openingAmount) || other.openingAmount == openingAmount)&&(identical(other.openingNote, openingNote) || other.openingNote == openingNote)&&(identical(other.openedAt, openedAt) || other.openedAt == openedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,deviceId,openingAmount,openingNote,openedAt);

@override
String toString() {
  return 'CashSessionOpenRequestDto(id: $id, deviceId: $deviceId, openingAmount: $openingAmount, openingNote: $openingNote, openedAt: $openedAt)';
}


}

/// @nodoc
abstract mixin class $CashSessionOpenRequestDtoCopyWith<$Res>  {
  factory $CashSessionOpenRequestDtoCopyWith(CashSessionOpenRequestDto value, $Res Function(CashSessionOpenRequestDto) _then) = _$CashSessionOpenRequestDtoCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'device_id') String deviceId,@JsonKey(name: 'opening_amount') String openingAmount,@JsonKey(name: 'opening_note') String? openingNote,@JsonKey(name: 'opened_at') String openedAt
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
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? deviceId = null,Object? openingAmount = null,Object? openingNote = freezed,Object? openedAt = null,}) {
  return _then(CashSessionOpenRequestDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,deviceId: null == deviceId ? _self.deviceId : deviceId // ignore: cast_nullable_to_non_nullable
as String,openingAmount: null == openingAmount ? _self.openingAmount : openingAmount // ignore: cast_nullable_to_non_nullable
as String,openingNote: freezed == openingNote ? _self.openingNote : openingNote // ignore: cast_nullable_to_non_nullable
as String?,openedAt: null == openedAt ? _self.openedAt : openedAt // ignore: cast_nullable_to_non_nullable
as String,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'device_id')  String deviceId, @JsonKey(name: 'opening_amount')  String openingAmount, @JsonKey(name: 'opening_note')  String? openingNote, @JsonKey(name: 'opened_at')  String openedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CashSessionOpenRequestDto() when $default != null:
return $default(_that.id,_that.deviceId,_that.openingAmount,_that.openingNote,_that.openedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'device_id')  String deviceId, @JsonKey(name: 'opening_amount')  String openingAmount, @JsonKey(name: 'opening_note')  String? openingNote, @JsonKey(name: 'opened_at')  String openedAt)  $default,) {final _that = this;
switch (_that) {
case _CashSessionOpenRequestDto():
return $default(_that.id,_that.deviceId,_that.openingAmount,_that.openingNote,_that.openedAt);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'device_id')  String deviceId, @JsonKey(name: 'opening_amount')  String openingAmount, @JsonKey(name: 'opening_note')  String? openingNote, @JsonKey(name: 'opened_at')  String openedAt)?  $default,) {final _that = this;
switch (_that) {
case _CashSessionOpenRequestDto() when $default != null:
return $default(_that.id,_that.deviceId,_that.openingAmount,_that.openingNote,_that.openedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CashSessionOpenRequestDto implements CashSessionOpenRequestDto {
  const _CashSessionOpenRequestDto({required this.id, @JsonKey(name: 'device_id') required this.deviceId, @JsonKey(name: 'opening_amount') required this.openingAmount, @JsonKey(name: 'opening_note') this.openingNote, @JsonKey(name: 'opened_at') required this.openedAt});
  factory _CashSessionOpenRequestDto.fromJson(Map<String, dynamic> json) => _$CashSessionOpenRequestDtoFromJson(json);

@override final  String id;
@override@JsonKey(name: 'device_id') final  String deviceId;
@override@JsonKey(name: 'opening_amount') final  String openingAmount;
@override@JsonKey(name: 'opening_note') final  String? openingNote;
@override@JsonKey(name: 'opened_at') final  String openedAt;

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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CashSessionOpenRequestDto&&(identical(other.id, id) || other.id == id)&&(identical(other.deviceId, deviceId) || other.deviceId == deviceId)&&(identical(other.openingAmount, openingAmount) || other.openingAmount == openingAmount)&&(identical(other.openingNote, openingNote) || other.openingNote == openingNote)&&(identical(other.openedAt, openedAt) || other.openedAt == openedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,deviceId,openingAmount,openingNote,openedAt);

@override
String toString() {
  return 'CashSessionOpenRequestDto(id: $id, deviceId: $deviceId, openingAmount: $openingAmount, openingNote: $openingNote, openedAt: $openedAt)';
}


}

/// @nodoc
abstract mixin class _$CashSessionOpenRequestDtoCopyWith<$Res> implements $CashSessionOpenRequestDtoCopyWith<$Res> {
  factory _$CashSessionOpenRequestDtoCopyWith(_CashSessionOpenRequestDto value, $Res Function(_CashSessionOpenRequestDto) _then) = __$CashSessionOpenRequestDtoCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'device_id') String deviceId,@JsonKey(name: 'opening_amount') String openingAmount,@JsonKey(name: 'opening_note') String? openingNote,@JsonKey(name: 'opened_at') String openedAt
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
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? deviceId = null,Object? openingAmount = null,Object? openingNote = freezed,Object? openedAt = null,}) {
  return _then(_CashSessionOpenRequestDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,deviceId: null == deviceId ? _self.deviceId : deviceId // ignore: cast_nullable_to_non_nullable
as String,openingAmount: null == openingAmount ? _self.openingAmount : openingAmount // ignore: cast_nullable_to_non_nullable
as String,openingNote: freezed == openingNote ? _self.openingNote : openingNote // ignore: cast_nullable_to_non_nullable
as String?,openedAt: null == openedAt ? _self.openedAt : openedAt // ignore: cast_nullable_to_non_nullable
as String,
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

@JsonKey(name: 'counted_amount') String get countedAmount;@JsonKey(name: 'client_expected_amount') String get clientExpectedAmount;@JsonKey(name: 'closing_note') String? get closingNote;@JsonKey(name: 'closed_at') String get closedAt;
/// Create a copy of CashSessionCloseRequestDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CashSessionCloseRequestDtoCopyWith<CashSessionCloseRequestDto> get copyWith => _$CashSessionCloseRequestDtoCopyWithImpl<CashSessionCloseRequestDto>(this as CashSessionCloseRequestDto, _$identity);

  /// Serializes this CashSessionCloseRequestDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CashSessionCloseRequestDto&&(identical(other.countedAmount, countedAmount) || other.countedAmount == countedAmount)&&(identical(other.clientExpectedAmount, clientExpectedAmount) || other.clientExpectedAmount == clientExpectedAmount)&&(identical(other.closingNote, closingNote) || other.closingNote == closingNote)&&(identical(other.closedAt, closedAt) || other.closedAt == closedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,countedAmount,clientExpectedAmount,closingNote,closedAt);

@override
String toString() {
  return 'CashSessionCloseRequestDto(countedAmount: $countedAmount, clientExpectedAmount: $clientExpectedAmount, closingNote: $closingNote, closedAt: $closedAt)';
}


}

/// @nodoc
abstract mixin class $CashSessionCloseRequestDtoCopyWith<$Res>  {
  factory $CashSessionCloseRequestDtoCopyWith(CashSessionCloseRequestDto value, $Res Function(CashSessionCloseRequestDto) _then) = _$CashSessionCloseRequestDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'counted_amount') String countedAmount,@JsonKey(name: 'client_expected_amount') String clientExpectedAmount,@JsonKey(name: 'closing_note') String? closingNote,@JsonKey(name: 'closed_at') String closedAt
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
@pragma('vm:prefer-inline') @override $Res call({Object? countedAmount = null,Object? clientExpectedAmount = null,Object? closingNote = freezed,Object? closedAt = null,}) {
  return _then(CashSessionCloseRequestDto(
countedAmount: null == countedAmount ? _self.countedAmount : countedAmount // ignore: cast_nullable_to_non_nullable
as String,clientExpectedAmount: null == clientExpectedAmount ? _self.clientExpectedAmount : clientExpectedAmount // ignore: cast_nullable_to_non_nullable
as String,closingNote: freezed == closingNote ? _self.closingNote : closingNote // ignore: cast_nullable_to_non_nullable
as String?,closedAt: null == closedAt ? _self.closedAt : closedAt // ignore: cast_nullable_to_non_nullable
as String,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'counted_amount')  String countedAmount, @JsonKey(name: 'client_expected_amount')  String clientExpectedAmount, @JsonKey(name: 'closing_note')  String? closingNote, @JsonKey(name: 'closed_at')  String closedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CashSessionCloseRequestDto() when $default != null:
return $default(_that.countedAmount,_that.clientExpectedAmount,_that.closingNote,_that.closedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'counted_amount')  String countedAmount, @JsonKey(name: 'client_expected_amount')  String clientExpectedAmount, @JsonKey(name: 'closing_note')  String? closingNote, @JsonKey(name: 'closed_at')  String closedAt)  $default,) {final _that = this;
switch (_that) {
case _CashSessionCloseRequestDto():
return $default(_that.countedAmount,_that.clientExpectedAmount,_that.closingNote,_that.closedAt);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'counted_amount')  String countedAmount, @JsonKey(name: 'client_expected_amount')  String clientExpectedAmount, @JsonKey(name: 'closing_note')  String? closingNote, @JsonKey(name: 'closed_at')  String closedAt)?  $default,) {final _that = this;
switch (_that) {
case _CashSessionCloseRequestDto() when $default != null:
return $default(_that.countedAmount,_that.clientExpectedAmount,_that.closingNote,_that.closedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CashSessionCloseRequestDto implements CashSessionCloseRequestDto {
  const _CashSessionCloseRequestDto({@JsonKey(name: 'counted_amount') required this.countedAmount, @JsonKey(name: 'client_expected_amount') required this.clientExpectedAmount, @JsonKey(name: 'closing_note') this.closingNote, @JsonKey(name: 'closed_at') required this.closedAt});
  factory _CashSessionCloseRequestDto.fromJson(Map<String, dynamic> json) => _$CashSessionCloseRequestDtoFromJson(json);

@override@JsonKey(name: 'counted_amount') final  String countedAmount;
@override@JsonKey(name: 'client_expected_amount') final  String clientExpectedAmount;
@override@JsonKey(name: 'closing_note') final  String? closingNote;
@override@JsonKey(name: 'closed_at') final  String closedAt;

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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CashSessionCloseRequestDto&&(identical(other.countedAmount, countedAmount) || other.countedAmount == countedAmount)&&(identical(other.clientExpectedAmount, clientExpectedAmount) || other.clientExpectedAmount == clientExpectedAmount)&&(identical(other.closingNote, closingNote) || other.closingNote == closingNote)&&(identical(other.closedAt, closedAt) || other.closedAt == closedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,countedAmount,clientExpectedAmount,closingNote,closedAt);

@override
String toString() {
  return 'CashSessionCloseRequestDto(countedAmount: $countedAmount, clientExpectedAmount: $clientExpectedAmount, closingNote: $closingNote, closedAt: $closedAt)';
}


}

/// @nodoc
abstract mixin class _$CashSessionCloseRequestDtoCopyWith<$Res> implements $CashSessionCloseRequestDtoCopyWith<$Res> {
  factory _$CashSessionCloseRequestDtoCopyWith(_CashSessionCloseRequestDto value, $Res Function(_CashSessionCloseRequestDto) _then) = __$CashSessionCloseRequestDtoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'counted_amount') String countedAmount,@JsonKey(name: 'client_expected_amount') String clientExpectedAmount,@JsonKey(name: 'closing_note') String? closingNote,@JsonKey(name: 'closed_at') String closedAt
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
@override @pragma('vm:prefer-inline') $Res call({Object? countedAmount = null,Object? clientExpectedAmount = null,Object? closingNote = freezed,Object? closedAt = null,}) {
  return _then(_CashSessionCloseRequestDto(
countedAmount: null == countedAmount ? _self.countedAmount : countedAmount // ignore: cast_nullable_to_non_nullable
as String,clientExpectedAmount: null == clientExpectedAmount ? _self.clientExpectedAmount : clientExpectedAmount // ignore: cast_nullable_to_non_nullable
as String,closingNote: freezed == closingNote ? _self.closingNote : closingNote // ignore: cast_nullable_to_non_nullable
as String?,closedAt: null == closedAt ? _self.closedAt : closedAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
