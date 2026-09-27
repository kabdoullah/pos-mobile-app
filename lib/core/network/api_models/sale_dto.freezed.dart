// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sale_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SaleItemDto {

 String get id;@JsonKey(name: 'sale_id') String get saleId;@JsonKey(name: 'product_id') String? get productId;@JsonKey(name: 'product_name_at_sale') String get productNameAtSale;@JsonKey(name: 'unit_price_at_sale') String get unitPriceAtSale; int get quantity;@JsonKey(name: 'line_total') String get lineTotal;// Champs ADR-0009 : absents d'une vente antérieure → pas de réduction,
// prix d'achat inconnu.
@JsonKey(name: 'purchase_price_at_sale') String? get purchasePriceAtSale;@JsonKey(name: 'discount_type') String? get discountType;@JsonKey(name: 'discount_value') String? get discountValue;@JsonKey(name: 'discount_amount') String get discountAmount;
/// Create a copy of SaleItemDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SaleItemDtoCopyWith<SaleItemDto> get copyWith => _$SaleItemDtoCopyWithImpl<SaleItemDto>(this as SaleItemDto, _$identity);

  /// Serializes this SaleItemDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SaleItemDto&&(identical(other.id, id) || other.id == id)&&(identical(other.saleId, saleId) || other.saleId == saleId)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.productNameAtSale, productNameAtSale) || other.productNameAtSale == productNameAtSale)&&(identical(other.unitPriceAtSale, unitPriceAtSale) || other.unitPriceAtSale == unitPriceAtSale)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.lineTotal, lineTotal) || other.lineTotal == lineTotal)&&(identical(other.purchasePriceAtSale, purchasePriceAtSale) || other.purchasePriceAtSale == purchasePriceAtSale)&&(identical(other.discountType, discountType) || other.discountType == discountType)&&(identical(other.discountValue, discountValue) || other.discountValue == discountValue)&&(identical(other.discountAmount, discountAmount) || other.discountAmount == discountAmount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,saleId,productId,productNameAtSale,unitPriceAtSale,quantity,lineTotal,purchasePriceAtSale,discountType,discountValue,discountAmount);

@override
String toString() {
  return 'SaleItemDto(id: $id, saleId: $saleId, productId: $productId, productNameAtSale: $productNameAtSale, unitPriceAtSale: $unitPriceAtSale, quantity: $quantity, lineTotal: $lineTotal, purchasePriceAtSale: $purchasePriceAtSale, discountType: $discountType, discountValue: $discountValue, discountAmount: $discountAmount)';
}


}

/// @nodoc
abstract mixin class $SaleItemDtoCopyWith<$Res>  {
  factory $SaleItemDtoCopyWith(SaleItemDto value, $Res Function(SaleItemDto) _then) = _$SaleItemDtoCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'sale_id') String saleId,@JsonKey(name: 'product_id') String? productId,@JsonKey(name: 'product_name_at_sale') String productNameAtSale,@JsonKey(name: 'unit_price_at_sale') String unitPriceAtSale, int quantity,@JsonKey(name: 'line_total') String lineTotal,@JsonKey(name: 'purchase_price_at_sale') String? purchasePriceAtSale,@JsonKey(name: 'discount_type') String? discountType,@JsonKey(name: 'discount_value') String? discountValue,@JsonKey(name: 'discount_amount') String discountAmount
});




}
/// @nodoc
class _$SaleItemDtoCopyWithImpl<$Res>
    implements $SaleItemDtoCopyWith<$Res> {
  _$SaleItemDtoCopyWithImpl(this._self, this._then);

  final SaleItemDto _self;
  final $Res Function(SaleItemDto) _then;

/// Create a copy of SaleItemDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? saleId = null,Object? productId = freezed,Object? productNameAtSale = null,Object? unitPriceAtSale = null,Object? quantity = null,Object? lineTotal = null,Object? purchasePriceAtSale = freezed,Object? discountType = freezed,Object? discountValue = freezed,Object? discountAmount = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,saleId: null == saleId ? _self.saleId : saleId // ignore: cast_nullable_to_non_nullable
as String,productId: freezed == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String?,productNameAtSale: null == productNameAtSale ? _self.productNameAtSale : productNameAtSale // ignore: cast_nullable_to_non_nullable
as String,unitPriceAtSale: null == unitPriceAtSale ? _self.unitPriceAtSale : unitPriceAtSale // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,lineTotal: null == lineTotal ? _self.lineTotal : lineTotal // ignore: cast_nullable_to_non_nullable
as String,purchasePriceAtSale: freezed == purchasePriceAtSale ? _self.purchasePriceAtSale : purchasePriceAtSale // ignore: cast_nullable_to_non_nullable
as String?,discountType: freezed == discountType ? _self.discountType : discountType // ignore: cast_nullable_to_non_nullable
as String?,discountValue: freezed == discountValue ? _self.discountValue : discountValue // ignore: cast_nullable_to_non_nullable
as String?,discountAmount: null == discountAmount ? _self.discountAmount : discountAmount // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [SaleItemDto].
extension SaleItemDtoPatterns on SaleItemDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SaleItemDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SaleItemDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SaleItemDto value)  $default,){
final _that = this;
switch (_that) {
case _SaleItemDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SaleItemDto value)?  $default,){
final _that = this;
switch (_that) {
case _SaleItemDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'sale_id')  String saleId, @JsonKey(name: 'product_id')  String? productId, @JsonKey(name: 'product_name_at_sale')  String productNameAtSale, @JsonKey(name: 'unit_price_at_sale')  String unitPriceAtSale,  int quantity, @JsonKey(name: 'line_total')  String lineTotal, @JsonKey(name: 'purchase_price_at_sale')  String? purchasePriceAtSale, @JsonKey(name: 'discount_type')  String? discountType, @JsonKey(name: 'discount_value')  String? discountValue, @JsonKey(name: 'discount_amount')  String discountAmount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SaleItemDto() when $default != null:
return $default(_that.id,_that.saleId,_that.productId,_that.productNameAtSale,_that.unitPriceAtSale,_that.quantity,_that.lineTotal,_that.purchasePriceAtSale,_that.discountType,_that.discountValue,_that.discountAmount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'sale_id')  String saleId, @JsonKey(name: 'product_id')  String? productId, @JsonKey(name: 'product_name_at_sale')  String productNameAtSale, @JsonKey(name: 'unit_price_at_sale')  String unitPriceAtSale,  int quantity, @JsonKey(name: 'line_total')  String lineTotal, @JsonKey(name: 'purchase_price_at_sale')  String? purchasePriceAtSale, @JsonKey(name: 'discount_type')  String? discountType, @JsonKey(name: 'discount_value')  String? discountValue, @JsonKey(name: 'discount_amount')  String discountAmount)  $default,) {final _that = this;
switch (_that) {
case _SaleItemDto():
return $default(_that.id,_that.saleId,_that.productId,_that.productNameAtSale,_that.unitPriceAtSale,_that.quantity,_that.lineTotal,_that.purchasePriceAtSale,_that.discountType,_that.discountValue,_that.discountAmount);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'sale_id')  String saleId, @JsonKey(name: 'product_id')  String? productId, @JsonKey(name: 'product_name_at_sale')  String productNameAtSale, @JsonKey(name: 'unit_price_at_sale')  String unitPriceAtSale,  int quantity, @JsonKey(name: 'line_total')  String lineTotal, @JsonKey(name: 'purchase_price_at_sale')  String? purchasePriceAtSale, @JsonKey(name: 'discount_type')  String? discountType, @JsonKey(name: 'discount_value')  String? discountValue, @JsonKey(name: 'discount_amount')  String discountAmount)?  $default,) {final _that = this;
switch (_that) {
case _SaleItemDto() when $default != null:
return $default(_that.id,_that.saleId,_that.productId,_that.productNameAtSale,_that.unitPriceAtSale,_that.quantity,_that.lineTotal,_that.purchasePriceAtSale,_that.discountType,_that.discountValue,_that.discountAmount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SaleItemDto implements SaleItemDto {
  const _SaleItemDto({required this.id, @JsonKey(name: 'sale_id') required this.saleId, @JsonKey(name: 'product_id') this.productId, @JsonKey(name: 'product_name_at_sale') required this.productNameAtSale, @JsonKey(name: 'unit_price_at_sale') required this.unitPriceAtSale, required this.quantity, @JsonKey(name: 'line_total') required this.lineTotal, @JsonKey(name: 'purchase_price_at_sale') this.purchasePriceAtSale, @JsonKey(name: 'discount_type') this.discountType, @JsonKey(name: 'discount_value') this.discountValue, @JsonKey(name: 'discount_amount') this.discountAmount = '0'});
  factory _SaleItemDto.fromJson(Map<String, dynamic> json) => _$SaleItemDtoFromJson(json);

@override final  String id;
@override@JsonKey(name: 'sale_id') final  String saleId;
@override@JsonKey(name: 'product_id') final  String? productId;
@override@JsonKey(name: 'product_name_at_sale') final  String productNameAtSale;
@override@JsonKey(name: 'unit_price_at_sale') final  String unitPriceAtSale;
@override final  int quantity;
@override@JsonKey(name: 'line_total') final  String lineTotal;
// Champs ADR-0009 : absents d'une vente antérieure → pas de réduction,
// prix d'achat inconnu.
@override@JsonKey(name: 'purchase_price_at_sale') final  String? purchasePriceAtSale;
@override@JsonKey(name: 'discount_type') final  String? discountType;
@override@JsonKey(name: 'discount_value') final  String? discountValue;
@override@JsonKey(name: 'discount_amount') final  String discountAmount;

/// Create a copy of SaleItemDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SaleItemDtoCopyWith<_SaleItemDto> get copyWith => __$SaleItemDtoCopyWithImpl<_SaleItemDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SaleItemDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SaleItemDto&&(identical(other.id, id) || other.id == id)&&(identical(other.saleId, saleId) || other.saleId == saleId)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.productNameAtSale, productNameAtSale) || other.productNameAtSale == productNameAtSale)&&(identical(other.unitPriceAtSale, unitPriceAtSale) || other.unitPriceAtSale == unitPriceAtSale)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.lineTotal, lineTotal) || other.lineTotal == lineTotal)&&(identical(other.purchasePriceAtSale, purchasePriceAtSale) || other.purchasePriceAtSale == purchasePriceAtSale)&&(identical(other.discountType, discountType) || other.discountType == discountType)&&(identical(other.discountValue, discountValue) || other.discountValue == discountValue)&&(identical(other.discountAmount, discountAmount) || other.discountAmount == discountAmount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,saleId,productId,productNameAtSale,unitPriceAtSale,quantity,lineTotal,purchasePriceAtSale,discountType,discountValue,discountAmount);

@override
String toString() {
  return 'SaleItemDto(id: $id, saleId: $saleId, productId: $productId, productNameAtSale: $productNameAtSale, unitPriceAtSale: $unitPriceAtSale, quantity: $quantity, lineTotal: $lineTotal, purchasePriceAtSale: $purchasePriceAtSale, discountType: $discountType, discountValue: $discountValue, discountAmount: $discountAmount)';
}


}

/// @nodoc
abstract mixin class _$SaleItemDtoCopyWith<$Res> implements $SaleItemDtoCopyWith<$Res> {
  factory _$SaleItemDtoCopyWith(_SaleItemDto value, $Res Function(_SaleItemDto) _then) = __$SaleItemDtoCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'sale_id') String saleId,@JsonKey(name: 'product_id') String? productId,@JsonKey(name: 'product_name_at_sale') String productNameAtSale,@JsonKey(name: 'unit_price_at_sale') String unitPriceAtSale, int quantity,@JsonKey(name: 'line_total') String lineTotal,@JsonKey(name: 'purchase_price_at_sale') String? purchasePriceAtSale,@JsonKey(name: 'discount_type') String? discountType,@JsonKey(name: 'discount_value') String? discountValue,@JsonKey(name: 'discount_amount') String discountAmount
});




}
/// @nodoc
class __$SaleItemDtoCopyWithImpl<$Res>
    implements _$SaleItemDtoCopyWith<$Res> {
  __$SaleItemDtoCopyWithImpl(this._self, this._then);

  final _SaleItemDto _self;
  final $Res Function(_SaleItemDto) _then;

/// Create a copy of SaleItemDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? saleId = null,Object? productId = freezed,Object? productNameAtSale = null,Object? unitPriceAtSale = null,Object? quantity = null,Object? lineTotal = null,Object? purchasePriceAtSale = freezed,Object? discountType = freezed,Object? discountValue = freezed,Object? discountAmount = null,}) {
  return _then(_SaleItemDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,saleId: null == saleId ? _self.saleId : saleId // ignore: cast_nullable_to_non_nullable
as String,productId: freezed == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String?,productNameAtSale: null == productNameAtSale ? _self.productNameAtSale : productNameAtSale // ignore: cast_nullable_to_non_nullable
as String,unitPriceAtSale: null == unitPriceAtSale ? _self.unitPriceAtSale : unitPriceAtSale // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,lineTotal: null == lineTotal ? _self.lineTotal : lineTotal // ignore: cast_nullable_to_non_nullable
as String,purchasePriceAtSale: freezed == purchasePriceAtSale ? _self.purchasePriceAtSale : purchasePriceAtSale // ignore: cast_nullable_to_non_nullable
as String?,discountType: freezed == discountType ? _self.discountType : discountType // ignore: cast_nullable_to_non_nullable
as String?,discountValue: freezed == discountValue ? _self.discountValue : discountValue // ignore: cast_nullable_to_non_nullable
as String?,discountAmount: null == discountAmount ? _self.discountAmount : discountAmount // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$SaleDto {

 String get id;@JsonKey(name: 'store_id') String get storeId;@JsonKey(name: 'receipt_number') int? get receiptNumber;@JsonKey(name: 'total_amount') String get totalAmount;@JsonKey(name: 'vat_amount') String get vatAmount;@JsonKey(name: 'payment_method') String get paymentMethod;@JsonKey(name: 'cash_amount') String? get cashAmount;@JsonKey(name: 'mobile_money_amount') String? get mobileMoneyAmount;@JsonKey(name: 'created_at') String get createdAt;@JsonKey(name: 'synced_at') String get syncedAt;// Remise globale (ADR-0009) ; absente d'une vente antérieure.
@JsonKey(name: 'discount_type') String? get discountType;@JsonKey(name: 'discount_value') String? get discountValue;@JsonKey(name: 'discount_amount') String get discountAmount; List<SaleItemDto> get items;
/// Create a copy of SaleDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SaleDtoCopyWith<SaleDto> get copyWith => _$SaleDtoCopyWithImpl<SaleDto>(this as SaleDto, _$identity);

  /// Serializes this SaleDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SaleDto&&(identical(other.id, id) || other.id == id)&&(identical(other.storeId, storeId) || other.storeId == storeId)&&(identical(other.receiptNumber, receiptNumber) || other.receiptNumber == receiptNumber)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&(identical(other.vatAmount, vatAmount) || other.vatAmount == vatAmount)&&(identical(other.paymentMethod, paymentMethod) || other.paymentMethod == paymentMethod)&&(identical(other.cashAmount, cashAmount) || other.cashAmount == cashAmount)&&(identical(other.mobileMoneyAmount, mobileMoneyAmount) || other.mobileMoneyAmount == mobileMoneyAmount)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.syncedAt, syncedAt) || other.syncedAt == syncedAt)&&(identical(other.discountType, discountType) || other.discountType == discountType)&&(identical(other.discountValue, discountValue) || other.discountValue == discountValue)&&(identical(other.discountAmount, discountAmount) || other.discountAmount == discountAmount)&&const DeepCollectionEquality().equals(other.items, items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,storeId,receiptNumber,totalAmount,vatAmount,paymentMethod,cashAmount,mobileMoneyAmount,createdAt,syncedAt,discountType,discountValue,discountAmount,const DeepCollectionEquality().hash(items));

@override
String toString() {
  return 'SaleDto(id: $id, storeId: $storeId, receiptNumber: $receiptNumber, totalAmount: $totalAmount, vatAmount: $vatAmount, paymentMethod: $paymentMethod, cashAmount: $cashAmount, mobileMoneyAmount: $mobileMoneyAmount, createdAt: $createdAt, syncedAt: $syncedAt, discountType: $discountType, discountValue: $discountValue, discountAmount: $discountAmount, items: $items)';
}


}

/// @nodoc
abstract mixin class $SaleDtoCopyWith<$Res>  {
  factory $SaleDtoCopyWith(SaleDto value, $Res Function(SaleDto) _then) = _$SaleDtoCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'store_id') String storeId,@JsonKey(name: 'receipt_number') int? receiptNumber,@JsonKey(name: 'total_amount') String totalAmount,@JsonKey(name: 'vat_amount') String vatAmount,@JsonKey(name: 'payment_method') String paymentMethod,@JsonKey(name: 'cash_amount') String? cashAmount,@JsonKey(name: 'mobile_money_amount') String? mobileMoneyAmount,@JsonKey(name: 'created_at') String createdAt,@JsonKey(name: 'synced_at') String syncedAt,@JsonKey(name: 'discount_type') String? discountType,@JsonKey(name: 'discount_value') String? discountValue,@JsonKey(name: 'discount_amount') String discountAmount, List<SaleItemDto> items
});




}
/// @nodoc
class _$SaleDtoCopyWithImpl<$Res>
    implements $SaleDtoCopyWith<$Res> {
  _$SaleDtoCopyWithImpl(this._self, this._then);

  final SaleDto _self;
  final $Res Function(SaleDto) _then;

/// Create a copy of SaleDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? storeId = null,Object? receiptNumber = freezed,Object? totalAmount = null,Object? vatAmount = null,Object? paymentMethod = null,Object? cashAmount = freezed,Object? mobileMoneyAmount = freezed,Object? createdAt = null,Object? syncedAt = null,Object? discountType = freezed,Object? discountValue = freezed,Object? discountAmount = null,Object? items = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,storeId: null == storeId ? _self.storeId : storeId // ignore: cast_nullable_to_non_nullable
as String,receiptNumber: freezed == receiptNumber ? _self.receiptNumber : receiptNumber // ignore: cast_nullable_to_non_nullable
as int?,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as String,vatAmount: null == vatAmount ? _self.vatAmount : vatAmount // ignore: cast_nullable_to_non_nullable
as String,paymentMethod: null == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as String,cashAmount: freezed == cashAmount ? _self.cashAmount : cashAmount // ignore: cast_nullable_to_non_nullable
as String?,mobileMoneyAmount: freezed == mobileMoneyAmount ? _self.mobileMoneyAmount : mobileMoneyAmount // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,syncedAt: null == syncedAt ? _self.syncedAt : syncedAt // ignore: cast_nullable_to_non_nullable
as String,discountType: freezed == discountType ? _self.discountType : discountType // ignore: cast_nullable_to_non_nullable
as String?,discountValue: freezed == discountValue ? _self.discountValue : discountValue // ignore: cast_nullable_to_non_nullable
as String?,discountAmount: null == discountAmount ? _self.discountAmount : discountAmount // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<SaleItemDto>,
  ));
}

}


/// Adds pattern-matching-related methods to [SaleDto].
extension SaleDtoPatterns on SaleDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SaleDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SaleDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SaleDto value)  $default,){
final _that = this;
switch (_that) {
case _SaleDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SaleDto value)?  $default,){
final _that = this;
switch (_that) {
case _SaleDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'store_id')  String storeId, @JsonKey(name: 'receipt_number')  int? receiptNumber, @JsonKey(name: 'total_amount')  String totalAmount, @JsonKey(name: 'vat_amount')  String vatAmount, @JsonKey(name: 'payment_method')  String paymentMethod, @JsonKey(name: 'cash_amount')  String? cashAmount, @JsonKey(name: 'mobile_money_amount')  String? mobileMoneyAmount, @JsonKey(name: 'created_at')  String createdAt, @JsonKey(name: 'synced_at')  String syncedAt, @JsonKey(name: 'discount_type')  String? discountType, @JsonKey(name: 'discount_value')  String? discountValue, @JsonKey(name: 'discount_amount')  String discountAmount,  List<SaleItemDto> items)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SaleDto() when $default != null:
return $default(_that.id,_that.storeId,_that.receiptNumber,_that.totalAmount,_that.vatAmount,_that.paymentMethod,_that.cashAmount,_that.mobileMoneyAmount,_that.createdAt,_that.syncedAt,_that.discountType,_that.discountValue,_that.discountAmount,_that.items);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'store_id')  String storeId, @JsonKey(name: 'receipt_number')  int? receiptNumber, @JsonKey(name: 'total_amount')  String totalAmount, @JsonKey(name: 'vat_amount')  String vatAmount, @JsonKey(name: 'payment_method')  String paymentMethod, @JsonKey(name: 'cash_amount')  String? cashAmount, @JsonKey(name: 'mobile_money_amount')  String? mobileMoneyAmount, @JsonKey(name: 'created_at')  String createdAt, @JsonKey(name: 'synced_at')  String syncedAt, @JsonKey(name: 'discount_type')  String? discountType, @JsonKey(name: 'discount_value')  String? discountValue, @JsonKey(name: 'discount_amount')  String discountAmount,  List<SaleItemDto> items)  $default,) {final _that = this;
switch (_that) {
case _SaleDto():
return $default(_that.id,_that.storeId,_that.receiptNumber,_that.totalAmount,_that.vatAmount,_that.paymentMethod,_that.cashAmount,_that.mobileMoneyAmount,_that.createdAt,_that.syncedAt,_that.discountType,_that.discountValue,_that.discountAmount,_that.items);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'store_id')  String storeId, @JsonKey(name: 'receipt_number')  int? receiptNumber, @JsonKey(name: 'total_amount')  String totalAmount, @JsonKey(name: 'vat_amount')  String vatAmount, @JsonKey(name: 'payment_method')  String paymentMethod, @JsonKey(name: 'cash_amount')  String? cashAmount, @JsonKey(name: 'mobile_money_amount')  String? mobileMoneyAmount, @JsonKey(name: 'created_at')  String createdAt, @JsonKey(name: 'synced_at')  String syncedAt, @JsonKey(name: 'discount_type')  String? discountType, @JsonKey(name: 'discount_value')  String? discountValue, @JsonKey(name: 'discount_amount')  String discountAmount,  List<SaleItemDto> items)?  $default,) {final _that = this;
switch (_that) {
case _SaleDto() when $default != null:
return $default(_that.id,_that.storeId,_that.receiptNumber,_that.totalAmount,_that.vatAmount,_that.paymentMethod,_that.cashAmount,_that.mobileMoneyAmount,_that.createdAt,_that.syncedAt,_that.discountType,_that.discountValue,_that.discountAmount,_that.items);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SaleDto implements SaleDto {
  const _SaleDto({required this.id, @JsonKey(name: 'store_id') required this.storeId, @JsonKey(name: 'receipt_number') this.receiptNumber, @JsonKey(name: 'total_amount') required this.totalAmount, @JsonKey(name: 'vat_amount') required this.vatAmount, @JsonKey(name: 'payment_method') required this.paymentMethod, @JsonKey(name: 'cash_amount') this.cashAmount, @JsonKey(name: 'mobile_money_amount') this.mobileMoneyAmount, @JsonKey(name: 'created_at') required this.createdAt, @JsonKey(name: 'synced_at') required this.syncedAt, @JsonKey(name: 'discount_type') this.discountType, @JsonKey(name: 'discount_value') this.discountValue, @JsonKey(name: 'discount_amount') this.discountAmount = '0', required final  List<SaleItemDto> items}): _items = items;
  factory _SaleDto.fromJson(Map<String, dynamic> json) => _$SaleDtoFromJson(json);

@override final  String id;
@override@JsonKey(name: 'store_id') final  String storeId;
@override@JsonKey(name: 'receipt_number') final  int? receiptNumber;
@override@JsonKey(name: 'total_amount') final  String totalAmount;
@override@JsonKey(name: 'vat_amount') final  String vatAmount;
@override@JsonKey(name: 'payment_method') final  String paymentMethod;
@override@JsonKey(name: 'cash_amount') final  String? cashAmount;
@override@JsonKey(name: 'mobile_money_amount') final  String? mobileMoneyAmount;
@override@JsonKey(name: 'created_at') final  String createdAt;
@override@JsonKey(name: 'synced_at') final  String syncedAt;
// Remise globale (ADR-0009) ; absente d'une vente antérieure.
@override@JsonKey(name: 'discount_type') final  String? discountType;
@override@JsonKey(name: 'discount_value') final  String? discountValue;
@override@JsonKey(name: 'discount_amount') final  String discountAmount;
 final  List<SaleItemDto> _items;
@override List<SaleItemDto> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of SaleDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SaleDtoCopyWith<_SaleDto> get copyWith => __$SaleDtoCopyWithImpl<_SaleDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SaleDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SaleDto&&(identical(other.id, id) || other.id == id)&&(identical(other.storeId, storeId) || other.storeId == storeId)&&(identical(other.receiptNumber, receiptNumber) || other.receiptNumber == receiptNumber)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&(identical(other.vatAmount, vatAmount) || other.vatAmount == vatAmount)&&(identical(other.paymentMethod, paymentMethod) || other.paymentMethod == paymentMethod)&&(identical(other.cashAmount, cashAmount) || other.cashAmount == cashAmount)&&(identical(other.mobileMoneyAmount, mobileMoneyAmount) || other.mobileMoneyAmount == mobileMoneyAmount)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.syncedAt, syncedAt) || other.syncedAt == syncedAt)&&(identical(other.discountType, discountType) || other.discountType == discountType)&&(identical(other.discountValue, discountValue) || other.discountValue == discountValue)&&(identical(other.discountAmount, discountAmount) || other.discountAmount == discountAmount)&&const DeepCollectionEquality().equals(other._items, _items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,storeId,receiptNumber,totalAmount,vatAmount,paymentMethod,cashAmount,mobileMoneyAmount,createdAt,syncedAt,discountType,discountValue,discountAmount,const DeepCollectionEquality().hash(_items));

@override
String toString() {
  return 'SaleDto(id: $id, storeId: $storeId, receiptNumber: $receiptNumber, totalAmount: $totalAmount, vatAmount: $vatAmount, paymentMethod: $paymentMethod, cashAmount: $cashAmount, mobileMoneyAmount: $mobileMoneyAmount, createdAt: $createdAt, syncedAt: $syncedAt, discountType: $discountType, discountValue: $discountValue, discountAmount: $discountAmount, items: $items)';
}


}

/// @nodoc
abstract mixin class _$SaleDtoCopyWith<$Res> implements $SaleDtoCopyWith<$Res> {
  factory _$SaleDtoCopyWith(_SaleDto value, $Res Function(_SaleDto) _then) = __$SaleDtoCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'store_id') String storeId,@JsonKey(name: 'receipt_number') int? receiptNumber,@JsonKey(name: 'total_amount') String totalAmount,@JsonKey(name: 'vat_amount') String vatAmount,@JsonKey(name: 'payment_method') String paymentMethod,@JsonKey(name: 'cash_amount') String? cashAmount,@JsonKey(name: 'mobile_money_amount') String? mobileMoneyAmount,@JsonKey(name: 'created_at') String createdAt,@JsonKey(name: 'synced_at') String syncedAt,@JsonKey(name: 'discount_type') String? discountType,@JsonKey(name: 'discount_value') String? discountValue,@JsonKey(name: 'discount_amount') String discountAmount, List<SaleItemDto> items
});




}
/// @nodoc
class __$SaleDtoCopyWithImpl<$Res>
    implements _$SaleDtoCopyWith<$Res> {
  __$SaleDtoCopyWithImpl(this._self, this._then);

  final _SaleDto _self;
  final $Res Function(_SaleDto) _then;

/// Create a copy of SaleDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? storeId = null,Object? receiptNumber = freezed,Object? totalAmount = null,Object? vatAmount = null,Object? paymentMethod = null,Object? cashAmount = freezed,Object? mobileMoneyAmount = freezed,Object? createdAt = null,Object? syncedAt = null,Object? discountType = freezed,Object? discountValue = freezed,Object? discountAmount = null,Object? items = null,}) {
  return _then(_SaleDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,storeId: null == storeId ? _self.storeId : storeId // ignore: cast_nullable_to_non_nullable
as String,receiptNumber: freezed == receiptNumber ? _self.receiptNumber : receiptNumber // ignore: cast_nullable_to_non_nullable
as int?,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as String,vatAmount: null == vatAmount ? _self.vatAmount : vatAmount // ignore: cast_nullable_to_non_nullable
as String,paymentMethod: null == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as String,cashAmount: freezed == cashAmount ? _self.cashAmount : cashAmount // ignore: cast_nullable_to_non_nullable
as String?,mobileMoneyAmount: freezed == mobileMoneyAmount ? _self.mobileMoneyAmount : mobileMoneyAmount // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,syncedAt: null == syncedAt ? _self.syncedAt : syncedAt // ignore: cast_nullable_to_non_nullable
as String,discountType: freezed == discountType ? _self.discountType : discountType // ignore: cast_nullable_to_non_nullable
as String?,discountValue: freezed == discountValue ? _self.discountValue : discountValue // ignore: cast_nullable_to_non_nullable
as String?,discountAmount: null == discountAmount ? _self.discountAmount : discountAmount // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<SaleItemDto>,
  ));
}


}


/// @nodoc
mixin _$SaleItemCreateDto {

@JsonKey(name: 'product_id') String? get productId;@JsonKey(name: 'product_name_at_sale') String get productNameAtSale;@JsonKey(name: 'unit_price_at_sale') String get unitPriceAtSale; int get quantity;@JsonKey(name: 'line_total') String get lineTotal;@JsonKey(name: 'purchase_price_at_sale') String? get purchasePriceAtSale;@JsonKey(name: 'discount_type') String? get discountType;@JsonKey(name: 'discount_value') String? get discountValue;@JsonKey(name: 'discount_amount') String get discountAmount;
/// Create a copy of SaleItemCreateDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SaleItemCreateDtoCopyWith<SaleItemCreateDto> get copyWith => _$SaleItemCreateDtoCopyWithImpl<SaleItemCreateDto>(this as SaleItemCreateDto, _$identity);

  /// Serializes this SaleItemCreateDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SaleItemCreateDto&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.productNameAtSale, productNameAtSale) || other.productNameAtSale == productNameAtSale)&&(identical(other.unitPriceAtSale, unitPriceAtSale) || other.unitPriceAtSale == unitPriceAtSale)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.lineTotal, lineTotal) || other.lineTotal == lineTotal)&&(identical(other.purchasePriceAtSale, purchasePriceAtSale) || other.purchasePriceAtSale == purchasePriceAtSale)&&(identical(other.discountType, discountType) || other.discountType == discountType)&&(identical(other.discountValue, discountValue) || other.discountValue == discountValue)&&(identical(other.discountAmount, discountAmount) || other.discountAmount == discountAmount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,productId,productNameAtSale,unitPriceAtSale,quantity,lineTotal,purchasePriceAtSale,discountType,discountValue,discountAmount);

@override
String toString() {
  return 'SaleItemCreateDto(productId: $productId, productNameAtSale: $productNameAtSale, unitPriceAtSale: $unitPriceAtSale, quantity: $quantity, lineTotal: $lineTotal, purchasePriceAtSale: $purchasePriceAtSale, discountType: $discountType, discountValue: $discountValue, discountAmount: $discountAmount)';
}


}

/// @nodoc
abstract mixin class $SaleItemCreateDtoCopyWith<$Res>  {
  factory $SaleItemCreateDtoCopyWith(SaleItemCreateDto value, $Res Function(SaleItemCreateDto) _then) = _$SaleItemCreateDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'product_id') String? productId,@JsonKey(name: 'product_name_at_sale') String productNameAtSale,@JsonKey(name: 'unit_price_at_sale') String unitPriceAtSale, int quantity,@JsonKey(name: 'line_total') String lineTotal,@JsonKey(name: 'purchase_price_at_sale') String? purchasePriceAtSale,@JsonKey(name: 'discount_type') String? discountType,@JsonKey(name: 'discount_value') String? discountValue,@JsonKey(name: 'discount_amount') String discountAmount
});




}
/// @nodoc
class _$SaleItemCreateDtoCopyWithImpl<$Res>
    implements $SaleItemCreateDtoCopyWith<$Res> {
  _$SaleItemCreateDtoCopyWithImpl(this._self, this._then);

  final SaleItemCreateDto _self;
  final $Res Function(SaleItemCreateDto) _then;

/// Create a copy of SaleItemCreateDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? productId = freezed,Object? productNameAtSale = null,Object? unitPriceAtSale = null,Object? quantity = null,Object? lineTotal = null,Object? purchasePriceAtSale = freezed,Object? discountType = freezed,Object? discountValue = freezed,Object? discountAmount = null,}) {
  return _then(_self.copyWith(
productId: freezed == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String?,productNameAtSale: null == productNameAtSale ? _self.productNameAtSale : productNameAtSale // ignore: cast_nullable_to_non_nullable
as String,unitPriceAtSale: null == unitPriceAtSale ? _self.unitPriceAtSale : unitPriceAtSale // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,lineTotal: null == lineTotal ? _self.lineTotal : lineTotal // ignore: cast_nullable_to_non_nullable
as String,purchasePriceAtSale: freezed == purchasePriceAtSale ? _self.purchasePriceAtSale : purchasePriceAtSale // ignore: cast_nullable_to_non_nullable
as String?,discountType: freezed == discountType ? _self.discountType : discountType // ignore: cast_nullable_to_non_nullable
as String?,discountValue: freezed == discountValue ? _self.discountValue : discountValue // ignore: cast_nullable_to_non_nullable
as String?,discountAmount: null == discountAmount ? _self.discountAmount : discountAmount // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [SaleItemCreateDto].
extension SaleItemCreateDtoPatterns on SaleItemCreateDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SaleItemCreateDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SaleItemCreateDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SaleItemCreateDto value)  $default,){
final _that = this;
switch (_that) {
case _SaleItemCreateDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SaleItemCreateDto value)?  $default,){
final _that = this;
switch (_that) {
case _SaleItemCreateDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'product_id')  String? productId, @JsonKey(name: 'product_name_at_sale')  String productNameAtSale, @JsonKey(name: 'unit_price_at_sale')  String unitPriceAtSale,  int quantity, @JsonKey(name: 'line_total')  String lineTotal, @JsonKey(name: 'purchase_price_at_sale')  String? purchasePriceAtSale, @JsonKey(name: 'discount_type')  String? discountType, @JsonKey(name: 'discount_value')  String? discountValue, @JsonKey(name: 'discount_amount')  String discountAmount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SaleItemCreateDto() when $default != null:
return $default(_that.productId,_that.productNameAtSale,_that.unitPriceAtSale,_that.quantity,_that.lineTotal,_that.purchasePriceAtSale,_that.discountType,_that.discountValue,_that.discountAmount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'product_id')  String? productId, @JsonKey(name: 'product_name_at_sale')  String productNameAtSale, @JsonKey(name: 'unit_price_at_sale')  String unitPriceAtSale,  int quantity, @JsonKey(name: 'line_total')  String lineTotal, @JsonKey(name: 'purchase_price_at_sale')  String? purchasePriceAtSale, @JsonKey(name: 'discount_type')  String? discountType, @JsonKey(name: 'discount_value')  String? discountValue, @JsonKey(name: 'discount_amount')  String discountAmount)  $default,) {final _that = this;
switch (_that) {
case _SaleItemCreateDto():
return $default(_that.productId,_that.productNameAtSale,_that.unitPriceAtSale,_that.quantity,_that.lineTotal,_that.purchasePriceAtSale,_that.discountType,_that.discountValue,_that.discountAmount);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'product_id')  String? productId, @JsonKey(name: 'product_name_at_sale')  String productNameAtSale, @JsonKey(name: 'unit_price_at_sale')  String unitPriceAtSale,  int quantity, @JsonKey(name: 'line_total')  String lineTotal, @JsonKey(name: 'purchase_price_at_sale')  String? purchasePriceAtSale, @JsonKey(name: 'discount_type')  String? discountType, @JsonKey(name: 'discount_value')  String? discountValue, @JsonKey(name: 'discount_amount')  String discountAmount)?  $default,) {final _that = this;
switch (_that) {
case _SaleItemCreateDto() when $default != null:
return $default(_that.productId,_that.productNameAtSale,_that.unitPriceAtSale,_that.quantity,_that.lineTotal,_that.purchasePriceAtSale,_that.discountType,_that.discountValue,_that.discountAmount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SaleItemCreateDto implements SaleItemCreateDto {
  const _SaleItemCreateDto({@JsonKey(name: 'product_id') this.productId, @JsonKey(name: 'product_name_at_sale') required this.productNameAtSale, @JsonKey(name: 'unit_price_at_sale') required this.unitPriceAtSale, required this.quantity, @JsonKey(name: 'line_total') required this.lineTotal, @JsonKey(name: 'purchase_price_at_sale') this.purchasePriceAtSale, @JsonKey(name: 'discount_type') this.discountType, @JsonKey(name: 'discount_value') this.discountValue, @JsonKey(name: 'discount_amount') this.discountAmount = '0'});
  factory _SaleItemCreateDto.fromJson(Map<String, dynamic> json) => _$SaleItemCreateDtoFromJson(json);

@override@JsonKey(name: 'product_id') final  String? productId;
@override@JsonKey(name: 'product_name_at_sale') final  String productNameAtSale;
@override@JsonKey(name: 'unit_price_at_sale') final  String unitPriceAtSale;
@override final  int quantity;
@override@JsonKey(name: 'line_total') final  String lineTotal;
@override@JsonKey(name: 'purchase_price_at_sale') final  String? purchasePriceAtSale;
@override@JsonKey(name: 'discount_type') final  String? discountType;
@override@JsonKey(name: 'discount_value') final  String? discountValue;
@override@JsonKey(name: 'discount_amount') final  String discountAmount;

/// Create a copy of SaleItemCreateDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SaleItemCreateDtoCopyWith<_SaleItemCreateDto> get copyWith => __$SaleItemCreateDtoCopyWithImpl<_SaleItemCreateDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SaleItemCreateDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SaleItemCreateDto&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.productNameAtSale, productNameAtSale) || other.productNameAtSale == productNameAtSale)&&(identical(other.unitPriceAtSale, unitPriceAtSale) || other.unitPriceAtSale == unitPriceAtSale)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.lineTotal, lineTotal) || other.lineTotal == lineTotal)&&(identical(other.purchasePriceAtSale, purchasePriceAtSale) || other.purchasePriceAtSale == purchasePriceAtSale)&&(identical(other.discountType, discountType) || other.discountType == discountType)&&(identical(other.discountValue, discountValue) || other.discountValue == discountValue)&&(identical(other.discountAmount, discountAmount) || other.discountAmount == discountAmount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,productId,productNameAtSale,unitPriceAtSale,quantity,lineTotal,purchasePriceAtSale,discountType,discountValue,discountAmount);

@override
String toString() {
  return 'SaleItemCreateDto(productId: $productId, productNameAtSale: $productNameAtSale, unitPriceAtSale: $unitPriceAtSale, quantity: $quantity, lineTotal: $lineTotal, purchasePriceAtSale: $purchasePriceAtSale, discountType: $discountType, discountValue: $discountValue, discountAmount: $discountAmount)';
}


}

/// @nodoc
abstract mixin class _$SaleItemCreateDtoCopyWith<$Res> implements $SaleItemCreateDtoCopyWith<$Res> {
  factory _$SaleItemCreateDtoCopyWith(_SaleItemCreateDto value, $Res Function(_SaleItemCreateDto) _then) = __$SaleItemCreateDtoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'product_id') String? productId,@JsonKey(name: 'product_name_at_sale') String productNameAtSale,@JsonKey(name: 'unit_price_at_sale') String unitPriceAtSale, int quantity,@JsonKey(name: 'line_total') String lineTotal,@JsonKey(name: 'purchase_price_at_sale') String? purchasePriceAtSale,@JsonKey(name: 'discount_type') String? discountType,@JsonKey(name: 'discount_value') String? discountValue,@JsonKey(name: 'discount_amount') String discountAmount
});




}
/// @nodoc
class __$SaleItemCreateDtoCopyWithImpl<$Res>
    implements _$SaleItemCreateDtoCopyWith<$Res> {
  __$SaleItemCreateDtoCopyWithImpl(this._self, this._then);

  final _SaleItemCreateDto _self;
  final $Res Function(_SaleItemCreateDto) _then;

/// Create a copy of SaleItemCreateDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? productId = freezed,Object? productNameAtSale = null,Object? unitPriceAtSale = null,Object? quantity = null,Object? lineTotal = null,Object? purchasePriceAtSale = freezed,Object? discountType = freezed,Object? discountValue = freezed,Object? discountAmount = null,}) {
  return _then(_SaleItemCreateDto(
productId: freezed == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String?,productNameAtSale: null == productNameAtSale ? _self.productNameAtSale : productNameAtSale // ignore: cast_nullable_to_non_nullable
as String,unitPriceAtSale: null == unitPriceAtSale ? _self.unitPriceAtSale : unitPriceAtSale // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,lineTotal: null == lineTotal ? _self.lineTotal : lineTotal // ignore: cast_nullable_to_non_nullable
as String,purchasePriceAtSale: freezed == purchasePriceAtSale ? _self.purchasePriceAtSale : purchasePriceAtSale // ignore: cast_nullable_to_non_nullable
as String?,discountType: freezed == discountType ? _self.discountType : discountType // ignore: cast_nullable_to_non_nullable
as String?,discountValue: freezed == discountValue ? _self.discountValue : discountValue // ignore: cast_nullable_to_non_nullable
as String?,discountAmount: null == discountAmount ? _self.discountAmount : discountAmount // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$SaleCreateDto {

 String get id; List<SaleItemCreateDto> get items;@JsonKey(name: 'total_amount') String get totalAmount;@JsonKey(name: 'vat_amount') String get vatAmount;@JsonKey(name: 'payment_method') PaymentMethodDto get paymentMethod;@JsonKey(name: 'cash_amount') String? get cashAmount;@JsonKey(name: 'mobile_money_amount') String? get mobileMoneyAmount;@JsonKey(name: 'created_at') String get createdAt;@JsonKey(name: 'discount_type') String? get discountType;@JsonKey(name: 'discount_value') String? get discountValue;@JsonKey(name: 'discount_amount') String get discountAmount;
/// Create a copy of SaleCreateDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SaleCreateDtoCopyWith<SaleCreateDto> get copyWith => _$SaleCreateDtoCopyWithImpl<SaleCreateDto>(this as SaleCreateDto, _$identity);

  /// Serializes this SaleCreateDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SaleCreateDto&&(identical(other.id, id) || other.id == id)&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&(identical(other.vatAmount, vatAmount) || other.vatAmount == vatAmount)&&(identical(other.paymentMethod, paymentMethod) || other.paymentMethod == paymentMethod)&&(identical(other.cashAmount, cashAmount) || other.cashAmount == cashAmount)&&(identical(other.mobileMoneyAmount, mobileMoneyAmount) || other.mobileMoneyAmount == mobileMoneyAmount)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.discountType, discountType) || other.discountType == discountType)&&(identical(other.discountValue, discountValue) || other.discountValue == discountValue)&&(identical(other.discountAmount, discountAmount) || other.discountAmount == discountAmount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,const DeepCollectionEquality().hash(items),totalAmount,vatAmount,paymentMethod,cashAmount,mobileMoneyAmount,createdAt,discountType,discountValue,discountAmount);

@override
String toString() {
  return 'SaleCreateDto(id: $id, items: $items, totalAmount: $totalAmount, vatAmount: $vatAmount, paymentMethod: $paymentMethod, cashAmount: $cashAmount, mobileMoneyAmount: $mobileMoneyAmount, createdAt: $createdAt, discountType: $discountType, discountValue: $discountValue, discountAmount: $discountAmount)';
}


}

/// @nodoc
abstract mixin class $SaleCreateDtoCopyWith<$Res>  {
  factory $SaleCreateDtoCopyWith(SaleCreateDto value, $Res Function(SaleCreateDto) _then) = _$SaleCreateDtoCopyWithImpl;
@useResult
$Res call({
 String id, List<SaleItemCreateDto> items,@JsonKey(name: 'total_amount') String totalAmount,@JsonKey(name: 'vat_amount') String vatAmount,@JsonKey(name: 'payment_method') PaymentMethodDto paymentMethod,@JsonKey(name: 'cash_amount') String? cashAmount,@JsonKey(name: 'mobile_money_amount') String? mobileMoneyAmount,@JsonKey(name: 'created_at') String createdAt,@JsonKey(name: 'discount_type') String? discountType,@JsonKey(name: 'discount_value') String? discountValue,@JsonKey(name: 'discount_amount') String discountAmount
});




}
/// @nodoc
class _$SaleCreateDtoCopyWithImpl<$Res>
    implements $SaleCreateDtoCopyWith<$Res> {
  _$SaleCreateDtoCopyWithImpl(this._self, this._then);

  final SaleCreateDto _self;
  final $Res Function(SaleCreateDto) _then;

/// Create a copy of SaleCreateDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? items = null,Object? totalAmount = null,Object? vatAmount = null,Object? paymentMethod = null,Object? cashAmount = freezed,Object? mobileMoneyAmount = freezed,Object? createdAt = null,Object? discountType = freezed,Object? discountValue = freezed,Object? discountAmount = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<SaleItemCreateDto>,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as String,vatAmount: null == vatAmount ? _self.vatAmount : vatAmount // ignore: cast_nullable_to_non_nullable
as String,paymentMethod: null == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as PaymentMethodDto,cashAmount: freezed == cashAmount ? _self.cashAmount : cashAmount // ignore: cast_nullable_to_non_nullable
as String?,mobileMoneyAmount: freezed == mobileMoneyAmount ? _self.mobileMoneyAmount : mobileMoneyAmount // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,discountType: freezed == discountType ? _self.discountType : discountType // ignore: cast_nullable_to_non_nullable
as String?,discountValue: freezed == discountValue ? _self.discountValue : discountValue // ignore: cast_nullable_to_non_nullable
as String?,discountAmount: null == discountAmount ? _self.discountAmount : discountAmount // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [SaleCreateDto].
extension SaleCreateDtoPatterns on SaleCreateDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SaleCreateDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SaleCreateDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SaleCreateDto value)  $default,){
final _that = this;
switch (_that) {
case _SaleCreateDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SaleCreateDto value)?  $default,){
final _that = this;
switch (_that) {
case _SaleCreateDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  List<SaleItemCreateDto> items, @JsonKey(name: 'total_amount')  String totalAmount, @JsonKey(name: 'vat_amount')  String vatAmount, @JsonKey(name: 'payment_method')  PaymentMethodDto paymentMethod, @JsonKey(name: 'cash_amount')  String? cashAmount, @JsonKey(name: 'mobile_money_amount')  String? mobileMoneyAmount, @JsonKey(name: 'created_at')  String createdAt, @JsonKey(name: 'discount_type')  String? discountType, @JsonKey(name: 'discount_value')  String? discountValue, @JsonKey(name: 'discount_amount')  String discountAmount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SaleCreateDto() when $default != null:
return $default(_that.id,_that.items,_that.totalAmount,_that.vatAmount,_that.paymentMethod,_that.cashAmount,_that.mobileMoneyAmount,_that.createdAt,_that.discountType,_that.discountValue,_that.discountAmount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  List<SaleItemCreateDto> items, @JsonKey(name: 'total_amount')  String totalAmount, @JsonKey(name: 'vat_amount')  String vatAmount, @JsonKey(name: 'payment_method')  PaymentMethodDto paymentMethod, @JsonKey(name: 'cash_amount')  String? cashAmount, @JsonKey(name: 'mobile_money_amount')  String? mobileMoneyAmount, @JsonKey(name: 'created_at')  String createdAt, @JsonKey(name: 'discount_type')  String? discountType, @JsonKey(name: 'discount_value')  String? discountValue, @JsonKey(name: 'discount_amount')  String discountAmount)  $default,) {final _that = this;
switch (_that) {
case _SaleCreateDto():
return $default(_that.id,_that.items,_that.totalAmount,_that.vatAmount,_that.paymentMethod,_that.cashAmount,_that.mobileMoneyAmount,_that.createdAt,_that.discountType,_that.discountValue,_that.discountAmount);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  List<SaleItemCreateDto> items, @JsonKey(name: 'total_amount')  String totalAmount, @JsonKey(name: 'vat_amount')  String vatAmount, @JsonKey(name: 'payment_method')  PaymentMethodDto paymentMethod, @JsonKey(name: 'cash_amount')  String? cashAmount, @JsonKey(name: 'mobile_money_amount')  String? mobileMoneyAmount, @JsonKey(name: 'created_at')  String createdAt, @JsonKey(name: 'discount_type')  String? discountType, @JsonKey(name: 'discount_value')  String? discountValue, @JsonKey(name: 'discount_amount')  String discountAmount)?  $default,) {final _that = this;
switch (_that) {
case _SaleCreateDto() when $default != null:
return $default(_that.id,_that.items,_that.totalAmount,_that.vatAmount,_that.paymentMethod,_that.cashAmount,_that.mobileMoneyAmount,_that.createdAt,_that.discountType,_that.discountValue,_that.discountAmount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SaleCreateDto implements SaleCreateDto {
  const _SaleCreateDto({required this.id, required final  List<SaleItemCreateDto> items, @JsonKey(name: 'total_amount') required this.totalAmount, @JsonKey(name: 'vat_amount') required this.vatAmount, @JsonKey(name: 'payment_method') required this.paymentMethod, @JsonKey(name: 'cash_amount') this.cashAmount, @JsonKey(name: 'mobile_money_amount') this.mobileMoneyAmount, @JsonKey(name: 'created_at') required this.createdAt, @JsonKey(name: 'discount_type') this.discountType, @JsonKey(name: 'discount_value') this.discountValue, @JsonKey(name: 'discount_amount') this.discountAmount = '0'}): _items = items;
  factory _SaleCreateDto.fromJson(Map<String, dynamic> json) => _$SaleCreateDtoFromJson(json);

@override final  String id;
 final  List<SaleItemCreateDto> _items;
@override List<SaleItemCreateDto> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override@JsonKey(name: 'total_amount') final  String totalAmount;
@override@JsonKey(name: 'vat_amount') final  String vatAmount;
@override@JsonKey(name: 'payment_method') final  PaymentMethodDto paymentMethod;
@override@JsonKey(name: 'cash_amount') final  String? cashAmount;
@override@JsonKey(name: 'mobile_money_amount') final  String? mobileMoneyAmount;
@override@JsonKey(name: 'created_at') final  String createdAt;
@override@JsonKey(name: 'discount_type') final  String? discountType;
@override@JsonKey(name: 'discount_value') final  String? discountValue;
@override@JsonKey(name: 'discount_amount') final  String discountAmount;

/// Create a copy of SaleCreateDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SaleCreateDtoCopyWith<_SaleCreateDto> get copyWith => __$SaleCreateDtoCopyWithImpl<_SaleCreateDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SaleCreateDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SaleCreateDto&&(identical(other.id, id) || other.id == id)&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&(identical(other.vatAmount, vatAmount) || other.vatAmount == vatAmount)&&(identical(other.paymentMethod, paymentMethod) || other.paymentMethod == paymentMethod)&&(identical(other.cashAmount, cashAmount) || other.cashAmount == cashAmount)&&(identical(other.mobileMoneyAmount, mobileMoneyAmount) || other.mobileMoneyAmount == mobileMoneyAmount)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.discountType, discountType) || other.discountType == discountType)&&(identical(other.discountValue, discountValue) || other.discountValue == discountValue)&&(identical(other.discountAmount, discountAmount) || other.discountAmount == discountAmount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,const DeepCollectionEquality().hash(_items),totalAmount,vatAmount,paymentMethod,cashAmount,mobileMoneyAmount,createdAt,discountType,discountValue,discountAmount);

@override
String toString() {
  return 'SaleCreateDto(id: $id, items: $items, totalAmount: $totalAmount, vatAmount: $vatAmount, paymentMethod: $paymentMethod, cashAmount: $cashAmount, mobileMoneyAmount: $mobileMoneyAmount, createdAt: $createdAt, discountType: $discountType, discountValue: $discountValue, discountAmount: $discountAmount)';
}


}

/// @nodoc
abstract mixin class _$SaleCreateDtoCopyWith<$Res> implements $SaleCreateDtoCopyWith<$Res> {
  factory _$SaleCreateDtoCopyWith(_SaleCreateDto value, $Res Function(_SaleCreateDto) _then) = __$SaleCreateDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, List<SaleItemCreateDto> items,@JsonKey(name: 'total_amount') String totalAmount,@JsonKey(name: 'vat_amount') String vatAmount,@JsonKey(name: 'payment_method') PaymentMethodDto paymentMethod,@JsonKey(name: 'cash_amount') String? cashAmount,@JsonKey(name: 'mobile_money_amount') String? mobileMoneyAmount,@JsonKey(name: 'created_at') String createdAt,@JsonKey(name: 'discount_type') String? discountType,@JsonKey(name: 'discount_value') String? discountValue,@JsonKey(name: 'discount_amount') String discountAmount
});




}
/// @nodoc
class __$SaleCreateDtoCopyWithImpl<$Res>
    implements _$SaleCreateDtoCopyWith<$Res> {
  __$SaleCreateDtoCopyWithImpl(this._self, this._then);

  final _SaleCreateDto _self;
  final $Res Function(_SaleCreateDto) _then;

/// Create a copy of SaleCreateDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? items = null,Object? totalAmount = null,Object? vatAmount = null,Object? paymentMethod = null,Object? cashAmount = freezed,Object? mobileMoneyAmount = freezed,Object? createdAt = null,Object? discountType = freezed,Object? discountValue = freezed,Object? discountAmount = null,}) {
  return _then(_SaleCreateDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<SaleItemCreateDto>,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as String,vatAmount: null == vatAmount ? _self.vatAmount : vatAmount // ignore: cast_nullable_to_non_nullable
as String,paymentMethod: null == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as PaymentMethodDto,cashAmount: freezed == cashAmount ? _self.cashAmount : cashAmount // ignore: cast_nullable_to_non_nullable
as String?,mobileMoneyAmount: freezed == mobileMoneyAmount ? _self.mobileMoneyAmount : mobileMoneyAmount // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,discountType: freezed == discountType ? _self.discountType : discountType // ignore: cast_nullable_to_non_nullable
as String?,discountValue: freezed == discountValue ? _self.discountValue : discountValue // ignore: cast_nullable_to_non_nullable
as String?,discountAmount: null == discountAmount ? _self.discountAmount : discountAmount // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$DailySalesSummaryDto {

 String get date;@JsonKey(name: 'total_amount') String get totalAmount;@JsonKey(name: 'sales_count') int get salesCount;
/// Create a copy of DailySalesSummaryDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DailySalesSummaryDtoCopyWith<DailySalesSummaryDto> get copyWith => _$DailySalesSummaryDtoCopyWithImpl<DailySalesSummaryDto>(this as DailySalesSummaryDto, _$identity);

  /// Serializes this DailySalesSummaryDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DailySalesSummaryDto&&(identical(other.date, date) || other.date == date)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&(identical(other.salesCount, salesCount) || other.salesCount == salesCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,totalAmount,salesCount);

@override
String toString() {
  return 'DailySalesSummaryDto(date: $date, totalAmount: $totalAmount, salesCount: $salesCount)';
}


}

/// @nodoc
abstract mixin class $DailySalesSummaryDtoCopyWith<$Res>  {
  factory $DailySalesSummaryDtoCopyWith(DailySalesSummaryDto value, $Res Function(DailySalesSummaryDto) _then) = _$DailySalesSummaryDtoCopyWithImpl;
@useResult
$Res call({
 String date,@JsonKey(name: 'total_amount') String totalAmount,@JsonKey(name: 'sales_count') int salesCount
});




}
/// @nodoc
class _$DailySalesSummaryDtoCopyWithImpl<$Res>
    implements $DailySalesSummaryDtoCopyWith<$Res> {
  _$DailySalesSummaryDtoCopyWithImpl(this._self, this._then);

  final DailySalesSummaryDto _self;
  final $Res Function(DailySalesSummaryDto) _then;

/// Create a copy of DailySalesSummaryDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? totalAmount = null,Object? salesCount = null,}) {
  return _then(_self.copyWith(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as String,salesCount: null == salesCount ? _self.salesCount : salesCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [DailySalesSummaryDto].
extension DailySalesSummaryDtoPatterns on DailySalesSummaryDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DailySalesSummaryDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DailySalesSummaryDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DailySalesSummaryDto value)  $default,){
final _that = this;
switch (_that) {
case _DailySalesSummaryDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DailySalesSummaryDto value)?  $default,){
final _that = this;
switch (_that) {
case _DailySalesSummaryDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String date, @JsonKey(name: 'total_amount')  String totalAmount, @JsonKey(name: 'sales_count')  int salesCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DailySalesSummaryDto() when $default != null:
return $default(_that.date,_that.totalAmount,_that.salesCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String date, @JsonKey(name: 'total_amount')  String totalAmount, @JsonKey(name: 'sales_count')  int salesCount)  $default,) {final _that = this;
switch (_that) {
case _DailySalesSummaryDto():
return $default(_that.date,_that.totalAmount,_that.salesCount);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String date, @JsonKey(name: 'total_amount')  String totalAmount, @JsonKey(name: 'sales_count')  int salesCount)?  $default,) {final _that = this;
switch (_that) {
case _DailySalesSummaryDto() when $default != null:
return $default(_that.date,_that.totalAmount,_that.salesCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DailySalesSummaryDto implements DailySalesSummaryDto {
  const _DailySalesSummaryDto({required this.date, @JsonKey(name: 'total_amount') required this.totalAmount, @JsonKey(name: 'sales_count') required this.salesCount});
  factory _DailySalesSummaryDto.fromJson(Map<String, dynamic> json) => _$DailySalesSummaryDtoFromJson(json);

@override final  String date;
@override@JsonKey(name: 'total_amount') final  String totalAmount;
@override@JsonKey(name: 'sales_count') final  int salesCount;

/// Create a copy of DailySalesSummaryDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DailySalesSummaryDtoCopyWith<_DailySalesSummaryDto> get copyWith => __$DailySalesSummaryDtoCopyWithImpl<_DailySalesSummaryDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DailySalesSummaryDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DailySalesSummaryDto&&(identical(other.date, date) || other.date == date)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&(identical(other.salesCount, salesCount) || other.salesCount == salesCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,totalAmount,salesCount);

@override
String toString() {
  return 'DailySalesSummaryDto(date: $date, totalAmount: $totalAmount, salesCount: $salesCount)';
}


}

/// @nodoc
abstract mixin class _$DailySalesSummaryDtoCopyWith<$Res> implements $DailySalesSummaryDtoCopyWith<$Res> {
  factory _$DailySalesSummaryDtoCopyWith(_DailySalesSummaryDto value, $Res Function(_DailySalesSummaryDto) _then) = __$DailySalesSummaryDtoCopyWithImpl;
@override @useResult
$Res call({
 String date,@JsonKey(name: 'total_amount') String totalAmount,@JsonKey(name: 'sales_count') int salesCount
});




}
/// @nodoc
class __$DailySalesSummaryDtoCopyWithImpl<$Res>
    implements _$DailySalesSummaryDtoCopyWith<$Res> {
  __$DailySalesSummaryDtoCopyWithImpl(this._self, this._then);

  final _DailySalesSummaryDto _self;
  final $Res Function(_DailySalesSummaryDto) _then;

/// Create a copy of DailySalesSummaryDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? totalAmount = null,Object? salesCount = null,}) {
  return _then(_DailySalesSummaryDto(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as String,salesCount: null == salesCount ? _self.salesCount : salesCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
