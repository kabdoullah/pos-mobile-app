// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Product {

 String get id; String get name;/// Prix de vente normal facturé au client (FCFA).
 Decimal get sellingPrice;/// Prix d'achat (coût d'acquisition, FCFA) ; null = non renseigné.
/// Donnée interne au commerçant, jamais montrée au client (ADR-0009).
 Decimal? get purchasePrice; String? get barcode; int? get currentStock;/// Seuil de réapprovisionnement (null = pas d'alerte configurée).
 int? get minStock;/// Catégorie (null = sans catégorie).
 String? get categoryId;/// Version (SHA-256) de l'image serveur ; null = pas d'image.
 String? get imageVersion; DateTime get updatedAt; DateTime? get deletedAt;
/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductCopyWith<Product> get copyWith => _$ProductCopyWithImpl<Product>(this as Product, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Product&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.sellingPrice, sellingPrice) || other.sellingPrice == sellingPrice)&&(identical(other.purchasePrice, purchasePrice) || other.purchasePrice == purchasePrice)&&(identical(other.barcode, barcode) || other.barcode == barcode)&&(identical(other.currentStock, currentStock) || other.currentStock == currentStock)&&(identical(other.minStock, minStock) || other.minStock == minStock)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.imageVersion, imageVersion) || other.imageVersion == imageVersion)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,sellingPrice,purchasePrice,barcode,currentStock,minStock,categoryId,imageVersion,updatedAt,deletedAt);

@override
String toString() {
  return 'Product(id: $id, name: $name, sellingPrice: $sellingPrice, purchasePrice: $purchasePrice, barcode: $barcode, currentStock: $currentStock, minStock: $minStock, categoryId: $categoryId, imageVersion: $imageVersion, updatedAt: $updatedAt, deletedAt: $deletedAt)';
}


}

/// @nodoc
abstract mixin class $ProductCopyWith<$Res>  {
  factory $ProductCopyWith(Product value, $Res Function(Product) _then) = _$ProductCopyWithImpl;
@useResult
$Res call({
 String id, String name, Decimal sellingPrice, Decimal? purchasePrice, String? barcode, int? currentStock, int? minStock, String? categoryId, String? imageVersion, DateTime updatedAt, DateTime? deletedAt
});




}
/// @nodoc
class _$ProductCopyWithImpl<$Res>
    implements $ProductCopyWith<$Res> {
  _$ProductCopyWithImpl(this._self, this._then);

  final Product _self;
  final $Res Function(Product) _then;

/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? sellingPrice = null,Object? purchasePrice = freezed,Object? barcode = freezed,Object? currentStock = freezed,Object? minStock = freezed,Object? categoryId = freezed,Object? imageVersion = freezed,Object? updatedAt = null,Object? deletedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,sellingPrice: null == sellingPrice ? _self.sellingPrice : sellingPrice // ignore: cast_nullable_to_non_nullable
as Decimal,purchasePrice: freezed == purchasePrice ? _self.purchasePrice : purchasePrice // ignore: cast_nullable_to_non_nullable
as Decimal?,barcode: freezed == barcode ? _self.barcode : barcode // ignore: cast_nullable_to_non_nullable
as String?,currentStock: freezed == currentStock ? _self.currentStock : currentStock // ignore: cast_nullable_to_non_nullable
as int?,minStock: freezed == minStock ? _self.minStock : minStock // ignore: cast_nullable_to_non_nullable
as int?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,imageVersion: freezed == imageVersion ? _self.imageVersion : imageVersion // ignore: cast_nullable_to_non_nullable
as String?,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Product].
extension ProductPatterns on Product {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Product value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Product() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Product value)  $default,){
final _that = this;
switch (_that) {
case _Product():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Product value)?  $default,){
final _that = this;
switch (_that) {
case _Product() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  Decimal sellingPrice,  Decimal? purchasePrice,  String? barcode,  int? currentStock,  int? minStock,  String? categoryId,  String? imageVersion,  DateTime updatedAt,  DateTime? deletedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Product() when $default != null:
return $default(_that.id,_that.name,_that.sellingPrice,_that.purchasePrice,_that.barcode,_that.currentStock,_that.minStock,_that.categoryId,_that.imageVersion,_that.updatedAt,_that.deletedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  Decimal sellingPrice,  Decimal? purchasePrice,  String? barcode,  int? currentStock,  int? minStock,  String? categoryId,  String? imageVersion,  DateTime updatedAt,  DateTime? deletedAt)  $default,) {final _that = this;
switch (_that) {
case _Product():
return $default(_that.id,_that.name,_that.sellingPrice,_that.purchasePrice,_that.barcode,_that.currentStock,_that.minStock,_that.categoryId,_that.imageVersion,_that.updatedAt,_that.deletedAt);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  Decimal sellingPrice,  Decimal? purchasePrice,  String? barcode,  int? currentStock,  int? minStock,  String? categoryId,  String? imageVersion,  DateTime updatedAt,  DateTime? deletedAt)?  $default,) {final _that = this;
switch (_that) {
case _Product() when $default != null:
return $default(_that.id,_that.name,_that.sellingPrice,_that.purchasePrice,_that.barcode,_that.currentStock,_that.minStock,_that.categoryId,_that.imageVersion,_that.updatedAt,_that.deletedAt);case _:
  return null;

}
}

}

/// @nodoc


class _Product extends Product {
  const _Product({required this.id, required this.name, required this.sellingPrice, this.purchasePrice, this.barcode, this.currentStock, this.minStock, this.categoryId, this.imageVersion, required this.updatedAt, this.deletedAt}): super._();
  

@override final  String id;
@override final  String name;
/// Prix de vente normal facturé au client (FCFA).
@override final  Decimal sellingPrice;
/// Prix d'achat (coût d'acquisition, FCFA) ; null = non renseigné.
/// Donnée interne au commerçant, jamais montrée au client (ADR-0009).
@override final  Decimal? purchasePrice;
@override final  String? barcode;
@override final  int? currentStock;
/// Seuil de réapprovisionnement (null = pas d'alerte configurée).
@override final  int? minStock;
/// Catégorie (null = sans catégorie).
@override final  String? categoryId;
/// Version (SHA-256) de l'image serveur ; null = pas d'image.
@override final  String? imageVersion;
@override final  DateTime updatedAt;
@override final  DateTime? deletedAt;

/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductCopyWith<_Product> get copyWith => __$ProductCopyWithImpl<_Product>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Product&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.sellingPrice, sellingPrice) || other.sellingPrice == sellingPrice)&&(identical(other.purchasePrice, purchasePrice) || other.purchasePrice == purchasePrice)&&(identical(other.barcode, barcode) || other.barcode == barcode)&&(identical(other.currentStock, currentStock) || other.currentStock == currentStock)&&(identical(other.minStock, minStock) || other.minStock == minStock)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.imageVersion, imageVersion) || other.imageVersion == imageVersion)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,sellingPrice,purchasePrice,barcode,currentStock,minStock,categoryId,imageVersion,updatedAt,deletedAt);

@override
String toString() {
  return 'Product(id: $id, name: $name, sellingPrice: $sellingPrice, purchasePrice: $purchasePrice, barcode: $barcode, currentStock: $currentStock, minStock: $minStock, categoryId: $categoryId, imageVersion: $imageVersion, updatedAt: $updatedAt, deletedAt: $deletedAt)';
}


}

/// @nodoc
abstract mixin class _$ProductCopyWith<$Res> implements $ProductCopyWith<$Res> {
  factory _$ProductCopyWith(_Product value, $Res Function(_Product) _then) = __$ProductCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, Decimal sellingPrice, Decimal? purchasePrice, String? barcode, int? currentStock, int? minStock, String? categoryId, String? imageVersion, DateTime updatedAt, DateTime? deletedAt
});




}
/// @nodoc
class __$ProductCopyWithImpl<$Res>
    implements _$ProductCopyWith<$Res> {
  __$ProductCopyWithImpl(this._self, this._then);

  final _Product _self;
  final $Res Function(_Product) _then;

/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? sellingPrice = null,Object? purchasePrice = freezed,Object? barcode = freezed,Object? currentStock = freezed,Object? minStock = freezed,Object? categoryId = freezed,Object? imageVersion = freezed,Object? updatedAt = null,Object? deletedAt = freezed,}) {
  return _then(_Product(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,sellingPrice: null == sellingPrice ? _self.sellingPrice : sellingPrice // ignore: cast_nullable_to_non_nullable
as Decimal,purchasePrice: freezed == purchasePrice ? _self.purchasePrice : purchasePrice // ignore: cast_nullable_to_non_nullable
as Decimal?,barcode: freezed == barcode ? _self.barcode : barcode // ignore: cast_nullable_to_non_nullable
as String?,currentStock: freezed == currentStock ? _self.currentStock : currentStock // ignore: cast_nullable_to_non_nullable
as int?,minStock: freezed == minStock ? _self.minStock : minStock // ignore: cast_nullable_to_non_nullable
as int?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,imageVersion: freezed == imageVersion ? _self.imageVersion : imageVersion // ignore: cast_nullable_to_non_nullable
as String?,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
