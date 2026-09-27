// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sync_changes_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SyncChangesDto {

// Absent sur un serveur antérieur à l'ADR-0008.
 List<CategoryDto> get categories; List<ProductDto> get products; List<SaleDto> get sales;@JsonKey(name: 'next_cursor') String? get nextCursor;@JsonKey(name: 'has_more') bool get hasMore;@JsonKey(name: 'server_time') String get serverTime;
/// Create a copy of SyncChangesDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SyncChangesDtoCopyWith<SyncChangesDto> get copyWith => _$SyncChangesDtoCopyWithImpl<SyncChangesDto>(this as SyncChangesDto, _$identity);

  /// Serializes this SyncChangesDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SyncChangesDto&&const DeepCollectionEquality().equals(other.categories, categories)&&const DeepCollectionEquality().equals(other.products, products)&&const DeepCollectionEquality().equals(other.sales, sales)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore)&&(identical(other.serverTime, serverTime) || other.serverTime == serverTime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(categories),const DeepCollectionEquality().hash(products),const DeepCollectionEquality().hash(sales),nextCursor,hasMore,serverTime);

@override
String toString() {
  return 'SyncChangesDto(categories: $categories, products: $products, sales: $sales, nextCursor: $nextCursor, hasMore: $hasMore, serverTime: $serverTime)';
}


}

/// @nodoc
abstract mixin class $SyncChangesDtoCopyWith<$Res>  {
  factory $SyncChangesDtoCopyWith(SyncChangesDto value, $Res Function(SyncChangesDto) _then) = _$SyncChangesDtoCopyWithImpl;
@useResult
$Res call({
 List<CategoryDto> categories, List<ProductDto> products, List<SaleDto> sales,@JsonKey(name: 'next_cursor') String? nextCursor,@JsonKey(name: 'has_more') bool hasMore,@JsonKey(name: 'server_time') String serverTime
});




}
/// @nodoc
class _$SyncChangesDtoCopyWithImpl<$Res>
    implements $SyncChangesDtoCopyWith<$Res> {
  _$SyncChangesDtoCopyWithImpl(this._self, this._then);

  final SyncChangesDto _self;
  final $Res Function(SyncChangesDto) _then;

/// Create a copy of SyncChangesDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? categories = null,Object? products = null,Object? sales = null,Object? nextCursor = freezed,Object? hasMore = null,Object? serverTime = null,}) {
  return _then(_self.copyWith(
categories: null == categories ? _self.categories : categories // ignore: cast_nullable_to_non_nullable
as List<CategoryDto>,products: null == products ? _self.products : products // ignore: cast_nullable_to_non_nullable
as List<ProductDto>,sales: null == sales ? _self.sales : sales // ignore: cast_nullable_to_non_nullable
as List<SaleDto>,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,serverTime: null == serverTime ? _self.serverTime : serverTime // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [SyncChangesDto].
extension SyncChangesDtoPatterns on SyncChangesDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SyncChangesDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SyncChangesDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SyncChangesDto value)  $default,){
final _that = this;
switch (_that) {
case _SyncChangesDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SyncChangesDto value)?  $default,){
final _that = this;
switch (_that) {
case _SyncChangesDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<CategoryDto> categories,  List<ProductDto> products,  List<SaleDto> sales, @JsonKey(name: 'next_cursor')  String? nextCursor, @JsonKey(name: 'has_more')  bool hasMore, @JsonKey(name: 'server_time')  String serverTime)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SyncChangesDto() when $default != null:
return $default(_that.categories,_that.products,_that.sales,_that.nextCursor,_that.hasMore,_that.serverTime);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<CategoryDto> categories,  List<ProductDto> products,  List<SaleDto> sales, @JsonKey(name: 'next_cursor')  String? nextCursor, @JsonKey(name: 'has_more')  bool hasMore, @JsonKey(name: 'server_time')  String serverTime)  $default,) {final _that = this;
switch (_that) {
case _SyncChangesDto():
return $default(_that.categories,_that.products,_that.sales,_that.nextCursor,_that.hasMore,_that.serverTime);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<CategoryDto> categories,  List<ProductDto> products,  List<SaleDto> sales, @JsonKey(name: 'next_cursor')  String? nextCursor, @JsonKey(name: 'has_more')  bool hasMore, @JsonKey(name: 'server_time')  String serverTime)?  $default,) {final _that = this;
switch (_that) {
case _SyncChangesDto() when $default != null:
return $default(_that.categories,_that.products,_that.sales,_that.nextCursor,_that.hasMore,_that.serverTime);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SyncChangesDto implements SyncChangesDto {
  const _SyncChangesDto({final  List<CategoryDto> categories = const <CategoryDto>[], required final  List<ProductDto> products, required final  List<SaleDto> sales, @JsonKey(name: 'next_cursor') this.nextCursor, @JsonKey(name: 'has_more') required this.hasMore, @JsonKey(name: 'server_time') required this.serverTime}): _categories = categories,_products = products,_sales = sales;
  factory _SyncChangesDto.fromJson(Map<String, dynamic> json) => _$SyncChangesDtoFromJson(json);

// Absent sur un serveur antérieur à l'ADR-0008.
 final  List<CategoryDto> _categories;
// Absent sur un serveur antérieur à l'ADR-0008.
@override@JsonKey() List<CategoryDto> get categories {
  if (_categories is EqualUnmodifiableListView) return _categories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_categories);
}

 final  List<ProductDto> _products;
@override List<ProductDto> get products {
  if (_products is EqualUnmodifiableListView) return _products;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_products);
}

 final  List<SaleDto> _sales;
@override List<SaleDto> get sales {
  if (_sales is EqualUnmodifiableListView) return _sales;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sales);
}

@override@JsonKey(name: 'next_cursor') final  String? nextCursor;
@override@JsonKey(name: 'has_more') final  bool hasMore;
@override@JsonKey(name: 'server_time') final  String serverTime;

/// Create a copy of SyncChangesDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SyncChangesDtoCopyWith<_SyncChangesDto> get copyWith => __$SyncChangesDtoCopyWithImpl<_SyncChangesDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SyncChangesDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SyncChangesDto&&const DeepCollectionEquality().equals(other._categories, _categories)&&const DeepCollectionEquality().equals(other._products, _products)&&const DeepCollectionEquality().equals(other._sales, _sales)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore)&&(identical(other.serverTime, serverTime) || other.serverTime == serverTime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_categories),const DeepCollectionEquality().hash(_products),const DeepCollectionEquality().hash(_sales),nextCursor,hasMore,serverTime);

@override
String toString() {
  return 'SyncChangesDto(categories: $categories, products: $products, sales: $sales, nextCursor: $nextCursor, hasMore: $hasMore, serverTime: $serverTime)';
}


}

/// @nodoc
abstract mixin class _$SyncChangesDtoCopyWith<$Res> implements $SyncChangesDtoCopyWith<$Res> {
  factory _$SyncChangesDtoCopyWith(_SyncChangesDto value, $Res Function(_SyncChangesDto) _then) = __$SyncChangesDtoCopyWithImpl;
@override @useResult
$Res call({
 List<CategoryDto> categories, List<ProductDto> products, List<SaleDto> sales,@JsonKey(name: 'next_cursor') String? nextCursor,@JsonKey(name: 'has_more') bool hasMore,@JsonKey(name: 'server_time') String serverTime
});




}
/// @nodoc
class __$SyncChangesDtoCopyWithImpl<$Res>
    implements _$SyncChangesDtoCopyWith<$Res> {
  __$SyncChangesDtoCopyWithImpl(this._self, this._then);

  final _SyncChangesDto _self;
  final $Res Function(_SyncChangesDto) _then;

/// Create a copy of SyncChangesDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? categories = null,Object? products = null,Object? sales = null,Object? nextCursor = freezed,Object? hasMore = null,Object? serverTime = null,}) {
  return _then(_SyncChangesDto(
categories: null == categories ? _self._categories : categories // ignore: cast_nullable_to_non_nullable
as List<CategoryDto>,products: null == products ? _self._products : products // ignore: cast_nullable_to_non_nullable
as List<ProductDto>,sales: null == sales ? _self._sales : sales // ignore: cast_nullable_to_non_nullable
as List<SaleDto>,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,serverTime: null == serverTime ? _self.serverTime : serverTime // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$ProductSyncBatchDto {

 List<ProductSyncItemDto> get items;
/// Create a copy of ProductSyncBatchDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductSyncBatchDtoCopyWith<ProductSyncBatchDto> get copyWith => _$ProductSyncBatchDtoCopyWithImpl<ProductSyncBatchDto>(this as ProductSyncBatchDto, _$identity);

  /// Serializes this ProductSyncBatchDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductSyncBatchDto&&const DeepCollectionEquality().equals(other.items, items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(items));

@override
String toString() {
  return 'ProductSyncBatchDto(items: $items)';
}


}

/// @nodoc
abstract mixin class $ProductSyncBatchDtoCopyWith<$Res>  {
  factory $ProductSyncBatchDtoCopyWith(ProductSyncBatchDto value, $Res Function(ProductSyncBatchDto) _then) = _$ProductSyncBatchDtoCopyWithImpl;
@useResult
$Res call({
 List<ProductSyncItemDto> items
});




}
/// @nodoc
class _$ProductSyncBatchDtoCopyWithImpl<$Res>
    implements $ProductSyncBatchDtoCopyWith<$Res> {
  _$ProductSyncBatchDtoCopyWithImpl(this._self, this._then);

  final ProductSyncBatchDto _self;
  final $Res Function(ProductSyncBatchDto) _then;

/// Create a copy of ProductSyncBatchDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,}) {
  return _then(_self.copyWith(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<ProductSyncItemDto>,
  ));
}

}


/// Adds pattern-matching-related methods to [ProductSyncBatchDto].
extension ProductSyncBatchDtoPatterns on ProductSyncBatchDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProductSyncBatchDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProductSyncBatchDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProductSyncBatchDto value)  $default,){
final _that = this;
switch (_that) {
case _ProductSyncBatchDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProductSyncBatchDto value)?  $default,){
final _that = this;
switch (_that) {
case _ProductSyncBatchDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<ProductSyncItemDto> items)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProductSyncBatchDto() when $default != null:
return $default(_that.items);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<ProductSyncItemDto> items)  $default,) {final _that = this;
switch (_that) {
case _ProductSyncBatchDto():
return $default(_that.items);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<ProductSyncItemDto> items)?  $default,) {final _that = this;
switch (_that) {
case _ProductSyncBatchDto() when $default != null:
return $default(_that.items);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProductSyncBatchDto implements ProductSyncBatchDto {
  const _ProductSyncBatchDto({required final  List<ProductSyncItemDto> items}): _items = items;
  factory _ProductSyncBatchDto.fromJson(Map<String, dynamic> json) => _$ProductSyncBatchDtoFromJson(json);

 final  List<ProductSyncItemDto> _items;
@override List<ProductSyncItemDto> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of ProductSyncBatchDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductSyncBatchDtoCopyWith<_ProductSyncBatchDto> get copyWith => __$ProductSyncBatchDtoCopyWithImpl<_ProductSyncBatchDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProductSyncBatchDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProductSyncBatchDto&&const DeepCollectionEquality().equals(other._items, _items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items));

@override
String toString() {
  return 'ProductSyncBatchDto(items: $items)';
}


}

/// @nodoc
abstract mixin class _$ProductSyncBatchDtoCopyWith<$Res> implements $ProductSyncBatchDtoCopyWith<$Res> {
  factory _$ProductSyncBatchDtoCopyWith(_ProductSyncBatchDto value, $Res Function(_ProductSyncBatchDto) _then) = __$ProductSyncBatchDtoCopyWithImpl;
@override @useResult
$Res call({
 List<ProductSyncItemDto> items
});




}
/// @nodoc
class __$ProductSyncBatchDtoCopyWithImpl<$Res>
    implements _$ProductSyncBatchDtoCopyWith<$Res> {
  __$ProductSyncBatchDtoCopyWithImpl(this._self, this._then);

  final _ProductSyncBatchDto _self;
  final $Res Function(_ProductSyncBatchDto) _then;

/// Create a copy of ProductSyncBatchDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,}) {
  return _then(_ProductSyncBatchDto(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<ProductSyncItemDto>,
  ));
}


}


/// @nodoc
mixin _$ProductSyncItemDto {

 String get id; String get name; String? get barcode;@JsonKey(name: 'unit_price') String get unitPrice;@JsonKey(name: 'current_stock') int? get currentStock;@JsonKey(name: 'min_stock') int? get minStock;// Toujours envoyé (null = sans catégorie) : l'état local fait foi.
@JsonKey(name: 'category_id') String? get categoryId;@JsonKey(name: 'client_updated_at') String get clientUpdatedAt; bool get deleted;
/// Create a copy of ProductSyncItemDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductSyncItemDtoCopyWith<ProductSyncItemDto> get copyWith => _$ProductSyncItemDtoCopyWithImpl<ProductSyncItemDto>(this as ProductSyncItemDto, _$identity);

  /// Serializes this ProductSyncItemDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductSyncItemDto&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.barcode, barcode) || other.barcode == barcode)&&(identical(other.unitPrice, unitPrice) || other.unitPrice == unitPrice)&&(identical(other.currentStock, currentStock) || other.currentStock == currentStock)&&(identical(other.minStock, minStock) || other.minStock == minStock)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.clientUpdatedAt, clientUpdatedAt) || other.clientUpdatedAt == clientUpdatedAt)&&(identical(other.deleted, deleted) || other.deleted == deleted));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,barcode,unitPrice,currentStock,minStock,categoryId,clientUpdatedAt,deleted);

@override
String toString() {
  return 'ProductSyncItemDto(id: $id, name: $name, barcode: $barcode, unitPrice: $unitPrice, currentStock: $currentStock, minStock: $minStock, categoryId: $categoryId, clientUpdatedAt: $clientUpdatedAt, deleted: $deleted)';
}


}

/// @nodoc
abstract mixin class $ProductSyncItemDtoCopyWith<$Res>  {
  factory $ProductSyncItemDtoCopyWith(ProductSyncItemDto value, $Res Function(ProductSyncItemDto) _then) = _$ProductSyncItemDtoCopyWithImpl;
@useResult
$Res call({
 String id, String name, String? barcode,@JsonKey(name: 'unit_price') String unitPrice,@JsonKey(name: 'current_stock') int? currentStock,@JsonKey(name: 'min_stock') int? minStock,@JsonKey(name: 'category_id') String? categoryId,@JsonKey(name: 'client_updated_at') String clientUpdatedAt, bool deleted
});




}
/// @nodoc
class _$ProductSyncItemDtoCopyWithImpl<$Res>
    implements $ProductSyncItemDtoCopyWith<$Res> {
  _$ProductSyncItemDtoCopyWithImpl(this._self, this._then);

  final ProductSyncItemDto _self;
  final $Res Function(ProductSyncItemDto) _then;

/// Create a copy of ProductSyncItemDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? barcode = freezed,Object? unitPrice = null,Object? currentStock = freezed,Object? minStock = freezed,Object? categoryId = freezed,Object? clientUpdatedAt = null,Object? deleted = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,barcode: freezed == barcode ? _self.barcode : barcode // ignore: cast_nullable_to_non_nullable
as String?,unitPrice: null == unitPrice ? _self.unitPrice : unitPrice // ignore: cast_nullable_to_non_nullable
as String,currentStock: freezed == currentStock ? _self.currentStock : currentStock // ignore: cast_nullable_to_non_nullable
as int?,minStock: freezed == minStock ? _self.minStock : minStock // ignore: cast_nullable_to_non_nullable
as int?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,clientUpdatedAt: null == clientUpdatedAt ? _self.clientUpdatedAt : clientUpdatedAt // ignore: cast_nullable_to_non_nullable
as String,deleted: null == deleted ? _self.deleted : deleted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ProductSyncItemDto].
extension ProductSyncItemDtoPatterns on ProductSyncItemDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProductSyncItemDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProductSyncItemDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProductSyncItemDto value)  $default,){
final _that = this;
switch (_that) {
case _ProductSyncItemDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProductSyncItemDto value)?  $default,){
final _that = this;
switch (_that) {
case _ProductSyncItemDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String? barcode, @JsonKey(name: 'unit_price')  String unitPrice, @JsonKey(name: 'current_stock')  int? currentStock, @JsonKey(name: 'min_stock')  int? minStock, @JsonKey(name: 'category_id')  String? categoryId, @JsonKey(name: 'client_updated_at')  String clientUpdatedAt,  bool deleted)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProductSyncItemDto() when $default != null:
return $default(_that.id,_that.name,_that.barcode,_that.unitPrice,_that.currentStock,_that.minStock,_that.categoryId,_that.clientUpdatedAt,_that.deleted);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String? barcode, @JsonKey(name: 'unit_price')  String unitPrice, @JsonKey(name: 'current_stock')  int? currentStock, @JsonKey(name: 'min_stock')  int? minStock, @JsonKey(name: 'category_id')  String? categoryId, @JsonKey(name: 'client_updated_at')  String clientUpdatedAt,  bool deleted)  $default,) {final _that = this;
switch (_that) {
case _ProductSyncItemDto():
return $default(_that.id,_that.name,_that.barcode,_that.unitPrice,_that.currentStock,_that.minStock,_that.categoryId,_that.clientUpdatedAt,_that.deleted);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String? barcode, @JsonKey(name: 'unit_price')  String unitPrice, @JsonKey(name: 'current_stock')  int? currentStock, @JsonKey(name: 'min_stock')  int? minStock, @JsonKey(name: 'category_id')  String? categoryId, @JsonKey(name: 'client_updated_at')  String clientUpdatedAt,  bool deleted)?  $default,) {final _that = this;
switch (_that) {
case _ProductSyncItemDto() when $default != null:
return $default(_that.id,_that.name,_that.barcode,_that.unitPrice,_that.currentStock,_that.minStock,_that.categoryId,_that.clientUpdatedAt,_that.deleted);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProductSyncItemDto implements ProductSyncItemDto {
  const _ProductSyncItemDto({required this.id, required this.name, this.barcode, @JsonKey(name: 'unit_price') required this.unitPrice, @JsonKey(name: 'current_stock') this.currentStock, @JsonKey(name: 'min_stock') this.minStock, @JsonKey(name: 'category_id') this.categoryId, @JsonKey(name: 'client_updated_at') required this.clientUpdatedAt, this.deleted = false});
  factory _ProductSyncItemDto.fromJson(Map<String, dynamic> json) => _$ProductSyncItemDtoFromJson(json);

@override final  String id;
@override final  String name;
@override final  String? barcode;
@override@JsonKey(name: 'unit_price') final  String unitPrice;
@override@JsonKey(name: 'current_stock') final  int? currentStock;
@override@JsonKey(name: 'min_stock') final  int? minStock;
// Toujours envoyé (null = sans catégorie) : l'état local fait foi.
@override@JsonKey(name: 'category_id') final  String? categoryId;
@override@JsonKey(name: 'client_updated_at') final  String clientUpdatedAt;
@override@JsonKey() final  bool deleted;

/// Create a copy of ProductSyncItemDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductSyncItemDtoCopyWith<_ProductSyncItemDto> get copyWith => __$ProductSyncItemDtoCopyWithImpl<_ProductSyncItemDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProductSyncItemDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProductSyncItemDto&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.barcode, barcode) || other.barcode == barcode)&&(identical(other.unitPrice, unitPrice) || other.unitPrice == unitPrice)&&(identical(other.currentStock, currentStock) || other.currentStock == currentStock)&&(identical(other.minStock, minStock) || other.minStock == minStock)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.clientUpdatedAt, clientUpdatedAt) || other.clientUpdatedAt == clientUpdatedAt)&&(identical(other.deleted, deleted) || other.deleted == deleted));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,barcode,unitPrice,currentStock,minStock,categoryId,clientUpdatedAt,deleted);

@override
String toString() {
  return 'ProductSyncItemDto(id: $id, name: $name, barcode: $barcode, unitPrice: $unitPrice, currentStock: $currentStock, minStock: $minStock, categoryId: $categoryId, clientUpdatedAt: $clientUpdatedAt, deleted: $deleted)';
}


}

/// @nodoc
abstract mixin class _$ProductSyncItemDtoCopyWith<$Res> implements $ProductSyncItemDtoCopyWith<$Res> {
  factory _$ProductSyncItemDtoCopyWith(_ProductSyncItemDto value, $Res Function(_ProductSyncItemDto) _then) = __$ProductSyncItemDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String? barcode,@JsonKey(name: 'unit_price') String unitPrice,@JsonKey(name: 'current_stock') int? currentStock,@JsonKey(name: 'min_stock') int? minStock,@JsonKey(name: 'category_id') String? categoryId,@JsonKey(name: 'client_updated_at') String clientUpdatedAt, bool deleted
});




}
/// @nodoc
class __$ProductSyncItemDtoCopyWithImpl<$Res>
    implements _$ProductSyncItemDtoCopyWith<$Res> {
  __$ProductSyncItemDtoCopyWithImpl(this._self, this._then);

  final _ProductSyncItemDto _self;
  final $Res Function(_ProductSyncItemDto) _then;

/// Create a copy of ProductSyncItemDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? barcode = freezed,Object? unitPrice = null,Object? currentStock = freezed,Object? minStock = freezed,Object? categoryId = freezed,Object? clientUpdatedAt = null,Object? deleted = null,}) {
  return _then(_ProductSyncItemDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,barcode: freezed == barcode ? _self.barcode : barcode // ignore: cast_nullable_to_non_nullable
as String?,unitPrice: null == unitPrice ? _self.unitPrice : unitPrice // ignore: cast_nullable_to_non_nullable
as String,currentStock: freezed == currentStock ? _self.currentStock : currentStock // ignore: cast_nullable_to_non_nullable
as int?,minStock: freezed == minStock ? _self.minStock : minStock // ignore: cast_nullable_to_non_nullable
as int?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,clientUpdatedAt: null == clientUpdatedAt ? _self.clientUpdatedAt : clientUpdatedAt // ignore: cast_nullable_to_non_nullable
as String,deleted: null == deleted ? _self.deleted : deleted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$SyncResponseDto {

 String get message;@JsonKey(name: 'synced_count') int get syncedCount;
/// Create a copy of SyncResponseDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SyncResponseDtoCopyWith<SyncResponseDto> get copyWith => _$SyncResponseDtoCopyWithImpl<SyncResponseDto>(this as SyncResponseDto, _$identity);

  /// Serializes this SyncResponseDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SyncResponseDto&&(identical(other.message, message) || other.message == message)&&(identical(other.syncedCount, syncedCount) || other.syncedCount == syncedCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,message,syncedCount);

@override
String toString() {
  return 'SyncResponseDto(message: $message, syncedCount: $syncedCount)';
}


}

/// @nodoc
abstract mixin class $SyncResponseDtoCopyWith<$Res>  {
  factory $SyncResponseDtoCopyWith(SyncResponseDto value, $Res Function(SyncResponseDto) _then) = _$SyncResponseDtoCopyWithImpl;
@useResult
$Res call({
 String message,@JsonKey(name: 'synced_count') int syncedCount
});




}
/// @nodoc
class _$SyncResponseDtoCopyWithImpl<$Res>
    implements $SyncResponseDtoCopyWith<$Res> {
  _$SyncResponseDtoCopyWithImpl(this._self, this._then);

  final SyncResponseDto _self;
  final $Res Function(SyncResponseDto) _then;

/// Create a copy of SyncResponseDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? message = null,Object? syncedCount = null,}) {
  return _then(_self.copyWith(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,syncedCount: null == syncedCount ? _self.syncedCount : syncedCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [SyncResponseDto].
extension SyncResponseDtoPatterns on SyncResponseDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SyncResponseDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SyncResponseDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SyncResponseDto value)  $default,){
final _that = this;
switch (_that) {
case _SyncResponseDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SyncResponseDto value)?  $default,){
final _that = this;
switch (_that) {
case _SyncResponseDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String message, @JsonKey(name: 'synced_count')  int syncedCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SyncResponseDto() when $default != null:
return $default(_that.message,_that.syncedCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String message, @JsonKey(name: 'synced_count')  int syncedCount)  $default,) {final _that = this;
switch (_that) {
case _SyncResponseDto():
return $default(_that.message,_that.syncedCount);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String message, @JsonKey(name: 'synced_count')  int syncedCount)?  $default,) {final _that = this;
switch (_that) {
case _SyncResponseDto() when $default != null:
return $default(_that.message,_that.syncedCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SyncResponseDto implements SyncResponseDto {
  const _SyncResponseDto({required this.message, @JsonKey(name: 'synced_count') required this.syncedCount});
  factory _SyncResponseDto.fromJson(Map<String, dynamic> json) => _$SyncResponseDtoFromJson(json);

@override final  String message;
@override@JsonKey(name: 'synced_count') final  int syncedCount;

/// Create a copy of SyncResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SyncResponseDtoCopyWith<_SyncResponseDto> get copyWith => __$SyncResponseDtoCopyWithImpl<_SyncResponseDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SyncResponseDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SyncResponseDto&&(identical(other.message, message) || other.message == message)&&(identical(other.syncedCount, syncedCount) || other.syncedCount == syncedCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,message,syncedCount);

@override
String toString() {
  return 'SyncResponseDto(message: $message, syncedCount: $syncedCount)';
}


}

/// @nodoc
abstract mixin class _$SyncResponseDtoCopyWith<$Res> implements $SyncResponseDtoCopyWith<$Res> {
  factory _$SyncResponseDtoCopyWith(_SyncResponseDto value, $Res Function(_SyncResponseDto) _then) = __$SyncResponseDtoCopyWithImpl;
@override @useResult
$Res call({
 String message,@JsonKey(name: 'synced_count') int syncedCount
});




}
/// @nodoc
class __$SyncResponseDtoCopyWithImpl<$Res>
    implements _$SyncResponseDtoCopyWith<$Res> {
  __$SyncResponseDtoCopyWithImpl(this._self, this._then);

  final _SyncResponseDto _self;
  final $Res Function(_SyncResponseDto) _then;

/// Create a copy of SyncResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? syncedCount = null,}) {
  return _then(_SyncResponseDto(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,syncedCount: null == syncedCount ? _self.syncedCount : syncedCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
