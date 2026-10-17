// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sale_return.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SaleReturnLine {

 String get id; String get saleItemId; String? get productId; int get quantity; ItemCondition get condition;/// L'article a réintégré le stock disponible.
 bool get restocked; Decimal get refundAmount;
/// Create a copy of SaleReturnLine
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SaleReturnLineCopyWith<SaleReturnLine> get copyWith => _$SaleReturnLineCopyWithImpl<SaleReturnLine>(this as SaleReturnLine, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SaleReturnLine&&(identical(other.id, id) || other.id == id)&&(identical(other.saleItemId, saleItemId) || other.saleItemId == saleItemId)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.condition, condition) || other.condition == condition)&&(identical(other.restocked, restocked) || other.restocked == restocked)&&(identical(other.refundAmount, refundAmount) || other.refundAmount == refundAmount));
}


@override
int get hashCode => Object.hash(runtimeType,id,saleItemId,productId,quantity,condition,restocked,refundAmount);

@override
String toString() {
  return 'SaleReturnLine(id: $id, saleItemId: $saleItemId, productId: $productId, quantity: $quantity, condition: $condition, restocked: $restocked, refundAmount: $refundAmount)';
}


}

/// @nodoc
abstract mixin class $SaleReturnLineCopyWith<$Res>  {
  factory $SaleReturnLineCopyWith(SaleReturnLine value, $Res Function(SaleReturnLine) _then) = _$SaleReturnLineCopyWithImpl;
@useResult
$Res call({
 String id, String saleItemId, String? productId, int quantity, ItemCondition condition, bool restocked, Decimal refundAmount
});




}
/// @nodoc
class _$SaleReturnLineCopyWithImpl<$Res>
    implements $SaleReturnLineCopyWith<$Res> {
  _$SaleReturnLineCopyWithImpl(this._self, this._then);

  final SaleReturnLine _self;
  final $Res Function(SaleReturnLine) _then;

/// Create a copy of SaleReturnLine
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? saleItemId = null,Object? productId = freezed,Object? quantity = null,Object? condition = null,Object? restocked = null,Object? refundAmount = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,saleItemId: null == saleItemId ? _self.saleItemId : saleItemId // ignore: cast_nullable_to_non_nullable
as String,productId: freezed == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String?,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,condition: null == condition ? _self.condition : condition // ignore: cast_nullable_to_non_nullable
as ItemCondition,restocked: null == restocked ? _self.restocked : restocked // ignore: cast_nullable_to_non_nullable
as bool,refundAmount: null == refundAmount ? _self.refundAmount : refundAmount // ignore: cast_nullable_to_non_nullable
as Decimal,
  ));
}

}


/// Adds pattern-matching-related methods to [SaleReturnLine].
extension SaleReturnLinePatterns on SaleReturnLine {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SaleReturnLine value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SaleReturnLine() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SaleReturnLine value)  $default,){
final _that = this;
switch (_that) {
case _SaleReturnLine():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SaleReturnLine value)?  $default,){
final _that = this;
switch (_that) {
case _SaleReturnLine() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String saleItemId,  String? productId,  int quantity,  ItemCondition condition,  bool restocked,  Decimal refundAmount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SaleReturnLine() when $default != null:
return $default(_that.id,_that.saleItemId,_that.productId,_that.quantity,_that.condition,_that.restocked,_that.refundAmount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String saleItemId,  String? productId,  int quantity,  ItemCondition condition,  bool restocked,  Decimal refundAmount)  $default,) {final _that = this;
switch (_that) {
case _SaleReturnLine():
return $default(_that.id,_that.saleItemId,_that.productId,_that.quantity,_that.condition,_that.restocked,_that.refundAmount);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String saleItemId,  String? productId,  int quantity,  ItemCondition condition,  bool restocked,  Decimal refundAmount)?  $default,) {final _that = this;
switch (_that) {
case _SaleReturnLine() when $default != null:
return $default(_that.id,_that.saleItemId,_that.productId,_that.quantity,_that.condition,_that.restocked,_that.refundAmount);case _:
  return null;

}
}

}

/// @nodoc


class _SaleReturnLine implements SaleReturnLine {
  const _SaleReturnLine({required this.id, required this.saleItemId, this.productId, required this.quantity, required this.condition, required this.restocked, required this.refundAmount});
  

@override final  String id;
@override final  String saleItemId;
@override final  String? productId;
@override final  int quantity;
@override final  ItemCondition condition;
/// L'article a réintégré le stock disponible.
@override final  bool restocked;
@override final  Decimal refundAmount;

/// Create a copy of SaleReturnLine
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SaleReturnLineCopyWith<_SaleReturnLine> get copyWith => __$SaleReturnLineCopyWithImpl<_SaleReturnLine>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SaleReturnLine&&(identical(other.id, id) || other.id == id)&&(identical(other.saleItemId, saleItemId) || other.saleItemId == saleItemId)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.condition, condition) || other.condition == condition)&&(identical(other.restocked, restocked) || other.restocked == restocked)&&(identical(other.refundAmount, refundAmount) || other.refundAmount == refundAmount));
}


@override
int get hashCode => Object.hash(runtimeType,id,saleItemId,productId,quantity,condition,restocked,refundAmount);

@override
String toString() {
  return 'SaleReturnLine(id: $id, saleItemId: $saleItemId, productId: $productId, quantity: $quantity, condition: $condition, restocked: $restocked, refundAmount: $refundAmount)';
}


}

/// @nodoc
abstract mixin class _$SaleReturnLineCopyWith<$Res> implements $SaleReturnLineCopyWith<$Res> {
  factory _$SaleReturnLineCopyWith(_SaleReturnLine value, $Res Function(_SaleReturnLine) _then) = __$SaleReturnLineCopyWithImpl;
@override @useResult
$Res call({
 String id, String saleItemId, String? productId, int quantity, ItemCondition condition, bool restocked, Decimal refundAmount
});




}
/// @nodoc
class __$SaleReturnLineCopyWithImpl<$Res>
    implements _$SaleReturnLineCopyWith<$Res> {
  __$SaleReturnLineCopyWithImpl(this._self, this._then);

  final _SaleReturnLine _self;
  final $Res Function(_SaleReturnLine) _then;

/// Create a copy of SaleReturnLine
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? saleItemId = null,Object? productId = freezed,Object? quantity = null,Object? condition = null,Object? restocked = null,Object? refundAmount = null,}) {
  return _then(_SaleReturnLine(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,saleItemId: null == saleItemId ? _self.saleItemId : saleItemId // ignore: cast_nullable_to_non_nullable
as String,productId: freezed == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String?,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,condition: null == condition ? _self.condition : condition // ignore: cast_nullable_to_non_nullable
as ItemCondition,restocked: null == restocked ? _self.restocked : restocked // ignore: cast_nullable_to_non_nullable
as bool,refundAmount: null == refundAmount ? _self.refundAmount : refundAmount // ignore: cast_nullable_to_non_nullable
as Decimal,
  ));
}


}

/// @nodoc
mixin _$SaleReturn {

 String get id; String get saleId;/// Numéro attribué par le serveur (0 tant que non synchronisé).
 int get returnNumber; ReturnReason get reason; String? get note; RefundMethod get refundMethod;/// Montant rendu au client.
 Decimal get refundAmount; DateTime get createdAt; ReturnSyncStatus get syncStatus;/// Code du refus serveur (`quantity_exceeded`…), si refusé.
 String? get rejectionCode; List<SaleReturnLine> get lines;
/// Create a copy of SaleReturn
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SaleReturnCopyWith<SaleReturn> get copyWith => _$SaleReturnCopyWithImpl<SaleReturn>(this as SaleReturn, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SaleReturn&&(identical(other.id, id) || other.id == id)&&(identical(other.saleId, saleId) || other.saleId == saleId)&&(identical(other.returnNumber, returnNumber) || other.returnNumber == returnNumber)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.note, note) || other.note == note)&&(identical(other.refundMethod, refundMethod) || other.refundMethod == refundMethod)&&(identical(other.refundAmount, refundAmount) || other.refundAmount == refundAmount)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.syncStatus, syncStatus) || other.syncStatus == syncStatus)&&(identical(other.rejectionCode, rejectionCode) || other.rejectionCode == rejectionCode)&&const DeepCollectionEquality().equals(other.lines, lines));
}


@override
int get hashCode => Object.hash(runtimeType,id,saleId,returnNumber,reason,note,refundMethod,refundAmount,createdAt,syncStatus,rejectionCode,const DeepCollectionEquality().hash(lines));

@override
String toString() {
  return 'SaleReturn(id: $id, saleId: $saleId, returnNumber: $returnNumber, reason: $reason, note: $note, refundMethod: $refundMethod, refundAmount: $refundAmount, createdAt: $createdAt, syncStatus: $syncStatus, rejectionCode: $rejectionCode, lines: $lines)';
}


}

/// @nodoc
abstract mixin class $SaleReturnCopyWith<$Res>  {
  factory $SaleReturnCopyWith(SaleReturn value, $Res Function(SaleReturn) _then) = _$SaleReturnCopyWithImpl;
@useResult
$Res call({
 String id, String saleId, int returnNumber, ReturnReason reason, String? note, RefundMethod refundMethod, Decimal refundAmount, DateTime createdAt, ReturnSyncStatus syncStatus, String? rejectionCode, List<SaleReturnLine> lines
});




}
/// @nodoc
class _$SaleReturnCopyWithImpl<$Res>
    implements $SaleReturnCopyWith<$Res> {
  _$SaleReturnCopyWithImpl(this._self, this._then);

  final SaleReturn _self;
  final $Res Function(SaleReturn) _then;

/// Create a copy of SaleReturn
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? saleId = null,Object? returnNumber = null,Object? reason = null,Object? note = freezed,Object? refundMethod = null,Object? refundAmount = null,Object? createdAt = null,Object? syncStatus = null,Object? rejectionCode = freezed,Object? lines = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,saleId: null == saleId ? _self.saleId : saleId // ignore: cast_nullable_to_non_nullable
as String,returnNumber: null == returnNumber ? _self.returnNumber : returnNumber // ignore: cast_nullable_to_non_nullable
as int,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as ReturnReason,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,refundMethod: null == refundMethod ? _self.refundMethod : refundMethod // ignore: cast_nullable_to_non_nullable
as RefundMethod,refundAmount: null == refundAmount ? _self.refundAmount : refundAmount // ignore: cast_nullable_to_non_nullable
as Decimal,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,syncStatus: null == syncStatus ? _self.syncStatus : syncStatus // ignore: cast_nullable_to_non_nullable
as ReturnSyncStatus,rejectionCode: freezed == rejectionCode ? _self.rejectionCode : rejectionCode // ignore: cast_nullable_to_non_nullable
as String?,lines: null == lines ? _self.lines : lines // ignore: cast_nullable_to_non_nullable
as List<SaleReturnLine>,
  ));
}

}


/// Adds pattern-matching-related methods to [SaleReturn].
extension SaleReturnPatterns on SaleReturn {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SaleReturn value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SaleReturn() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SaleReturn value)  $default,){
final _that = this;
switch (_that) {
case _SaleReturn():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SaleReturn value)?  $default,){
final _that = this;
switch (_that) {
case _SaleReturn() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String saleId,  int returnNumber,  ReturnReason reason,  String? note,  RefundMethod refundMethod,  Decimal refundAmount,  DateTime createdAt,  ReturnSyncStatus syncStatus,  String? rejectionCode,  List<SaleReturnLine> lines)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SaleReturn() when $default != null:
return $default(_that.id,_that.saleId,_that.returnNumber,_that.reason,_that.note,_that.refundMethod,_that.refundAmount,_that.createdAt,_that.syncStatus,_that.rejectionCode,_that.lines);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String saleId,  int returnNumber,  ReturnReason reason,  String? note,  RefundMethod refundMethod,  Decimal refundAmount,  DateTime createdAt,  ReturnSyncStatus syncStatus,  String? rejectionCode,  List<SaleReturnLine> lines)  $default,) {final _that = this;
switch (_that) {
case _SaleReturn():
return $default(_that.id,_that.saleId,_that.returnNumber,_that.reason,_that.note,_that.refundMethod,_that.refundAmount,_that.createdAt,_that.syncStatus,_that.rejectionCode,_that.lines);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String saleId,  int returnNumber,  ReturnReason reason,  String? note,  RefundMethod refundMethod,  Decimal refundAmount,  DateTime createdAt,  ReturnSyncStatus syncStatus,  String? rejectionCode,  List<SaleReturnLine> lines)?  $default,) {final _that = this;
switch (_that) {
case _SaleReturn() when $default != null:
return $default(_that.id,_that.saleId,_that.returnNumber,_that.reason,_that.note,_that.refundMethod,_that.refundAmount,_that.createdAt,_that.syncStatus,_that.rejectionCode,_that.lines);case _:
  return null;

}
}

}

/// @nodoc


class _SaleReturn implements SaleReturn {
  const _SaleReturn({required this.id, required this.saleId, required this.returnNumber, required this.reason, this.note, required this.refundMethod, required this.refundAmount, required this.createdAt, required this.syncStatus, this.rejectionCode, required final  List<SaleReturnLine> lines}): _lines = lines;
  

@override final  String id;
@override final  String saleId;
/// Numéro attribué par le serveur (0 tant que non synchronisé).
@override final  int returnNumber;
@override final  ReturnReason reason;
@override final  String? note;
@override final  RefundMethod refundMethod;
/// Montant rendu au client.
@override final  Decimal refundAmount;
@override final  DateTime createdAt;
@override final  ReturnSyncStatus syncStatus;
/// Code du refus serveur (`quantity_exceeded`…), si refusé.
@override final  String? rejectionCode;
 final  List<SaleReturnLine> _lines;
@override List<SaleReturnLine> get lines {
  if (_lines is EqualUnmodifiableListView) return _lines;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_lines);
}


/// Create a copy of SaleReturn
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SaleReturnCopyWith<_SaleReturn> get copyWith => __$SaleReturnCopyWithImpl<_SaleReturn>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SaleReturn&&(identical(other.id, id) || other.id == id)&&(identical(other.saleId, saleId) || other.saleId == saleId)&&(identical(other.returnNumber, returnNumber) || other.returnNumber == returnNumber)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.note, note) || other.note == note)&&(identical(other.refundMethod, refundMethod) || other.refundMethod == refundMethod)&&(identical(other.refundAmount, refundAmount) || other.refundAmount == refundAmount)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.syncStatus, syncStatus) || other.syncStatus == syncStatus)&&(identical(other.rejectionCode, rejectionCode) || other.rejectionCode == rejectionCode)&&const DeepCollectionEquality().equals(other._lines, _lines));
}


@override
int get hashCode => Object.hash(runtimeType,id,saleId,returnNumber,reason,note,refundMethod,refundAmount,createdAt,syncStatus,rejectionCode,const DeepCollectionEquality().hash(_lines));

@override
String toString() {
  return 'SaleReturn(id: $id, saleId: $saleId, returnNumber: $returnNumber, reason: $reason, note: $note, refundMethod: $refundMethod, refundAmount: $refundAmount, createdAt: $createdAt, syncStatus: $syncStatus, rejectionCode: $rejectionCode, lines: $lines)';
}


}

/// @nodoc
abstract mixin class _$SaleReturnCopyWith<$Res> implements $SaleReturnCopyWith<$Res> {
  factory _$SaleReturnCopyWith(_SaleReturn value, $Res Function(_SaleReturn) _then) = __$SaleReturnCopyWithImpl;
@override @useResult
$Res call({
 String id, String saleId, int returnNumber, ReturnReason reason, String? note, RefundMethod refundMethod, Decimal refundAmount, DateTime createdAt, ReturnSyncStatus syncStatus, String? rejectionCode, List<SaleReturnLine> lines
});




}
/// @nodoc
class __$SaleReturnCopyWithImpl<$Res>
    implements _$SaleReturnCopyWith<$Res> {
  __$SaleReturnCopyWithImpl(this._self, this._then);

  final _SaleReturn _self;
  final $Res Function(_SaleReturn) _then;

/// Create a copy of SaleReturn
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? saleId = null,Object? returnNumber = null,Object? reason = null,Object? note = freezed,Object? refundMethod = null,Object? refundAmount = null,Object? createdAt = null,Object? syncStatus = null,Object? rejectionCode = freezed,Object? lines = null,}) {
  return _then(_SaleReturn(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,saleId: null == saleId ? _self.saleId : saleId // ignore: cast_nullable_to_non_nullable
as String,returnNumber: null == returnNumber ? _self.returnNumber : returnNumber // ignore: cast_nullable_to_non_nullable
as int,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as ReturnReason,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,refundMethod: null == refundMethod ? _self.refundMethod : refundMethod // ignore: cast_nullable_to_non_nullable
as RefundMethod,refundAmount: null == refundAmount ? _self.refundAmount : refundAmount // ignore: cast_nullable_to_non_nullable
as Decimal,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,syncStatus: null == syncStatus ? _self.syncStatus : syncStatus // ignore: cast_nullable_to_non_nullable
as ReturnSyncStatus,rejectionCode: freezed == rejectionCode ? _self.rejectionCode : rejectionCode // ignore: cast_nullable_to_non_nullable
as String?,lines: null == lines ? _self._lines : lines // ignore: cast_nullable_to_non_nullable
as List<SaleReturnLine>,
  ));
}


}

// dart format on
