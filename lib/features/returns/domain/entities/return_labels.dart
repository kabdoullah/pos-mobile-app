import 'sale_return.dart';

/// Libellé affiché d'un motif de retour.
extension ReturnReasonLabel on ReturnReason {
  /// Libellé (ex. « Produit défectueux »).
  String get label => switch (this) {
    ReturnReason.defective => 'Produit défectueux',
    ReturnReason.damaged => 'Produit endommagé',
    ReturnReason.wrongProduct => 'Mauvais produit',
    ReturnReason.saleError => 'Erreur de vente',
    ReturnReason.changedMind => 'Changement d’avis',
    ReturnReason.other => 'Autre',
  };
}

/// Libellé affiché de l'état d'un article rendu.
extension ItemConditionLabel on ItemCondition {
  /// Libellé (ex. « Revendable »).
  String get label => switch (this) {
    ItemCondition.resellable => 'Revendable',
    ItemCondition.damaged => 'Endommagé',
    ItemCondition.defective => 'Défectueux',
    ItemCondition.unsellable => 'Non revendable',
  };
}

/// Libellé affiché d'un moyen de remboursement.
extension RefundMethodLabel on RefundMethod {
  /// Libellé (ex. « Orange Money »).
  String get label => switch (this) {
    RefundMethod.cash => 'Espèces',
    RefundMethod.orangeMoney => 'Orange Money',
    RefundMethod.mtn => 'MTN',
    RefundMethod.wave => 'Wave',
  };
}

/// Explication d'un refus du serveur, à afficher au commerçant.
String returnRejectionMessage(String? code) => switch (code) {
  'quantity_exceeded' =>
    'Ces articles ont déjà été retournés sur un autre appareil.',
  'amount_mismatch' => 'Montant refusé par le serveur.',
  'sale_not_found' || 'item_not_in_sale' => 'Vente inconnue du serveur.',
  _ => 'Retour refusé par le serveur.',
};
