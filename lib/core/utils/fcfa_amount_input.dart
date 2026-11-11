import 'package:decimal/decimal.dart';
import 'package:flutter/services.dart';

import 'whole_number_input.dart';

export 'whole_number_input.dart' show hasDecimalSeparator;

/// Message affiché quand un montant FCFA contient une virgule ou un point.
const String fcfaWholeAmountError = 'Montant en francs entiers, sans virgule';

/// Filtres de saisie d'un montant FCFA (francs entiers).
///
/// Mêmes règles qu'une quantité : la virgule reste visible pour que la saisie
/// soit refusée par [parseFcfaAmount] au lieu de recoller « 5000,5 » en 50005 ;
/// les espaces de milliers d'un montant collé sont retirés.
final List<TextInputFormatter> fcfaAmountInputFormatters =
    wholeNumberInputFormatters(maxLength: 10);

/// Montant FCFA en francs entiers, ou `null` si [text] est vide ou contient
/// une virgule ou un point.
Decimal? parseFcfaAmount(String text) {
  final trimmed = text.trim();
  if (trimmed.isEmpty || hasDecimalSeparator(trimmed)) return null;
  return Decimal.tryParse(trimmed);
}
