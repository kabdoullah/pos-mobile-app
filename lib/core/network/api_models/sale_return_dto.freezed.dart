// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sale_return_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SaleReturnItemCreateDto {

 String get id;@JsonKey(name: 'sale_item_id') String get saleItemId; int get quantity; String get condition;@JsonKey(name: 'refund_amount') String get refundAmount;
/// Create a copy of SaleReturnItemCreateDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SaleReturnItemCreateDtoCopyWith<SaleReturnItemCreateDto> get copyWith => _$SaleReturnItemCreateDtoCopyWithImpl<SaleReturnItemCreateDto>(this as SaleReturnItemCreateDto, _$identity);

  /// Serializes this SaleReturnItemCreateDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SaleReturnItemCreateDto&&(identical(other.id, id) || other.id == id)&&(identical(other.saleItemId, saleItemId) || other.saleItemId == saleItemId)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.condition, condition) || other.condition == condition)&&(identical(other.refundAmount, refundAmount) || other.refundAmount == refundAmount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,saleItemId,quantity,condition,refundAmount);

@override
String toString() {
  return 'SaleReturnItemCreateDto(id: $id, saleItemId: $saleItemId, quantity: $quantity, condition: $condition, refundAmount: $refundAmount)';
}


}

/// @nodoc
abstract mixin class $SaleReturnItemCreateDtoCopyWith<$Res>  {
  factory $SaleReturnItemCreateDtoCopyWith(SaleReturnItemCreateDto value, $Res Function(SaleReturnItemCreateDto) _then) = _$SaleReturnItemCreateDtoCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'sale_item_id') String saleItemId, int quantity, String condition,@JsonKey(name: 'refund_amount') String refundAmount
});




}
/// @nodoc
class _$SaleReturnItemCreateDtoCopyWithImpl<$Res>
    implements $SaleReturnItemCreateDtoCopyWith<$Res> {
  _$SaleReturnItemCreateDtoCopyWithImpl(this._self, this._then);

  final SaleReturnItemCreateDto _self;
  final $Res Function(SaleReturnItemCreateDto) _then;

/// Create a copy of SaleReturnItemCreateDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? saleItemId = null,Object? quantity = null,Object? condition = null,Object? refundAmount = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,saleItemId: null == saleItemId ? _self.saleItemId : saleItemId // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,condition: null == condition ? _self.condition : condition // ignore: cast_nullable_to_non_nullable
as String,refundAmount: null == refundAmount ? _self.refundAmount : refundAmount // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [SaleReturnItemCreateDto].
extension SaleReturnItemCreateDtoPatterns on SaleReturnItemCreateDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SaleReturnItemCreateDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SaleReturnItemCreateDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SaleReturnItemCreateDto value)  $default,){
final _that = this;
switch (_that) {
case _SaleReturnItemCreateDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SaleReturnItemCreateDto value)?  $default,){
final _that = this;
switch (_that) {
case _SaleReturnItemCreateDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'sale_item_id')  String saleItemId,  int quantity,  String condition, @JsonKey(name: 'refund_amount')  String refundAmount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SaleReturnItemCreateDto() when $default != null:
return $default(_that.id,_that.saleItemId,_that.quantity,_that.condition,_that.refundAmount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'sale_item_id')  String saleItemId,  int quantity,  String condition, @JsonKey(name: 'refund_amount')  String refundAmount)  $default,) {final _that = this;
switch (_that) {
case _SaleReturnItemCreateDto():
return $default(_that.id,_that.saleItemId,_that.quantity,_that.condition,_that.refundAmount);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'sale_item_id')  String saleItemId,  int quantity,  String condition, @JsonKey(name: 'refund_amount')  String refundAmount)?  $default,) {final _that = this;
switch (_that) {
case _SaleReturnItemCreateDto() when $default != null:
return $default(_that.id,_that.saleItemId,_that.quantity,_that.condition,_that.refundAmount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SaleReturnItemCreateDto implements SaleReturnItemCreateDto {
  const _SaleReturnItemCreateDto({required this.id, @JsonKey(name: 'sale_item_id') required this.saleItemId, required this.quantity, required this.condition, @JsonKey(name: 'refund_amount') required this.refundAmount});
  factory _SaleReturnItemCreateDto.fromJson(Map<String, dynamic> json) => _$SaleReturnItemCreateDtoFromJson(json);

@override final  String id;
@override@JsonKey(name: 'sale_item_id') final  String saleItemId;
@override final  int quantity;
@override final  String condition;
@override@JsonKey(name: 'refund_amount') final  String refundAmount;

/// Create a copy of SaleReturnItemCreateDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SaleReturnItemCreateDtoCopyWith<_SaleReturnItemCreateDto> get copyWith => __$SaleReturnItemCreateDtoCopyWithImpl<_SaleReturnItemCreateDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SaleReturnItemCreateDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SaleReturnItemCreateDto&&(identical(other.id, id) || other.id == id)&&(identical(other.saleItemId, saleItemId) || other.saleItemId == saleItemId)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.condition, condition) || other.condition == condition)&&(identical(other.refundAmount, refundAmount) || other.refundAmount == refundAmount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,saleItemId,quantity,condition,refundAmount);

@override
String toString() {
  return 'SaleReturnItemCreateDto(id: $id, saleItemId: $saleItemId, quantity: $quantity, condition: $condition, refundAmount: $refundAmount)';
}


}

/// @nodoc
abstract mixin class _$SaleReturnItemCreateDtoCopyWith<$Res> implements $SaleReturnItemCreateDtoCopyWith<$Res> {
  factory _$SaleReturnItemCreateDtoCopyWith(_SaleReturnItemCreateDto value, $Res Function(_SaleReturnItemCreateDto) _then) = __$SaleReturnItemCreateDtoCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'sale_item_id') String saleItemId, int quantity, String condition,@JsonKey(name: 'refund_amount') String refundAmount
});




}
/// @nodoc
class __$SaleReturnItemCreateDtoCopyWithImpl<$Res>
    implements _$SaleReturnItemCreateDtoCopyWith<$Res> {
  __$SaleReturnItemCreateDtoCopyWithImpl(this._self, this._then);

  final _SaleReturnItemCreateDto _self;
  final $Res Function(_SaleReturnItemCreateDto) _then;

/// Create a copy of SaleReturnItemCreateDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? saleItemId = null,Object? quantity = null,Object? condition = null,Object? refundAmount = null,}) {
  return _then(_SaleReturnItemCreateDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,saleItemId: null == saleItemId ? _self.saleItemId : saleItemId // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,condition: null == condition ? _self.condition : condition // ignore: cast_nullable_to_non_nullable
as String,refundAmount: null == refundAmount ? _self.refundAmount : refundAmount // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$SaleReturnCreateDto {

 String get id;@JsonKey(name: 'sale_id') String get saleId; String get reason; String? get note;@JsonKey(name: 'refund_method') String get refundMethod;@JsonKey(name: 'refund_amount') String get refundAmount;@JsonKey(name: 'created_at') String get createdAt; List<SaleReturnItemCreateDto> get items;
/// Create a copy of SaleReturnCreateDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SaleReturnCreateDtoCopyWith<SaleReturnCreateDto> get copyWith => _$SaleReturnCreateDtoCopyWithImpl<SaleReturnCreateDto>(this as SaleReturnCreateDto, _$identity);

  /// Serializes this SaleReturnCreateDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SaleReturnCreateDto&&(identical(other.id, id) || other.id == id)&&(identical(other.saleId, saleId) || other.saleId == saleId)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.note, note) || other.note == note)&&(identical(other.refundMethod, refundMethod) || other.refundMethod == refundMethod)&&(identical(other.refundAmount, refundAmount) || other.refundAmount == refundAmount)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&const DeepCollectionEquality().equals(other.items, items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,saleId,reason,note,refundMethod,refundAmount,createdAt,const DeepCollectionEquality().hash(items));

@override
String toString() {
  return 'SaleReturnCreateDto(id: $id, saleId: $saleId, reason: $reason, note: $note, refundMethod: $refundMethod, refundAmount: $refundAmount, createdAt: $createdAt, items: $items)';
}


}

/// @nodoc
abstract mixin class $SaleReturnCreateDtoCopyWith<$Res>  {
  factory $SaleReturnCreateDtoCopyWith(SaleReturnCreateDto value, $Res Function(SaleReturnCreateDto) _then) = _$SaleReturnCreateDtoCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'sale_id') String saleId, String reason, String? note,@JsonKey(name: 'refund_method') String refundMethod,@JsonKey(name: 'refund_amount') String refundAmount,@JsonKey(name: 'created_at') String createdAt, List<SaleReturnItemCreateDto> items
});




}
/// @nodoc
class _$SaleReturnCreateDtoCopyWithImpl<$Res>
    implements $SaleReturnCreateDtoCopyWith<$Res> {
  _$SaleReturnCreateDtoCopyWithImpl(this._self, this._then);

  final SaleReturnCreateDto _self;
  final $Res Function(SaleReturnCreateDto) _then;

/// Create a copy of SaleReturnCreateDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? saleId = null,Object? reason = null,Object? note = freezed,Object? refundMethod = null,Object? refundAmount = null,Object? createdAt = null,Object? items = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,saleId: null == saleId ? _self.saleId : saleId // ignore: cast_nullable_to_non_nullable
as String,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,refundMethod: null == refundMethod ? _self.refundMethod : refundMethod // ignore: cast_nullable_to_non_nullable
as String,refundAmount: null == refundAmount ? _self.refundAmount : refundAmount // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<SaleReturnItemCreateDto>,
  ));
}

}


/// Adds pattern-matching-related methods to [SaleReturnCreateDto].
extension SaleReturnCreateDtoPatterns on SaleReturnCreateDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SaleReturnCreateDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SaleReturnCreateDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SaleReturnCreateDto value)  $default,){
final _that = this;
switch (_that) {
case _SaleReturnCreateDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SaleReturnCreateDto value)?  $default,){
final _that = this;
switch (_that) {
case _SaleReturnCreateDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'sale_id')  String saleId,  String reason,  String? note, @JsonKey(name: 'refund_method')  String refundMethod, @JsonKey(name: 'refund_amount')  String refundAmount, @JsonKey(name: 'created_at')  String createdAt,  List<SaleReturnItemCreateDto> items)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SaleReturnCreateDto() when $default != null:
return $default(_that.id,_that.saleId,_that.reason,_that.note,_that.refundMethod,_that.refundAmount,_that.createdAt,_that.items);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'sale_id')  String saleId,  String reason,  String? note, @JsonKey(name: 'refund_method')  String refundMethod, @JsonKey(name: 'refund_amount')  String refundAmount, @JsonKey(name: 'created_at')  String createdAt,  List<SaleReturnItemCreateDto> items)  $default,) {final _that = this;
switch (_that) {
case _SaleReturnCreateDto():
return $default(_that.id,_that.saleId,_that.reason,_that.note,_that.refundMethod,_that.refundAmount,_that.createdAt,_that.items);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'sale_id')  String saleId,  String reason,  String? note, @JsonKey(name: 'refund_method')  String refundMethod, @JsonKey(name: 'refund_amount')  String refundAmount, @JsonKey(name: 'created_at')  String createdAt,  List<SaleReturnItemCreateDto> items)?  $default,) {final _that = this;
switch (_that) {
case _SaleReturnCreateDto() when $default != null:
return $default(_that.id,_that.saleId,_that.reason,_that.note,_that.refundMethod,_that.refundAmount,_that.createdAt,_that.items);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SaleReturnCreateDto implements SaleReturnCreateDto {
  const _SaleReturnCreateDto({required this.id, @JsonKey(name: 'sale_id') required this.saleId, required this.reason, this.note, @JsonKey(name: 'refund_method') required this.refundMethod, @JsonKey(name: 'refund_amount') required this.refundAmount, @JsonKey(name: 'created_at') required this.createdAt, required final  List<SaleReturnItemCreateDto> items}): _items = items;
  factory _SaleReturnCreateDto.fromJson(Map<String, dynamic> json) => _$SaleReturnCreateDtoFromJson(json);

@override final  String id;
@override@JsonKey(name: 'sale_id') final  String saleId;
@override final  String reason;
@override final  String? note;
@override@JsonKey(name: 'refund_method') final  String refundMethod;
@override@JsonKey(name: 'refund_amount') final  String refundAmount;
@override@JsonKey(name: 'created_at') final  String createdAt;
 final  List<SaleReturnItemCreateDto> _items;
@override List<SaleReturnItemCreateDto> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of SaleReturnCreateDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SaleReturnCreateDtoCopyWith<_SaleReturnCreateDto> get copyWith => __$SaleReturnCreateDtoCopyWithImpl<_SaleReturnCreateDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SaleReturnCreateDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SaleReturnCreateDto&&(identical(other.id, id) || other.id == id)&&(identical(other.saleId, saleId) || other.saleId == saleId)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.note, note) || other.note == note)&&(identical(other.refundMethod, refundMethod) || other.refundMethod == refundMethod)&&(identical(other.refundAmount, refundAmount) || other.refundAmount == refundAmount)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&const DeepCollectionEquality().equals(other._items, _items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,saleId,reason,note,refundMethod,refundAmount,createdAt,const DeepCollectionEquality().hash(_items));

@override
String toString() {
  return 'SaleReturnCreateDto(id: $id, saleId: $saleId, reason: $reason, note: $note, refundMethod: $refundMethod, refundAmount: $refundAmount, createdAt: $createdAt, items: $items)';
}


}

/// @nodoc
abstract mixin class _$SaleReturnCreateDtoCopyWith<$Res> implements $SaleReturnCreateDtoCopyWith<$Res> {
  factory _$SaleReturnCreateDtoCopyWith(_SaleReturnCreateDto value, $Res Function(_SaleReturnCreateDto) _then) = __$SaleReturnCreateDtoCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'sale_id') String saleId, String reason, String? note,@JsonKey(name: 'refund_method') String refundMethod,@JsonKey(name: 'refund_amount') String refundAmount,@JsonKey(name: 'created_at') String createdAt, List<SaleReturnItemCreateDto> items
});




}
/// @nodoc
class __$SaleReturnCreateDtoCopyWithImpl<$Res>
    implements _$SaleReturnCreateDtoCopyWith<$Res> {
  __$SaleReturnCreateDtoCopyWithImpl(this._self, this._then);

  final _SaleReturnCreateDto _self;
  final $Res Function(_SaleReturnCreateDto) _then;

/// Create a copy of SaleReturnCreateDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? saleId = null,Object? reason = null,Object? note = freezed,Object? refundMethod = null,Object? refundAmount = null,Object? createdAt = null,Object? items = null,}) {
  return _then(_SaleReturnCreateDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,saleId: null == saleId ? _self.saleId : saleId // ignore: cast_nullable_to_non_nullable
as String,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,refundMethod: null == refundMethod ? _self.refundMethod : refundMethod // ignore: cast_nullable_to_non_nullable
as String,refundAmount: null == refundAmount ? _self.refundAmount : refundAmount // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<SaleReturnItemCreateDto>,
  ));
}


}


/// @nodoc
mixin _$SaleReturnItemDto {

 String get id;@JsonKey(name: 'sale_return_id') String get saleReturnId;@JsonKey(name: 'sale_item_id') String get saleItemId;@JsonKey(name: 'product_id') String? get productId; int get quantity; String get condition; bool get restocked;@JsonKey(name: 'refund_amount') String get refundAmount;
/// Create a copy of SaleReturnItemDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SaleReturnItemDtoCopyWith<SaleReturnItemDto> get copyWith => _$SaleReturnItemDtoCopyWithImpl<SaleReturnItemDto>(this as SaleReturnItemDto, _$identity);

  /// Serializes this SaleReturnItemDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SaleReturnItemDto&&(identical(other.id, id) || other.id == id)&&(identical(other.saleReturnId, saleReturnId) || other.saleReturnId == saleReturnId)&&(identical(other.saleItemId, saleItemId) || other.saleItemId == saleItemId)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.condition, condition) || other.condition == condition)&&(identical(other.restocked, restocked) || other.restocked == restocked)&&(identical(other.refundAmount, refundAmount) || other.refundAmount == refundAmount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,saleReturnId,saleItemId,productId,quantity,condition,restocked,refundAmount);

@override
String toString() {
  return 'SaleReturnItemDto(id: $id, saleReturnId: $saleReturnId, saleItemId: $saleItemId, productId: $productId, quantity: $quantity, condition: $condition, restocked: $restocked, refundAmount: $refundAmount)';
}


}

/// @nodoc
abstract mixin class $SaleReturnItemDtoCopyWith<$Res>  {
  factory $SaleReturnItemDtoCopyWith(SaleReturnItemDto value, $Res Function(SaleReturnItemDto) _then) = _$SaleReturnItemDtoCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'sale_return_id') String saleReturnId,@JsonKey(name: 'sale_item_id') String saleItemId,@JsonKey(name: 'product_id') String? productId, int quantity, String condition, bool restocked,@JsonKey(name: 'refund_amount') String refundAmount
});




}
/// @nodoc
class _$SaleReturnItemDtoCopyWithImpl<$Res>
    implements $SaleReturnItemDtoCopyWith<$Res> {
  _$SaleReturnItemDtoCopyWithImpl(this._self, this._then);

  final SaleReturnItemDto _self;
  final $Res Function(SaleReturnItemDto) _then;

/// Create a copy of SaleReturnItemDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? saleReturnId = null,Object? saleItemId = null,Object? productId = freezed,Object? quantity = null,Object? condition = null,Object? restocked = null,Object? refundAmount = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,saleReturnId: null == saleReturnId ? _self.saleReturnId : saleReturnId // ignore: cast_nullable_to_non_nullable
as String,saleItemId: null == saleItemId ? _self.saleItemId : saleItemId // ignore: cast_nullable_to_non_nullable
as String,productId: freezed == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String?,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,condition: null == condition ? _self.condition : condition // ignore: cast_nullable_to_non_nullable
as String,restocked: null == restocked ? _self.restocked : restocked // ignore: cast_nullable_to_non_nullable
as bool,refundAmount: null == refundAmount ? _self.refundAmount : refundAmount // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [SaleReturnItemDto].
extension SaleReturnItemDtoPatterns on SaleReturnItemDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SaleReturnItemDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SaleReturnItemDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SaleReturnItemDto value)  $default,){
final _that = this;
switch (_that) {
case _SaleReturnItemDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SaleReturnItemDto value)?  $default,){
final _that = this;
switch (_that) {
case _SaleReturnItemDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'sale_return_id')  String saleReturnId, @JsonKey(name: 'sale_item_id')  String saleItemId, @JsonKey(name: 'product_id')  String? productId,  int quantity,  String condition,  bool restocked, @JsonKey(name: 'refund_amount')  String refundAmount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SaleReturnItemDto() when $default != null:
return $default(_that.id,_that.saleReturnId,_that.saleItemId,_that.productId,_that.quantity,_that.condition,_that.restocked,_that.refundAmount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'sale_return_id')  String saleReturnId, @JsonKey(name: 'sale_item_id')  String saleItemId, @JsonKey(name: 'product_id')  String? productId,  int quantity,  String condition,  bool restocked, @JsonKey(name: 'refund_amount')  String refundAmount)  $default,) {final _that = this;
switch (_that) {
case _SaleReturnItemDto():
return $default(_that.id,_that.saleReturnId,_that.saleItemId,_that.productId,_that.quantity,_that.condition,_that.restocked,_that.refundAmount);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'sale_return_id')  String saleReturnId, @JsonKey(name: 'sale_item_id')  String saleItemId, @JsonKey(name: 'product_id')  String? productId,  int quantity,  String condition,  bool restocked, @JsonKey(name: 'refund_amount')  String refundAmount)?  $default,) {final _that = this;
switch (_that) {
case _SaleReturnItemDto() when $default != null:
return $default(_that.id,_that.saleReturnId,_that.saleItemId,_that.productId,_that.quantity,_that.condition,_that.restocked,_that.refundAmount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SaleReturnItemDto implements SaleReturnItemDto {
  const _SaleReturnItemDto({required this.id, @JsonKey(name: 'sale_return_id') required this.saleReturnId, @JsonKey(name: 'sale_item_id') required this.saleItemId, @JsonKey(name: 'product_id') this.productId, required this.quantity, required this.condition, required this.restocked, @JsonKey(name: 'refund_amount') required this.refundAmount});
  factory _SaleReturnItemDto.fromJson(Map<String, dynamic> json) => _$SaleReturnItemDtoFromJson(json);

@override final  String id;
@override@JsonKey(name: 'sale_return_id') final  String saleReturnId;
@override@JsonKey(name: 'sale_item_id') final  String saleItemId;
@override@JsonKey(name: 'product_id') final  String? productId;
@override final  int quantity;
@override final  String condition;
@override final  bool restocked;
@override@JsonKey(name: 'refund_amount') final  String refundAmount;

/// Create a copy of SaleReturnItemDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SaleReturnItemDtoCopyWith<_SaleReturnItemDto> get copyWith => __$SaleReturnItemDtoCopyWithImpl<_SaleReturnItemDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SaleReturnItemDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SaleReturnItemDto&&(identical(other.id, id) || other.id == id)&&(identical(other.saleReturnId, saleReturnId) || other.saleReturnId == saleReturnId)&&(identical(other.saleItemId, saleItemId) || other.saleItemId == saleItemId)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.condition, condition) || other.condition == condition)&&(identical(other.restocked, restocked) || other.restocked == restocked)&&(identical(other.refundAmount, refundAmount) || other.refundAmount == refundAmount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,saleReturnId,saleItemId,productId,quantity,condition,restocked,refundAmount);

@override
String toString() {
  return 'SaleReturnItemDto(id: $id, saleReturnId: $saleReturnId, saleItemId: $saleItemId, productId: $productId, quantity: $quantity, condition: $condition, restocked: $restocked, refundAmount: $refundAmount)';
}


}

/// @nodoc
abstract mixin class _$SaleReturnItemDtoCopyWith<$Res> implements $SaleReturnItemDtoCopyWith<$Res> {
  factory _$SaleReturnItemDtoCopyWith(_SaleReturnItemDto value, $Res Function(_SaleReturnItemDto) _then) = __$SaleReturnItemDtoCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'sale_return_id') String saleReturnId,@JsonKey(name: 'sale_item_id') String saleItemId,@JsonKey(name: 'product_id') String? productId, int quantity, String condition, bool restocked,@JsonKey(name: 'refund_amount') String refundAmount
});




}
/// @nodoc
class __$SaleReturnItemDtoCopyWithImpl<$Res>
    implements _$SaleReturnItemDtoCopyWith<$Res> {
  __$SaleReturnItemDtoCopyWithImpl(this._self, this._then);

  final _SaleReturnItemDto _self;
  final $Res Function(_SaleReturnItemDto) _then;

/// Create a copy of SaleReturnItemDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? saleReturnId = null,Object? saleItemId = null,Object? productId = freezed,Object? quantity = null,Object? condition = null,Object? restocked = null,Object? refundAmount = null,}) {
  return _then(_SaleReturnItemDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,saleReturnId: null == saleReturnId ? _self.saleReturnId : saleReturnId // ignore: cast_nullable_to_non_nullable
as String,saleItemId: null == saleItemId ? _self.saleItemId : saleItemId // ignore: cast_nullable_to_non_nullable
as String,productId: freezed == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String?,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,condition: null == condition ? _self.condition : condition // ignore: cast_nullable_to_non_nullable
as String,restocked: null == restocked ? _self.restocked : restocked // ignore: cast_nullable_to_non_nullable
as bool,refundAmount: null == refundAmount ? _self.refundAmount : refundAmount // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$SaleReturnDto {

 String get id;@JsonKey(name: 'sale_id') String get saleId;@JsonKey(name: 'return_number') int? get returnNumber; String get reason; String? get note;@JsonKey(name: 'refund_method') String get refundMethod;@JsonKey(name: 'refund_amount') String get refundAmount;@JsonKey(name: 'created_at') String get createdAt; List<SaleReturnItemDto> get items;
/// Create a copy of SaleReturnDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SaleReturnDtoCopyWith<SaleReturnDto> get copyWith => _$SaleReturnDtoCopyWithImpl<SaleReturnDto>(this as SaleReturnDto, _$identity);

  /// Serializes this SaleReturnDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SaleReturnDto&&(identical(other.id, id) || other.id == id)&&(identical(other.saleId, saleId) || other.saleId == saleId)&&(identical(other.returnNumber, returnNumber) || other.returnNumber == returnNumber)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.note, note) || other.note == note)&&(identical(other.refundMethod, refundMethod) || other.refundMethod == refundMethod)&&(identical(other.refundAmount, refundAmount) || other.refundAmount == refundAmount)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&const DeepCollectionEquality().equals(other.items, items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,saleId,returnNumber,reason,note,refundMethod,refundAmount,createdAt,const DeepCollectionEquality().hash(items));

@override
String toString() {
  return 'SaleReturnDto(id: $id, saleId: $saleId, returnNumber: $returnNumber, reason: $reason, note: $note, refundMethod: $refundMethod, refundAmount: $refundAmount, createdAt: $createdAt, items: $items)';
}


}

/// @nodoc
abstract mixin class $SaleReturnDtoCopyWith<$Res>  {
  factory $SaleReturnDtoCopyWith(SaleReturnDto value, $Res Function(SaleReturnDto) _then) = _$SaleReturnDtoCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'sale_id') String saleId,@JsonKey(name: 'return_number') int? returnNumber, String reason, String? note,@JsonKey(name: 'refund_method') String refundMethod,@JsonKey(name: 'refund_amount') String refundAmount,@JsonKey(name: 'created_at') String createdAt, List<SaleReturnItemDto> items
});




}
/// @nodoc
class _$SaleReturnDtoCopyWithImpl<$Res>
    implements $SaleReturnDtoCopyWith<$Res> {
  _$SaleReturnDtoCopyWithImpl(this._self, this._then);

  final SaleReturnDto _self;
  final $Res Function(SaleReturnDto) _then;

/// Create a copy of SaleReturnDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? saleId = null,Object? returnNumber = freezed,Object? reason = null,Object? note = freezed,Object? refundMethod = null,Object? refundAmount = null,Object? createdAt = null,Object? items = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,saleId: null == saleId ? _self.saleId : saleId // ignore: cast_nullable_to_non_nullable
as String,returnNumber: freezed == returnNumber ? _self.returnNumber : returnNumber // ignore: cast_nullable_to_non_nullable
as int?,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,refundMethod: null == refundMethod ? _self.refundMethod : refundMethod // ignore: cast_nullable_to_non_nullable
as String,refundAmount: null == refundAmount ? _self.refundAmount : refundAmount // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<SaleReturnItemDto>,
  ));
}

}


/// Adds pattern-matching-related methods to [SaleReturnDto].
extension SaleReturnDtoPatterns on SaleReturnDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SaleReturnDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SaleReturnDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SaleReturnDto value)  $default,){
final _that = this;
switch (_that) {
case _SaleReturnDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SaleReturnDto value)?  $default,){
final _that = this;
switch (_that) {
case _SaleReturnDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'sale_id')  String saleId, @JsonKey(name: 'return_number')  int? returnNumber,  String reason,  String? note, @JsonKey(name: 'refund_method')  String refundMethod, @JsonKey(name: 'refund_amount')  String refundAmount, @JsonKey(name: 'created_at')  String createdAt,  List<SaleReturnItemDto> items)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SaleReturnDto() when $default != null:
return $default(_that.id,_that.saleId,_that.returnNumber,_that.reason,_that.note,_that.refundMethod,_that.refundAmount,_that.createdAt,_that.items);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'sale_id')  String saleId, @JsonKey(name: 'return_number')  int? returnNumber,  String reason,  String? note, @JsonKey(name: 'refund_method')  String refundMethod, @JsonKey(name: 'refund_amount')  String refundAmount, @JsonKey(name: 'created_at')  String createdAt,  List<SaleReturnItemDto> items)  $default,) {final _that = this;
switch (_that) {
case _SaleReturnDto():
return $default(_that.id,_that.saleId,_that.returnNumber,_that.reason,_that.note,_that.refundMethod,_that.refundAmount,_that.createdAt,_that.items);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'sale_id')  String saleId, @JsonKey(name: 'return_number')  int? returnNumber,  String reason,  String? note, @JsonKey(name: 'refund_method')  String refundMethod, @JsonKey(name: 'refund_amount')  String refundAmount, @JsonKey(name: 'created_at')  String createdAt,  List<SaleReturnItemDto> items)?  $default,) {final _that = this;
switch (_that) {
case _SaleReturnDto() when $default != null:
return $default(_that.id,_that.saleId,_that.returnNumber,_that.reason,_that.note,_that.refundMethod,_that.refundAmount,_that.createdAt,_that.items);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SaleReturnDto implements SaleReturnDto {
  const _SaleReturnDto({required this.id, @JsonKey(name: 'sale_id') required this.saleId, @JsonKey(name: 'return_number') this.returnNumber, required this.reason, this.note, @JsonKey(name: 'refund_method') required this.refundMethod, @JsonKey(name: 'refund_amount') required this.refundAmount, @JsonKey(name: 'created_at') required this.createdAt, required final  List<SaleReturnItemDto> items}): _items = items;
  factory _SaleReturnDto.fromJson(Map<String, dynamic> json) => _$SaleReturnDtoFromJson(json);

@override final  String id;
@override@JsonKey(name: 'sale_id') final  String saleId;
@override@JsonKey(name: 'return_number') final  int? returnNumber;
@override final  String reason;
@override final  String? note;
@override@JsonKey(name: 'refund_method') final  String refundMethod;
@override@JsonKey(name: 'refund_amount') final  String refundAmount;
@override@JsonKey(name: 'created_at') final  String createdAt;
 final  List<SaleReturnItemDto> _items;
@override List<SaleReturnItemDto> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of SaleReturnDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SaleReturnDtoCopyWith<_SaleReturnDto> get copyWith => __$SaleReturnDtoCopyWithImpl<_SaleReturnDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SaleReturnDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SaleReturnDto&&(identical(other.id, id) || other.id == id)&&(identical(other.saleId, saleId) || other.saleId == saleId)&&(identical(other.returnNumber, returnNumber) || other.returnNumber == returnNumber)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.note, note) || other.note == note)&&(identical(other.refundMethod, refundMethod) || other.refundMethod == refundMethod)&&(identical(other.refundAmount, refundAmount) || other.refundAmount == refundAmount)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&const DeepCollectionEquality().equals(other._items, _items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,saleId,returnNumber,reason,note,refundMethod,refundAmount,createdAt,const DeepCollectionEquality().hash(_items));

@override
String toString() {
  return 'SaleReturnDto(id: $id, saleId: $saleId, returnNumber: $returnNumber, reason: $reason, note: $note, refundMethod: $refundMethod, refundAmount: $refundAmount, createdAt: $createdAt, items: $items)';
}


}

/// @nodoc
abstract mixin class _$SaleReturnDtoCopyWith<$Res> implements $SaleReturnDtoCopyWith<$Res> {
  factory _$SaleReturnDtoCopyWith(_SaleReturnDto value, $Res Function(_SaleReturnDto) _then) = __$SaleReturnDtoCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'sale_id') String saleId,@JsonKey(name: 'return_number') int? returnNumber, String reason, String? note,@JsonKey(name: 'refund_method') String refundMethod,@JsonKey(name: 'refund_amount') String refundAmount,@JsonKey(name: 'created_at') String createdAt, List<SaleReturnItemDto> items
});




}
/// @nodoc
class __$SaleReturnDtoCopyWithImpl<$Res>
    implements _$SaleReturnDtoCopyWith<$Res> {
  __$SaleReturnDtoCopyWithImpl(this._self, this._then);

  final _SaleReturnDto _self;
  final $Res Function(_SaleReturnDto) _then;

/// Create a copy of SaleReturnDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? saleId = null,Object? returnNumber = freezed,Object? reason = null,Object? note = freezed,Object? refundMethod = null,Object? refundAmount = null,Object? createdAt = null,Object? items = null,}) {
  return _then(_SaleReturnDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,saleId: null == saleId ? _self.saleId : saleId // ignore: cast_nullable_to_non_nullable
as String,returnNumber: freezed == returnNumber ? _self.returnNumber : returnNumber // ignore: cast_nullable_to_non_nullable
as int?,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,refundMethod: null == refundMethod ? _self.refundMethod : refundMethod // ignore: cast_nullable_to_non_nullable
as String,refundAmount: null == refundAmount ? _self.refundAmount : refundAmount // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<SaleReturnItemDto>,
  ));
}


}


/// @nodoc
mixin _$ReturnsSyncBatchRequestDto {

 List<SaleReturnCreateDto> get returns;
/// Create a copy of ReturnsSyncBatchRequestDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReturnsSyncBatchRequestDtoCopyWith<ReturnsSyncBatchRequestDto> get copyWith => _$ReturnsSyncBatchRequestDtoCopyWithImpl<ReturnsSyncBatchRequestDto>(this as ReturnsSyncBatchRequestDto, _$identity);

  /// Serializes this ReturnsSyncBatchRequestDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReturnsSyncBatchRequestDto&&const DeepCollectionEquality().equals(other.returns, returns));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(returns));

@override
String toString() {
  return 'ReturnsSyncBatchRequestDto(returns: $returns)';
}


}

/// @nodoc
abstract mixin class $ReturnsSyncBatchRequestDtoCopyWith<$Res>  {
  factory $ReturnsSyncBatchRequestDtoCopyWith(ReturnsSyncBatchRequestDto value, $Res Function(ReturnsSyncBatchRequestDto) _then) = _$ReturnsSyncBatchRequestDtoCopyWithImpl;
@useResult
$Res call({
 List<SaleReturnCreateDto> returns
});




}
/// @nodoc
class _$ReturnsSyncBatchRequestDtoCopyWithImpl<$Res>
    implements $ReturnsSyncBatchRequestDtoCopyWith<$Res> {
  _$ReturnsSyncBatchRequestDtoCopyWithImpl(this._self, this._then);

  final ReturnsSyncBatchRequestDto _self;
  final $Res Function(ReturnsSyncBatchRequestDto) _then;

/// Create a copy of ReturnsSyncBatchRequestDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? returns = null,}) {
  return _then(_self.copyWith(
returns: null == returns ? _self.returns : returns // ignore: cast_nullable_to_non_nullable
as List<SaleReturnCreateDto>,
  ));
}

}


/// Adds pattern-matching-related methods to [ReturnsSyncBatchRequestDto].
extension ReturnsSyncBatchRequestDtoPatterns on ReturnsSyncBatchRequestDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReturnsSyncBatchRequestDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReturnsSyncBatchRequestDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReturnsSyncBatchRequestDto value)  $default,){
final _that = this;
switch (_that) {
case _ReturnsSyncBatchRequestDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReturnsSyncBatchRequestDto value)?  $default,){
final _that = this;
switch (_that) {
case _ReturnsSyncBatchRequestDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<SaleReturnCreateDto> returns)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReturnsSyncBatchRequestDto() when $default != null:
return $default(_that.returns);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<SaleReturnCreateDto> returns)  $default,) {final _that = this;
switch (_that) {
case _ReturnsSyncBatchRequestDto():
return $default(_that.returns);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<SaleReturnCreateDto> returns)?  $default,) {final _that = this;
switch (_that) {
case _ReturnsSyncBatchRequestDto() when $default != null:
return $default(_that.returns);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReturnsSyncBatchRequestDto implements ReturnsSyncBatchRequestDto {
  const _ReturnsSyncBatchRequestDto({required final  List<SaleReturnCreateDto> returns}): _returns = returns;
  factory _ReturnsSyncBatchRequestDto.fromJson(Map<String, dynamic> json) => _$ReturnsSyncBatchRequestDtoFromJson(json);

 final  List<SaleReturnCreateDto> _returns;
@override List<SaleReturnCreateDto> get returns {
  if (_returns is EqualUnmodifiableListView) return _returns;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_returns);
}


/// Create a copy of ReturnsSyncBatchRequestDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReturnsSyncBatchRequestDtoCopyWith<_ReturnsSyncBatchRequestDto> get copyWith => __$ReturnsSyncBatchRequestDtoCopyWithImpl<_ReturnsSyncBatchRequestDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReturnsSyncBatchRequestDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReturnsSyncBatchRequestDto&&const DeepCollectionEquality().equals(other._returns, _returns));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_returns));

@override
String toString() {
  return 'ReturnsSyncBatchRequestDto(returns: $returns)';
}


}

/// @nodoc
abstract mixin class _$ReturnsSyncBatchRequestDtoCopyWith<$Res> implements $ReturnsSyncBatchRequestDtoCopyWith<$Res> {
  factory _$ReturnsSyncBatchRequestDtoCopyWith(_ReturnsSyncBatchRequestDto value, $Res Function(_ReturnsSyncBatchRequestDto) _then) = __$ReturnsSyncBatchRequestDtoCopyWithImpl;
@override @useResult
$Res call({
 List<SaleReturnCreateDto> returns
});




}
/// @nodoc
class __$ReturnsSyncBatchRequestDtoCopyWithImpl<$Res>
    implements _$ReturnsSyncBatchRequestDtoCopyWith<$Res> {
  __$ReturnsSyncBatchRequestDtoCopyWithImpl(this._self, this._then);

  final _ReturnsSyncBatchRequestDto _self;
  final $Res Function(_ReturnsSyncBatchRequestDto) _then;

/// Create a copy of ReturnsSyncBatchRequestDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? returns = null,}) {
  return _then(_ReturnsSyncBatchRequestDto(
returns: null == returns ? _self._returns : returns // ignore: cast_nullable_to_non_nullable
as List<SaleReturnCreateDto>,
  ));
}


}


/// @nodoc
mixin _$ReturnSyncResultDto {

 String get id;// 'created', 'already_exists', 'rejected' (définitif), 'failed'.
 String get status;@JsonKey(name: 'return_number') int? get returnNumber;@JsonKey(name: 'error_code') String? get errorCode; String? get error;
/// Create a copy of ReturnSyncResultDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReturnSyncResultDtoCopyWith<ReturnSyncResultDto> get copyWith => _$ReturnSyncResultDtoCopyWithImpl<ReturnSyncResultDto>(this as ReturnSyncResultDto, _$identity);

  /// Serializes this ReturnSyncResultDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReturnSyncResultDto&&(identical(other.id, id) || other.id == id)&&(identical(other.status, status) || other.status == status)&&(identical(other.returnNumber, returnNumber) || other.returnNumber == returnNumber)&&(identical(other.errorCode, errorCode) || other.errorCode == errorCode)&&(identical(other.error, error) || other.error == error));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,status,returnNumber,errorCode,error);

@override
String toString() {
  return 'ReturnSyncResultDto(id: $id, status: $status, returnNumber: $returnNumber, errorCode: $errorCode, error: $error)';
}


}

/// @nodoc
abstract mixin class $ReturnSyncResultDtoCopyWith<$Res>  {
  factory $ReturnSyncResultDtoCopyWith(ReturnSyncResultDto value, $Res Function(ReturnSyncResultDto) _then) = _$ReturnSyncResultDtoCopyWithImpl;
@useResult
$Res call({
 String id, String status,@JsonKey(name: 'return_number') int? returnNumber,@JsonKey(name: 'error_code') String? errorCode, String? error
});




}
/// @nodoc
class _$ReturnSyncResultDtoCopyWithImpl<$Res>
    implements $ReturnSyncResultDtoCopyWith<$Res> {
  _$ReturnSyncResultDtoCopyWithImpl(this._self, this._then);

  final ReturnSyncResultDto _self;
  final $Res Function(ReturnSyncResultDto) _then;

/// Create a copy of ReturnSyncResultDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? status = null,Object? returnNumber = freezed,Object? errorCode = freezed,Object? error = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,returnNumber: freezed == returnNumber ? _self.returnNumber : returnNumber // ignore: cast_nullable_to_non_nullable
as int?,errorCode: freezed == errorCode ? _self.errorCode : errorCode // ignore: cast_nullable_to_non_nullable
as String?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ReturnSyncResultDto].
extension ReturnSyncResultDtoPatterns on ReturnSyncResultDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReturnSyncResultDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReturnSyncResultDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReturnSyncResultDto value)  $default,){
final _that = this;
switch (_that) {
case _ReturnSyncResultDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReturnSyncResultDto value)?  $default,){
final _that = this;
switch (_that) {
case _ReturnSyncResultDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String status, @JsonKey(name: 'return_number')  int? returnNumber, @JsonKey(name: 'error_code')  String? errorCode,  String? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReturnSyncResultDto() when $default != null:
return $default(_that.id,_that.status,_that.returnNumber,_that.errorCode,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String status, @JsonKey(name: 'return_number')  int? returnNumber, @JsonKey(name: 'error_code')  String? errorCode,  String? error)  $default,) {final _that = this;
switch (_that) {
case _ReturnSyncResultDto():
return $default(_that.id,_that.status,_that.returnNumber,_that.errorCode,_that.error);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String status, @JsonKey(name: 'return_number')  int? returnNumber, @JsonKey(name: 'error_code')  String? errorCode,  String? error)?  $default,) {final _that = this;
switch (_that) {
case _ReturnSyncResultDto() when $default != null:
return $default(_that.id,_that.status,_that.returnNumber,_that.errorCode,_that.error);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReturnSyncResultDto implements ReturnSyncResultDto {
  const _ReturnSyncResultDto({required this.id, required this.status, @JsonKey(name: 'return_number') this.returnNumber, @JsonKey(name: 'error_code') this.errorCode, this.error});
  factory _ReturnSyncResultDto.fromJson(Map<String, dynamic> json) => _$ReturnSyncResultDtoFromJson(json);

@override final  String id;
// 'created', 'already_exists', 'rejected' (définitif), 'failed'.
@override final  String status;
@override@JsonKey(name: 'return_number') final  int? returnNumber;
@override@JsonKey(name: 'error_code') final  String? errorCode;
@override final  String? error;

/// Create a copy of ReturnSyncResultDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReturnSyncResultDtoCopyWith<_ReturnSyncResultDto> get copyWith => __$ReturnSyncResultDtoCopyWithImpl<_ReturnSyncResultDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReturnSyncResultDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReturnSyncResultDto&&(identical(other.id, id) || other.id == id)&&(identical(other.status, status) || other.status == status)&&(identical(other.returnNumber, returnNumber) || other.returnNumber == returnNumber)&&(identical(other.errorCode, errorCode) || other.errorCode == errorCode)&&(identical(other.error, error) || other.error == error));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,status,returnNumber,errorCode,error);

@override
String toString() {
  return 'ReturnSyncResultDto(id: $id, status: $status, returnNumber: $returnNumber, errorCode: $errorCode, error: $error)';
}


}

/// @nodoc
abstract mixin class _$ReturnSyncResultDtoCopyWith<$Res> implements $ReturnSyncResultDtoCopyWith<$Res> {
  factory _$ReturnSyncResultDtoCopyWith(_ReturnSyncResultDto value, $Res Function(_ReturnSyncResultDto) _then) = __$ReturnSyncResultDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, String status,@JsonKey(name: 'return_number') int? returnNumber,@JsonKey(name: 'error_code') String? errorCode, String? error
});




}
/// @nodoc
class __$ReturnSyncResultDtoCopyWithImpl<$Res>
    implements _$ReturnSyncResultDtoCopyWith<$Res> {
  __$ReturnSyncResultDtoCopyWithImpl(this._self, this._then);

  final _ReturnSyncResultDto _self;
  final $Res Function(_ReturnSyncResultDto) _then;

/// Create a copy of ReturnSyncResultDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? status = null,Object? returnNumber = freezed,Object? errorCode = freezed,Object? error = freezed,}) {
  return _then(_ReturnSyncResultDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,returnNumber: freezed == returnNumber ? _self.returnNumber : returnNumber // ignore: cast_nullable_to_non_nullable
as int?,errorCode: freezed == errorCode ? _self.errorCode : errorCode // ignore: cast_nullable_to_non_nullable
as String?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$ReturnsSyncBatchResponseDto {

 int get processed; List<ReturnSyncResultDto> get results;
/// Create a copy of ReturnsSyncBatchResponseDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReturnsSyncBatchResponseDtoCopyWith<ReturnsSyncBatchResponseDto> get copyWith => _$ReturnsSyncBatchResponseDtoCopyWithImpl<ReturnsSyncBatchResponseDto>(this as ReturnsSyncBatchResponseDto, _$identity);

  /// Serializes this ReturnsSyncBatchResponseDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReturnsSyncBatchResponseDto&&(identical(other.processed, processed) || other.processed == processed)&&const DeepCollectionEquality().equals(other.results, results));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,processed,const DeepCollectionEquality().hash(results));

@override
String toString() {
  return 'ReturnsSyncBatchResponseDto(processed: $processed, results: $results)';
}


}

/// @nodoc
abstract mixin class $ReturnsSyncBatchResponseDtoCopyWith<$Res>  {
  factory $ReturnsSyncBatchResponseDtoCopyWith(ReturnsSyncBatchResponseDto value, $Res Function(ReturnsSyncBatchResponseDto) _then) = _$ReturnsSyncBatchResponseDtoCopyWithImpl;
@useResult
$Res call({
 int processed, List<ReturnSyncResultDto> results
});




}
/// @nodoc
class _$ReturnsSyncBatchResponseDtoCopyWithImpl<$Res>
    implements $ReturnsSyncBatchResponseDtoCopyWith<$Res> {
  _$ReturnsSyncBatchResponseDtoCopyWithImpl(this._self, this._then);

  final ReturnsSyncBatchResponseDto _self;
  final $Res Function(ReturnsSyncBatchResponseDto) _then;

/// Create a copy of ReturnsSyncBatchResponseDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? processed = null,Object? results = null,}) {
  return _then(_self.copyWith(
processed: null == processed ? _self.processed : processed // ignore: cast_nullable_to_non_nullable
as int,results: null == results ? _self.results : results // ignore: cast_nullable_to_non_nullable
as List<ReturnSyncResultDto>,
  ));
}

}


/// Adds pattern-matching-related methods to [ReturnsSyncBatchResponseDto].
extension ReturnsSyncBatchResponseDtoPatterns on ReturnsSyncBatchResponseDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReturnsSyncBatchResponseDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReturnsSyncBatchResponseDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReturnsSyncBatchResponseDto value)  $default,){
final _that = this;
switch (_that) {
case _ReturnsSyncBatchResponseDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReturnsSyncBatchResponseDto value)?  $default,){
final _that = this;
switch (_that) {
case _ReturnsSyncBatchResponseDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int processed,  List<ReturnSyncResultDto> results)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReturnsSyncBatchResponseDto() when $default != null:
return $default(_that.processed,_that.results);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int processed,  List<ReturnSyncResultDto> results)  $default,) {final _that = this;
switch (_that) {
case _ReturnsSyncBatchResponseDto():
return $default(_that.processed,_that.results);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int processed,  List<ReturnSyncResultDto> results)?  $default,) {final _that = this;
switch (_that) {
case _ReturnsSyncBatchResponseDto() when $default != null:
return $default(_that.processed,_that.results);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReturnsSyncBatchResponseDto implements ReturnsSyncBatchResponseDto {
  const _ReturnsSyncBatchResponseDto({required this.processed, required final  List<ReturnSyncResultDto> results}): _results = results;
  factory _ReturnsSyncBatchResponseDto.fromJson(Map<String, dynamic> json) => _$ReturnsSyncBatchResponseDtoFromJson(json);

@override final  int processed;
 final  List<ReturnSyncResultDto> _results;
@override List<ReturnSyncResultDto> get results {
  if (_results is EqualUnmodifiableListView) return _results;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_results);
}


/// Create a copy of ReturnsSyncBatchResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReturnsSyncBatchResponseDtoCopyWith<_ReturnsSyncBatchResponseDto> get copyWith => __$ReturnsSyncBatchResponseDtoCopyWithImpl<_ReturnsSyncBatchResponseDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReturnsSyncBatchResponseDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReturnsSyncBatchResponseDto&&(identical(other.processed, processed) || other.processed == processed)&&const DeepCollectionEquality().equals(other._results, _results));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,processed,const DeepCollectionEquality().hash(_results));

@override
String toString() {
  return 'ReturnsSyncBatchResponseDto(processed: $processed, results: $results)';
}


}

/// @nodoc
abstract mixin class _$ReturnsSyncBatchResponseDtoCopyWith<$Res> implements $ReturnsSyncBatchResponseDtoCopyWith<$Res> {
  factory _$ReturnsSyncBatchResponseDtoCopyWith(_ReturnsSyncBatchResponseDto value, $Res Function(_ReturnsSyncBatchResponseDto) _then) = __$ReturnsSyncBatchResponseDtoCopyWithImpl;
@override @useResult
$Res call({
 int processed, List<ReturnSyncResultDto> results
});




}
/// @nodoc
class __$ReturnsSyncBatchResponseDtoCopyWithImpl<$Res>
    implements _$ReturnsSyncBatchResponseDtoCopyWith<$Res> {
  __$ReturnsSyncBatchResponseDtoCopyWithImpl(this._self, this._then);

  final _ReturnsSyncBatchResponseDto _self;
  final $Res Function(_ReturnsSyncBatchResponseDto) _then;

/// Create a copy of ReturnsSyncBatchResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? processed = null,Object? results = null,}) {
  return _then(_ReturnsSyncBatchResponseDto(
processed: null == processed ? _self.processed : processed // ignore: cast_nullable_to_non_nullable
as int,results: null == results ? _self._results : results // ignore: cast_nullable_to_non_nullable
as List<ReturnSyncResultDto>,
  ));
}


}

// dart format on
