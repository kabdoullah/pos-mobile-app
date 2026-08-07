// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stock_movement_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StockMovementDto {

 String get id;@JsonKey(name: 'store_id') String get storeId;@JsonKey(name: 'product_id') String get productId;@JsonKey(name: 'quantity_delta') int? get quantityDelta; StockMovementReasonDto get reason;@JsonKey(name: 'resulting_stock') int? get resultingStock;@JsonKey(name: 'sale_id') String? get saleId;@JsonKey(name: 'created_by') String? get createdBy; String? get note;@JsonKey(name: 'created_at') String get createdAt;
/// Create a copy of StockMovementDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StockMovementDtoCopyWith<StockMovementDto> get copyWith => _$StockMovementDtoCopyWithImpl<StockMovementDto>(this as StockMovementDto, _$identity);

  /// Serializes this StockMovementDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StockMovementDto&&(identical(other.id, id) || other.id == id)&&(identical(other.storeId, storeId) || other.storeId == storeId)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.quantityDelta, quantityDelta) || other.quantityDelta == quantityDelta)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.resultingStock, resultingStock) || other.resultingStock == resultingStock)&&(identical(other.saleId, saleId) || other.saleId == saleId)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.note, note) || other.note == note)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,storeId,productId,quantityDelta,reason,resultingStock,saleId,createdBy,note,createdAt);

@override
String toString() {
  return 'StockMovementDto(id: $id, storeId: $storeId, productId: $productId, quantityDelta: $quantityDelta, reason: $reason, resultingStock: $resultingStock, saleId: $saleId, createdBy: $createdBy, note: $note, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $StockMovementDtoCopyWith<$Res>  {
  factory $StockMovementDtoCopyWith(StockMovementDto value, $Res Function(StockMovementDto) _then) = _$StockMovementDtoCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'store_id') String storeId,@JsonKey(name: 'product_id') String productId,@JsonKey(name: 'quantity_delta') int? quantityDelta, StockMovementReasonDto reason,@JsonKey(name: 'resulting_stock') int? resultingStock,@JsonKey(name: 'sale_id') String? saleId,@JsonKey(name: 'created_by') String? createdBy, String? note,@JsonKey(name: 'created_at') String createdAt
});




}
/// @nodoc
class _$StockMovementDtoCopyWithImpl<$Res>
    implements $StockMovementDtoCopyWith<$Res> {
  _$StockMovementDtoCopyWithImpl(this._self, this._then);

  final StockMovementDto _self;
  final $Res Function(StockMovementDto) _then;

/// Create a copy of StockMovementDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? storeId = null,Object? productId = null,Object? quantityDelta = freezed,Object? reason = null,Object? resultingStock = freezed,Object? saleId = freezed,Object? createdBy = freezed,Object? note = freezed,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,storeId: null == storeId ? _self.storeId : storeId // ignore: cast_nullable_to_non_nullable
as String,productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,quantityDelta: freezed == quantityDelta ? _self.quantityDelta : quantityDelta // ignore: cast_nullable_to_non_nullable
as int?,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as StockMovementReasonDto,resultingStock: freezed == resultingStock ? _self.resultingStock : resultingStock // ignore: cast_nullable_to_non_nullable
as int?,saleId: freezed == saleId ? _self.saleId : saleId // ignore: cast_nullable_to_non_nullable
as String?,createdBy: freezed == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [StockMovementDto].
extension StockMovementDtoPatterns on StockMovementDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StockMovementDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StockMovementDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StockMovementDto value)  $default,){
final _that = this;
switch (_that) {
case _StockMovementDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StockMovementDto value)?  $default,){
final _that = this;
switch (_that) {
case _StockMovementDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'store_id')  String storeId, @JsonKey(name: 'product_id')  String productId, @JsonKey(name: 'quantity_delta')  int? quantityDelta,  StockMovementReasonDto reason, @JsonKey(name: 'resulting_stock')  int? resultingStock, @JsonKey(name: 'sale_id')  String? saleId, @JsonKey(name: 'created_by')  String? createdBy,  String? note, @JsonKey(name: 'created_at')  String createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StockMovementDto() when $default != null:
return $default(_that.id,_that.storeId,_that.productId,_that.quantityDelta,_that.reason,_that.resultingStock,_that.saleId,_that.createdBy,_that.note,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'store_id')  String storeId, @JsonKey(name: 'product_id')  String productId, @JsonKey(name: 'quantity_delta')  int? quantityDelta,  StockMovementReasonDto reason, @JsonKey(name: 'resulting_stock')  int? resultingStock, @JsonKey(name: 'sale_id')  String? saleId, @JsonKey(name: 'created_by')  String? createdBy,  String? note, @JsonKey(name: 'created_at')  String createdAt)  $default,) {final _that = this;
switch (_that) {
case _StockMovementDto():
return $default(_that.id,_that.storeId,_that.productId,_that.quantityDelta,_that.reason,_that.resultingStock,_that.saleId,_that.createdBy,_that.note,_that.createdAt);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'store_id')  String storeId, @JsonKey(name: 'product_id')  String productId, @JsonKey(name: 'quantity_delta')  int? quantityDelta,  StockMovementReasonDto reason, @JsonKey(name: 'resulting_stock')  int? resultingStock, @JsonKey(name: 'sale_id')  String? saleId, @JsonKey(name: 'created_by')  String? createdBy,  String? note, @JsonKey(name: 'created_at')  String createdAt)?  $default,) {final _that = this;
switch (_that) {
case _StockMovementDto() when $default != null:
return $default(_that.id,_that.storeId,_that.productId,_that.quantityDelta,_that.reason,_that.resultingStock,_that.saleId,_that.createdBy,_that.note,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StockMovementDto implements StockMovementDto {
  const _StockMovementDto({required this.id, @JsonKey(name: 'store_id') required this.storeId, @JsonKey(name: 'product_id') required this.productId, @JsonKey(name: 'quantity_delta') this.quantityDelta, required this.reason, @JsonKey(name: 'resulting_stock') this.resultingStock, @JsonKey(name: 'sale_id') this.saleId, @JsonKey(name: 'created_by') this.createdBy, this.note, @JsonKey(name: 'created_at') required this.createdAt});
  factory _StockMovementDto.fromJson(Map<String, dynamic> json) => _$StockMovementDtoFromJson(json);

@override final  String id;
@override@JsonKey(name: 'store_id') final  String storeId;
@override@JsonKey(name: 'product_id') final  String productId;
@override@JsonKey(name: 'quantity_delta') final  int? quantityDelta;
@override final  StockMovementReasonDto reason;
@override@JsonKey(name: 'resulting_stock') final  int? resultingStock;
@override@JsonKey(name: 'sale_id') final  String? saleId;
@override@JsonKey(name: 'created_by') final  String? createdBy;
@override final  String? note;
@override@JsonKey(name: 'created_at') final  String createdAt;

/// Create a copy of StockMovementDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StockMovementDtoCopyWith<_StockMovementDto> get copyWith => __$StockMovementDtoCopyWithImpl<_StockMovementDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StockMovementDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StockMovementDto&&(identical(other.id, id) || other.id == id)&&(identical(other.storeId, storeId) || other.storeId == storeId)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.quantityDelta, quantityDelta) || other.quantityDelta == quantityDelta)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.resultingStock, resultingStock) || other.resultingStock == resultingStock)&&(identical(other.saleId, saleId) || other.saleId == saleId)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.note, note) || other.note == note)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,storeId,productId,quantityDelta,reason,resultingStock,saleId,createdBy,note,createdAt);

@override
String toString() {
  return 'StockMovementDto(id: $id, storeId: $storeId, productId: $productId, quantityDelta: $quantityDelta, reason: $reason, resultingStock: $resultingStock, saleId: $saleId, createdBy: $createdBy, note: $note, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$StockMovementDtoCopyWith<$Res> implements $StockMovementDtoCopyWith<$Res> {
  factory _$StockMovementDtoCopyWith(_StockMovementDto value, $Res Function(_StockMovementDto) _then) = __$StockMovementDtoCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'store_id') String storeId,@JsonKey(name: 'product_id') String productId,@JsonKey(name: 'quantity_delta') int? quantityDelta, StockMovementReasonDto reason,@JsonKey(name: 'resulting_stock') int? resultingStock,@JsonKey(name: 'sale_id') String? saleId,@JsonKey(name: 'created_by') String? createdBy, String? note,@JsonKey(name: 'created_at') String createdAt
});




}
/// @nodoc
class __$StockMovementDtoCopyWithImpl<$Res>
    implements _$StockMovementDtoCopyWith<$Res> {
  __$StockMovementDtoCopyWithImpl(this._self, this._then);

  final _StockMovementDto _self;
  final $Res Function(_StockMovementDto) _then;

/// Create a copy of StockMovementDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? storeId = null,Object? productId = null,Object? quantityDelta = freezed,Object? reason = null,Object? resultingStock = freezed,Object? saleId = freezed,Object? createdBy = freezed,Object? note = freezed,Object? createdAt = null,}) {
  return _then(_StockMovementDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,storeId: null == storeId ? _self.storeId : storeId // ignore: cast_nullable_to_non_nullable
as String,productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,quantityDelta: freezed == quantityDelta ? _self.quantityDelta : quantityDelta // ignore: cast_nullable_to_non_nullable
as int?,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as StockMovementReasonDto,resultingStock: freezed == resultingStock ? _self.resultingStock : resultingStock // ignore: cast_nullable_to_non_nullable
as int?,saleId: freezed == saleId ? _self.saleId : saleId // ignore: cast_nullable_to_non_nullable
as String?,createdBy: freezed == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$ManualStockAdjustmentCreateDto {

@JsonKey(name: 'product_id') String get productId;@JsonKey(name: 'quantity_delta') int get quantityDelta; String? get note;
/// Create a copy of ManualStockAdjustmentCreateDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ManualStockAdjustmentCreateDtoCopyWith<ManualStockAdjustmentCreateDto> get copyWith => _$ManualStockAdjustmentCreateDtoCopyWithImpl<ManualStockAdjustmentCreateDto>(this as ManualStockAdjustmentCreateDto, _$identity);

  /// Serializes this ManualStockAdjustmentCreateDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ManualStockAdjustmentCreateDto&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.quantityDelta, quantityDelta) || other.quantityDelta == quantityDelta)&&(identical(other.note, note) || other.note == note));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,productId,quantityDelta,note);

@override
String toString() {
  return 'ManualStockAdjustmentCreateDto(productId: $productId, quantityDelta: $quantityDelta, note: $note)';
}


}

/// @nodoc
abstract mixin class $ManualStockAdjustmentCreateDtoCopyWith<$Res>  {
  factory $ManualStockAdjustmentCreateDtoCopyWith(ManualStockAdjustmentCreateDto value, $Res Function(ManualStockAdjustmentCreateDto) _then) = _$ManualStockAdjustmentCreateDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'product_id') String productId,@JsonKey(name: 'quantity_delta') int quantityDelta, String? note
});




}
/// @nodoc
class _$ManualStockAdjustmentCreateDtoCopyWithImpl<$Res>
    implements $ManualStockAdjustmentCreateDtoCopyWith<$Res> {
  _$ManualStockAdjustmentCreateDtoCopyWithImpl(this._self, this._then);

  final ManualStockAdjustmentCreateDto _self;
  final $Res Function(ManualStockAdjustmentCreateDto) _then;

/// Create a copy of ManualStockAdjustmentCreateDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? productId = null,Object? quantityDelta = null,Object? note = freezed,}) {
  return _then(_self.copyWith(
productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,quantityDelta: null == quantityDelta ? _self.quantityDelta : quantityDelta // ignore: cast_nullable_to_non_nullable
as int,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ManualStockAdjustmentCreateDto].
extension ManualStockAdjustmentCreateDtoPatterns on ManualStockAdjustmentCreateDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ManualStockAdjustmentCreateDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ManualStockAdjustmentCreateDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ManualStockAdjustmentCreateDto value)  $default,){
final _that = this;
switch (_that) {
case _ManualStockAdjustmentCreateDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ManualStockAdjustmentCreateDto value)?  $default,){
final _that = this;
switch (_that) {
case _ManualStockAdjustmentCreateDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'product_id')  String productId, @JsonKey(name: 'quantity_delta')  int quantityDelta,  String? note)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ManualStockAdjustmentCreateDto() when $default != null:
return $default(_that.productId,_that.quantityDelta,_that.note);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'product_id')  String productId, @JsonKey(name: 'quantity_delta')  int quantityDelta,  String? note)  $default,) {final _that = this;
switch (_that) {
case _ManualStockAdjustmentCreateDto():
return $default(_that.productId,_that.quantityDelta,_that.note);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'product_id')  String productId, @JsonKey(name: 'quantity_delta')  int quantityDelta,  String? note)?  $default,) {final _that = this;
switch (_that) {
case _ManualStockAdjustmentCreateDto() when $default != null:
return $default(_that.productId,_that.quantityDelta,_that.note);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ManualStockAdjustmentCreateDto implements ManualStockAdjustmentCreateDto {
  const _ManualStockAdjustmentCreateDto({@JsonKey(name: 'product_id') required this.productId, @JsonKey(name: 'quantity_delta') required this.quantityDelta, this.note});
  factory _ManualStockAdjustmentCreateDto.fromJson(Map<String, dynamic> json) => _$ManualStockAdjustmentCreateDtoFromJson(json);

@override@JsonKey(name: 'product_id') final  String productId;
@override@JsonKey(name: 'quantity_delta') final  int quantityDelta;
@override final  String? note;

/// Create a copy of ManualStockAdjustmentCreateDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ManualStockAdjustmentCreateDtoCopyWith<_ManualStockAdjustmentCreateDto> get copyWith => __$ManualStockAdjustmentCreateDtoCopyWithImpl<_ManualStockAdjustmentCreateDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ManualStockAdjustmentCreateDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ManualStockAdjustmentCreateDto&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.quantityDelta, quantityDelta) || other.quantityDelta == quantityDelta)&&(identical(other.note, note) || other.note == note));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,productId,quantityDelta,note);

@override
String toString() {
  return 'ManualStockAdjustmentCreateDto(productId: $productId, quantityDelta: $quantityDelta, note: $note)';
}


}

/// @nodoc
abstract mixin class _$ManualStockAdjustmentCreateDtoCopyWith<$Res> implements $ManualStockAdjustmentCreateDtoCopyWith<$Res> {
  factory _$ManualStockAdjustmentCreateDtoCopyWith(_ManualStockAdjustmentCreateDto value, $Res Function(_ManualStockAdjustmentCreateDto) _then) = __$ManualStockAdjustmentCreateDtoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'product_id') String productId,@JsonKey(name: 'quantity_delta') int quantityDelta, String? note
});




}
/// @nodoc
class __$ManualStockAdjustmentCreateDtoCopyWithImpl<$Res>
    implements _$ManualStockAdjustmentCreateDtoCopyWith<$Res> {
  __$ManualStockAdjustmentCreateDtoCopyWithImpl(this._self, this._then);

  final _ManualStockAdjustmentCreateDto _self;
  final $Res Function(_ManualStockAdjustmentCreateDto) _then;

/// Create a copy of ManualStockAdjustmentCreateDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? productId = null,Object? quantityDelta = null,Object? note = freezed,}) {
  return _then(_ManualStockAdjustmentCreateDto(
productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,quantityDelta: null == quantityDelta ? _self.quantityDelta : quantityDelta // ignore: cast_nullable_to_non_nullable
as int,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
