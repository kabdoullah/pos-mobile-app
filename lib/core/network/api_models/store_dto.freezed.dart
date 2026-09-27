// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'store_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StoreDto {

 String get id;@JsonKey(name: 'owner_id') String get ownerId; String get name; String? get address; String? get ncc;@JsonKey(name: 'vat_subject') bool get vatSubject;@JsonKey(name: 'receipt_footer_text') String? get receiptFooterText; String? get phone;@JsonKey(name: 'logo_version') String? get logoVersion;@JsonKey(name: 'next_receipt_number') int get nextReceiptNumber;@JsonKey(name: 'created_at') String get createdAt;@JsonKey(name: 'updated_at') String get updatedAt;
/// Create a copy of StoreDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StoreDtoCopyWith<StoreDto> get copyWith => _$StoreDtoCopyWithImpl<StoreDto>(this as StoreDto, _$identity);

  /// Serializes this StoreDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StoreDto&&(identical(other.id, id) || other.id == id)&&(identical(other.ownerId, ownerId) || other.ownerId == ownerId)&&(identical(other.name, name) || other.name == name)&&(identical(other.address, address) || other.address == address)&&(identical(other.ncc, ncc) || other.ncc == ncc)&&(identical(other.vatSubject, vatSubject) || other.vatSubject == vatSubject)&&(identical(other.receiptFooterText, receiptFooterText) || other.receiptFooterText == receiptFooterText)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.logoVersion, logoVersion) || other.logoVersion == logoVersion)&&(identical(other.nextReceiptNumber, nextReceiptNumber) || other.nextReceiptNumber == nextReceiptNumber)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,ownerId,name,address,ncc,vatSubject,receiptFooterText,phone,logoVersion,nextReceiptNumber,createdAt,updatedAt);

@override
String toString() {
  return 'StoreDto(id: $id, ownerId: $ownerId, name: $name, address: $address, ncc: $ncc, vatSubject: $vatSubject, receiptFooterText: $receiptFooterText, phone: $phone, logoVersion: $logoVersion, nextReceiptNumber: $nextReceiptNumber, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $StoreDtoCopyWith<$Res>  {
  factory $StoreDtoCopyWith(StoreDto value, $Res Function(StoreDto) _then) = _$StoreDtoCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'owner_id') String ownerId, String name, String? address, String? ncc,@JsonKey(name: 'vat_subject') bool vatSubject,@JsonKey(name: 'receipt_footer_text') String? receiptFooterText, String? phone,@JsonKey(name: 'logo_version') String? logoVersion,@JsonKey(name: 'next_receipt_number') int nextReceiptNumber,@JsonKey(name: 'created_at') String createdAt,@JsonKey(name: 'updated_at') String updatedAt
});




}
/// @nodoc
class _$StoreDtoCopyWithImpl<$Res>
    implements $StoreDtoCopyWith<$Res> {
  _$StoreDtoCopyWithImpl(this._self, this._then);

  final StoreDto _self;
  final $Res Function(StoreDto) _then;

/// Create a copy of StoreDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? ownerId = null,Object? name = null,Object? address = freezed,Object? ncc = freezed,Object? vatSubject = null,Object? receiptFooterText = freezed,Object? phone = freezed,Object? logoVersion = freezed,Object? nextReceiptNumber = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,ownerId: null == ownerId ? _self.ownerId : ownerId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,ncc: freezed == ncc ? _self.ncc : ncc // ignore: cast_nullable_to_non_nullable
as String?,vatSubject: null == vatSubject ? _self.vatSubject : vatSubject // ignore: cast_nullable_to_non_nullable
as bool,receiptFooterText: freezed == receiptFooterText ? _self.receiptFooterText : receiptFooterText // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,logoVersion: freezed == logoVersion ? _self.logoVersion : logoVersion // ignore: cast_nullable_to_non_nullable
as String?,nextReceiptNumber: null == nextReceiptNumber ? _self.nextReceiptNumber : nextReceiptNumber // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [StoreDto].
extension StoreDtoPatterns on StoreDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StoreDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StoreDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StoreDto value)  $default,){
final _that = this;
switch (_that) {
case _StoreDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StoreDto value)?  $default,){
final _that = this;
switch (_that) {
case _StoreDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'owner_id')  String ownerId,  String name,  String? address,  String? ncc, @JsonKey(name: 'vat_subject')  bool vatSubject, @JsonKey(name: 'receipt_footer_text')  String? receiptFooterText,  String? phone, @JsonKey(name: 'logo_version')  String? logoVersion, @JsonKey(name: 'next_receipt_number')  int nextReceiptNumber, @JsonKey(name: 'created_at')  String createdAt, @JsonKey(name: 'updated_at')  String updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StoreDto() when $default != null:
return $default(_that.id,_that.ownerId,_that.name,_that.address,_that.ncc,_that.vatSubject,_that.receiptFooterText,_that.phone,_that.logoVersion,_that.nextReceiptNumber,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'owner_id')  String ownerId,  String name,  String? address,  String? ncc, @JsonKey(name: 'vat_subject')  bool vatSubject, @JsonKey(name: 'receipt_footer_text')  String? receiptFooterText,  String? phone, @JsonKey(name: 'logo_version')  String? logoVersion, @JsonKey(name: 'next_receipt_number')  int nextReceiptNumber, @JsonKey(name: 'created_at')  String createdAt, @JsonKey(name: 'updated_at')  String updatedAt)  $default,) {final _that = this;
switch (_that) {
case _StoreDto():
return $default(_that.id,_that.ownerId,_that.name,_that.address,_that.ncc,_that.vatSubject,_that.receiptFooterText,_that.phone,_that.logoVersion,_that.nextReceiptNumber,_that.createdAt,_that.updatedAt);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'owner_id')  String ownerId,  String name,  String? address,  String? ncc, @JsonKey(name: 'vat_subject')  bool vatSubject, @JsonKey(name: 'receipt_footer_text')  String? receiptFooterText,  String? phone, @JsonKey(name: 'logo_version')  String? logoVersion, @JsonKey(name: 'next_receipt_number')  int nextReceiptNumber, @JsonKey(name: 'created_at')  String createdAt, @JsonKey(name: 'updated_at')  String updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _StoreDto() when $default != null:
return $default(_that.id,_that.ownerId,_that.name,_that.address,_that.ncc,_that.vatSubject,_that.receiptFooterText,_that.phone,_that.logoVersion,_that.nextReceiptNumber,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StoreDto implements StoreDto {
  const _StoreDto({required this.id, @JsonKey(name: 'owner_id') required this.ownerId, required this.name, this.address, this.ncc, @JsonKey(name: 'vat_subject') required this.vatSubject, @JsonKey(name: 'receipt_footer_text') this.receiptFooterText, this.phone, @JsonKey(name: 'logo_version') this.logoVersion, @JsonKey(name: 'next_receipt_number') required this.nextReceiptNumber, @JsonKey(name: 'created_at') required this.createdAt, @JsonKey(name: 'updated_at') required this.updatedAt});
  factory _StoreDto.fromJson(Map<String, dynamic> json) => _$StoreDtoFromJson(json);

@override final  String id;
@override@JsonKey(name: 'owner_id') final  String ownerId;
@override final  String name;
@override final  String? address;
@override final  String? ncc;
@override@JsonKey(name: 'vat_subject') final  bool vatSubject;
@override@JsonKey(name: 'receipt_footer_text') final  String? receiptFooterText;
@override final  String? phone;
@override@JsonKey(name: 'logo_version') final  String? logoVersion;
@override@JsonKey(name: 'next_receipt_number') final  int nextReceiptNumber;
@override@JsonKey(name: 'created_at') final  String createdAt;
@override@JsonKey(name: 'updated_at') final  String updatedAt;

/// Create a copy of StoreDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StoreDtoCopyWith<_StoreDto> get copyWith => __$StoreDtoCopyWithImpl<_StoreDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StoreDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StoreDto&&(identical(other.id, id) || other.id == id)&&(identical(other.ownerId, ownerId) || other.ownerId == ownerId)&&(identical(other.name, name) || other.name == name)&&(identical(other.address, address) || other.address == address)&&(identical(other.ncc, ncc) || other.ncc == ncc)&&(identical(other.vatSubject, vatSubject) || other.vatSubject == vatSubject)&&(identical(other.receiptFooterText, receiptFooterText) || other.receiptFooterText == receiptFooterText)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.logoVersion, logoVersion) || other.logoVersion == logoVersion)&&(identical(other.nextReceiptNumber, nextReceiptNumber) || other.nextReceiptNumber == nextReceiptNumber)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,ownerId,name,address,ncc,vatSubject,receiptFooterText,phone,logoVersion,nextReceiptNumber,createdAt,updatedAt);

@override
String toString() {
  return 'StoreDto(id: $id, ownerId: $ownerId, name: $name, address: $address, ncc: $ncc, vatSubject: $vatSubject, receiptFooterText: $receiptFooterText, phone: $phone, logoVersion: $logoVersion, nextReceiptNumber: $nextReceiptNumber, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$StoreDtoCopyWith<$Res> implements $StoreDtoCopyWith<$Res> {
  factory _$StoreDtoCopyWith(_StoreDto value, $Res Function(_StoreDto) _then) = __$StoreDtoCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'owner_id') String ownerId, String name, String? address, String? ncc,@JsonKey(name: 'vat_subject') bool vatSubject,@JsonKey(name: 'receipt_footer_text') String? receiptFooterText, String? phone,@JsonKey(name: 'logo_version') String? logoVersion,@JsonKey(name: 'next_receipt_number') int nextReceiptNumber,@JsonKey(name: 'created_at') String createdAt,@JsonKey(name: 'updated_at') String updatedAt
});




}
/// @nodoc
class __$StoreDtoCopyWithImpl<$Res>
    implements _$StoreDtoCopyWith<$Res> {
  __$StoreDtoCopyWithImpl(this._self, this._then);

  final _StoreDto _self;
  final $Res Function(_StoreDto) _then;

/// Create a copy of StoreDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? ownerId = null,Object? name = null,Object? address = freezed,Object? ncc = freezed,Object? vatSubject = null,Object? receiptFooterText = freezed,Object? phone = freezed,Object? logoVersion = freezed,Object? nextReceiptNumber = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_StoreDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,ownerId: null == ownerId ? _self.ownerId : ownerId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,ncc: freezed == ncc ? _self.ncc : ncc // ignore: cast_nullable_to_non_nullable
as String?,vatSubject: null == vatSubject ? _self.vatSubject : vatSubject // ignore: cast_nullable_to_non_nullable
as bool,receiptFooterText: freezed == receiptFooterText ? _self.receiptFooterText : receiptFooterText // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,logoVersion: freezed == logoVersion ? _self.logoVersion : logoVersion // ignore: cast_nullable_to_non_nullable
as String?,nextReceiptNumber: null == nextReceiptNumber ? _self.nextReceiptNumber : nextReceiptNumber // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$StoreCreateDto {

 String get name; String? get address; String? get ncc;@JsonKey(name: 'vat_subject') bool? get vatSubject;@JsonKey(name: 'receipt_footer_text') String? get receiptFooterText; String? get phone;
/// Create a copy of StoreCreateDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StoreCreateDtoCopyWith<StoreCreateDto> get copyWith => _$StoreCreateDtoCopyWithImpl<StoreCreateDto>(this as StoreCreateDto, _$identity);

  /// Serializes this StoreCreateDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StoreCreateDto&&(identical(other.name, name) || other.name == name)&&(identical(other.address, address) || other.address == address)&&(identical(other.ncc, ncc) || other.ncc == ncc)&&(identical(other.vatSubject, vatSubject) || other.vatSubject == vatSubject)&&(identical(other.receiptFooterText, receiptFooterText) || other.receiptFooterText == receiptFooterText)&&(identical(other.phone, phone) || other.phone == phone));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,address,ncc,vatSubject,receiptFooterText,phone);

@override
String toString() {
  return 'StoreCreateDto(name: $name, address: $address, ncc: $ncc, vatSubject: $vatSubject, receiptFooterText: $receiptFooterText, phone: $phone)';
}


}

/// @nodoc
abstract mixin class $StoreCreateDtoCopyWith<$Res>  {
  factory $StoreCreateDtoCopyWith(StoreCreateDto value, $Res Function(StoreCreateDto) _then) = _$StoreCreateDtoCopyWithImpl;
@useResult
$Res call({
 String name, String? address, String? ncc,@JsonKey(name: 'vat_subject') bool? vatSubject,@JsonKey(name: 'receipt_footer_text') String? receiptFooterText, String? phone
});




}
/// @nodoc
class _$StoreCreateDtoCopyWithImpl<$Res>
    implements $StoreCreateDtoCopyWith<$Res> {
  _$StoreCreateDtoCopyWithImpl(this._self, this._then);

  final StoreCreateDto _self;
  final $Res Function(StoreCreateDto) _then;

/// Create a copy of StoreCreateDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? address = freezed,Object? ncc = freezed,Object? vatSubject = freezed,Object? receiptFooterText = freezed,Object? phone = freezed,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,ncc: freezed == ncc ? _self.ncc : ncc // ignore: cast_nullable_to_non_nullable
as String?,vatSubject: freezed == vatSubject ? _self.vatSubject : vatSubject // ignore: cast_nullable_to_non_nullable
as bool?,receiptFooterText: freezed == receiptFooterText ? _self.receiptFooterText : receiptFooterText // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [StoreCreateDto].
extension StoreCreateDtoPatterns on StoreCreateDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StoreCreateDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StoreCreateDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StoreCreateDto value)  $default,){
final _that = this;
switch (_that) {
case _StoreCreateDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StoreCreateDto value)?  $default,){
final _that = this;
switch (_that) {
case _StoreCreateDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String? address,  String? ncc, @JsonKey(name: 'vat_subject')  bool? vatSubject, @JsonKey(name: 'receipt_footer_text')  String? receiptFooterText,  String? phone)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StoreCreateDto() when $default != null:
return $default(_that.name,_that.address,_that.ncc,_that.vatSubject,_that.receiptFooterText,_that.phone);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String? address,  String? ncc, @JsonKey(name: 'vat_subject')  bool? vatSubject, @JsonKey(name: 'receipt_footer_text')  String? receiptFooterText,  String? phone)  $default,) {final _that = this;
switch (_that) {
case _StoreCreateDto():
return $default(_that.name,_that.address,_that.ncc,_that.vatSubject,_that.receiptFooterText,_that.phone);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String? address,  String? ncc, @JsonKey(name: 'vat_subject')  bool? vatSubject, @JsonKey(name: 'receipt_footer_text')  String? receiptFooterText,  String? phone)?  $default,) {final _that = this;
switch (_that) {
case _StoreCreateDto() when $default != null:
return $default(_that.name,_that.address,_that.ncc,_that.vatSubject,_that.receiptFooterText,_that.phone);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StoreCreateDto implements StoreCreateDto {
  const _StoreCreateDto({required this.name, this.address, this.ncc, @JsonKey(name: 'vat_subject') this.vatSubject, @JsonKey(name: 'receipt_footer_text') this.receiptFooterText, this.phone});
  factory _StoreCreateDto.fromJson(Map<String, dynamic> json) => _$StoreCreateDtoFromJson(json);

@override final  String name;
@override final  String? address;
@override final  String? ncc;
@override@JsonKey(name: 'vat_subject') final  bool? vatSubject;
@override@JsonKey(name: 'receipt_footer_text') final  String? receiptFooterText;
@override final  String? phone;

/// Create a copy of StoreCreateDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StoreCreateDtoCopyWith<_StoreCreateDto> get copyWith => __$StoreCreateDtoCopyWithImpl<_StoreCreateDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StoreCreateDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StoreCreateDto&&(identical(other.name, name) || other.name == name)&&(identical(other.address, address) || other.address == address)&&(identical(other.ncc, ncc) || other.ncc == ncc)&&(identical(other.vatSubject, vatSubject) || other.vatSubject == vatSubject)&&(identical(other.receiptFooterText, receiptFooterText) || other.receiptFooterText == receiptFooterText)&&(identical(other.phone, phone) || other.phone == phone));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,address,ncc,vatSubject,receiptFooterText,phone);

@override
String toString() {
  return 'StoreCreateDto(name: $name, address: $address, ncc: $ncc, vatSubject: $vatSubject, receiptFooterText: $receiptFooterText, phone: $phone)';
}


}

/// @nodoc
abstract mixin class _$StoreCreateDtoCopyWith<$Res> implements $StoreCreateDtoCopyWith<$Res> {
  factory _$StoreCreateDtoCopyWith(_StoreCreateDto value, $Res Function(_StoreCreateDto) _then) = __$StoreCreateDtoCopyWithImpl;
@override @useResult
$Res call({
 String name, String? address, String? ncc,@JsonKey(name: 'vat_subject') bool? vatSubject,@JsonKey(name: 'receipt_footer_text') String? receiptFooterText, String? phone
});




}
/// @nodoc
class __$StoreCreateDtoCopyWithImpl<$Res>
    implements _$StoreCreateDtoCopyWith<$Res> {
  __$StoreCreateDtoCopyWithImpl(this._self, this._then);

  final _StoreCreateDto _self;
  final $Res Function(_StoreCreateDto) _then;

/// Create a copy of StoreCreateDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? address = freezed,Object? ncc = freezed,Object? vatSubject = freezed,Object? receiptFooterText = freezed,Object? phone = freezed,}) {
  return _then(_StoreCreateDto(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,ncc: freezed == ncc ? _self.ncc : ncc // ignore: cast_nullable_to_non_nullable
as String?,vatSubject: freezed == vatSubject ? _self.vatSubject : vatSubject // ignore: cast_nullable_to_non_nullable
as bool?,receiptFooterText: freezed == receiptFooterText ? _self.receiptFooterText : receiptFooterText // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$StoreUpdateDto {

 String? get name; String? get address; String? get ncc;@JsonKey(name: 'vat_subject') bool? get vatSubject;@JsonKey(name: 'receipt_footer_text') String? get receiptFooterText; String? get phone;
/// Create a copy of StoreUpdateDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StoreUpdateDtoCopyWith<StoreUpdateDto> get copyWith => _$StoreUpdateDtoCopyWithImpl<StoreUpdateDto>(this as StoreUpdateDto, _$identity);

  /// Serializes this StoreUpdateDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StoreUpdateDto&&(identical(other.name, name) || other.name == name)&&(identical(other.address, address) || other.address == address)&&(identical(other.ncc, ncc) || other.ncc == ncc)&&(identical(other.vatSubject, vatSubject) || other.vatSubject == vatSubject)&&(identical(other.receiptFooterText, receiptFooterText) || other.receiptFooterText == receiptFooterText)&&(identical(other.phone, phone) || other.phone == phone));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,address,ncc,vatSubject,receiptFooterText,phone);

@override
String toString() {
  return 'StoreUpdateDto(name: $name, address: $address, ncc: $ncc, vatSubject: $vatSubject, receiptFooterText: $receiptFooterText, phone: $phone)';
}


}

/// @nodoc
abstract mixin class $StoreUpdateDtoCopyWith<$Res>  {
  factory $StoreUpdateDtoCopyWith(StoreUpdateDto value, $Res Function(StoreUpdateDto) _then) = _$StoreUpdateDtoCopyWithImpl;
@useResult
$Res call({
 String? name, String? address, String? ncc,@JsonKey(name: 'vat_subject') bool? vatSubject,@JsonKey(name: 'receipt_footer_text') String? receiptFooterText, String? phone
});




}
/// @nodoc
class _$StoreUpdateDtoCopyWithImpl<$Res>
    implements $StoreUpdateDtoCopyWith<$Res> {
  _$StoreUpdateDtoCopyWithImpl(this._self, this._then);

  final StoreUpdateDto _self;
  final $Res Function(StoreUpdateDto) _then;

/// Create a copy of StoreUpdateDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = freezed,Object? address = freezed,Object? ncc = freezed,Object? vatSubject = freezed,Object? receiptFooterText = freezed,Object? phone = freezed,}) {
  return _then(_self.copyWith(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,ncc: freezed == ncc ? _self.ncc : ncc // ignore: cast_nullable_to_non_nullable
as String?,vatSubject: freezed == vatSubject ? _self.vatSubject : vatSubject // ignore: cast_nullable_to_non_nullable
as bool?,receiptFooterText: freezed == receiptFooterText ? _self.receiptFooterText : receiptFooterText // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [StoreUpdateDto].
extension StoreUpdateDtoPatterns on StoreUpdateDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StoreUpdateDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StoreUpdateDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StoreUpdateDto value)  $default,){
final _that = this;
switch (_that) {
case _StoreUpdateDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StoreUpdateDto value)?  $default,){
final _that = this;
switch (_that) {
case _StoreUpdateDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? name,  String? address,  String? ncc, @JsonKey(name: 'vat_subject')  bool? vatSubject, @JsonKey(name: 'receipt_footer_text')  String? receiptFooterText,  String? phone)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StoreUpdateDto() when $default != null:
return $default(_that.name,_that.address,_that.ncc,_that.vatSubject,_that.receiptFooterText,_that.phone);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? name,  String? address,  String? ncc, @JsonKey(name: 'vat_subject')  bool? vatSubject, @JsonKey(name: 'receipt_footer_text')  String? receiptFooterText,  String? phone)  $default,) {final _that = this;
switch (_that) {
case _StoreUpdateDto():
return $default(_that.name,_that.address,_that.ncc,_that.vatSubject,_that.receiptFooterText,_that.phone);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? name,  String? address,  String? ncc, @JsonKey(name: 'vat_subject')  bool? vatSubject, @JsonKey(name: 'receipt_footer_text')  String? receiptFooterText,  String? phone)?  $default,) {final _that = this;
switch (_that) {
case _StoreUpdateDto() when $default != null:
return $default(_that.name,_that.address,_that.ncc,_that.vatSubject,_that.receiptFooterText,_that.phone);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StoreUpdateDto implements StoreUpdateDto {
  const _StoreUpdateDto({this.name, this.address, this.ncc, @JsonKey(name: 'vat_subject') this.vatSubject, @JsonKey(name: 'receipt_footer_text') this.receiptFooterText, this.phone});
  factory _StoreUpdateDto.fromJson(Map<String, dynamic> json) => _$StoreUpdateDtoFromJson(json);

@override final  String? name;
@override final  String? address;
@override final  String? ncc;
@override@JsonKey(name: 'vat_subject') final  bool? vatSubject;
@override@JsonKey(name: 'receipt_footer_text') final  String? receiptFooterText;
@override final  String? phone;

/// Create a copy of StoreUpdateDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StoreUpdateDtoCopyWith<_StoreUpdateDto> get copyWith => __$StoreUpdateDtoCopyWithImpl<_StoreUpdateDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StoreUpdateDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StoreUpdateDto&&(identical(other.name, name) || other.name == name)&&(identical(other.address, address) || other.address == address)&&(identical(other.ncc, ncc) || other.ncc == ncc)&&(identical(other.vatSubject, vatSubject) || other.vatSubject == vatSubject)&&(identical(other.receiptFooterText, receiptFooterText) || other.receiptFooterText == receiptFooterText)&&(identical(other.phone, phone) || other.phone == phone));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,address,ncc,vatSubject,receiptFooterText,phone);

@override
String toString() {
  return 'StoreUpdateDto(name: $name, address: $address, ncc: $ncc, vatSubject: $vatSubject, receiptFooterText: $receiptFooterText, phone: $phone)';
}


}

/// @nodoc
abstract mixin class _$StoreUpdateDtoCopyWith<$Res> implements $StoreUpdateDtoCopyWith<$Res> {
  factory _$StoreUpdateDtoCopyWith(_StoreUpdateDto value, $Res Function(_StoreUpdateDto) _then) = __$StoreUpdateDtoCopyWithImpl;
@override @useResult
$Res call({
 String? name, String? address, String? ncc,@JsonKey(name: 'vat_subject') bool? vatSubject,@JsonKey(name: 'receipt_footer_text') String? receiptFooterText, String? phone
});




}
/// @nodoc
class __$StoreUpdateDtoCopyWithImpl<$Res>
    implements _$StoreUpdateDtoCopyWith<$Res> {
  __$StoreUpdateDtoCopyWithImpl(this._self, this._then);

  final _StoreUpdateDto _self;
  final $Res Function(_StoreUpdateDto) _then;

/// Create a copy of StoreUpdateDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = freezed,Object? address = freezed,Object? ncc = freezed,Object? vatSubject = freezed,Object? receiptFooterText = freezed,Object? phone = freezed,}) {
  return _then(_StoreUpdateDto(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,ncc: freezed == ncc ? _self.ncc : ncc // ignore: cast_nullable_to_non_nullable
as String?,vatSubject: freezed == vatSubject ? _self.vatSubject : vatSubject // ignore: cast_nullable_to_non_nullable
as bool?,receiptFooterText: freezed == receiptFooterText ? _self.receiptFooterText : receiptFooterText // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
