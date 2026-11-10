import 'cash_movement.dart';

/// Valeur de l'API pour un sens de mouvement (`cash_in` / `cash_out`).
String cashMovementTypeToApi(CashMovementType type) => switch (type) {
  CashMovementType.cashIn => 'cash_in',
  CashMovementType.cashOut => 'cash_out',
};

/// Sens de mouvement correspondant à une valeur de l'API.
///
/// Lève une [ArgumentError] si la valeur est inconnue.
CashMovementType cashMovementTypeFromApi(String value) => switch (value) {
  'cash_in' => CashMovementType.cashIn,
  'cash_out' => CashMovementType.cashOut,
  _ => throw ArgumentError.value(value, 'value', 'Sens de mouvement inconnu'),
};

/// Valeur de l'API pour un motif (`top_up`, `float`, …).
String cashMovementReasonToApi(CashMovementReason reason) => switch (reason) {
  CashMovementReason.topUp => 'top_up',
  CashMovementReason.float => 'float',
  CashMovementReason.expense => 'expense',
  CashMovementReason.withdrawal => 'withdrawal',
  CashMovementReason.supplies => 'supplies',
  CashMovementReason.other => 'other',
};

/// Motif correspondant à une valeur de l'API.
///
/// Lève une [ArgumentError] si la valeur est inconnue.
CashMovementReason cashMovementReasonFromApi(String value) => switch (value) {
  'top_up' => CashMovementReason.topUp,
  'float' => CashMovementReason.float,
  'expense' => CashMovementReason.expense,
  'withdrawal' => CashMovementReason.withdrawal,
  'supplies' => CashMovementReason.supplies,
  'other' => CashMovementReason.other,
  _ => throw ArgumentError.value(value, 'value', 'Motif inconnu'),
};

/// Libellé français d'un motif.
String cashMovementReasonLabel(CashMovementReason reason) => switch (reason) {
  CashMovementReason.topUp => 'Réapprovisionnement',
  CashMovementReason.float => 'Fond de monnaie',
  CashMovementReason.expense => 'Dépense',
  CashMovementReason.withdrawal => 'Retrait',
  CashMovementReason.supplies => 'Fournitures',
  CashMovementReason.other => 'Autre',
};
