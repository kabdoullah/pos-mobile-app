// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sale.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Sale {

 String get id; int get receiptNumber; Decimal get totalAmount; Decimal get vatAmount; PaymentMethod get paymentMethod; DateTime get createdAt;
/// Create a copy of Sale
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SaleCopyWith<Sale> get copyWith => _$SaleCopyWithImpl<Sale>(this as Sale, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Sale&&(identical(other.id, id) || other.id == id)&&(identical(other.receiptNumber, receiptNumber) || other.receiptNumber == receiptNumber)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&(identical(other.vatAmount, vatAmount) || other.vatAmount == vatAmount)&&(identical(other.paymentMethod, paymentMethod) || other.paymentMethod == paymentMethod)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,receiptNumber,totalAmount,vatAmount,paymentMethod,createdAt);

@override
String toString() {
  return 'Sale(id: $id, receiptNumber: $receiptNumber, totalAmount: $totalAmount, vatAmount: $vatAmount, paymentMethod: $paymentMethod, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $SaleCopyWith<$Res>  {
  factory $SaleCopyWith(Sale value, $Res Function(Sale) _then) = _$SaleCopyWithImpl;
@useResult
$Res call({
 String id, int receiptNumber, Decimal totalAmount, Decimal vatAmount, PaymentMethod paymentMethod, DateTime createdAt
});




}
/// @nodoc
class _$SaleCopyWithImpl<$Res>
    implements $SaleCopyWith<$Res> {
  _$SaleCopyWithImpl(this._self, this._then);

  final Sale _self;
  final $Res Function(Sale) _then;

/// Create a copy of Sale
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? receiptNumber = null,Object? totalAmount = null,Object? vatAmount = null,Object? paymentMethod = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,receiptNumber: null == receiptNumber ? _self.receiptNumber : receiptNumber // ignore: cast_nullable_to_non_nullable
as int,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as Decimal,vatAmount: null == vatAmount ? _self.vatAmount : vatAmount // ignore: cast_nullable_to_non_nullable
as Decimal,paymentMethod: null == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as PaymentMethod,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [Sale].
extension SalePatterns on Sale {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Sale value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Sale() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Sale value)  $default,){
final _that = this;
switch (_that) {
case _Sale():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Sale value)?  $default,){
final _that = this;
switch (_that) {
case _Sale() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  int receiptNumber,  Decimal totalAmount,  Decimal vatAmount,  PaymentMethod paymentMethod,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Sale() when $default != null:
return $default(_that.id,_that.receiptNumber,_that.totalAmount,_that.vatAmount,_that.paymentMethod,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  int receiptNumber,  Decimal totalAmount,  Decimal vatAmount,  PaymentMethod paymentMethod,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _Sale():
return $default(_that.id,_that.receiptNumber,_that.totalAmount,_that.vatAmount,_that.paymentMethod,_that.createdAt);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  int receiptNumber,  Decimal totalAmount,  Decimal vatAmount,  PaymentMethod paymentMethod,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _Sale() when $default != null:
return $default(_that.id,_that.receiptNumber,_that.totalAmount,_that.vatAmount,_that.paymentMethod,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc


class _Sale implements Sale {
  const _Sale({required this.id, required this.receiptNumber, required this.totalAmount, required this.vatAmount, required this.paymentMethod, required this.createdAt});
  

@override final  String id;
@override final  int receiptNumber;
@override final  Decimal totalAmount;
@override final  Decimal vatAmount;
@override final  PaymentMethod paymentMethod;
@override final  DateTime createdAt;

/// Create a copy of Sale
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SaleCopyWith<_Sale> get copyWith => __$SaleCopyWithImpl<_Sale>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Sale&&(identical(other.id, id) || other.id == id)&&(identical(other.receiptNumber, receiptNumber) || other.receiptNumber == receiptNumber)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&(identical(other.vatAmount, vatAmount) || other.vatAmount == vatAmount)&&(identical(other.paymentMethod, paymentMethod) || other.paymentMethod == paymentMethod)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,receiptNumber,totalAmount,vatAmount,paymentMethod,createdAt);

@override
String toString() {
  return 'Sale(id: $id, receiptNumber: $receiptNumber, totalAmount: $totalAmount, vatAmount: $vatAmount, paymentMethod: $paymentMethod, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$SaleCopyWith<$Res> implements $SaleCopyWith<$Res> {
  factory _$SaleCopyWith(_Sale value, $Res Function(_Sale) _then) = __$SaleCopyWithImpl;
@override @useResult
$Res call({
 String id, int receiptNumber, Decimal totalAmount, Decimal vatAmount, PaymentMethod paymentMethod, DateTime createdAt
});




}
/// @nodoc
class __$SaleCopyWithImpl<$Res>
    implements _$SaleCopyWith<$Res> {
  __$SaleCopyWithImpl(this._self, this._then);

  final _Sale _self;
  final $Res Function(_Sale) _then;

/// Create a copy of Sale
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? receiptNumber = null,Object? totalAmount = null,Object? vatAmount = null,Object? paymentMethod = null,Object? createdAt = null,}) {
  return _then(_Sale(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,receiptNumber: null == receiptNumber ? _self.receiptNumber : receiptNumber // ignore: cast_nullable_to_non_nullable
as int,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as Decimal,vatAmount: null == vatAmount ? _self.vatAmount : vatAmount // ignore: cast_nullable_to_non_nullable
as Decimal,paymentMethod: null == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as PaymentMethod,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
