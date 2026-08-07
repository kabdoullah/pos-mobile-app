// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sync_responses_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SalesSyncBatchRequestDto {

 List<SaleCreateDto> get sales;
/// Create a copy of SalesSyncBatchRequestDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SalesSyncBatchRequestDtoCopyWith<SalesSyncBatchRequestDto> get copyWith => _$SalesSyncBatchRequestDtoCopyWithImpl<SalesSyncBatchRequestDto>(this as SalesSyncBatchRequestDto, _$identity);

  /// Serializes this SalesSyncBatchRequestDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SalesSyncBatchRequestDto&&const DeepCollectionEquality().equals(other.sales, sales));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(sales));

@override
String toString() {
  return 'SalesSyncBatchRequestDto(sales: $sales)';
}


}

/// @nodoc
abstract mixin class $SalesSyncBatchRequestDtoCopyWith<$Res>  {
  factory $SalesSyncBatchRequestDtoCopyWith(SalesSyncBatchRequestDto value, $Res Function(SalesSyncBatchRequestDto) _then) = _$SalesSyncBatchRequestDtoCopyWithImpl;
@useResult
$Res call({
 List<SaleCreateDto> sales
});




}
/// @nodoc
class _$SalesSyncBatchRequestDtoCopyWithImpl<$Res>
    implements $SalesSyncBatchRequestDtoCopyWith<$Res> {
  _$SalesSyncBatchRequestDtoCopyWithImpl(this._self, this._then);

  final SalesSyncBatchRequestDto _self;
  final $Res Function(SalesSyncBatchRequestDto) _then;

/// Create a copy of SalesSyncBatchRequestDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sales = null,}) {
  return _then(_self.copyWith(
sales: null == sales ? _self.sales : sales // ignore: cast_nullable_to_non_nullable
as List<SaleCreateDto>,
  ));
}

}


/// Adds pattern-matching-related methods to [SalesSyncBatchRequestDto].
extension SalesSyncBatchRequestDtoPatterns on SalesSyncBatchRequestDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SalesSyncBatchRequestDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SalesSyncBatchRequestDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SalesSyncBatchRequestDto value)  $default,){
final _that = this;
switch (_that) {
case _SalesSyncBatchRequestDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SalesSyncBatchRequestDto value)?  $default,){
final _that = this;
switch (_that) {
case _SalesSyncBatchRequestDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<SaleCreateDto> sales)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SalesSyncBatchRequestDto() when $default != null:
return $default(_that.sales);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<SaleCreateDto> sales)  $default,) {final _that = this;
switch (_that) {
case _SalesSyncBatchRequestDto():
return $default(_that.sales);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<SaleCreateDto> sales)?  $default,) {final _that = this;
switch (_that) {
case _SalesSyncBatchRequestDto() when $default != null:
return $default(_that.sales);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SalesSyncBatchRequestDto implements SalesSyncBatchRequestDto {
  const _SalesSyncBatchRequestDto({required final  List<SaleCreateDto> sales}): _sales = sales;
  factory _SalesSyncBatchRequestDto.fromJson(Map<String, dynamic> json) => _$SalesSyncBatchRequestDtoFromJson(json);

 final  List<SaleCreateDto> _sales;
@override List<SaleCreateDto> get sales {
  if (_sales is EqualUnmodifiableListView) return _sales;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sales);
}


/// Create a copy of SalesSyncBatchRequestDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SalesSyncBatchRequestDtoCopyWith<_SalesSyncBatchRequestDto> get copyWith => __$SalesSyncBatchRequestDtoCopyWithImpl<_SalesSyncBatchRequestDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SalesSyncBatchRequestDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SalesSyncBatchRequestDto&&const DeepCollectionEquality().equals(other._sales, _sales));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_sales));

@override
String toString() {
  return 'SalesSyncBatchRequestDto(sales: $sales)';
}


}

/// @nodoc
abstract mixin class _$SalesSyncBatchRequestDtoCopyWith<$Res> implements $SalesSyncBatchRequestDtoCopyWith<$Res> {
  factory _$SalesSyncBatchRequestDtoCopyWith(_SalesSyncBatchRequestDto value, $Res Function(_SalesSyncBatchRequestDto) _then) = __$SalesSyncBatchRequestDtoCopyWithImpl;
@override @useResult
$Res call({
 List<SaleCreateDto> sales
});




}
/// @nodoc
class __$SalesSyncBatchRequestDtoCopyWithImpl<$Res>
    implements _$SalesSyncBatchRequestDtoCopyWith<$Res> {
  __$SalesSyncBatchRequestDtoCopyWithImpl(this._self, this._then);

  final _SalesSyncBatchRequestDto _self;
  final $Res Function(_SalesSyncBatchRequestDto) _then;

/// Create a copy of SalesSyncBatchRequestDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sales = null,}) {
  return _then(_SalesSyncBatchRequestDto(
sales: null == sales ? _self._sales : sales // ignore: cast_nullable_to_non_nullable
as List<SaleCreateDto>,
  ));
}


}


/// @nodoc
mixin _$SaleSyncResultDto {

 String get id; String get status;// 'created', 'already_exists', 'failed'
@JsonKey(name: 'receipt_number') int? get receiptNumber; String? get error;
/// Create a copy of SaleSyncResultDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SaleSyncResultDtoCopyWith<SaleSyncResultDto> get copyWith => _$SaleSyncResultDtoCopyWithImpl<SaleSyncResultDto>(this as SaleSyncResultDto, _$identity);

  /// Serializes this SaleSyncResultDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SaleSyncResultDto&&(identical(other.id, id) || other.id == id)&&(identical(other.status, status) || other.status == status)&&(identical(other.receiptNumber, receiptNumber) || other.receiptNumber == receiptNumber)&&(identical(other.error, error) || other.error == error));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,status,receiptNumber,error);

@override
String toString() {
  return 'SaleSyncResultDto(id: $id, status: $status, receiptNumber: $receiptNumber, error: $error)';
}


}

/// @nodoc
abstract mixin class $SaleSyncResultDtoCopyWith<$Res>  {
  factory $SaleSyncResultDtoCopyWith(SaleSyncResultDto value, $Res Function(SaleSyncResultDto) _then) = _$SaleSyncResultDtoCopyWithImpl;
@useResult
$Res call({
 String id, String status,@JsonKey(name: 'receipt_number') int? receiptNumber, String? error
});




}
/// @nodoc
class _$SaleSyncResultDtoCopyWithImpl<$Res>
    implements $SaleSyncResultDtoCopyWith<$Res> {
  _$SaleSyncResultDtoCopyWithImpl(this._self, this._then);

  final SaleSyncResultDto _self;
  final $Res Function(SaleSyncResultDto) _then;

/// Create a copy of SaleSyncResultDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? status = null,Object? receiptNumber = freezed,Object? error = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,receiptNumber: freezed == receiptNumber ? _self.receiptNumber : receiptNumber // ignore: cast_nullable_to_non_nullable
as int?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [SaleSyncResultDto].
extension SaleSyncResultDtoPatterns on SaleSyncResultDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SaleSyncResultDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SaleSyncResultDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SaleSyncResultDto value)  $default,){
final _that = this;
switch (_that) {
case _SaleSyncResultDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SaleSyncResultDto value)?  $default,){
final _that = this;
switch (_that) {
case _SaleSyncResultDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String status, @JsonKey(name: 'receipt_number')  int? receiptNumber,  String? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SaleSyncResultDto() when $default != null:
return $default(_that.id,_that.status,_that.receiptNumber,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String status, @JsonKey(name: 'receipt_number')  int? receiptNumber,  String? error)  $default,) {final _that = this;
switch (_that) {
case _SaleSyncResultDto():
return $default(_that.id,_that.status,_that.receiptNumber,_that.error);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String status, @JsonKey(name: 'receipt_number')  int? receiptNumber,  String? error)?  $default,) {final _that = this;
switch (_that) {
case _SaleSyncResultDto() when $default != null:
return $default(_that.id,_that.status,_that.receiptNumber,_that.error);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SaleSyncResultDto implements SaleSyncResultDto {
  const _SaleSyncResultDto({required this.id, required this.status, @JsonKey(name: 'receipt_number') this.receiptNumber, this.error});
  factory _SaleSyncResultDto.fromJson(Map<String, dynamic> json) => _$SaleSyncResultDtoFromJson(json);

@override final  String id;
@override final  String status;
// 'created', 'already_exists', 'failed'
@override@JsonKey(name: 'receipt_number') final  int? receiptNumber;
@override final  String? error;

/// Create a copy of SaleSyncResultDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SaleSyncResultDtoCopyWith<_SaleSyncResultDto> get copyWith => __$SaleSyncResultDtoCopyWithImpl<_SaleSyncResultDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SaleSyncResultDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SaleSyncResultDto&&(identical(other.id, id) || other.id == id)&&(identical(other.status, status) || other.status == status)&&(identical(other.receiptNumber, receiptNumber) || other.receiptNumber == receiptNumber)&&(identical(other.error, error) || other.error == error));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,status,receiptNumber,error);

@override
String toString() {
  return 'SaleSyncResultDto(id: $id, status: $status, receiptNumber: $receiptNumber, error: $error)';
}


}

/// @nodoc
abstract mixin class _$SaleSyncResultDtoCopyWith<$Res> implements $SaleSyncResultDtoCopyWith<$Res> {
  factory _$SaleSyncResultDtoCopyWith(_SaleSyncResultDto value, $Res Function(_SaleSyncResultDto) _then) = __$SaleSyncResultDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, String status,@JsonKey(name: 'receipt_number') int? receiptNumber, String? error
});




}
/// @nodoc
class __$SaleSyncResultDtoCopyWithImpl<$Res>
    implements _$SaleSyncResultDtoCopyWith<$Res> {
  __$SaleSyncResultDtoCopyWithImpl(this._self, this._then);

  final _SaleSyncResultDto _self;
  final $Res Function(_SaleSyncResultDto) _then;

/// Create a copy of SaleSyncResultDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? status = null,Object? receiptNumber = freezed,Object? error = freezed,}) {
  return _then(_SaleSyncResultDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,receiptNumber: freezed == receiptNumber ? _self.receiptNumber : receiptNumber // ignore: cast_nullable_to_non_nullable
as int?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$SalesSyncBatchResponseDto {

 int get processed; List<SaleSyncResultDto> get results;
/// Create a copy of SalesSyncBatchResponseDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SalesSyncBatchResponseDtoCopyWith<SalesSyncBatchResponseDto> get copyWith => _$SalesSyncBatchResponseDtoCopyWithImpl<SalesSyncBatchResponseDto>(this as SalesSyncBatchResponseDto, _$identity);

  /// Serializes this SalesSyncBatchResponseDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SalesSyncBatchResponseDto&&(identical(other.processed, processed) || other.processed == processed)&&const DeepCollectionEquality().equals(other.results, results));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,processed,const DeepCollectionEquality().hash(results));

@override
String toString() {
  return 'SalesSyncBatchResponseDto(processed: $processed, results: $results)';
}


}

/// @nodoc
abstract mixin class $SalesSyncBatchResponseDtoCopyWith<$Res>  {
  factory $SalesSyncBatchResponseDtoCopyWith(SalesSyncBatchResponseDto value, $Res Function(SalesSyncBatchResponseDto) _then) = _$SalesSyncBatchResponseDtoCopyWithImpl;
@useResult
$Res call({
 int processed, List<SaleSyncResultDto> results
});




}
/// @nodoc
class _$SalesSyncBatchResponseDtoCopyWithImpl<$Res>
    implements $SalesSyncBatchResponseDtoCopyWith<$Res> {
  _$SalesSyncBatchResponseDtoCopyWithImpl(this._self, this._then);

  final SalesSyncBatchResponseDto _self;
  final $Res Function(SalesSyncBatchResponseDto) _then;

/// Create a copy of SalesSyncBatchResponseDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? processed = null,Object? results = null,}) {
  return _then(_self.copyWith(
processed: null == processed ? _self.processed : processed // ignore: cast_nullable_to_non_nullable
as int,results: null == results ? _self.results : results // ignore: cast_nullable_to_non_nullable
as List<SaleSyncResultDto>,
  ));
}

}


/// Adds pattern-matching-related methods to [SalesSyncBatchResponseDto].
extension SalesSyncBatchResponseDtoPatterns on SalesSyncBatchResponseDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SalesSyncBatchResponseDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SalesSyncBatchResponseDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SalesSyncBatchResponseDto value)  $default,){
final _that = this;
switch (_that) {
case _SalesSyncBatchResponseDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SalesSyncBatchResponseDto value)?  $default,){
final _that = this;
switch (_that) {
case _SalesSyncBatchResponseDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int processed,  List<SaleSyncResultDto> results)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SalesSyncBatchResponseDto() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int processed,  List<SaleSyncResultDto> results)  $default,) {final _that = this;
switch (_that) {
case _SalesSyncBatchResponseDto():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int processed,  List<SaleSyncResultDto> results)?  $default,) {final _that = this;
switch (_that) {
case _SalesSyncBatchResponseDto() when $default != null:
return $default(_that.processed,_that.results);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SalesSyncBatchResponseDto implements SalesSyncBatchResponseDto {
  const _SalesSyncBatchResponseDto({required this.processed, required final  List<SaleSyncResultDto> results}): _results = results;
  factory _SalesSyncBatchResponseDto.fromJson(Map<String, dynamic> json) => _$SalesSyncBatchResponseDtoFromJson(json);

@override final  int processed;
 final  List<SaleSyncResultDto> _results;
@override List<SaleSyncResultDto> get results {
  if (_results is EqualUnmodifiableListView) return _results;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_results);
}


/// Create a copy of SalesSyncBatchResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SalesSyncBatchResponseDtoCopyWith<_SalesSyncBatchResponseDto> get copyWith => __$SalesSyncBatchResponseDtoCopyWithImpl<_SalesSyncBatchResponseDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SalesSyncBatchResponseDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SalesSyncBatchResponseDto&&(identical(other.processed, processed) || other.processed == processed)&&const DeepCollectionEquality().equals(other._results, _results));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,processed,const DeepCollectionEquality().hash(_results));

@override
String toString() {
  return 'SalesSyncBatchResponseDto(processed: $processed, results: $results)';
}


}

/// @nodoc
abstract mixin class _$SalesSyncBatchResponseDtoCopyWith<$Res> implements $SalesSyncBatchResponseDtoCopyWith<$Res> {
  factory _$SalesSyncBatchResponseDtoCopyWith(_SalesSyncBatchResponseDto value, $Res Function(_SalesSyncBatchResponseDto) _then) = __$SalesSyncBatchResponseDtoCopyWithImpl;
@override @useResult
$Res call({
 int processed, List<SaleSyncResultDto> results
});




}
/// @nodoc
class __$SalesSyncBatchResponseDtoCopyWithImpl<$Res>
    implements _$SalesSyncBatchResponseDtoCopyWith<$Res> {
  __$SalesSyncBatchResponseDtoCopyWithImpl(this._self, this._then);

  final _SalesSyncBatchResponseDto _self;
  final $Res Function(_SalesSyncBatchResponseDto) _then;

/// Create a copy of SalesSyncBatchResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? processed = null,Object? results = null,}) {
  return _then(_SalesSyncBatchResponseDto(
processed: null == processed ? _self.processed : processed // ignore: cast_nullable_to_non_nullable
as int,results: null == results ? _self._results : results // ignore: cast_nullable_to_non_nullable
as List<SaleSyncResultDto>,
  ));
}


}


/// @nodoc
mixin _$ProductSyncResponseDto {

 String get status;// 'created', 'updated', 'no_change', 'deleted', 'conflict'
@JsonKey(name: 'server_state') ProductDto? get serverState;
/// Create a copy of ProductSyncResponseDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductSyncResponseDtoCopyWith<ProductSyncResponseDto> get copyWith => _$ProductSyncResponseDtoCopyWithImpl<ProductSyncResponseDto>(this as ProductSyncResponseDto, _$identity);

  /// Serializes this ProductSyncResponseDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductSyncResponseDto&&(identical(other.status, status) || other.status == status)&&(identical(other.serverState, serverState) || other.serverState == serverState));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,serverState);

@override
String toString() {
  return 'ProductSyncResponseDto(status: $status, serverState: $serverState)';
}


}

/// @nodoc
abstract mixin class $ProductSyncResponseDtoCopyWith<$Res>  {
  factory $ProductSyncResponseDtoCopyWith(ProductSyncResponseDto value, $Res Function(ProductSyncResponseDto) _then) = _$ProductSyncResponseDtoCopyWithImpl;
@useResult
$Res call({
 String status,@JsonKey(name: 'server_state') ProductDto? serverState
});


$ProductDtoCopyWith<$Res>? get serverState;

}
/// @nodoc
class _$ProductSyncResponseDtoCopyWithImpl<$Res>
    implements $ProductSyncResponseDtoCopyWith<$Res> {
  _$ProductSyncResponseDtoCopyWithImpl(this._self, this._then);

  final ProductSyncResponseDto _self;
  final $Res Function(ProductSyncResponseDto) _then;

/// Create a copy of ProductSyncResponseDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? serverState = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,serverState: freezed == serverState ? _self.serverState : serverState // ignore: cast_nullable_to_non_nullable
as ProductDto?,
  ));
}
/// Create a copy of ProductSyncResponseDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProductDtoCopyWith<$Res>? get serverState {
    if (_self.serverState == null) {
    return null;
  }

  return $ProductDtoCopyWith<$Res>(_self.serverState!, (value) {
    return _then(_self.copyWith(serverState: value));
  });
}
}


/// Adds pattern-matching-related methods to [ProductSyncResponseDto].
extension ProductSyncResponseDtoPatterns on ProductSyncResponseDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProductSyncResponseDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProductSyncResponseDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProductSyncResponseDto value)  $default,){
final _that = this;
switch (_that) {
case _ProductSyncResponseDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProductSyncResponseDto value)?  $default,){
final _that = this;
switch (_that) {
case _ProductSyncResponseDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String status, @JsonKey(name: 'server_state')  ProductDto? serverState)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProductSyncResponseDto() when $default != null:
return $default(_that.status,_that.serverState);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String status, @JsonKey(name: 'server_state')  ProductDto? serverState)  $default,) {final _that = this;
switch (_that) {
case _ProductSyncResponseDto():
return $default(_that.status,_that.serverState);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String status, @JsonKey(name: 'server_state')  ProductDto? serverState)?  $default,) {final _that = this;
switch (_that) {
case _ProductSyncResponseDto() when $default != null:
return $default(_that.status,_that.serverState);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProductSyncResponseDto implements ProductSyncResponseDto {
  const _ProductSyncResponseDto({required this.status, @JsonKey(name: 'server_state') this.serverState});
  factory _ProductSyncResponseDto.fromJson(Map<String, dynamic> json) => _$ProductSyncResponseDtoFromJson(json);

@override final  String status;
// 'created', 'updated', 'no_change', 'deleted', 'conflict'
@override@JsonKey(name: 'server_state') final  ProductDto? serverState;

/// Create a copy of ProductSyncResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductSyncResponseDtoCopyWith<_ProductSyncResponseDto> get copyWith => __$ProductSyncResponseDtoCopyWithImpl<_ProductSyncResponseDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProductSyncResponseDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProductSyncResponseDto&&(identical(other.status, status) || other.status == status)&&(identical(other.serverState, serverState) || other.serverState == serverState));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,serverState);

@override
String toString() {
  return 'ProductSyncResponseDto(status: $status, serverState: $serverState)';
}


}

/// @nodoc
abstract mixin class _$ProductSyncResponseDtoCopyWith<$Res> implements $ProductSyncResponseDtoCopyWith<$Res> {
  factory _$ProductSyncResponseDtoCopyWith(_ProductSyncResponseDto value, $Res Function(_ProductSyncResponseDto) _then) = __$ProductSyncResponseDtoCopyWithImpl;
@override @useResult
$Res call({
 String status,@JsonKey(name: 'server_state') ProductDto? serverState
});


@override $ProductDtoCopyWith<$Res>? get serverState;

}
/// @nodoc
class __$ProductSyncResponseDtoCopyWithImpl<$Res>
    implements _$ProductSyncResponseDtoCopyWith<$Res> {
  __$ProductSyncResponseDtoCopyWithImpl(this._self, this._then);

  final _ProductSyncResponseDto _self;
  final $Res Function(_ProductSyncResponseDto) _then;

/// Create a copy of ProductSyncResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? serverState = freezed,}) {
  return _then(_ProductSyncResponseDto(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,serverState: freezed == serverState ? _self.serverState : serverState // ignore: cast_nullable_to_non_nullable
as ProductDto?,
  ));
}

/// Create a copy of ProductSyncResponseDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProductDtoCopyWith<$Res>? get serverState {
    if (_self.serverState == null) {
    return null;
  }

  return $ProductDtoCopyWith<$Res>(_self.serverState!, (value) {
    return _then(_self.copyWith(serverState: value));
  });
}
}

// dart format on
