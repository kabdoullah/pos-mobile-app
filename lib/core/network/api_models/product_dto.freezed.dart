// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProductDto {

 String get id;@JsonKey(name: 'store_id') String get storeId; String get name; String? get barcode;/// Prix en FCFA, reçu sous forme de chaîne depuis l'API.
@JsonKey(name: 'unit_price') String get unitPrice;@JsonKey(name: 'current_stock') int? get currentStock;@JsonKey(name: 'min_stock') int? get minStock;@JsonKey(name: 'created_at') String get createdAt;@JsonKey(name: 'updated_at') String get updatedAt;@JsonKey(name: 'deleted_at') String? get deletedAt;
/// Create a copy of ProductDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductDtoCopyWith<ProductDto> get copyWith => _$ProductDtoCopyWithImpl<ProductDto>(this as ProductDto, _$identity);

  /// Serializes this ProductDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductDto&&(identical(other.id, id) || other.id == id)&&(identical(other.storeId, storeId) || other.storeId == storeId)&&(identical(other.name, name) || other.name == name)&&(identical(other.barcode, barcode) || other.barcode == barcode)&&(identical(other.unitPrice, unitPrice) || other.unitPrice == unitPrice)&&(identical(other.currentStock, currentStock) || other.currentStock == currentStock)&&(identical(other.minStock, minStock) || other.minStock == minStock)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,storeId,name,barcode,unitPrice,currentStock,minStock,createdAt,updatedAt,deletedAt);

@override
String toString() {
  return 'ProductDto(id: $id, storeId: $storeId, name: $name, barcode: $barcode, unitPrice: $unitPrice, currentStock: $currentStock, minStock: $minStock, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt)';
}


}

/// @nodoc
abstract mixin class $ProductDtoCopyWith<$Res>  {
  factory $ProductDtoCopyWith(ProductDto value, $Res Function(ProductDto) _then) = _$ProductDtoCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'store_id') String storeId, String name, String? barcode,@JsonKey(name: 'unit_price') String unitPrice,@JsonKey(name: 'current_stock') int? currentStock,@JsonKey(name: 'min_stock') int? minStock,@JsonKey(name: 'created_at') String createdAt,@JsonKey(name: 'updated_at') String updatedAt,@JsonKey(name: 'deleted_at') String? deletedAt
});




}
/// @nodoc
class _$ProductDtoCopyWithImpl<$Res>
    implements $ProductDtoCopyWith<$Res> {
  _$ProductDtoCopyWithImpl(this._self, this._then);

  final ProductDto _self;
  final $Res Function(ProductDto) _then;

/// Create a copy of ProductDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? storeId = null,Object? name = null,Object? barcode = freezed,Object? unitPrice = null,Object? currentStock = freezed,Object? minStock = freezed,Object? createdAt = null,Object? updatedAt = null,Object? deletedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,storeId: null == storeId ? _self.storeId : storeId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,barcode: freezed == barcode ? _self.barcode : barcode // ignore: cast_nullable_to_non_nullable
as String?,unitPrice: null == unitPrice ? _self.unitPrice : unitPrice // ignore: cast_nullable_to_non_nullable
as String,currentStock: freezed == currentStock ? _self.currentStock : currentStock // ignore: cast_nullable_to_non_nullable
as int?,minStock: freezed == minStock ? _self.minStock : minStock // ignore: cast_nullable_to_non_nullable
as int?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ProductDto].
extension ProductDtoPatterns on ProductDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProductDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProductDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProductDto value)  $default,){
final _that = this;
switch (_that) {
case _ProductDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProductDto value)?  $default,){
final _that = this;
switch (_that) {
case _ProductDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'store_id')  String storeId,  String name,  String? barcode, @JsonKey(name: 'unit_price')  String unitPrice, @JsonKey(name: 'current_stock')  int? currentStock, @JsonKey(name: 'min_stock')  int? minStock, @JsonKey(name: 'created_at')  String createdAt, @JsonKey(name: 'updated_at')  String updatedAt, @JsonKey(name: 'deleted_at')  String? deletedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProductDto() when $default != null:
return $default(_that.id,_that.storeId,_that.name,_that.barcode,_that.unitPrice,_that.currentStock,_that.minStock,_that.createdAt,_that.updatedAt,_that.deletedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'store_id')  String storeId,  String name,  String? barcode, @JsonKey(name: 'unit_price')  String unitPrice, @JsonKey(name: 'current_stock')  int? currentStock, @JsonKey(name: 'min_stock')  int? minStock, @JsonKey(name: 'created_at')  String createdAt, @JsonKey(name: 'updated_at')  String updatedAt, @JsonKey(name: 'deleted_at')  String? deletedAt)  $default,) {final _that = this;
switch (_that) {
case _ProductDto():
return $default(_that.id,_that.storeId,_that.name,_that.barcode,_that.unitPrice,_that.currentStock,_that.minStock,_that.createdAt,_that.updatedAt,_that.deletedAt);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'store_id')  String storeId,  String name,  String? barcode, @JsonKey(name: 'unit_price')  String unitPrice, @JsonKey(name: 'current_stock')  int? currentStock, @JsonKey(name: 'min_stock')  int? minStock, @JsonKey(name: 'created_at')  String createdAt, @JsonKey(name: 'updated_at')  String updatedAt, @JsonKey(name: 'deleted_at')  String? deletedAt)?  $default,) {final _that = this;
switch (_that) {
case _ProductDto() when $default != null:
return $default(_that.id,_that.storeId,_that.name,_that.barcode,_that.unitPrice,_that.currentStock,_that.minStock,_that.createdAt,_that.updatedAt,_that.deletedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProductDto implements ProductDto {
  const _ProductDto({required this.id, @JsonKey(name: 'store_id') required this.storeId, required this.name, this.barcode, @JsonKey(name: 'unit_price') required this.unitPrice, @JsonKey(name: 'current_stock') this.currentStock, @JsonKey(name: 'min_stock') this.minStock, @JsonKey(name: 'created_at') required this.createdAt, @JsonKey(name: 'updated_at') required this.updatedAt, @JsonKey(name: 'deleted_at') this.deletedAt});
  factory _ProductDto.fromJson(Map<String, dynamic> json) => _$ProductDtoFromJson(json);

@override final  String id;
@override@JsonKey(name: 'store_id') final  String storeId;
@override final  String name;
@override final  String? barcode;
/// Prix en FCFA, reçu sous forme de chaîne depuis l'API.
@override@JsonKey(name: 'unit_price') final  String unitPrice;
@override@JsonKey(name: 'current_stock') final  int? currentStock;
@override@JsonKey(name: 'min_stock') final  int? minStock;
@override@JsonKey(name: 'created_at') final  String createdAt;
@override@JsonKey(name: 'updated_at') final  String updatedAt;
@override@JsonKey(name: 'deleted_at') final  String? deletedAt;

/// Create a copy of ProductDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductDtoCopyWith<_ProductDto> get copyWith => __$ProductDtoCopyWithImpl<_ProductDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProductDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProductDto&&(identical(other.id, id) || other.id == id)&&(identical(other.storeId, storeId) || other.storeId == storeId)&&(identical(other.name, name) || other.name == name)&&(identical(other.barcode, barcode) || other.barcode == barcode)&&(identical(other.unitPrice, unitPrice) || other.unitPrice == unitPrice)&&(identical(other.currentStock, currentStock) || other.currentStock == currentStock)&&(identical(other.minStock, minStock) || other.minStock == minStock)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,storeId,name,barcode,unitPrice,currentStock,minStock,createdAt,updatedAt,deletedAt);

@override
String toString() {
  return 'ProductDto(id: $id, storeId: $storeId, name: $name, barcode: $barcode, unitPrice: $unitPrice, currentStock: $currentStock, minStock: $minStock, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt)';
}


}

/// @nodoc
abstract mixin class _$ProductDtoCopyWith<$Res> implements $ProductDtoCopyWith<$Res> {
  factory _$ProductDtoCopyWith(_ProductDto value, $Res Function(_ProductDto) _then) = __$ProductDtoCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'store_id') String storeId, String name, String? barcode,@JsonKey(name: 'unit_price') String unitPrice,@JsonKey(name: 'current_stock') int? currentStock,@JsonKey(name: 'min_stock') int? minStock,@JsonKey(name: 'created_at') String createdAt,@JsonKey(name: 'updated_at') String updatedAt,@JsonKey(name: 'deleted_at') String? deletedAt
});




}
/// @nodoc
class __$ProductDtoCopyWithImpl<$Res>
    implements _$ProductDtoCopyWith<$Res> {
  __$ProductDtoCopyWithImpl(this._self, this._then);

  final _ProductDto _self;
  final $Res Function(_ProductDto) _then;

/// Create a copy of ProductDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? storeId = null,Object? name = null,Object? barcode = freezed,Object? unitPrice = null,Object? currentStock = freezed,Object? minStock = freezed,Object? createdAt = null,Object? updatedAt = null,Object? deletedAt = freezed,}) {
  return _then(_ProductDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,storeId: null == storeId ? _self.storeId : storeId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,barcode: freezed == barcode ? _self.barcode : barcode // ignore: cast_nullable_to_non_nullable
as String?,unitPrice: null == unitPrice ? _self.unitPrice : unitPrice // ignore: cast_nullable_to_non_nullable
as String,currentStock: freezed == currentStock ? _self.currentStock : currentStock // ignore: cast_nullable_to_non_nullable
as int?,minStock: freezed == minStock ? _self.minStock : minStock // ignore: cast_nullable_to_non_nullable
as int?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$ProductCreateDto {

 String get name; String? get barcode;/// Prix en FCFA.
@JsonKey(name: 'unit_price') String get unitPrice;@JsonKey(name: 'current_stock') int? get currentStock;@JsonKey(name: 'min_stock') int? get minStock;
/// Create a copy of ProductCreateDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductCreateDtoCopyWith<ProductCreateDto> get copyWith => _$ProductCreateDtoCopyWithImpl<ProductCreateDto>(this as ProductCreateDto, _$identity);

  /// Serializes this ProductCreateDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductCreateDto&&(identical(other.name, name) || other.name == name)&&(identical(other.barcode, barcode) || other.barcode == barcode)&&(identical(other.unitPrice, unitPrice) || other.unitPrice == unitPrice)&&(identical(other.currentStock, currentStock) || other.currentStock == currentStock)&&(identical(other.minStock, minStock) || other.minStock == minStock));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,barcode,unitPrice,currentStock,minStock);

@override
String toString() {
  return 'ProductCreateDto(name: $name, barcode: $barcode, unitPrice: $unitPrice, currentStock: $currentStock, minStock: $minStock)';
}


}

/// @nodoc
abstract mixin class $ProductCreateDtoCopyWith<$Res>  {
  factory $ProductCreateDtoCopyWith(ProductCreateDto value, $Res Function(ProductCreateDto) _then) = _$ProductCreateDtoCopyWithImpl;
@useResult
$Res call({
 String name, String? barcode,@JsonKey(name: 'unit_price') String unitPrice,@JsonKey(name: 'current_stock') int? currentStock,@JsonKey(name: 'min_stock') int? minStock
});




}
/// @nodoc
class _$ProductCreateDtoCopyWithImpl<$Res>
    implements $ProductCreateDtoCopyWith<$Res> {
  _$ProductCreateDtoCopyWithImpl(this._self, this._then);

  final ProductCreateDto _self;
  final $Res Function(ProductCreateDto) _then;

/// Create a copy of ProductCreateDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? barcode = freezed,Object? unitPrice = null,Object? currentStock = freezed,Object? minStock = freezed,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,barcode: freezed == barcode ? _self.barcode : barcode // ignore: cast_nullable_to_non_nullable
as String?,unitPrice: null == unitPrice ? _self.unitPrice : unitPrice // ignore: cast_nullable_to_non_nullable
as String,currentStock: freezed == currentStock ? _self.currentStock : currentStock // ignore: cast_nullable_to_non_nullable
as int?,minStock: freezed == minStock ? _self.minStock : minStock // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [ProductCreateDto].
extension ProductCreateDtoPatterns on ProductCreateDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProductCreateDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProductCreateDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProductCreateDto value)  $default,){
final _that = this;
switch (_that) {
case _ProductCreateDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProductCreateDto value)?  $default,){
final _that = this;
switch (_that) {
case _ProductCreateDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String? barcode, @JsonKey(name: 'unit_price')  String unitPrice, @JsonKey(name: 'current_stock')  int? currentStock, @JsonKey(name: 'min_stock')  int? minStock)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProductCreateDto() when $default != null:
return $default(_that.name,_that.barcode,_that.unitPrice,_that.currentStock,_that.minStock);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String? barcode, @JsonKey(name: 'unit_price')  String unitPrice, @JsonKey(name: 'current_stock')  int? currentStock, @JsonKey(name: 'min_stock')  int? minStock)  $default,) {final _that = this;
switch (_that) {
case _ProductCreateDto():
return $default(_that.name,_that.barcode,_that.unitPrice,_that.currentStock,_that.minStock);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String? barcode, @JsonKey(name: 'unit_price')  String unitPrice, @JsonKey(name: 'current_stock')  int? currentStock, @JsonKey(name: 'min_stock')  int? minStock)?  $default,) {final _that = this;
switch (_that) {
case _ProductCreateDto() when $default != null:
return $default(_that.name,_that.barcode,_that.unitPrice,_that.currentStock,_that.minStock);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProductCreateDto implements ProductCreateDto {
  const _ProductCreateDto({required this.name, this.barcode, @JsonKey(name: 'unit_price') required this.unitPrice, @JsonKey(name: 'current_stock') this.currentStock, @JsonKey(name: 'min_stock') this.minStock});
  factory _ProductCreateDto.fromJson(Map<String, dynamic> json) => _$ProductCreateDtoFromJson(json);

@override final  String name;
@override final  String? barcode;
/// Prix en FCFA.
@override@JsonKey(name: 'unit_price') final  String unitPrice;
@override@JsonKey(name: 'current_stock') final  int? currentStock;
@override@JsonKey(name: 'min_stock') final  int? minStock;

/// Create a copy of ProductCreateDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductCreateDtoCopyWith<_ProductCreateDto> get copyWith => __$ProductCreateDtoCopyWithImpl<_ProductCreateDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProductCreateDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProductCreateDto&&(identical(other.name, name) || other.name == name)&&(identical(other.barcode, barcode) || other.barcode == barcode)&&(identical(other.unitPrice, unitPrice) || other.unitPrice == unitPrice)&&(identical(other.currentStock, currentStock) || other.currentStock == currentStock)&&(identical(other.minStock, minStock) || other.minStock == minStock));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,barcode,unitPrice,currentStock,minStock);

@override
String toString() {
  return 'ProductCreateDto(name: $name, barcode: $barcode, unitPrice: $unitPrice, currentStock: $currentStock, minStock: $minStock)';
}


}

/// @nodoc
abstract mixin class _$ProductCreateDtoCopyWith<$Res> implements $ProductCreateDtoCopyWith<$Res> {
  factory _$ProductCreateDtoCopyWith(_ProductCreateDto value, $Res Function(_ProductCreateDto) _then) = __$ProductCreateDtoCopyWithImpl;
@override @useResult
$Res call({
 String name, String? barcode,@JsonKey(name: 'unit_price') String unitPrice,@JsonKey(name: 'current_stock') int? currentStock,@JsonKey(name: 'min_stock') int? minStock
});




}
/// @nodoc
class __$ProductCreateDtoCopyWithImpl<$Res>
    implements _$ProductCreateDtoCopyWith<$Res> {
  __$ProductCreateDtoCopyWithImpl(this._self, this._then);

  final _ProductCreateDto _self;
  final $Res Function(_ProductCreateDto) _then;

/// Create a copy of ProductCreateDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? barcode = freezed,Object? unitPrice = null,Object? currentStock = freezed,Object? minStock = freezed,}) {
  return _then(_ProductCreateDto(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,barcode: freezed == barcode ? _self.barcode : barcode // ignore: cast_nullable_to_non_nullable
as String?,unitPrice: null == unitPrice ? _self.unitPrice : unitPrice // ignore: cast_nullable_to_non_nullable
as String,currentStock: freezed == currentStock ? _self.currentStock : currentStock // ignore: cast_nullable_to_non_nullable
as int?,minStock: freezed == minStock ? _self.minStock : minStock // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$ProductUpdateDto {

 String? get name; String? get barcode;@JsonKey(name: 'unit_price') String? get unitPrice;@JsonKey(name: 'current_stock') int? get currentStock;@JsonKey(name: 'min_stock') int? get minStock;
/// Create a copy of ProductUpdateDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductUpdateDtoCopyWith<ProductUpdateDto> get copyWith => _$ProductUpdateDtoCopyWithImpl<ProductUpdateDto>(this as ProductUpdateDto, _$identity);

  /// Serializes this ProductUpdateDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductUpdateDto&&(identical(other.name, name) || other.name == name)&&(identical(other.barcode, barcode) || other.barcode == barcode)&&(identical(other.unitPrice, unitPrice) || other.unitPrice == unitPrice)&&(identical(other.currentStock, currentStock) || other.currentStock == currentStock)&&(identical(other.minStock, minStock) || other.minStock == minStock));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,barcode,unitPrice,currentStock,minStock);

@override
String toString() {
  return 'ProductUpdateDto(name: $name, barcode: $barcode, unitPrice: $unitPrice, currentStock: $currentStock, minStock: $minStock)';
}


}

/// @nodoc
abstract mixin class $ProductUpdateDtoCopyWith<$Res>  {
  factory $ProductUpdateDtoCopyWith(ProductUpdateDto value, $Res Function(ProductUpdateDto) _then) = _$ProductUpdateDtoCopyWithImpl;
@useResult
$Res call({
 String? name, String? barcode,@JsonKey(name: 'unit_price') String? unitPrice,@JsonKey(name: 'current_stock') int? currentStock,@JsonKey(name: 'min_stock') int? minStock
});




}
/// @nodoc
class _$ProductUpdateDtoCopyWithImpl<$Res>
    implements $ProductUpdateDtoCopyWith<$Res> {
  _$ProductUpdateDtoCopyWithImpl(this._self, this._then);

  final ProductUpdateDto _self;
  final $Res Function(ProductUpdateDto) _then;

/// Create a copy of ProductUpdateDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = freezed,Object? barcode = freezed,Object? unitPrice = freezed,Object? currentStock = freezed,Object? minStock = freezed,}) {
  return _then(_self.copyWith(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,barcode: freezed == barcode ? _self.barcode : barcode // ignore: cast_nullable_to_non_nullable
as String?,unitPrice: freezed == unitPrice ? _self.unitPrice : unitPrice // ignore: cast_nullable_to_non_nullable
as String?,currentStock: freezed == currentStock ? _self.currentStock : currentStock // ignore: cast_nullable_to_non_nullable
as int?,minStock: freezed == minStock ? _self.minStock : minStock // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [ProductUpdateDto].
extension ProductUpdateDtoPatterns on ProductUpdateDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProductUpdateDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProductUpdateDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProductUpdateDto value)  $default,){
final _that = this;
switch (_that) {
case _ProductUpdateDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProductUpdateDto value)?  $default,){
final _that = this;
switch (_that) {
case _ProductUpdateDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? name,  String? barcode, @JsonKey(name: 'unit_price')  String? unitPrice, @JsonKey(name: 'current_stock')  int? currentStock, @JsonKey(name: 'min_stock')  int? minStock)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProductUpdateDto() when $default != null:
return $default(_that.name,_that.barcode,_that.unitPrice,_that.currentStock,_that.minStock);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? name,  String? barcode, @JsonKey(name: 'unit_price')  String? unitPrice, @JsonKey(name: 'current_stock')  int? currentStock, @JsonKey(name: 'min_stock')  int? minStock)  $default,) {final _that = this;
switch (_that) {
case _ProductUpdateDto():
return $default(_that.name,_that.barcode,_that.unitPrice,_that.currentStock,_that.minStock);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? name,  String? barcode, @JsonKey(name: 'unit_price')  String? unitPrice, @JsonKey(name: 'current_stock')  int? currentStock, @JsonKey(name: 'min_stock')  int? minStock)?  $default,) {final _that = this;
switch (_that) {
case _ProductUpdateDto() when $default != null:
return $default(_that.name,_that.barcode,_that.unitPrice,_that.currentStock,_that.minStock);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProductUpdateDto implements ProductUpdateDto {
  const _ProductUpdateDto({this.name, this.barcode, @JsonKey(name: 'unit_price') this.unitPrice, @JsonKey(name: 'current_stock') this.currentStock, @JsonKey(name: 'min_stock') this.minStock});
  factory _ProductUpdateDto.fromJson(Map<String, dynamic> json) => _$ProductUpdateDtoFromJson(json);

@override final  String? name;
@override final  String? barcode;
@override@JsonKey(name: 'unit_price') final  String? unitPrice;
@override@JsonKey(name: 'current_stock') final  int? currentStock;
@override@JsonKey(name: 'min_stock') final  int? minStock;

/// Create a copy of ProductUpdateDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductUpdateDtoCopyWith<_ProductUpdateDto> get copyWith => __$ProductUpdateDtoCopyWithImpl<_ProductUpdateDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProductUpdateDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProductUpdateDto&&(identical(other.name, name) || other.name == name)&&(identical(other.barcode, barcode) || other.barcode == barcode)&&(identical(other.unitPrice, unitPrice) || other.unitPrice == unitPrice)&&(identical(other.currentStock, currentStock) || other.currentStock == currentStock)&&(identical(other.minStock, minStock) || other.minStock == minStock));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,barcode,unitPrice,currentStock,minStock);

@override
String toString() {
  return 'ProductUpdateDto(name: $name, barcode: $barcode, unitPrice: $unitPrice, currentStock: $currentStock, minStock: $minStock)';
}


}

/// @nodoc
abstract mixin class _$ProductUpdateDtoCopyWith<$Res> implements $ProductUpdateDtoCopyWith<$Res> {
  factory _$ProductUpdateDtoCopyWith(_ProductUpdateDto value, $Res Function(_ProductUpdateDto) _then) = __$ProductUpdateDtoCopyWithImpl;
@override @useResult
$Res call({
 String? name, String? barcode,@JsonKey(name: 'unit_price') String? unitPrice,@JsonKey(name: 'current_stock') int? currentStock,@JsonKey(name: 'min_stock') int? minStock
});




}
/// @nodoc
class __$ProductUpdateDtoCopyWithImpl<$Res>
    implements _$ProductUpdateDtoCopyWith<$Res> {
  __$ProductUpdateDtoCopyWithImpl(this._self, this._then);

  final _ProductUpdateDto _self;
  final $Res Function(_ProductUpdateDto) _then;

/// Create a copy of ProductUpdateDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = freezed,Object? barcode = freezed,Object? unitPrice = freezed,Object? currentStock = freezed,Object? minStock = freezed,}) {
  return _then(_ProductUpdateDto(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,barcode: freezed == barcode ? _self.barcode : barcode // ignore: cast_nullable_to_non_nullable
as String?,unitPrice: freezed == unitPrice ? _self.unitPrice : unitPrice // ignore: cast_nullable_to_non_nullable
as String?,currentStock: freezed == currentStock ? _self.currentStock : currentStock // ignore: cast_nullable_to_non_nullable
as int?,minStock: freezed == minStock ? _self.minStock : minStock // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
