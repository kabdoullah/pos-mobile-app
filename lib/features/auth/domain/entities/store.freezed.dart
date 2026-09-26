// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'store.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Store {

/// Nom de la boutique (obligatoire).
 String get name;/// Adresse de la boutique (optionnelle).
 String? get address;/// Numéro de Compte Contribuable DGI (optional).
 String? get ncc;/// Indique si la boutique est assujettie à la TVA (par défaut : false).
 bool get isSubjectToVat;/// Texte de pied de reçu personnalisé (optionnel).
 String? get receiptFooterText;
/// Create a copy of Store
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StoreCopyWith<Store> get copyWith => _$StoreCopyWithImpl<Store>(this as Store, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Store&&(identical(other.name, name) || other.name == name)&&(identical(other.address, address) || other.address == address)&&(identical(other.ncc, ncc) || other.ncc == ncc)&&(identical(other.isSubjectToVat, isSubjectToVat) || other.isSubjectToVat == isSubjectToVat)&&(identical(other.receiptFooterText, receiptFooterText) || other.receiptFooterText == receiptFooterText));
}


@override
int get hashCode => Object.hash(runtimeType,name,address,ncc,isSubjectToVat,receiptFooterText);

@override
String toString() {
  return 'Store(name: $name, address: $address, ncc: $ncc, isSubjectToVat: $isSubjectToVat, receiptFooterText: $receiptFooterText)';
}


}

/// @nodoc
abstract mixin class $StoreCopyWith<$Res>  {
  factory $StoreCopyWith(Store value, $Res Function(Store) _then) = _$StoreCopyWithImpl;
@useResult
$Res call({
 String name, String? address, String? ncc, bool isSubjectToVat, String? receiptFooterText
});




}
/// @nodoc
class _$StoreCopyWithImpl<$Res>
    implements $StoreCopyWith<$Res> {
  _$StoreCopyWithImpl(this._self, this._then);

  final Store _self;
  final $Res Function(Store) _then;

/// Create a copy of Store
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? address = freezed,Object? ncc = freezed,Object? isSubjectToVat = null,Object? receiptFooterText = freezed,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,ncc: freezed == ncc ? _self.ncc : ncc // ignore: cast_nullable_to_non_nullable
as String?,isSubjectToVat: null == isSubjectToVat ? _self.isSubjectToVat : isSubjectToVat // ignore: cast_nullable_to_non_nullable
as bool,receiptFooterText: freezed == receiptFooterText ? _self.receiptFooterText : receiptFooterText // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Store].
extension StorePatterns on Store {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Store value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Store() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Store value)  $default,){
final _that = this;
switch (_that) {
case _Store():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Store value)?  $default,){
final _that = this;
switch (_that) {
case _Store() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String? address,  String? ncc,  bool isSubjectToVat,  String? receiptFooterText)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Store() when $default != null:
return $default(_that.name,_that.address,_that.ncc,_that.isSubjectToVat,_that.receiptFooterText);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String? address,  String? ncc,  bool isSubjectToVat,  String? receiptFooterText)  $default,) {final _that = this;
switch (_that) {
case _Store():
return $default(_that.name,_that.address,_that.ncc,_that.isSubjectToVat,_that.receiptFooterText);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String? address,  String? ncc,  bool isSubjectToVat,  String? receiptFooterText)?  $default,) {final _that = this;
switch (_that) {
case _Store() when $default != null:
return $default(_that.name,_that.address,_that.ncc,_that.isSubjectToVat,_that.receiptFooterText);case _:
  return null;

}
}

}

/// @nodoc


class _Store implements Store {
  const _Store({required this.name, this.address, this.ncc, required this.isSubjectToVat, this.receiptFooterText});
  

/// Nom de la boutique (obligatoire).
@override final  String name;
/// Adresse de la boutique (optionnelle).
@override final  String? address;
/// Numéro de Compte Contribuable DGI (optional).
@override final  String? ncc;
/// Indique si la boutique est assujettie à la TVA (par défaut : false).
@override final  bool isSubjectToVat;
/// Texte de pied de reçu personnalisé (optionnel).
@override final  String? receiptFooterText;

/// Create a copy of Store
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StoreCopyWith<_Store> get copyWith => __$StoreCopyWithImpl<_Store>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Store&&(identical(other.name, name) || other.name == name)&&(identical(other.address, address) || other.address == address)&&(identical(other.ncc, ncc) || other.ncc == ncc)&&(identical(other.isSubjectToVat, isSubjectToVat) || other.isSubjectToVat == isSubjectToVat)&&(identical(other.receiptFooterText, receiptFooterText) || other.receiptFooterText == receiptFooterText));
}


@override
int get hashCode => Object.hash(runtimeType,name,address,ncc,isSubjectToVat,receiptFooterText);

@override
String toString() {
  return 'Store(name: $name, address: $address, ncc: $ncc, isSubjectToVat: $isSubjectToVat, receiptFooterText: $receiptFooterText)';
}


}

/// @nodoc
abstract mixin class _$StoreCopyWith<$Res> implements $StoreCopyWith<$Res> {
  factory _$StoreCopyWith(_Store value, $Res Function(_Store) _then) = __$StoreCopyWithImpl;
@override @useResult
$Res call({
 String name, String? address, String? ncc, bool isSubjectToVat, String? receiptFooterText
});




}
/// @nodoc
class __$StoreCopyWithImpl<$Res>
    implements _$StoreCopyWith<$Res> {
  __$StoreCopyWithImpl(this._self, this._then);

  final _Store _self;
  final $Res Function(_Store) _then;

/// Create a copy of Store
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? address = freezed,Object? ncc = freezed,Object? isSubjectToVat = null,Object? receiptFooterText = freezed,}) {
  return _then(_Store(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,ncc: freezed == ncc ? _self.ncc : ncc // ignore: cast_nullable_to_non_nullable
as String?,isSubjectToVat: null == isSubjectToVat ? _self.isSubjectToVat : isSubjectToVat // ignore: cast_nullable_to_non_nullable
as bool,receiptFooterText: freezed == receiptFooterText ? _self.receiptFooterText : receiptFooterText // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
