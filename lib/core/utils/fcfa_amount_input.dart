import 'package:decimal/decimal.dart';
import 'package:flutter/services.dart';

/// Message affiché quand un montant FCFA contient une virgule ou un point.
const String fcfaWholeAmountError = 'Montant en francs entiers, sans virgule';

final RegExp _decimalSeparator = RegExp('[.,]');

/// Filtres de saisie d'un montant FCFA (francs entiers).
///
/// Garde chiffres, virgule et point ; retire le reste (espaces de milliers d'un
/// montant collé). La virgule et le point restent visibles pour que la saisie
/// soit refusée par [parseFcfaAmount] au lieu de recoller « 5000,5 » en 50005.
final List<TextInputFormatter> fcfaAmountInputFormatters = [
  FilteringTextInputFormatter.allow(RegExp('[0-9.,]')),
  LengthLimitingTextInputFormatter(10),
];

/// Vrai si [text] contient une virgule ou un point.
bool hasDecimalSeparator(String text) => text.contains(_decimalSeparator);

/// Montant FCFA en francs entiers, ou `null` si [text] est vide ou contient
/// une virgule ou un point.
Decimal? parseFcfaAmount(String text) {
  final trimmed = text.trim();
  if (trimmed.isEmpty || hasDecimalSeparator(trimmed)) return null;
  return Decimal.tryParse(trimmed);
}
