// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'returnable_line.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ReturnableLine {

 String get saleItemId;/// Produit (null si supprimé côté serveur).
 String? get productId; String get productName;/// Prix unitaire figé à la vente.
 Decimal get unitPrice;/// Réduction de la ligne figée à la vente.
 Decimal get discountAmount; int get soldQuantity;/// Quantité déjà rendue (retours refusés par le serveur exclus).
 int get returnedQuantity;/// Part du total encaissé de la vente, remise globale répartie.
 Decimal get paidAmount;
/// Create a copy of ReturnableLine
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReturnableLineCopyWith<ReturnableLine> get copyWith => _$ReturnableLineCopyWithImpl<ReturnableLine>(this as ReturnableLine, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReturnableLine&&(identical(other.saleItemId, saleItemId) || other.saleItemId == saleItemId)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.unitPrice, unitPrice) || other.unitPrice == unitPrice)&&(identical(other.discountAmount, discountAmount) || other.discountAmount == discountAmount)&&(identical(other.soldQuantity, soldQuantity) || other.soldQuantity == soldQuantity)&&(identical(other.returnedQuantity, returnedQuantity) || other.returnedQuantity == returnedQuantity)&&(identical(other.paidAmount, paidAmount) || other.paidAmount == paidAmount));
}


@override
int get hashCode => Object.hash(runtimeType,saleItemId,productId,productName,unitPrice,discountAmount,soldQuantity,returnedQuantity,paidAmount);

@override
String toString() {
  return 'ReturnableLine(saleItemId: $saleItemId, productId: $productId, productName: $productName, unitPrice: $unitPrice, discountAmount: $discountAmount, soldQuantity: $soldQuantity, returnedQuantity: $returnedQuantity, paidAmount: $paidAmount)';
}


}

/// @nodoc
abstract mixin class $ReturnableLineCopyWith<$Res>  {
  factory $ReturnableLineCopyWith(ReturnableLine value, $Res Function(ReturnableLine) _then) = _$ReturnableLineCopyWithImpl;
@useResult
$Res call({
 String saleItemId, String? productId, String productName, Decimal unitPrice, Decimal discountAmount, int soldQuantity, int returnedQuantity, Decimal paidAmount
});




}
/// @nodoc
class _$ReturnableLineCopyWithImpl<$Res>
    implements $ReturnableLineCopyWith<$Res> {
  _$ReturnableLineCopyWithImpl(this._self, this._then);

  final ReturnableLine _self;
  final $Res Function(ReturnableLine) _then;

/// Create a copy of ReturnableLine
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? saleItemId = null,Object? productId = freezed,Object? productName = null,Object? unitPrice = null,Object? discountAmount = null,Object? soldQuantity = null,Object? returnedQuantity = null,Object? paidAmount = null,}) {
  return _then(ReturnableLine(
saleItemId: null == saleItemId ? _self.saleItemId : saleItemId // ignore: cast_nullable_to_non_nullable
as String,productId: freezed == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String?,productName: null == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String,unitPrice: null == unitPrice ? _self.unitPrice : unitPrice // ignore: cast_nullable_to_non_nullable
as Decimal,discountAmount: null == discountAmount ? _self.discountAmount : discountAmount // ignore: cast_nullable_to_non_nullable
as Decimal,soldQuantity: null == soldQuantity ? _self.soldQuantity : soldQuantity // ignore: cast_nullable_to_non_nullable
as int,returnedQuantity: null == returnedQuantity ? _self.returnedQuantity : returnedQuantity // ignore: cast_nullable_to_non_nullable
as int,paidAmount: null == paidAmount ? _self.paidAmount : paidAmount // ignore: cast_nullable_to_non_nullable
as Decimal,
  ));
}

}


/// Adds pattern-matching-related methods to [ReturnableLine].
extension ReturnableLinePatterns on ReturnableLine {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReturnableLine value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReturnableLine() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReturnableLine value)  $default,){
final _that = this;
switch (_that) {
case _ReturnableLine():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReturnableLine value)?  $default,){
final _that = this;
switch (_that) {
case _ReturnableLine() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String saleItemId,  String? productId,  String productName,  Decimal unitPrice,  Decimal discountAmount,  int soldQuantity,  int returnedQuantity,  Decimal paidAmount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReturnableLine() when $default != null:
return $default(_that.saleItemId,_that.productId,_that.productName,_that.unitPrice,_that.discountAmount,_that.soldQuantity,_that.returnedQuantity,_that.paidAmount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String saleItemId,  String? productId,  String productName,  Decimal unitPrice,  Decimal discountAmount,  int soldQuantity,  int returnedQuantity,  Decimal paidAmount)  $default,) {final _that = this;
switch (_that) {
case _ReturnableLine():
return $default(_that.saleItemId,_that.productId,_that.productName,_that.unitPrice,_that.discountAmount,_that.soldQuantity,_that.returnedQuantity,_that.paidAmount);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String saleItemId,  String? productId,  String productName,  Decimal unitPrice,  Decimal discountAmount,  int soldQuantity,  int returnedQuantity,  Decimal paidAmount)?  $default,) {final _that = this;
switch (_that) {
case _ReturnableLine() when $default != null:
return $default(_that.saleItemId,_that.productId,_that.productName,_that.unitPrice,_that.discountAmount,_that.soldQuantity,_that.returnedQuantity,_that.paidAmount);case _:
  return null;

}
}

}

/// @nodoc


class _ReturnableLine extends ReturnableLine {
  const _ReturnableLine({required this.saleItemId, this.productId, required this.productName, required this.unitPrice, required this.discountAmount, required this.soldQuantity, required this.returnedQuantity, required this.paidAmount}): super._();
  

@override final  String saleItemId;
/// Produit (null si supprimé côté serveur).
@override final  String? productId;
@override final  String productName;
/// Prix unitaire figé à la vente.
@override final  Decimal unitPrice;
/// Réduction de la ligne figée à la vente.
@override final  Decimal discountAmount;
@override final  int soldQuantity;
/// Quantité déjà rendue (retours refusés par le serveur exclus).
@override final  int returnedQuantity;
/// Part du total encaissé de la vente, remise globale répartie.
@override final  Decimal paidAmount;

/// Create a copy of ReturnableLine
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReturnableLineCopyWith<_ReturnableLine> get copyWith => __$ReturnableLineCopyWithImpl<_ReturnableLine>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReturnableLine&&(identical(other.saleItemId, saleItemId) || other.saleItemId == saleItemId)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.unitPrice, unitPrice) || other.unitPrice == unitPrice)&&(identical(other.discountAmount, discountAmount) || other.discountAmount == discountAmount)&&(identical(other.soldQuantity, soldQuantity) || other.soldQuantity == soldQuantity)&&(identical(other.returnedQuantity, returnedQuantity) || other.returnedQuantity == returnedQuantity)&&(identical(other.paidAmount, paidAmount) || other.paidAmount == paidAmount));
}


@override
int get hashCode => Object.hash(runtimeType,saleItemId,productId,productName,unitPrice,discountAmount,soldQuantity,returnedQuantity,paidAmount);

@override
String toString() {
  return 'ReturnableLine(saleItemId: $saleItemId, productId: $productId, productName: $productName, unitPrice: $unitPrice, discountAmount: $discountAmount, soldQuantity: $soldQuantity, returnedQuantity: $returnedQuantity, paidAmount: $paidAmount)';
}


}

/// @nodoc
abstract mixin class _$ReturnableLineCopyWith<$Res> implements $ReturnableLineCopyWith<$Res> {
  factory _$ReturnableLineCopyWith(_ReturnableLine value, $Res Function(_ReturnableLine) _then) = __$ReturnableLineCopyWithImpl;
@override @useResult
$Res call({
 String saleItemId, String? productId, String productName, Decimal unitPrice, Decimal discountAmount, int soldQuantity, int returnedQuantity, Decimal paidAmount
});




}
/// @nodoc
class __$ReturnableLineCopyWithImpl<$Res>
    implements _$ReturnableLineCopyWith<$Res> {
  __$ReturnableLineCopyWithImpl(this._self, this._then);

  final _ReturnableLine _self;
  final $Res Function(_ReturnableLine) _then;

/// Create a copy of ReturnableLine
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? saleItemId = null,Object? productId = freezed,Object? productName = null,Object? unitPrice = null,Object? discountAmount = null,Object? soldQuantity = null,Object? returnedQuantity = null,Object? paidAmount = null,}) {
  return _then(_ReturnableLine(
saleItemId: null == saleItemId ? _self.saleItemId : saleItemId // ignore: cast_nullable_to_non_nullable
as String,productId: freezed == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String?,productName: null == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String,unitPrice: null == unitPrice ? _self.unitPrice : unitPrice // ignore: cast_nullable_to_non_nullable
as Decimal,discountAmount: null == discountAmount ? _self.discountAmount : discountAmount // ignore: cast_nullable_to_non_nullable
as Decimal,soldQuantity: null == soldQuantity ? _self.soldQuantity : soldQuantity // ignore: cast_nullable_to_non_nullable
as int,returnedQuantity: null == returnedQuantity ? _self.returnedQuantity : returnedQuantity // ignore: cast_nullable_to_non_nullable
as int,paidAmount: null == paidAmount ? _self.paidAmount : paidAmount // ignore: cast_nullable_to_non_nullable
as Decimal,
  ));
}


}

// dart format on
