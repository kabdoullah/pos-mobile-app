import 'package:decimal/decimal.dart';

import 'denomination.dart';

/// Moment du comptage dans la session.
enum CashCountOperation {
  /// Fond de caisse, à l'ouverture.
  opening,

  /// Montant compté, à la clôture.
  closing,
}

/// Comptage du tiroir coupure par coupure (billetterie, ADR-0016).
///
/// Immuable : chaque saisie produit un nouveau comptage. Les quantités sont
/// des entiers ≥ 0 ; les totaux sont calculés en entiers FCFA puis exposés en
/// [Decimal] (les coupures sont entières, aucun arrondi).
class CashCount {
  CashCount._(Map<Denomination, int> quantities)
    : _quantities = Map.unmodifiable(
        Map.fromEntries(
          quantities.entries.toList()
            ..sort((a, b) => _compareDenominations(a.key, b.key)),
        ),
      );

  /// Comptage vierge : toutes les coupures de [fcfaDenominations] à zéro.
  factory CashCount.empty() =>
      CashCount._({for (final d in fcfaDenominations) d: 0});

  /// Comptage enregistré (base locale, serveur). Une coupure absente de
  /// [fcfaDenominations] est conservée telle quelle : un comptage validé ne
  /// se réécrit pas.
  ///
  /// Lève une [ArgumentError] si une quantité est négative ou une valeur
  /// faciale non positive.
  factory CashCount.fromQuantities(Map<Denomination, int> quantities) {
    for (final MapEntry(key: d, value: q) in quantities.entries) {
      if (d.value <= 0) {
        throw ArgumentError.value(d, 'denomination', 'Coupure invalide');
      }
      _checkQuantity(q);
    }
    return CashCount._(quantities);
  }

  /// Quantité maximale par coupure (même plafond que le serveur).
  static const maxQuantity = 100000;

  /// Au-delà, une quantité est signalée comme inhabituelle.
  static const unusualQuantity = 200;

  /// Au-delà (en FCFA), le sous-total d'une coupure est signalé comme
  /// inhabituel.
  static const unusualSubtotal = 1000000;

  final Map<Denomination, int> _quantities;

  /// Quantités par coupure, billets puis pièces, de la plus grande coupure à
  /// la plus petite.
  Map<Denomination, int> get quantities => _quantities;

  /// Quantité comptée pour [denomination], 0 si elle n'a pas été comptée.
  int quantityOf(Denomination denomination) => _quantities[denomination] ?? 0;

  /// Nouveau comptage avec [quantity] pour [denomination].
  ///
  /// Lève une [ArgumentError] si la coupure n'est pas proposée
  /// ([fcfaDenominations]) ou si la quantité est hors de 0…[maxQuantity].
  CashCount withQuantity(Denomination denomination, int quantity) {
    if (!fcfaDenominations.contains(denomination)) {
      throw ArgumentError.value(
        denomination,
        'denomination',
        'Coupure inconnue',
      );
    }
    _checkQuantity(quantity);
    return CashCount._({..._quantities, denomination: quantity});
  }

  /// Sous-total de [denomination] : valeur × quantité.
  Decimal subtotalOf(Denomination denomination) =>
      Decimal.fromInt(denomination.value * quantityOf(denomination));

  /// Total des billets.
  Decimal get billsTotal => Decimal.fromInt(_sum(DenominationType.bill));

  /// Total des pièces.
  Decimal get coinsTotal => Decimal.fromInt(_sum(DenominationType.coin));

  /// Montant total compté.
  Decimal get total => billsTotal + coinsTotal;

  /// Nombre de billets comptés.
  int get billCount => _count(DenominationType.bill);

  /// Nombre de pièces comptées.
  int get coinCount => _count(DenominationType.coin);

  /// Vrai si la quantité de [denomination] mérite une vérification (saisie
  /// probablement erronée). N'empêche jamais de valider.
  bool isUnusual(Denomination denomination) {
    final quantity = quantityOf(denomination);
    return quantity > unusualQuantity ||
        denomination.value * quantity > unusualSubtotal;
  }

  /// Quantité saisie au clavier : entier sans signe ni décimale, de 0 à
  /// [maxQuantity] ; null sinon. Un champ vide vaut 0.
  static int? parseQuantity(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return 0;
    if (!RegExp(r'^\d{1,6}$').hasMatch(trimmed)) return null;
    final quantity = int.parse(trimmed);
    return quantity > maxQuantity ? null : quantity;
  }

  int _sum(DenominationType type) => _quantities.entries
      .where((e) => e.key.type == type)
      .fold(0, (sum, e) => sum + e.key.value * e.value);

  int _count(DenominationType type) => _quantities.entries
      .where((e) => e.key.type == type)
      .fold(0, (sum, e) => sum + e.value);

  static void _checkQuantity(int quantity) {
    if (quantity < 0 || quantity > maxQuantity) {
      throw ArgumentError.value(quantity, 'quantity', 'Quantité invalide');
    }
  }

  /// Billets avant pièces, puis valeur décroissante.
  static int _compareDenominations(Denomination a, Denomination b) {
    final byType = a.type.index.compareTo(b.type.index);
    return byType != 0 ? byType : b.value.compareTo(a.value);
  }

  @override
  bool operator ==(Object other) {
    if (other is! CashCount || other._quantities.length != _quantities.length) {
      return false;
    }
    return _quantities.entries.every(
      (e) => other._quantities[e.key] == e.value,
    );
  }

  @override
  int get hashCode => Object.hashAllUnordered(
    _quantities.entries.map((e) => Object.hash(e.key, e.value)),
  );

  @override
  String toString() => 'CashCount($_quantities)';
}
