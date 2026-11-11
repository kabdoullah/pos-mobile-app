import 'package:flutter/services.dart';

/// Message affiché quand une quantité contient une virgule ou un point.
const String wholeQuantityError = 'Quantité entière, sans virgule';

final RegExp _decimalSeparator = RegExp('[.,]');

/// Filtres de saisie d'un nombre entier (quantité, montant en francs).
///
/// Garde chiffres, virgule et point ; retire le reste (espaces, lettres). La
/// virgule et le point restent visibles pour que la saisie soit refusée au
/// lieu de recoller « 2,5 » en 25.
List<TextInputFormatter> wholeNumberInputFormatters({required int maxLength}) =>
    [
      FilteringTextInputFormatter.allow(RegExp('[0-9.,]')),
      LengthLimitingTextInputFormatter(maxLength),
    ];

/// Vrai si [text] contient une virgule ou un point.
bool hasDecimalSeparator(String text) => text.contains(_decimalSeparator);

/// Quantité entière saisie, ou `null` si [text] est vide ou contient une
/// virgule ou un point.
int? parseWholeQuantity(String text) {
  final trimmed = text.trim();
  if (trimmed.isEmpty || hasDecimalSeparator(trimmed)) return null;
  return int.tryParse(trimmed);
}
