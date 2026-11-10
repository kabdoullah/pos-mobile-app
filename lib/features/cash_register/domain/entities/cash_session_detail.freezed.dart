// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cash_session_detail.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CashServerSummary {

/// Fond de caisse à l'ouverture.
 Decimal get openingAmount;/// Part espèces des ventes.
 Decimal get cashSales;/// Nombre de ventes avec une part espèces.
 int get cashSalesCount;/// Ventes payées par mobile money (hors tiroir).
 Decimal get mobileMoneySales;/// Total des entrées d'espèces.
 Decimal get cashIn;/// Total des sorties d'espèces.
 Decimal get cashOut;/// Remboursements en espèces.
 Decimal get cashRefunds;/// Solde théorique (courant, ou figé à la clôture).
 Decimal get expectedAmount;/// Recalcul actuel moins montant figé ; zéro pour une session ouverte.
 Decimal get lateImpact;/// Le montant figé diffère du solde affiché par l'app à la clôture.
 bool get serverRecalculated;
/// Create a copy of CashServerSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CashServerSummaryCopyWith<CashServerSummary> get copyWith => _$CashServerSummaryCopyWithImpl<CashServerSummary>(this as CashServerSummary, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CashServerSummary&&(identical(other.openingAmount, openingAmount) || other.openingAmount == openingAmount)&&(identical(other.cashSales, cashSales) || other.cashSales == cashSales)&&(identical(other.cashSalesCount, cashSalesCount) || other.cashSalesCount == cashSalesCount)&&(identical(other.mobileMoneySales, mobileMoneySales) || other.mobileMoneySales == mobileMoneySales)&&(identical(other.cashIn, cashIn) || other.cashIn == cashIn)&&(identical(other.cashOut, cashOut) || other.cashOut == cashOut)&&(identical(other.cashRefunds, cashRefunds) || other.cashRefunds == cashRefunds)&&(identical(other.expectedAmount, expectedAmount) || other.expectedAmount == expectedAmount)&&(identical(other.lateImpact, lateImpact) || other.lateImpact == lateImpact)&&(identical(other.serverRecalculated, serverRecalculated) || other.serverRecalculated == serverRecalculated));
}


@override
int get hashCode => Object.hash(runtimeType,openingAmount,cashSales,cashSalesCount,mobileMoneySales,cashIn,cashOut,cashRefunds,expectedAmount,lateImpact,serverRecalculated);

@override
String toString() {
  return 'CashServerSummary(openingAmount: $openingAmount, cashSales: $cashSales, cashSalesCount: $cashSalesCount, mobileMoneySales: $mobileMoneySales, cashIn: $cashIn, cashOut: $cashOut, cashRefunds: $cashRefunds, expectedAmount: $expectedAmount, lateImpact: $lateImpact, serverRecalculated: $serverRecalculated)';
}


}

/// @nodoc
abstract mixin class $CashServerSummaryCopyWith<$Res>  {
  factory $CashServerSummaryCopyWith(CashServerSummary value, $Res Function(CashServerSummary) _then) = _$CashServerSummaryCopyWithImpl;
@useResult
$Res call({
 Decimal openingAmount, Decimal cashSales, int cashSalesCount, Decimal mobileMoneySales, Decimal cashIn, Decimal cashOut, Decimal cashRefunds, Decimal expectedAmount, Decimal lateImpact, bool serverRecalculated
});




}
/// @nodoc
class _$CashServerSummaryCopyWithImpl<$Res>
    implements $CashServerSummaryCopyWith<$Res> {
  _$CashServerSummaryCopyWithImpl(this._self, this._then);

  final CashServerSummary _self;
  final $Res Function(CashServerSummary) _then;

/// Create a copy of CashServerSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? openingAmount = null,Object? cashSales = null,Object? cashSalesCount = null,Object? mobileMoneySales = null,Object? cashIn = null,Object? cashOut = null,Object? cashRefunds = null,Object? expectedAmount = null,Object? lateImpact = null,Object? serverRecalculated = null,}) {
  return _then(CashServerSummary(
openingAmount: null == openingAmount ? _self.openingAmount : openingAmount // ignore: cast_nullable_to_non_nullable
as Decimal,cashSales: null == cashSales ? _self.cashSales : cashSales // ignore: cast_nullable_to_non_nullable
as Decimal,cashSalesCount: null == cashSalesCount ? _self.cashSalesCount : cashSalesCount // ignore: cast_nullable_to_non_nullable
as int,mobileMoneySales: null == mobileMoneySales ? _self.mobileMoneySales : mobileMoneySales // ignore: cast_nullable_to_non_nullable
as Decimal,cashIn: null == cashIn ? _self.cashIn : cashIn // ignore: cast_nullable_to_non_nullable
as Decimal,cashOut: null == cashOut ? _self.cashOut : cashOut // ignore: cast_nullable_to_non_nullable
as Decimal,cashRefunds: null == cashRefunds ? _self.cashRefunds : cashRefunds // ignore: cast_nullable_to_non_nullable
as Decimal,expectedAmount: null == expectedAmount ? _self.expectedAmount : expectedAmount // ignore: cast_nullable_to_non_nullable
as Decimal,lateImpact: null == lateImpact ? _self.lateImpact : lateImpact // ignore: cast_nullable_to_non_nullable
as Decimal,serverRecalculated: null == serverRecalculated ? _self.serverRecalculated : serverRecalculated // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [CashServerSummary].
extension CashServerSummaryPatterns on CashServerSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CashServerSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CashServerSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CashServerSummary value)  $default,){
final _that = this;
switch (_that) {
case _CashServerSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CashServerSummary value)?  $default,){
final _that = this;
switch (_that) {
case _CashServerSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Decimal openingAmount,  Decimal cashSales,  int cashSalesCount,  Decimal mobileMoneySales,  Decimal cashIn,  Decimal cashOut,  Decimal cashRefunds,  Decimal expectedAmount,  Decimal lateImpact,  bool serverRecalculated)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CashServerSummary() when $default != null:
return $default(_that.openingAmount,_that.cashSales,_that.cashSalesCount,_that.mobileMoneySales,_that.cashIn,_that.cashOut,_that.cashRefunds,_that.expectedAmount,_that.lateImpact,_that.serverRecalculated);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Decimal openingAmount,  Decimal cashSales,  int cashSalesCount,  Decimal mobileMoneySales,  Decimal cashIn,  Decimal cashOut,  Decimal cashRefunds,  Decimal expectedAmount,  Decimal lateImpact,  bool serverRecalculated)  $default,) {final _that = this;
switch (_that) {
case _CashServerSummary():
return $default(_that.openingAmount,_that.cashSales,_that.cashSalesCount,_that.mobileMoneySales,_that.cashIn,_that.cashOut,_that.cashRefunds,_that.expectedAmount,_that.lateImpact,_that.serverRecalculated);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Decimal openingAmount,  Decimal cashSales,  int cashSalesCount,  Decimal mobileMoneySales,  Decimal cashIn,  Decimal cashOut,  Decimal cashRefunds,  Decimal expectedAmount,  Decimal lateImpact,  bool serverRecalculated)?  $default,) {final _that = this;
switch (_that) {
case _CashServerSummary() when $default != null:
return $default(_that.openingAmount,_that.cashSales,_that.cashSalesCount,_that.mobileMoneySales,_that.cashIn,_that.cashOut,_that.cashRefunds,_that.expectedAmount,_that.lateImpact,_that.serverRecalculated);case _:
  return null;

}
}

}

/// @nodoc


class _CashServerSummary implements CashServerSummary {
  const _CashServerSummary({required this.openingAmount, required this.cashSales, required this.cashSalesCount, required this.mobileMoneySales, required this.cashIn, required this.cashOut, required this.cashRefunds, required this.expectedAmount, required this.lateImpact, required this.serverRecalculated});
  

/// Fond de caisse à l'ouverture.
@override final  Decimal openingAmount;
/// Part espèces des ventes.
@override final  Decimal cashSales;
/// Nombre de ventes avec une part espèces.
@override final  int cashSalesCount;
/// Ventes payées par mobile money (hors tiroir).
@override final  Decimal mobileMoneySales;
/// Total des entrées d'espèces.
@override final  Decimal cashIn;
/// Total des sorties d'espèces.
@override final  Decimal cashOut;
/// Remboursements en espèces.
@override final  Decimal cashRefunds;
/// Solde théorique (courant, ou figé à la clôture).
@override final  Decimal expectedAmount;
/// Recalcul actuel moins montant figé ; zéro pour une session ouverte.
@override final  Decimal lateImpact;
/// Le montant figé diffère du solde affiché par l'app à la clôture.
@override final  bool serverRecalculated;

/// Create a copy of CashServerSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CashServerSummaryCopyWith<_CashServerSummary> get copyWith => __$CashServerSummaryCopyWithImpl<_CashServerSummary>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CashServerSummary&&(identical(other.openingAmount, openingAmount) || other.openingAmount == openingAmount)&&(identical(other.cashSales, cashSales) || other.cashSales == cashSales)&&(identical(other.cashSalesCount, cashSalesCount) || other.cashSalesCount == cashSalesCount)&&(identical(other.mobileMoneySales, mobileMoneySales) || other.mobileMoneySales == mobileMoneySales)&&(identical(other.cashIn, cashIn) || other.cashIn == cashIn)&&(identical(other.cashOut, cashOut) || other.cashOut == cashOut)&&(identical(other.cashRefunds, cashRefunds) || other.cashRefunds == cashRefunds)&&(identical(other.expectedAmount, expectedAmount) || other.expectedAmount == expectedAmount)&&(identical(other.lateImpact, lateImpact) || other.lateImpact == lateImpact)&&(identical(other.serverRecalculated, serverRecalculated) || other.serverRecalculated == serverRecalculated));
}


@override
int get hashCode => Object.hash(runtimeType,openingAmount,cashSales,cashSalesCount,mobileMoneySales,cashIn,cashOut,cashRefunds,expectedAmount,lateImpact,serverRecalculated);

@override
String toString() {
  return 'CashServerSummary(openingAmount: $openingAmount, cashSales: $cashSales, cashSalesCount: $cashSalesCount, mobileMoneySales: $mobileMoneySales, cashIn: $cashIn, cashOut: $cashOut, cashRefunds: $cashRefunds, expectedAmount: $expectedAmount, lateImpact: $lateImpact, serverRecalculated: $serverRecalculated)';
}


}

/// @nodoc
abstract mixin class _$CashServerSummaryCopyWith<$Res> implements $CashServerSummaryCopyWith<$Res> {
  factory _$CashServerSummaryCopyWith(_CashServerSummary value, $Res Function(_CashServerSummary) _then) = __$CashServerSummaryCopyWithImpl;
@override @useResult
$Res call({
 Decimal openingAmount, Decimal cashSales, int cashSalesCount, Decimal mobileMoneySales, Decimal cashIn, Decimal cashOut, Decimal cashRefunds, Decimal expectedAmount, Decimal lateImpact, bool serverRecalculated
});




}
/// @nodoc
class __$CashServerSummaryCopyWithImpl<$Res>
    implements _$CashServerSummaryCopyWith<$Res> {
  __$CashServerSummaryCopyWithImpl(this._self, this._then);

  final _CashServerSummary _self;
  final $Res Function(_CashServerSummary) _then;

/// Create a copy of CashServerSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? openingAmount = null,Object? cashSales = null,Object? cashSalesCount = null,Object? mobileMoneySales = null,Object? cashIn = null,Object? cashOut = null,Object? cashRefunds = null,Object? expectedAmount = null,Object? lateImpact = null,Object? serverRecalculated = null,}) {
  return _then(_CashServerSummary(
openingAmount: null == openingAmount ? _self.openingAmount : openingAmount // ignore: cast_nullable_to_non_nullable
as Decimal,cashSales: null == cashSales ? _self.cashSales : cashSales // ignore: cast_nullable_to_non_nullable
as Decimal,cashSalesCount: null == cashSalesCount ? _self.cashSalesCount : cashSalesCount // ignore: cast_nullable_to_non_nullable
as int,mobileMoneySales: null == mobileMoneySales ? _self.mobileMoneySales : mobileMoneySales // ignore: cast_nullable_to_non_nullable
as Decimal,cashIn: null == cashIn ? _self.cashIn : cashIn // ignore: cast_nullable_to_non_nullable
as Decimal,cashOut: null == cashOut ? _self.cashOut : cashOut // ignore: cast_nullable_to_non_nullable
as Decimal,cashRefunds: null == cashRefunds ? _self.cashRefunds : cashRefunds // ignore: cast_nullable_to_non_nullable
as Decimal,expectedAmount: null == expectedAmount ? _self.expectedAmount : expectedAmount // ignore: cast_nullable_to_non_nullable
as Decimal,lateImpact: null == lateImpact ? _self.lateImpact : lateImpact // ignore: cast_nullable_to_non_nullable
as Decimal,serverRecalculated: null == serverRecalculated ? _self.serverRecalculated : serverRecalculated // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
mixin _$CashSessionDetail {

/// La session.
 CashSession get session;/// Récapitulatif calculé par le serveur.
 CashServerSummary get summary;/// Mouvements, du plus récent au plus ancien.
 List<CashMovement> get movements;
/// Create a copy of CashSessionDetail
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CashSessionDetailCopyWith<CashSessionDetail> get copyWith => _$CashSessionDetailCopyWithImpl<CashSessionDetail>(this as CashSessionDetail, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CashSessionDetail&&(identical(other.session, session) || other.session == session)&&(identical(other.summary, summary) || other.summary == summary)&&const DeepCollectionEquality().equals(other.movements, movements));
}


@override
int get hashCode => Object.hash(runtimeType,session,summary,const DeepCollectionEquality().hash(movements));

@override
String toString() {
  return 'CashSessionDetail(session: $session, summary: $summary, movements: $movements)';
}


}

/// @nodoc
abstract mixin class $CashSessionDetailCopyWith<$Res>  {
  factory $CashSessionDetailCopyWith(CashSessionDetail value, $Res Function(CashSessionDetail) _then) = _$CashSessionDetailCopyWithImpl;
@useResult
$Res call({
 CashSession session, CashServerSummary summary, List<CashMovement> movements
});


$CashSessionCopyWith<$Res> get session;$CashServerSummaryCopyWith<$Res> get summary;

}
/// @nodoc
class _$CashSessionDetailCopyWithImpl<$Res>
    implements $CashSessionDetailCopyWith<$Res> {
  _$CashSessionDetailCopyWithImpl(this._self, this._then);

  final CashSessionDetail _self;
  final $Res Function(CashSessionDetail) _then;

/// Create a copy of CashSessionDetail
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? session = null,Object? summary = null,Object? movements = null,}) {
  return _then(CashSessionDetail(
session: null == session ? _self.session : session // ignore: cast_nullable_to_non_nullable
as CashSession,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as CashServerSummary,movements: null == movements ? _self.movements : movements // ignore: cast_nullable_to_non_nullable
as List<CashMovement>,
  ));
}
/// Create a copy of CashSessionDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CashSessionCopyWith<$Res> get session {
  
  return $CashSessionCopyWith<$Res>(_self.session, (value) {
    return _then(_self.copyWith(session: value));
  });
}/// Create a copy of CashSessionDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CashServerSummaryCopyWith<$Res> get summary {
  
  return $CashServerSummaryCopyWith<$Res>(_self.summary, (value) {
    return _then(_self.copyWith(summary: value));
  });
}
}


/// Adds pattern-matching-related methods to [CashSessionDetail].
extension CashSessionDetailPatterns on CashSessionDetail {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CashSessionDetail value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CashSessionDetail() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CashSessionDetail value)  $default,){
final _that = this;
switch (_that) {
case _CashSessionDetail():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CashSessionDetail value)?  $default,){
final _that = this;
switch (_that) {
case _CashSessionDetail() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( CashSession session,  CashServerSummary summary,  List<CashMovement> movements)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CashSessionDetail() when $default != null:
return $default(_that.session,_that.summary,_that.movements);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( CashSession session,  CashServerSummary summary,  List<CashMovement> movements)  $default,) {final _that = this;
switch (_that) {
case _CashSessionDetail():
return $default(_that.session,_that.summary,_that.movements);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( CashSession session,  CashServerSummary summary,  List<CashMovement> movements)?  $default,) {final _that = this;
switch (_that) {
case _CashSessionDetail() when $default != null:
return $default(_that.session,_that.summary,_that.movements);case _:
  return null;

}
}

}

/// @nodoc


class _CashSessionDetail implements CashSessionDetail {
  const _CashSessionDetail({required this.session, required this.summary, required  List<CashMovement> movements}): _movements = movements;
  

/// La session.
@override final  CashSession session;
/// Récapitulatif calculé par le serveur.
@override final  CashServerSummary summary;
/// Mouvements, du plus récent au plus ancien.
 final  List<CashMovement> _movements;
/// Mouvements, du plus récent au plus ancien.
@override List<CashMovement> get movements {
  if (_movements is EqualUnmodifiableListView) return _movements;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_movements);
}


/// Create a copy of CashSessionDetail
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CashSessionDetailCopyWith<_CashSessionDetail> get copyWith => __$CashSessionDetailCopyWithImpl<_CashSessionDetail>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CashSessionDetail&&(identical(other.session, session) || other.session == session)&&(identical(other.summary, summary) || other.summary == summary)&&const DeepCollectionEquality().equals(other._movements, _movements));
}


@override
int get hashCode => Object.hash(runtimeType,session,summary,const DeepCollectionEquality().hash(_movements));

@override
String toString() {
  return 'CashSessionDetail(session: $session, summary: $summary, movements: $movements)';
}


}

/// @nodoc
abstract mixin class _$CashSessionDetailCopyWith<$Res> implements $CashSessionDetailCopyWith<$Res> {
  factory _$CashSessionDetailCopyWith(_CashSessionDetail value, $Res Function(_CashSessionDetail) _then) = __$CashSessionDetailCopyWithImpl;
@override @useResult
$Res call({
 CashSession session, CashServerSummary summary, List<CashMovement> movements
});


@override $CashSessionCopyWith<$Res> get session;@override $CashServerSummaryCopyWith<$Res> get summary;

}
/// @nodoc
class __$CashSessionDetailCopyWithImpl<$Res>
    implements _$CashSessionDetailCopyWith<$Res> {
  __$CashSessionDetailCopyWithImpl(this._self, this._then);

  final _CashSessionDetail _self;
  final $Res Function(_CashSessionDetail) _then;

/// Create a copy of CashSessionDetail
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? session = null,Object? summary = null,Object? movements = null,}) {
  return _then(_CashSessionDetail(
session: null == session ? _self.session : session // ignore: cast_nullable_to_non_nullable
as CashSession,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as CashServerSummary,movements: null == movements ? _self._movements : movements // ignore: cast_nullable_to_non_nullable
as List<CashMovement>,
  ));
}

/// Create a copy of CashSessionDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CashSessionCopyWith<$Res> get session {
  
  return $CashSessionCopyWith<$Res>(_self.session, (value) {
    return _then(_self.copyWith(session: value));
  });
}/// Create a copy of CashSessionDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CashServerSummaryCopyWith<$Res> get summary {
  
  return $CashServerSummaryCopyWith<$Res>(_self.summary, (value) {
    return _then(_self.copyWith(summary: value));
  });
}
}

/// @nodoc
mixin _$CashSessionPage {

/// Sessions de la page, de la plus récente à la plus ancienne.
 List<CashSession> get items;/// Curseur opaque de la page suivante, null en fin d'historique.
 String? get nextCursor;/// Il reste des sessions après cette page.
 bool get hasMore;
/// Create a copy of CashSessionPage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CashSessionPageCopyWith<CashSessionPage> get copyWith => _$CashSessionPageCopyWithImpl<CashSessionPage>(this as CashSessionPage, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CashSessionPage&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(items),nextCursor,hasMore);

@override
String toString() {
  return 'CashSessionPage(items: $items, nextCursor: $nextCursor, hasMore: $hasMore)';
}


}

/// @nodoc
abstract mixin class $CashSessionPageCopyWith<$Res>  {
  factory $CashSessionPageCopyWith(CashSessionPage value, $Res Function(CashSessionPage) _then) = _$CashSessionPageCopyWithImpl;
@useResult
$Res call({
 List<CashSession> items, String? nextCursor, bool hasMore
});




}
/// @nodoc
class _$CashSessionPageCopyWithImpl<$Res>
    implements $CashSessionPageCopyWith<$Res> {
  _$CashSessionPageCopyWithImpl(this._self, this._then);

  final CashSessionPage _self;
  final $Res Function(CashSessionPage) _then;

/// Create a copy of CashSessionPage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? nextCursor = freezed,Object? hasMore = null,}) {
  return _then(CashSessionPage(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<CashSession>,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [CashSessionPage].
extension CashSessionPagePatterns on CashSessionPage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CashSessionPage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CashSessionPage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CashSessionPage value)  $default,){
final _that = this;
switch (_that) {
case _CashSessionPage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CashSessionPage value)?  $default,){
final _that = this;
switch (_that) {
case _CashSessionPage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<CashSession> items,  String? nextCursor,  bool hasMore)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CashSessionPage() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<CashSession> items,  String? nextCursor,  bool hasMore)  $default,) {final _that = this;
switch (_that) {
case _CashSessionPage():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<CashSession> items,  String? nextCursor,  bool hasMore)?  $default,) {final _that = this;
switch (_that) {
case _CashSessionPage() when $default != null:
return $default(_that.items,_that.nextCursor,_that.hasMore);case _:
  return null;

}
}

}

/// @nodoc


class _CashSessionPage implements CashSessionPage {
  const _CashSessionPage({required  List<CashSession> items, this.nextCursor, required this.hasMore}): _items = items;
  

/// Sessions de la page, de la plus récente à la plus ancienne.
 final  List<CashSession> _items;
/// Sessions de la page, de la plus récente à la plus ancienne.
@override List<CashSession> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

/// Curseur opaque de la page suivante, null en fin d'historique.
@override final  String? nextCursor;
/// Il reste des sessions après cette page.
@override final  bool hasMore;

/// Create a copy of CashSessionPage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CashSessionPageCopyWith<_CashSessionPage> get copyWith => __$CashSessionPageCopyWithImpl<_CashSessionPage>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CashSessionPage&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),nextCursor,hasMore);

@override
String toString() {
  return 'CashSessionPage(items: $items, nextCursor: $nextCursor, hasMore: $hasMore)';
}


}

/// @nodoc
abstract mixin class _$CashSessionPageCopyWith<$Res> implements $CashSessionPageCopyWith<$Res> {
  factory _$CashSessionPageCopyWith(_CashSessionPage value, $Res Function(_CashSessionPage) _then) = __$CashSessionPageCopyWithImpl;
@override @useResult
$Res call({
 List<CashSession> items, String? nextCursor, bool hasMore
});




}
/// @nodoc
class __$CashSessionPageCopyWithImpl<$Res>
    implements _$CashSessionPageCopyWith<$Res> {
  __$CashSessionPageCopyWithImpl(this._self, this._then);

  final _CashSessionPage _self;
  final $Res Function(_CashSessionPage) _then;

/// Create a copy of CashSessionPage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? nextCursor = freezed,Object? hasMore = null,}) {
  return _then(_CashSessionPage(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<CashSession>,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
