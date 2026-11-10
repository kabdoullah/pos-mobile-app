// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cash_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CashSummary {

/// Fond de caisse à l'ouverture.
 Decimal get openingAmount;/// Part espèces des ventes.
 Decimal get cashSales;/// Nombre de ventes payées en espèces ou en mixte.
 int get cashSalesCount;/// Ventes payées par mobile money (hors tiroir).
 Decimal get mobileMoneySales;/// Total des entrées d'espèces.
 Decimal get cashIn;/// Total des sorties d'espèces.
 Decimal get cashOut;/// Remboursements en espèces comptabilisés.
 Decimal get cashRefunds;/// Remboursements en espèces rejetés par le serveur, non comptabilisés.
 Decimal get rejectedCashRefunds;/// Solde théorique du tiroir.
 Decimal get expectedAmount;
/// Create a copy of CashSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CashSummaryCopyWith<CashSummary> get copyWith => _$CashSummaryCopyWithImpl<CashSummary>(this as CashSummary, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CashSummary&&(identical(other.openingAmount, openingAmount) || other.openingAmount == openingAmount)&&(identical(other.cashSales, cashSales) || other.cashSales == cashSales)&&(identical(other.cashSalesCount, cashSalesCount) || other.cashSalesCount == cashSalesCount)&&(identical(other.mobileMoneySales, mobileMoneySales) || other.mobileMoneySales == mobileMoneySales)&&(identical(other.cashIn, cashIn) || other.cashIn == cashIn)&&(identical(other.cashOut, cashOut) || other.cashOut == cashOut)&&(identical(other.cashRefunds, cashRefunds) || other.cashRefunds == cashRefunds)&&(identical(other.rejectedCashRefunds, rejectedCashRefunds) || other.rejectedCashRefunds == rejectedCashRefunds)&&(identical(other.expectedAmount, expectedAmount) || other.expectedAmount == expectedAmount));
}


@override
int get hashCode => Object.hash(runtimeType,openingAmount,cashSales,cashSalesCount,mobileMoneySales,cashIn,cashOut,cashRefunds,rejectedCashRefunds,expectedAmount);

@override
String toString() {
  return 'CashSummary(openingAmount: $openingAmount, cashSales: $cashSales, cashSalesCount: $cashSalesCount, mobileMoneySales: $mobileMoneySales, cashIn: $cashIn, cashOut: $cashOut, cashRefunds: $cashRefunds, rejectedCashRefunds: $rejectedCashRefunds, expectedAmount: $expectedAmount)';
}


}

/// @nodoc
abstract mixin class $CashSummaryCopyWith<$Res>  {
  factory $CashSummaryCopyWith(CashSummary value, $Res Function(CashSummary) _then) = _$CashSummaryCopyWithImpl;
@useResult
$Res call({
 Decimal openingAmount, Decimal cashSales, int cashSalesCount, Decimal mobileMoneySales, Decimal cashIn, Decimal cashOut, Decimal cashRefunds, Decimal rejectedCashRefunds, Decimal expectedAmount
});




}
/// @nodoc
class _$CashSummaryCopyWithImpl<$Res>
    implements $CashSummaryCopyWith<$Res> {
  _$CashSummaryCopyWithImpl(this._self, this._then);

  final CashSummary _self;
  final $Res Function(CashSummary) _then;

/// Create a copy of CashSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? openingAmount = null,Object? cashSales = null,Object? cashSalesCount = null,Object? mobileMoneySales = null,Object? cashIn = null,Object? cashOut = null,Object? cashRefunds = null,Object? rejectedCashRefunds = null,Object? expectedAmount = null,}) {
  return _then(CashSummary(
openingAmount: null == openingAmount ? _self.openingAmount : openingAmount // ignore: cast_nullable_to_non_nullable
as Decimal,cashSales: null == cashSales ? _self.cashSales : cashSales // ignore: cast_nullable_to_non_nullable
as Decimal,cashSalesCount: null == cashSalesCount ? _self.cashSalesCount : cashSalesCount // ignore: cast_nullable_to_non_nullable
as int,mobileMoneySales: null == mobileMoneySales ? _self.mobileMoneySales : mobileMoneySales // ignore: cast_nullable_to_non_nullable
as Decimal,cashIn: null == cashIn ? _self.cashIn : cashIn // ignore: cast_nullable_to_non_nullable
as Decimal,cashOut: null == cashOut ? _self.cashOut : cashOut // ignore: cast_nullable_to_non_nullable
as Decimal,cashRefunds: null == cashRefunds ? _self.cashRefunds : cashRefunds // ignore: cast_nullable_to_non_nullable
as Decimal,rejectedCashRefunds: null == rejectedCashRefunds ? _self.rejectedCashRefunds : rejectedCashRefunds // ignore: cast_nullable_to_non_nullable
as Decimal,expectedAmount: null == expectedAmount ? _self.expectedAmount : expectedAmount // ignore: cast_nullable_to_non_nullable
as Decimal,
  ));
}

}


/// Adds pattern-matching-related methods to [CashSummary].
extension CashSummaryPatterns on CashSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CashSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CashSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CashSummary value)  $default,){
final _that = this;
switch (_that) {
case _CashSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CashSummary value)?  $default,){
final _that = this;
switch (_that) {
case _CashSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Decimal openingAmount,  Decimal cashSales,  int cashSalesCount,  Decimal mobileMoneySales,  Decimal cashIn,  Decimal cashOut,  Decimal cashRefunds,  Decimal rejectedCashRefunds,  Decimal expectedAmount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CashSummary() when $default != null:
return $default(_that.openingAmount,_that.cashSales,_that.cashSalesCount,_that.mobileMoneySales,_that.cashIn,_that.cashOut,_that.cashRefunds,_that.rejectedCashRefunds,_that.expectedAmount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Decimal openingAmount,  Decimal cashSales,  int cashSalesCount,  Decimal mobileMoneySales,  Decimal cashIn,  Decimal cashOut,  Decimal cashRefunds,  Decimal rejectedCashRefunds,  Decimal expectedAmount)  $default,) {final _that = this;
switch (_that) {
case _CashSummary():
return $default(_that.openingAmount,_that.cashSales,_that.cashSalesCount,_that.mobileMoneySales,_that.cashIn,_that.cashOut,_that.cashRefunds,_that.rejectedCashRefunds,_that.expectedAmount);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Decimal openingAmount,  Decimal cashSales,  int cashSalesCount,  Decimal mobileMoneySales,  Decimal cashIn,  Decimal cashOut,  Decimal cashRefunds,  Decimal rejectedCashRefunds,  Decimal expectedAmount)?  $default,) {final _that = this;
switch (_that) {
case _CashSummary() when $default != null:
return $default(_that.openingAmount,_that.cashSales,_that.cashSalesCount,_that.mobileMoneySales,_that.cashIn,_that.cashOut,_that.cashRefunds,_that.rejectedCashRefunds,_that.expectedAmount);case _:
  return null;

}
}

}

/// @nodoc


class _CashSummary implements CashSummary {
  const _CashSummary({required this.openingAmount, required this.cashSales, required this.cashSalesCount, required this.mobileMoneySales, required this.cashIn, required this.cashOut, required this.cashRefunds, required this.rejectedCashRefunds, required this.expectedAmount});
  

/// Fond de caisse à l'ouverture.
@override final  Decimal openingAmount;
/// Part espèces des ventes.
@override final  Decimal cashSales;
/// Nombre de ventes payées en espèces ou en mixte.
@override final  int cashSalesCount;
/// Ventes payées par mobile money (hors tiroir).
@override final  Decimal mobileMoneySales;
/// Total des entrées d'espèces.
@override final  Decimal cashIn;
/// Total des sorties d'espèces.
@override final  Decimal cashOut;
/// Remboursements en espèces comptabilisés.
@override final  Decimal cashRefunds;
/// Remboursements en espèces rejetés par le serveur, non comptabilisés.
@override final  Decimal rejectedCashRefunds;
/// Solde théorique du tiroir.
@override final  Decimal expectedAmount;

/// Create a copy of CashSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CashSummaryCopyWith<_CashSummary> get copyWith => __$CashSummaryCopyWithImpl<_CashSummary>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CashSummary&&(identical(other.openingAmount, openingAmount) || other.openingAmount == openingAmount)&&(identical(other.cashSales, cashSales) || other.cashSales == cashSales)&&(identical(other.cashSalesCount, cashSalesCount) || other.cashSalesCount == cashSalesCount)&&(identical(other.mobileMoneySales, mobileMoneySales) || other.mobileMoneySales == mobileMoneySales)&&(identical(other.cashIn, cashIn) || other.cashIn == cashIn)&&(identical(other.cashOut, cashOut) || other.cashOut == cashOut)&&(identical(other.cashRefunds, cashRefunds) || other.cashRefunds == cashRefunds)&&(identical(other.rejectedCashRefunds, rejectedCashRefunds) || other.rejectedCashRefunds == rejectedCashRefunds)&&(identical(other.expectedAmount, expectedAmount) || other.expectedAmount == expectedAmount));
}


@override
int get hashCode => Object.hash(runtimeType,openingAmount,cashSales,cashSalesCount,mobileMoneySales,cashIn,cashOut,cashRefunds,rejectedCashRefunds,expectedAmount);

@override
String toString() {
  return 'CashSummary(openingAmount: $openingAmount, cashSales: $cashSales, cashSalesCount: $cashSalesCount, mobileMoneySales: $mobileMoneySales, cashIn: $cashIn, cashOut: $cashOut, cashRefunds: $cashRefunds, rejectedCashRefunds: $rejectedCashRefunds, expectedAmount: $expectedAmount)';
}


}

/// @nodoc
abstract mixin class _$CashSummaryCopyWith<$Res> implements $CashSummaryCopyWith<$Res> {
  factory _$CashSummaryCopyWith(_CashSummary value, $Res Function(_CashSummary) _then) = __$CashSummaryCopyWithImpl;
@override @useResult
$Res call({
 Decimal openingAmount, Decimal cashSales, int cashSalesCount, Decimal mobileMoneySales, Decimal cashIn, Decimal cashOut, Decimal cashRefunds, Decimal rejectedCashRefunds, Decimal expectedAmount
});




}
/// @nodoc
class __$CashSummaryCopyWithImpl<$Res>
    implements _$CashSummaryCopyWith<$Res> {
  __$CashSummaryCopyWithImpl(this._self, this._then);

  final _CashSummary _self;
  final $Res Function(_CashSummary) _then;

/// Create a copy of CashSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? openingAmount = null,Object? cashSales = null,Object? cashSalesCount = null,Object? mobileMoneySales = null,Object? cashIn = null,Object? cashOut = null,Object? cashRefunds = null,Object? rejectedCashRefunds = null,Object? expectedAmount = null,}) {
  return _then(_CashSummary(
openingAmount: null == openingAmount ? _self.openingAmount : openingAmount // ignore: cast_nullable_to_non_nullable
as Decimal,cashSales: null == cashSales ? _self.cashSales : cashSales // ignore: cast_nullable_to_non_nullable
as Decimal,cashSalesCount: null == cashSalesCount ? _self.cashSalesCount : cashSalesCount // ignore: cast_nullable_to_non_nullable
as int,mobileMoneySales: null == mobileMoneySales ? _self.mobileMoneySales : mobileMoneySales // ignore: cast_nullable_to_non_nullable
as Decimal,cashIn: null == cashIn ? _self.cashIn : cashIn // ignore: cast_nullable_to_non_nullable
as Decimal,cashOut: null == cashOut ? _self.cashOut : cashOut // ignore: cast_nullable_to_non_nullable
as Decimal,cashRefunds: null == cashRefunds ? _self.cashRefunds : cashRefunds // ignore: cast_nullable_to_non_nullable
as Decimal,rejectedCashRefunds: null == rejectedCashRefunds ? _self.rejectedCashRefunds : rejectedCashRefunds // ignore: cast_nullable_to_non_nullable
as Decimal,expectedAmount: null == expectedAmount ? _self.expectedAmount : expectedAmount // ignore: cast_nullable_to_non_nullable
as Decimal,
  ));
}


}

// dart format on
