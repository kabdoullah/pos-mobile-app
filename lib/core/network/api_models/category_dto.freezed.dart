// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'category_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CategoryDto {

 String get id;@JsonKey(name: 'store_id') String get storeId; String get name;@JsonKey(name: 'created_at') String get createdAt;@JsonKey(name: 'updated_at') String get updatedAt;@JsonKey(name: 'deleted_at') String? get deletedAt;
/// Create a copy of CategoryDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CategoryDtoCopyWith<CategoryDto> get copyWith => _$CategoryDtoCopyWithImpl<CategoryDto>(this as CategoryDto, _$identity);

  /// Serializes this CategoryDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CategoryDto&&(identical(other.id, id) || other.id == id)&&(identical(other.storeId, storeId) || other.storeId == storeId)&&(identical(other.name, name) || other.name == name)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,storeId,name,createdAt,updatedAt,deletedAt);

@override
String toString() {
  return 'CategoryDto(id: $id, storeId: $storeId, name: $name, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt)';
}


}

/// @nodoc
abstract mixin class $CategoryDtoCopyWith<$Res>  {
  factory $CategoryDtoCopyWith(CategoryDto value, $Res Function(CategoryDto) _then) = _$CategoryDtoCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'store_id') String storeId, String name,@JsonKey(name: 'created_at') String createdAt,@JsonKey(name: 'updated_at') String updatedAt,@JsonKey(name: 'deleted_at') String? deletedAt
});




}
/// @nodoc
class _$CategoryDtoCopyWithImpl<$Res>
    implements $CategoryDtoCopyWith<$Res> {
  _$CategoryDtoCopyWithImpl(this._self, this._then);

  final CategoryDto _self;
  final $Res Function(CategoryDto) _then;

/// Create a copy of CategoryDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? storeId = null,Object? name = null,Object? createdAt = null,Object? updatedAt = null,Object? deletedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,storeId: null == storeId ? _self.storeId : storeId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CategoryDto].
extension CategoryDtoPatterns on CategoryDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CategoryDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CategoryDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CategoryDto value)  $default,){
final _that = this;
switch (_that) {
case _CategoryDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CategoryDto value)?  $default,){
final _that = this;
switch (_that) {
case _CategoryDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'store_id')  String storeId,  String name, @JsonKey(name: 'created_at')  String createdAt, @JsonKey(name: 'updated_at')  String updatedAt, @JsonKey(name: 'deleted_at')  String? deletedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CategoryDto() when $default != null:
return $default(_that.id,_that.storeId,_that.name,_that.createdAt,_that.updatedAt,_that.deletedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'store_id')  String storeId,  String name, @JsonKey(name: 'created_at')  String createdAt, @JsonKey(name: 'updated_at')  String updatedAt, @JsonKey(name: 'deleted_at')  String? deletedAt)  $default,) {final _that = this;
switch (_that) {
case _CategoryDto():
return $default(_that.id,_that.storeId,_that.name,_that.createdAt,_that.updatedAt,_that.deletedAt);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'store_id')  String storeId,  String name, @JsonKey(name: 'created_at')  String createdAt, @JsonKey(name: 'updated_at')  String updatedAt, @JsonKey(name: 'deleted_at')  String? deletedAt)?  $default,) {final _that = this;
switch (_that) {
case _CategoryDto() when $default != null:
return $default(_that.id,_that.storeId,_that.name,_that.createdAt,_that.updatedAt,_that.deletedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CategoryDto implements CategoryDto {
  const _CategoryDto({required this.id, @JsonKey(name: 'store_id') required this.storeId, required this.name, @JsonKey(name: 'created_at') required this.createdAt, @JsonKey(name: 'updated_at') required this.updatedAt, @JsonKey(name: 'deleted_at') this.deletedAt});
  factory _CategoryDto.fromJson(Map<String, dynamic> json) => _$CategoryDtoFromJson(json);

@override final  String id;
@override@JsonKey(name: 'store_id') final  String storeId;
@override final  String name;
@override@JsonKey(name: 'created_at') final  String createdAt;
@override@JsonKey(name: 'updated_at') final  String updatedAt;
@override@JsonKey(name: 'deleted_at') final  String? deletedAt;

/// Create a copy of CategoryDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CategoryDtoCopyWith<_CategoryDto> get copyWith => __$CategoryDtoCopyWithImpl<_CategoryDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CategoryDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CategoryDto&&(identical(other.id, id) || other.id == id)&&(identical(other.storeId, storeId) || other.storeId == storeId)&&(identical(other.name, name) || other.name == name)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,storeId,name,createdAt,updatedAt,deletedAt);

@override
String toString() {
  return 'CategoryDto(id: $id, storeId: $storeId, name: $name, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt)';
}


}

/// @nodoc
abstract mixin class _$CategoryDtoCopyWith<$Res> implements $CategoryDtoCopyWith<$Res> {
  factory _$CategoryDtoCopyWith(_CategoryDto value, $Res Function(_CategoryDto) _then) = __$CategoryDtoCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'store_id') String storeId, String name,@JsonKey(name: 'created_at') String createdAt,@JsonKey(name: 'updated_at') String updatedAt,@JsonKey(name: 'deleted_at') String? deletedAt
});




}
/// @nodoc
class __$CategoryDtoCopyWithImpl<$Res>
    implements _$CategoryDtoCopyWith<$Res> {
  __$CategoryDtoCopyWithImpl(this._self, this._then);

  final _CategoryDto _self;
  final $Res Function(_CategoryDto) _then;

/// Create a copy of CategoryDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? storeId = null,Object? name = null,Object? createdAt = null,Object? updatedAt = null,Object? deletedAt = freezed,}) {
  return _then(_CategoryDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,storeId: null == storeId ? _self.storeId : storeId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$CategorySyncItemDto {

 String get id; String get name;@JsonKey(name: 'client_updated_at') String get clientUpdatedAt; bool get deleted;
/// Create a copy of CategorySyncItemDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CategorySyncItemDtoCopyWith<CategorySyncItemDto> get copyWith => _$CategorySyncItemDtoCopyWithImpl<CategorySyncItemDto>(this as CategorySyncItemDto, _$identity);

  /// Serializes this CategorySyncItemDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CategorySyncItemDto&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.clientUpdatedAt, clientUpdatedAt) || other.clientUpdatedAt == clientUpdatedAt)&&(identical(other.deleted, deleted) || other.deleted == deleted));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,clientUpdatedAt,deleted);

@override
String toString() {
  return 'CategorySyncItemDto(id: $id, name: $name, clientUpdatedAt: $clientUpdatedAt, deleted: $deleted)';
}


}

/// @nodoc
abstract mixin class $CategorySyncItemDtoCopyWith<$Res>  {
  factory $CategorySyncItemDtoCopyWith(CategorySyncItemDto value, $Res Function(CategorySyncItemDto) _then) = _$CategorySyncItemDtoCopyWithImpl;
@useResult
$Res call({
 String id, String name,@JsonKey(name: 'client_updated_at') String clientUpdatedAt, bool deleted
});




}
/// @nodoc
class _$CategorySyncItemDtoCopyWithImpl<$Res>
    implements $CategorySyncItemDtoCopyWith<$Res> {
  _$CategorySyncItemDtoCopyWithImpl(this._self, this._then);

  final CategorySyncItemDto _self;
  final $Res Function(CategorySyncItemDto) _then;

/// Create a copy of CategorySyncItemDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? clientUpdatedAt = null,Object? deleted = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,clientUpdatedAt: null == clientUpdatedAt ? _self.clientUpdatedAt : clientUpdatedAt // ignore: cast_nullable_to_non_nullable
as String,deleted: null == deleted ? _self.deleted : deleted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [CategorySyncItemDto].
extension CategorySyncItemDtoPatterns on CategorySyncItemDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CategorySyncItemDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CategorySyncItemDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CategorySyncItemDto value)  $default,){
final _that = this;
switch (_that) {
case _CategorySyncItemDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CategorySyncItemDto value)?  $default,){
final _that = this;
switch (_that) {
case _CategorySyncItemDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name, @JsonKey(name: 'client_updated_at')  String clientUpdatedAt,  bool deleted)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CategorySyncItemDto() when $default != null:
return $default(_that.id,_that.name,_that.clientUpdatedAt,_that.deleted);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name, @JsonKey(name: 'client_updated_at')  String clientUpdatedAt,  bool deleted)  $default,) {final _that = this;
switch (_that) {
case _CategorySyncItemDto():
return $default(_that.id,_that.name,_that.clientUpdatedAt,_that.deleted);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name, @JsonKey(name: 'client_updated_at')  String clientUpdatedAt,  bool deleted)?  $default,) {final _that = this;
switch (_that) {
case _CategorySyncItemDto() when $default != null:
return $default(_that.id,_that.name,_that.clientUpdatedAt,_that.deleted);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CategorySyncItemDto implements CategorySyncItemDto {
  const _CategorySyncItemDto({required this.id, required this.name, @JsonKey(name: 'client_updated_at') required this.clientUpdatedAt, this.deleted = false});
  factory _CategorySyncItemDto.fromJson(Map<String, dynamic> json) => _$CategorySyncItemDtoFromJson(json);

@override final  String id;
@override final  String name;
@override@JsonKey(name: 'client_updated_at') final  String clientUpdatedAt;
@override@JsonKey() final  bool deleted;

/// Create a copy of CategorySyncItemDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CategorySyncItemDtoCopyWith<_CategorySyncItemDto> get copyWith => __$CategorySyncItemDtoCopyWithImpl<_CategorySyncItemDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CategorySyncItemDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CategorySyncItemDto&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.clientUpdatedAt, clientUpdatedAt) || other.clientUpdatedAt == clientUpdatedAt)&&(identical(other.deleted, deleted) || other.deleted == deleted));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,clientUpdatedAt,deleted);

@override
String toString() {
  return 'CategorySyncItemDto(id: $id, name: $name, clientUpdatedAt: $clientUpdatedAt, deleted: $deleted)';
}


}

/// @nodoc
abstract mixin class _$CategorySyncItemDtoCopyWith<$Res> implements $CategorySyncItemDtoCopyWith<$Res> {
  factory _$CategorySyncItemDtoCopyWith(_CategorySyncItemDto value, $Res Function(_CategorySyncItemDto) _then) = __$CategorySyncItemDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, String name,@JsonKey(name: 'client_updated_at') String clientUpdatedAt, bool deleted
});




}
/// @nodoc
class __$CategorySyncItemDtoCopyWithImpl<$Res>
    implements _$CategorySyncItemDtoCopyWith<$Res> {
  __$CategorySyncItemDtoCopyWithImpl(this._self, this._then);

  final _CategorySyncItemDto _self;
  final $Res Function(_CategorySyncItemDto) _then;

/// Create a copy of CategorySyncItemDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? clientUpdatedAt = null,Object? deleted = null,}) {
  return _then(_CategorySyncItemDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,clientUpdatedAt: null == clientUpdatedAt ? _self.clientUpdatedAt : clientUpdatedAt // ignore: cast_nullable_to_non_nullable
as String,deleted: null == deleted ? _self.deleted : deleted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$CategorySyncResponseDto {

 String get status;// 'created', 'updated', 'no_change', 'deleted', 'conflict'
@JsonKey(name: 'server_state') CategoryDto? get serverState;
/// Create a copy of CategorySyncResponseDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CategorySyncResponseDtoCopyWith<CategorySyncResponseDto> get copyWith => _$CategorySyncResponseDtoCopyWithImpl<CategorySyncResponseDto>(this as CategorySyncResponseDto, _$identity);

  /// Serializes this CategorySyncResponseDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CategorySyncResponseDto&&(identical(other.status, status) || other.status == status)&&(identical(other.serverState, serverState) || other.serverState == serverState));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,serverState);

@override
String toString() {
  return 'CategorySyncResponseDto(status: $status, serverState: $serverState)';
}


}

/// @nodoc
abstract mixin class $CategorySyncResponseDtoCopyWith<$Res>  {
  factory $CategorySyncResponseDtoCopyWith(CategorySyncResponseDto value, $Res Function(CategorySyncResponseDto) _then) = _$CategorySyncResponseDtoCopyWithImpl;
@useResult
$Res call({
 String status,@JsonKey(name: 'server_state') CategoryDto? serverState
});


$CategoryDtoCopyWith<$Res>? get serverState;

}
/// @nodoc
class _$CategorySyncResponseDtoCopyWithImpl<$Res>
    implements $CategorySyncResponseDtoCopyWith<$Res> {
  _$CategorySyncResponseDtoCopyWithImpl(this._self, this._then);

  final CategorySyncResponseDto _self;
  final $Res Function(CategorySyncResponseDto) _then;

/// Create a copy of CategorySyncResponseDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? serverState = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,serverState: freezed == serverState ? _self.serverState : serverState // ignore: cast_nullable_to_non_nullable
as CategoryDto?,
  ));
}
/// Create a copy of CategorySyncResponseDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CategoryDtoCopyWith<$Res>? get serverState {
    if (_self.serverState == null) {
    return null;
  }

  return $CategoryDtoCopyWith<$Res>(_self.serverState!, (value) {
    return _then(_self.copyWith(serverState: value));
  });
}
}


/// Adds pattern-matching-related methods to [CategorySyncResponseDto].
extension CategorySyncResponseDtoPatterns on CategorySyncResponseDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CategorySyncResponseDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CategorySyncResponseDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CategorySyncResponseDto value)  $default,){
final _that = this;
switch (_that) {
case _CategorySyncResponseDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CategorySyncResponseDto value)?  $default,){
final _that = this;
switch (_that) {
case _CategorySyncResponseDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String status, @JsonKey(name: 'server_state')  CategoryDto? serverState)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CategorySyncResponseDto() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String status, @JsonKey(name: 'server_state')  CategoryDto? serverState)  $default,) {final _that = this;
switch (_that) {
case _CategorySyncResponseDto():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String status, @JsonKey(name: 'server_state')  CategoryDto? serverState)?  $default,) {final _that = this;
switch (_that) {
case _CategorySyncResponseDto() when $default != null:
return $default(_that.status,_that.serverState);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CategorySyncResponseDto implements CategorySyncResponseDto {
  const _CategorySyncResponseDto({required this.status, @JsonKey(name: 'server_state') this.serverState});
  factory _CategorySyncResponseDto.fromJson(Map<String, dynamic> json) => _$CategorySyncResponseDtoFromJson(json);

@override final  String status;
// 'created', 'updated', 'no_change', 'deleted', 'conflict'
@override@JsonKey(name: 'server_state') final  CategoryDto? serverState;

/// Create a copy of CategorySyncResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CategorySyncResponseDtoCopyWith<_CategorySyncResponseDto> get copyWith => __$CategorySyncResponseDtoCopyWithImpl<_CategorySyncResponseDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CategorySyncResponseDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CategorySyncResponseDto&&(identical(other.status, status) || other.status == status)&&(identical(other.serverState, serverState) || other.serverState == serverState));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,serverState);

@override
String toString() {
  return 'CategorySyncResponseDto(status: $status, serverState: $serverState)';
}


}

/// @nodoc
abstract mixin class _$CategorySyncResponseDtoCopyWith<$Res> implements $CategorySyncResponseDtoCopyWith<$Res> {
  factory _$CategorySyncResponseDtoCopyWith(_CategorySyncResponseDto value, $Res Function(_CategorySyncResponseDto) _then) = __$CategorySyncResponseDtoCopyWithImpl;
@override @useResult
$Res call({
 String status,@JsonKey(name: 'server_state') CategoryDto? serverState
});


@override $CategoryDtoCopyWith<$Res>? get serverState;

}
/// @nodoc
class __$CategorySyncResponseDtoCopyWithImpl<$Res>
    implements _$CategorySyncResponseDtoCopyWith<$Res> {
  __$CategorySyncResponseDtoCopyWithImpl(this._self, this._then);

  final _CategorySyncResponseDto _self;
  final $Res Function(_CategorySyncResponseDto) _then;

/// Create a copy of CategorySyncResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? serverState = freezed,}) {
  return _then(_CategorySyncResponseDto(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,serverState: freezed == serverState ? _self.serverState : serverState // ignore: cast_nullable_to_non_nullable
as CategoryDto?,
  ));
}

/// Create a copy of CategorySyncResponseDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CategoryDtoCopyWith<$Res>? get serverState {
    if (_self.serverState == null) {
    return null;
  }

  return $CategoryDtoCopyWith<$Res>(_self.serverState!, (value) {
    return _then(_self.copyWith(serverState: value));
  });
}
}

// dart format on
