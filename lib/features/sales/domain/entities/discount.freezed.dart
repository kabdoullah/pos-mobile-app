// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'discount.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Discount {

 DiscountType get type;/// Montant en FCFA ([DiscountType.amount]) ou pourcentage
/// ([DiscountType.percentage]).
 Decimal get value;
/// Create a copy of Discount
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DiscountCopyWith<Discount> get copyWith => _$DiscountCopyWithImpl<Discount>(this as Discount, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Discount&&(identical(other.type, type) || other.type == type)&&(identical(other.value, value) || other.value == value));
}


@override
int get hashCode => Object.hash(runtimeType,type,value);

@override
String toString() {
  return 'Discount(type: $type, value: $value)';
}


}

/// @nodoc
abstract mixin class $DiscountCopyWith<$Res>  {
  factory $DiscountCopyWith(Discount value, $Res Function(Discount) _then) = _$DiscountCopyWithImpl;
@useResult
$Res call({
 DiscountType type, Decimal value
});




}
/// @nodoc
class _$DiscountCopyWithImpl<$Res>
    implements $DiscountCopyWith<$Res> {
  _$DiscountCopyWithImpl(this._self, this._then);

  final Discount _self;
  final $Res Function(Discount) _then;

/// Create a copy of Discount
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? value = null,}) {
  return _then(_self.copyWith(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as DiscountType,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as Decimal,
  ));
}

}


/// Adds pattern-matching-related methods to [Discount].
extension DiscountPatterns on Discount {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Discount value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Discount() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Discount value)  $default,){
final _that = this;
switch (_that) {
case _Discount():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Discount value)?  $default,){
final _that = this;
switch (_that) {
case _Discount() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DiscountType type,  Decimal value)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Discount() when $default != null:
return $default(_that.type,_that.value);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DiscountType type,  Decimal value)  $default,) {final _that = this;
switch (_that) {
case _Discount():
return $default(_that.type,_that.value);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DiscountType type,  Decimal value)?  $default,) {final _that = this;
switch (_that) {
case _Discount() when $default != null:
return $default(_that.type,_that.value);case _:
  return null;

}
}

}

/// @nodoc


class _Discount extends Discount {
  const _Discount({required this.type, required this.value}): super._();
  

@override final  DiscountType type;
/// Montant en FCFA ([DiscountType.amount]) ou pourcentage
/// ([DiscountType.percentage]).
@override final  Decimal value;

/// Create a copy of Discount
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DiscountCopyWith<_Discount> get copyWith => __$DiscountCopyWithImpl<_Discount>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Discount&&(identical(other.type, type) || other.type == type)&&(identical(other.value, value) || other.value == value));
}


@override
int get hashCode => Object.hash(runtimeType,type,value);

@override
String toString() {
  return 'Discount(type: $type, value: $value)';
}


}

/// @nodoc
abstract mixin class _$DiscountCopyWith<$Res> implements $DiscountCopyWith<$Res> {
  factory _$DiscountCopyWith(_Discount value, $Res Function(_Discount) _then) = __$DiscountCopyWithImpl;
@override @useResult
$Res call({
 DiscountType type, Decimal value
});




}
/// @nodoc
class __$DiscountCopyWithImpl<$Res>
    implements _$DiscountCopyWith<$Res> {
  __$DiscountCopyWithImpl(this._self, this._then);

  final _Discount _self;
  final $Res Function(_Discount) _then;

/// Create a copy of Discount
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? value = null,}) {
  return _then(_Discount(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as DiscountType,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as Decimal,
  ));
}


}

// dart format on
