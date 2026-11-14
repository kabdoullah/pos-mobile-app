/// Nature d'une coupure : billet ou pièce.
enum DenominationType {
  /// Billet.
  bill,

  /// Pièce.
  coin,
}

/// Coupure de franc CFA, identifiée par sa nature et sa valeur : 500 existe
/// en billet et en pièce.
class Denomination {
  /// Crée une coupure de [value] FCFA.
  const Denomination(this.type, this.value);

  /// Billet ou pièce.
  final DenominationType type;

  /// Valeur faciale en FCFA (entier strictement positif).
  final int value;

  /// Vrai pour un billet.
  bool get isBill => type == DenominationType.bill;

  @override
  bool operator ==(Object other) =>
      other is Denomination && other.type == type && other.value == value;

  @override
  int get hashCode => Object.hash(type, value);

  @override
  String toString() => 'Denomination(${type.name}, $value)';
}

/// Coupures proposées par la billetterie (gamme BCEAO), billets puis pièces,
/// de la plus grande à la plus petite : l'ordre d'affichage.
///
/// Seule définition côté app. Le serveur valide la même liste
/// (`DENOMINATIONS`, cash_register/schemas.py, ADR-0016) : une coupure
/// ajoutée ici doit l'être d'abord côté serveur.
const fcfaDenominations = <Denomination>[
  Denomination(DenominationType.bill, 10000),
  Denomination(DenominationType.bill, 5000),
  Denomination(DenominationType.bill, 2000),
  Denomination(DenominationType.bill, 1000),
  Denomination(DenominationType.bill, 500),
  Denomination(DenominationType.coin, 500),
  Denomination(DenominationType.coin, 250),
  Denomination(DenominationType.coin, 200),
  Denomination(DenominationType.coin, 100),
  Denomination(DenominationType.coin, 50),
  Denomination(DenominationType.coin, 25),
  Denomination(DenominationType.coin, 10),
  Denomination(DenominationType.coin, 5),
];

/// Valeur de l'API pour une nature de coupure (`bill` / `coin`).
String denominationTypeToApi(DenominationType type) => switch (type) {
  DenominationType.bill => 'bill',
  DenominationType.coin => 'coin',
};

/// Nature de coupure correspondant à une valeur de l'API.
///
/// Lève une [ArgumentError] si la valeur est inconnue.
DenominationType denominationTypeFromApi(String value) => switch (value) {
  'bill' => DenominationType.bill,
  'coin' => DenominationType.coin,
  _ => throw ArgumentError.value(value, 'value', 'Nature de coupure inconnue'),
};
