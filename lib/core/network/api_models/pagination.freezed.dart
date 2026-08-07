// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pagination.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CursorPageDto<T> {

 List<T> get items;@JsonKey(name: 'next_cursor') String? get nextCursor;@JsonKey(name: 'has_more') bool get hasMore;
/// Create a copy of CursorPageDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CursorPageDtoCopyWith<T, CursorPageDto<T>> get copyWith => _$CursorPageDtoCopyWithImpl<T, CursorPageDto<T>>(this as CursorPageDto<T>, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CursorPageDto<T>&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(items),nextCursor,hasMore);

@override
String toString() {
  return 'CursorPageDto<$T>(items: $items, nextCursor: $nextCursor, hasMore: $hasMore)';
}


}

/// @nodoc
abstract mixin class $CursorPageDtoCopyWith<T,$Res>  {
  factory $CursorPageDtoCopyWith(CursorPageDto<T> value, $Res Function(CursorPageDto<T>) _then) = _$CursorPageDtoCopyWithImpl;
@useResult
$Res call({
 List<T> items,@JsonKey(name: 'next_cursor') String? nextCursor,@JsonKey(name: 'has_more') bool hasMore
});




}
/// @nodoc
class _$CursorPageDtoCopyWithImpl<T,$Res>
    implements $CursorPageDtoCopyWith<T, $Res> {
  _$CursorPageDtoCopyWithImpl(this._self, this._then);

  final CursorPageDto<T> _self;
  final $Res Function(CursorPageDto<T>) _then;

/// Create a copy of CursorPageDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? nextCursor = freezed,Object? hasMore = null,}) {
  return _then(_self.copyWith(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<T>,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [CursorPageDto].
extension CursorPageDtoPatterns<T> on CursorPageDto<T> {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CursorPageDto<T> value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CursorPageDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CursorPageDto<T> value)  $default,){
final _that = this;
switch (_that) {
case _CursorPageDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CursorPageDto<T> value)?  $default,){
final _that = this;
switch (_that) {
case _CursorPageDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<T> items, @JsonKey(name: 'next_cursor')  String? nextCursor, @JsonKey(name: 'has_more')  bool hasMore)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CursorPageDto() when $default != null:
return $default(_that.items,_that.nextCursor,_that.hasMore);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<T> items, @JsonKey(name: 'next_cursor')  String? nextCursor, @JsonKey(name: 'has_more')  bool hasMore)  $default,) {final _that = this;
switch (_that) {
case _CursorPageDto():
return $default(_that.items,_that.nextCursor,_that.hasMore);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<T> items, @JsonKey(name: 'next_cursor')  String? nextCursor, @JsonKey(name: 'has_more')  bool hasMore)?  $default,) {final _that = this;
switch (_that) {
case _CursorPageDto() when $default != null:
return $default(_that.items,_that.nextCursor,_that.hasMore);case _:
  return null;

}
}

}

/// @nodoc


class _CursorPageDto<T> implements CursorPageDto<T> {
  const _CursorPageDto({required final  List<T> items, @JsonKey(name: 'next_cursor') this.nextCursor, @JsonKey(name: 'has_more') required this.hasMore}): _items = items;
  

 final  List<T> _items;
@override List<T> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override@JsonKey(name: 'next_cursor') final  String? nextCursor;
@override@JsonKey(name: 'has_more') final  bool hasMore;

/// Create a copy of CursorPageDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CursorPageDtoCopyWith<T, _CursorPageDto<T>> get copyWith => __$CursorPageDtoCopyWithImpl<T, _CursorPageDto<T>>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CursorPageDto<T>&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),nextCursor,hasMore);

@override
String toString() {
  return 'CursorPageDto<$T>(items: $items, nextCursor: $nextCursor, hasMore: $hasMore)';
}


}

/// @nodoc
abstract mixin class _$CursorPageDtoCopyWith<T,$Res> implements $CursorPageDtoCopyWith<T, $Res> {
  factory _$CursorPageDtoCopyWith(_CursorPageDto<T> value, $Res Function(_CursorPageDto<T>) _then) = __$CursorPageDtoCopyWithImpl;
@override @useResult
$Res call({
 List<T> items,@JsonKey(name: 'next_cursor') String? nextCursor,@JsonKey(name: 'has_more') bool hasMore
});




}
/// @nodoc
class __$CursorPageDtoCopyWithImpl<T,$Res>
    implements _$CursorPageDtoCopyWith<T, $Res> {
  __$CursorPageDtoCopyWithImpl(this._self, this._then);

  final _CursorPageDto<T> _self;
  final $Res Function(_CursorPageDto<T>) _then;

/// Create a copy of CursorPageDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? nextCursor = freezed,Object? hasMore = null,}) {
  return _then(_CursorPageDto<T>(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<T>,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
