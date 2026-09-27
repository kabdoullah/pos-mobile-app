// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cart_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CartItem {

 String get productId; String get productName;/// Prix de vente unitaire au moment de l'ajout au panier.
 Decimal get unitPrice; int get quantity;/// Stock disponible au moment de l'ajout au panier (null = illimité).
 int? get availableStock;/// Prix d'achat unitaire au moment de l'ajout (null = non renseigné).
/// Donnée interne : jamais affichée au client.
 Decimal? get purchaseUnitPrice;/// Réduction de la ligne (null = aucune).
 Discount? get discount;
/// Create a copy of CartItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CartItemCopyWith<CartItem> get copyWith => _$CartItemCopyWithImpl<CartItem>(this as CartItem, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CartItem&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.unitPrice, unitPrice) || other.unitPrice == unitPrice)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.availableStock, availableStock) || other.availableStock == availableStock)&&(identical(other.purchaseUnitPrice, purchaseUnitPrice) || other.purchaseUnitPrice == purchaseUnitPrice)&&(identical(other.discount, discount) || other.discount == discount));
}


@override
int get hashCode => Object.hash(runtimeType,productId,productName,unitPrice,quantity,availableStock,purchaseUnitPrice,discount);

@override
String toString() {
  return 'CartItem(productId: $productId, productName: $productName, unitPrice: $unitPrice, quantity: $quantity, availableStock: $availableStock, purchaseUnitPrice: $purchaseUnitPrice, discount: $discount)';
}


}

/// @nodoc
abstract mixin class $CartItemCopyWith<$Res>  {
  factory $CartItemCopyWith(CartItem value, $Res Function(CartItem) _then) = _$CartItemCopyWithImpl;
@useResult
$Res call({
 String productId, String productName, Decimal unitPrice, int quantity, int? availableStock, Decimal? purchaseUnitPrice, Discount? discount
});


$DiscountCopyWith<$Res>? get discount;

}
/// @nodoc
class _$CartItemCopyWithImpl<$Res>
    implements $CartItemCopyWith<$Res> {
  _$CartItemCopyWithImpl(this._self, this._then);

  final CartItem _self;
  final $Res Function(CartItem) _then;

/// Create a copy of CartItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? productId = null,Object? productName = null,Object? unitPrice = null,Object? quantity = null,Object? availableStock = freezed,Object? purchaseUnitPrice = freezed,Object? discount = freezed,}) {
  return _then(_self.copyWith(
productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,productName: null == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String,unitPrice: null == unitPrice ? _self.unitPrice : unitPrice // ignore: cast_nullable_to_non_nullable
as Decimal,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,availableStock: freezed == availableStock ? _self.availableStock : availableStock // ignore: cast_nullable_to_non_nullable
as int?,purchaseUnitPrice: freezed == purchaseUnitPrice ? _self.purchaseUnitPrice : purchaseUnitPrice // ignore: cast_nullable_to_non_nullable
as Decimal?,discount: freezed == discount ? _self.discount : discount // ignore: cast_nullable_to_non_nullable
as Discount?,
  ));
}
/// Create a copy of CartItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DiscountCopyWith<$Res>? get discount {
    if (_self.discount == null) {
    return null;
  }

  return $DiscountCopyWith<$Res>(_self.discount!, (value) {
    return _then(_self.copyWith(discount: value));
  });
}
}


/// Adds pattern-matching-related methods to [CartItem].
extension CartItemPatterns on CartItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CartItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CartItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CartItem value)  $default,){
final _that = this;
switch (_that) {
case _CartItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CartItem value)?  $default,){
final _that = this;
switch (_that) {
case _CartItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String productId,  String productName,  Decimal unitPrice,  int quantity,  int? availableStock,  Decimal? purchaseUnitPrice,  Discount? discount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CartItem() when $default != null:
return $default(_that.productId,_that.productName,_that.unitPrice,_that.quantity,_that.availableStock,_that.purchaseUnitPrice,_that.discount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String productId,  String productName,  Decimal unitPrice,  int quantity,  int? availableStock,  Decimal? purchaseUnitPrice,  Discount? discount)  $default,) {final _that = this;
switch (_that) {
case _CartItem():
return $default(_that.productId,_that.productName,_that.unitPrice,_that.quantity,_that.availableStock,_that.purchaseUnitPrice,_that.discount);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String productId,  String productName,  Decimal unitPrice,  int quantity,  int? availableStock,  Decimal? purchaseUnitPrice,  Discount? discount)?  $default,) {final _that = this;
switch (_that) {
case _CartItem() when $default != null:
return $default(_that.productId,_that.productName,_that.unitPrice,_that.quantity,_that.availableStock,_that.purchaseUnitPrice,_that.discount);case _:
  return null;

}
}

}

/// @nodoc


class _CartItem extends CartItem {
  const _CartItem({required this.productId, required this.productName, required this.unitPrice, required this.quantity, this.availableStock, this.purchaseUnitPrice, this.discount}): super._();
  

@override final  String productId;
@override final  String productName;
/// Prix de vente unitaire au moment de l'ajout au panier.
@override final  Decimal unitPrice;
@override final  int quantity;
/// Stock disponible au moment de l'ajout au panier (null = illimité).
@override final  int? availableStock;
/// Prix d'achat unitaire au moment de l'ajout (null = non renseigné).
/// Donnée interne : jamais affichée au client.
@override final  Decimal? purchaseUnitPrice;
/// Réduction de la ligne (null = aucune).
@override final  Discount? discount;

/// Create a copy of CartItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CartItemCopyWith<_CartItem> get copyWith => __$CartItemCopyWithImpl<_CartItem>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CartItem&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.unitPrice, unitPrice) || other.unitPrice == unitPrice)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.availableStock, availableStock) || other.availableStock == availableStock)&&(identical(other.purchaseUnitPrice, purchaseUnitPrice) || other.purchaseUnitPrice == purchaseUnitPrice)&&(identical(other.discount, discount) || other.discount == discount));
}


@override
int get hashCode => Object.hash(runtimeType,productId,productName,unitPrice,quantity,availableStock,purchaseUnitPrice,discount);

@override
String toString() {
  return 'CartItem(productId: $productId, productName: $productName, unitPrice: $unitPrice, quantity: $quantity, availableStock: $availableStock, purchaseUnitPrice: $purchaseUnitPrice, discount: $discount)';
}


}

/// @nodoc
abstract mixin class _$CartItemCopyWith<$Res> implements $CartItemCopyWith<$Res> {
  factory _$CartItemCopyWith(_CartItem value, $Res Function(_CartItem) _then) = __$CartItemCopyWithImpl;
@override @useResult
$Res call({
 String productId, String productName, Decimal unitPrice, int quantity, int? availableStock, Decimal? purchaseUnitPrice, Discount? discount
});


@override $DiscountCopyWith<$Res>? get discount;

}
/// @nodoc
class __$CartItemCopyWithImpl<$Res>
    implements _$CartItemCopyWith<$Res> {
  __$CartItemCopyWithImpl(this._self, this._then);

  final _CartItem _self;
  final $Res Function(_CartItem) _then;

/// Create a copy of CartItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? productId = null,Object? productName = null,Object? unitPrice = null,Object? quantity = null,Object? availableStock = freezed,Object? purchaseUnitPrice = freezed,Object? discount = freezed,}) {
  return _then(_CartItem(
productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,productName: null == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String,unitPrice: null == unitPrice ? _self.unitPrice : unitPrice // ignore: cast_nullable_to_non_nullable
as Decimal,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,availableStock: freezed == availableStock ? _self.availableStock : availableStock // ignore: cast_nullable_to_non_nullable
as int?,purchaseUnitPrice: freezed == purchaseUnitPrice ? _self.purchaseUnitPrice : purchaseUnitPrice // ignore: cast_nullable_to_non_nullable
as Decimal?,discount: freezed == discount ? _self.discount : discount // ignore: cast_nullable_to_non_nullable
as Discount?,
  ));
}

/// Create a copy of CartItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DiscountCopyWith<$Res>? get discount {
    if (_self.discount == null) {
    return null;
  }

  return $DiscountCopyWith<$Res>(_self.discount!, (value) {
    return _then(_self.copyWith(discount: value));
  });
}
}

// dart format on
