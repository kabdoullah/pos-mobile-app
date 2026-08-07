// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_bulk_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProductBulkItemResultDto {

 int get index; ProductBulkItemStatusDto get status; ProductDto? get product; String? get error; String? get field;
/// Create a copy of ProductBulkItemResultDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductBulkItemResultDtoCopyWith<ProductBulkItemResultDto> get copyWith => _$ProductBulkItemResultDtoCopyWithImpl<ProductBulkItemResultDto>(this as ProductBulkItemResultDto, _$identity);

  /// Serializes this ProductBulkItemResultDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductBulkItemResultDto&&(identical(other.index, index) || other.index == index)&&(identical(other.status, status) || other.status == status)&&(identical(other.product, product) || other.product == product)&&(identical(other.error, error) || other.error == error)&&(identical(other.field, field) || other.field == field));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,index,status,product,error,field);

@override
String toString() {
  return 'ProductBulkItemResultDto(index: $index, status: $status, product: $product, error: $error, field: $field)';
}


}

/// @nodoc
abstract mixin class $ProductBulkItemResultDtoCopyWith<$Res>  {
  factory $ProductBulkItemResultDtoCopyWith(ProductBulkItemResultDto value, $Res Function(ProductBulkItemResultDto) _then) = _$ProductBulkItemResultDtoCopyWithImpl;
@useResult
$Res call({
 int index, ProductBulkItemStatusDto status, ProductDto? product, String? error, String? field
});


$ProductDtoCopyWith<$Res>? get product;

}
/// @nodoc
class _$ProductBulkItemResultDtoCopyWithImpl<$Res>
    implements $ProductBulkItemResultDtoCopyWith<$Res> {
  _$ProductBulkItemResultDtoCopyWithImpl(this._self, this._then);

  final ProductBulkItemResultDto _self;
  final $Res Function(ProductBulkItemResultDto) _then;

/// Create a copy of ProductBulkItemResultDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? index = null,Object? status = null,Object? product = freezed,Object? error = freezed,Object? field = freezed,}) {
  return _then(_self.copyWith(
index: null == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ProductBulkItemStatusDto,product: freezed == product ? _self.product : product // ignore: cast_nullable_to_non_nullable
as ProductDto?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,field: freezed == field ? _self.field : field // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of ProductBulkItemResultDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProductDtoCopyWith<$Res>? get product {
    if (_self.product == null) {
    return null;
  }

  return $ProductDtoCopyWith<$Res>(_self.product!, (value) {
    return _then(_self.copyWith(product: value));
  });
}
}


/// Adds pattern-matching-related methods to [ProductBulkItemResultDto].
extension ProductBulkItemResultDtoPatterns on ProductBulkItemResultDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProductBulkItemResultDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProductBulkItemResultDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProductBulkItemResultDto value)  $default,){
final _that = this;
switch (_that) {
case _ProductBulkItemResultDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProductBulkItemResultDto value)?  $default,){
final _that = this;
switch (_that) {
case _ProductBulkItemResultDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int index,  ProductBulkItemStatusDto status,  ProductDto? product,  String? error,  String? field)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProductBulkItemResultDto() when $default != null:
return $default(_that.index,_that.status,_that.product,_that.error,_that.field);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int index,  ProductBulkItemStatusDto status,  ProductDto? product,  String? error,  String? field)  $default,) {final _that = this;
switch (_that) {
case _ProductBulkItemResultDto():
return $default(_that.index,_that.status,_that.product,_that.error,_that.field);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int index,  ProductBulkItemStatusDto status,  ProductDto? product,  String? error,  String? field)?  $default,) {final _that = this;
switch (_that) {
case _ProductBulkItemResultDto() when $default != null:
return $default(_that.index,_that.status,_that.product,_that.error,_that.field);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProductBulkItemResultDto implements ProductBulkItemResultDto {
  const _ProductBulkItemResultDto({required this.index, required this.status, this.product, this.error, this.field});
  factory _ProductBulkItemResultDto.fromJson(Map<String, dynamic> json) => _$ProductBulkItemResultDtoFromJson(json);

@override final  int index;
@override final  ProductBulkItemStatusDto status;
@override final  ProductDto? product;
@override final  String? error;
@override final  String? field;

/// Create a copy of ProductBulkItemResultDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductBulkItemResultDtoCopyWith<_ProductBulkItemResultDto> get copyWith => __$ProductBulkItemResultDtoCopyWithImpl<_ProductBulkItemResultDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProductBulkItemResultDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProductBulkItemResultDto&&(identical(other.index, index) || other.index == index)&&(identical(other.status, status) || other.status == status)&&(identical(other.product, product) || other.product == product)&&(identical(other.error, error) || other.error == error)&&(identical(other.field, field) || other.field == field));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,index,status,product,error,field);

@override
String toString() {
  return 'ProductBulkItemResultDto(index: $index, status: $status, product: $product, error: $error, field: $field)';
}


}

/// @nodoc
abstract mixin class _$ProductBulkItemResultDtoCopyWith<$Res> implements $ProductBulkItemResultDtoCopyWith<$Res> {
  factory _$ProductBulkItemResultDtoCopyWith(_ProductBulkItemResultDto value, $Res Function(_ProductBulkItemResultDto) _then) = __$ProductBulkItemResultDtoCopyWithImpl;
@override @useResult
$Res call({
 int index, ProductBulkItemStatusDto status, ProductDto? product, String? error, String? field
});


@override $ProductDtoCopyWith<$Res>? get product;

}
/// @nodoc
class __$ProductBulkItemResultDtoCopyWithImpl<$Res>
    implements _$ProductBulkItemResultDtoCopyWith<$Res> {
  __$ProductBulkItemResultDtoCopyWithImpl(this._self, this._then);

  final _ProductBulkItemResultDto _self;
  final $Res Function(_ProductBulkItemResultDto) _then;

/// Create a copy of ProductBulkItemResultDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? index = null,Object? status = null,Object? product = freezed,Object? error = freezed,Object? field = freezed,}) {
  return _then(_ProductBulkItemResultDto(
index: null == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ProductBulkItemStatusDto,product: freezed == product ? _self.product : product // ignore: cast_nullable_to_non_nullable
as ProductDto?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,field: freezed == field ? _self.field : field // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of ProductBulkItemResultDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProductDtoCopyWith<$Res>? get product {
    if (_self.product == null) {
    return null;
  }

  return $ProductDtoCopyWith<$Res>(_self.product!, (value) {
    return _then(_self.copyWith(product: value));
  });
}
}


/// @nodoc
mixin _$ProductBulkCreateResponseDto {

 int get processed;@JsonKey(name: 'created_count') int get createdCount;@JsonKey(name: 'failed_count') int get failedCount; List<ProductBulkItemResultDto> get results;
/// Create a copy of ProductBulkCreateResponseDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductBulkCreateResponseDtoCopyWith<ProductBulkCreateResponseDto> get copyWith => _$ProductBulkCreateResponseDtoCopyWithImpl<ProductBulkCreateResponseDto>(this as ProductBulkCreateResponseDto, _$identity);

  /// Serializes this ProductBulkCreateResponseDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductBulkCreateResponseDto&&(identical(other.processed, processed) || other.processed == processed)&&(identical(other.createdCount, createdCount) || other.createdCount == createdCount)&&(identical(other.failedCount, failedCount) || other.failedCount == failedCount)&&const DeepCollectionEquality().equals(other.results, results));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,processed,createdCount,failedCount,const DeepCollectionEquality().hash(results));

@override
String toString() {
  return 'ProductBulkCreateResponseDto(processed: $processed, createdCount: $createdCount, failedCount: $failedCount, results: $results)';
}


}

/// @nodoc
abstract mixin class $ProductBulkCreateResponseDtoCopyWith<$Res>  {
  factory $ProductBulkCreateResponseDtoCopyWith(ProductBulkCreateResponseDto value, $Res Function(ProductBulkCreateResponseDto) _then) = _$ProductBulkCreateResponseDtoCopyWithImpl;
@useResult
$Res call({
 int processed,@JsonKey(name: 'created_count') int createdCount,@JsonKey(name: 'failed_count') int failedCount, List<ProductBulkItemResultDto> results
});




}
/// @nodoc
class _$ProductBulkCreateResponseDtoCopyWithImpl<$Res>
    implements $ProductBulkCreateResponseDtoCopyWith<$Res> {
  _$ProductBulkCreateResponseDtoCopyWithImpl(this._self, this._then);

  final ProductBulkCreateResponseDto _self;
  final $Res Function(ProductBulkCreateResponseDto) _then;

/// Create a copy of ProductBulkCreateResponseDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? processed = null,Object? createdCount = null,Object? failedCount = null,Object? results = null,}) {
  return _then(_self.copyWith(
processed: null == processed ? _self.processed : processed // ignore: cast_nullable_to_non_nullable
as int,createdCount: null == createdCount ? _self.createdCount : createdCount // ignore: cast_nullable_to_non_nullable
as int,failedCount: null == failedCount ? _self.failedCount : failedCount // ignore: cast_nullable_to_non_nullable
as int,results: null == results ? _self.results : results // ignore: cast_nullable_to_non_nullable
as List<ProductBulkItemResultDto>,
  ));
}

}


/// Adds pattern-matching-related methods to [ProductBulkCreateResponseDto].
extension ProductBulkCreateResponseDtoPatterns on ProductBulkCreateResponseDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProductBulkCreateResponseDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProductBulkCreateResponseDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProductBulkCreateResponseDto value)  $default,){
final _that = this;
switch (_that) {
case _ProductBulkCreateResponseDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProductBulkCreateResponseDto value)?  $default,){
final _that = this;
switch (_that) {
case _ProductBulkCreateResponseDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int processed, @JsonKey(name: 'created_count')  int createdCount, @JsonKey(name: 'failed_count')  int failedCount,  List<ProductBulkItemResultDto> results)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProductBulkCreateResponseDto() when $default != null:
return $default(_that.processed,_that.createdCount,_that.failedCount,_that.results);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int processed, @JsonKey(name: 'created_count')  int createdCount, @JsonKey(name: 'failed_count')  int failedCount,  List<ProductBulkItemResultDto> results)  $default,) {final _that = this;
switch (_that) {
case _ProductBulkCreateResponseDto():
return $default(_that.processed,_that.createdCount,_that.failedCount,_that.results);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int processed, @JsonKey(name: 'created_count')  int createdCount, @JsonKey(name: 'failed_count')  int failedCount,  List<ProductBulkItemResultDto> results)?  $default,) {final _that = this;
switch (_that) {
case _ProductBulkCreateResponseDto() when $default != null:
return $default(_that.processed,_that.createdCount,_that.failedCount,_that.results);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProductBulkCreateResponseDto implements ProductBulkCreateResponseDto {
  const _ProductBulkCreateResponseDto({required this.processed, @JsonKey(name: 'created_count') required this.createdCount, @JsonKey(name: 'failed_count') required this.failedCount, required final  List<ProductBulkItemResultDto> results}): _results = results;
  factory _ProductBulkCreateResponseDto.fromJson(Map<String, dynamic> json) => _$ProductBulkCreateResponseDtoFromJson(json);

@override final  int processed;
@override@JsonKey(name: 'created_count') final  int createdCount;
@override@JsonKey(name: 'failed_count') final  int failedCount;
 final  List<ProductBulkItemResultDto> _results;
@override List<ProductBulkItemResultDto> get results {
  if (_results is EqualUnmodifiableListView) return _results;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_results);
}


/// Create a copy of ProductBulkCreateResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductBulkCreateResponseDtoCopyWith<_ProductBulkCreateResponseDto> get copyWith => __$ProductBulkCreateResponseDtoCopyWithImpl<_ProductBulkCreateResponseDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProductBulkCreateResponseDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProductBulkCreateResponseDto&&(identical(other.processed, processed) || other.processed == processed)&&(identical(other.createdCount, createdCount) || other.createdCount == createdCount)&&(identical(other.failedCount, failedCount) || other.failedCount == failedCount)&&const DeepCollectionEquality().equals(other._results, _results));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,processed,createdCount,failedCount,const DeepCollectionEquality().hash(_results));

@override
String toString() {
  return 'ProductBulkCreateResponseDto(processed: $processed, createdCount: $createdCount, failedCount: $failedCount, results: $results)';
}


}

/// @nodoc
abstract mixin class _$ProductBulkCreateResponseDtoCopyWith<$Res> implements $ProductBulkCreateResponseDtoCopyWith<$Res> {
  factory _$ProductBulkCreateResponseDtoCopyWith(_ProductBulkCreateResponseDto value, $Res Function(_ProductBulkCreateResponseDto) _then) = __$ProductBulkCreateResponseDtoCopyWithImpl;
@override @useResult
$Res call({
 int processed,@JsonKey(name: 'created_count') int createdCount,@JsonKey(name: 'failed_count') int failedCount, List<ProductBulkItemResultDto> results
});




}
/// @nodoc
class __$ProductBulkCreateResponseDtoCopyWithImpl<$Res>
    implements _$ProductBulkCreateResponseDtoCopyWith<$Res> {
  __$ProductBulkCreateResponseDtoCopyWithImpl(this._self, this._then);

  final _ProductBulkCreateResponseDto _self;
  final $Res Function(_ProductBulkCreateResponseDto) _then;

/// Create a copy of ProductBulkCreateResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? processed = null,Object? createdCount = null,Object? failedCount = null,Object? results = null,}) {
  return _then(_ProductBulkCreateResponseDto(
processed: null == processed ? _self.processed : processed // ignore: cast_nullable_to_non_nullable
as int,createdCount: null == createdCount ? _self.createdCount : createdCount // ignore: cast_nullable_to_non_nullable
as int,failedCount: null == failedCount ? _self.failedCount : failedCount // ignore: cast_nullable_to_non_nullable
as int,results: null == results ? _self._results : results // ignore: cast_nullable_to_non_nullable
as List<ProductBulkItemResultDto>,
  ));
}


}

// dart format on
