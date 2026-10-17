import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'sale_return.freezed.dart';

/// Motif d'un retour client.
enum ReturnReason {
  /// Produit défectueux.
  defective,

  /// Produit endommagé.
  damaged,

  /// Mauvais produit.
  wrongProduct,

  /// Erreur de vente.
  saleError,

  /// Le client a changé d'avis.
  changedMind,

  /// Autre motif (commentaire obligatoire).
  other,
}

/// État de l'article rendu : seul un article revendable réintègre le stock.
enum ItemCondition {
  /// Revendable en l'état.
  resellable,

  /// Endommagé.
  damaged,

  /// Défectueux.
  defective,

  /// Non revendable.
  unsellable;

  /// True si l'article retourne dans le stock disponible à la vente.
  bool get restocks => this == ItemCondition.resellable;
}

/// Moyen de remboursement (remboursement manuel, confirmé au comptoir).
enum RefundMethod {
  /// Espèces.
  cash,

  /// Orange Money.
  orangeMoney,

  /// MTN mobile money.
  mtn,

  /// Wave.
  wave,
}

/// État de synchronisation d'un retour.
enum ReturnSyncStatus {
  /// Enregistré sur l'appareil, pas encore accepté par le serveur.
  pending,

  /// Accepté par le serveur (numéro de retour attribué).
  synced,

  /// Refusé définitivement par le serveur (ex. quantité déjà retournée sur un
  /// autre appareil) : à régulariser à la main.
  rejected,
}

/// Ligne d'un retour, rattachée à une ligne de vente.
@freezed
sealed class SaleReturnLine with _$SaleReturnLine {
  /// Crée une [SaleReturnLine].
  const factory SaleReturnLine({
    required String id,
    required String saleItemId,
    String? productId,
    required int quantity,
    required ItemCondition condition,

    /// L'article a réintégré le stock disponible.
    required bool restocked,
    required Decimal refundAmount,
  }) = _SaleReturnLine;
}

/// Retour client d'articles d'une vente — immuable une fois enregistré.
@freezed
sealed class SaleReturn with _$SaleReturn {
  /// Crée un [SaleReturn].
  const factory SaleReturn({
    required String id,
    required String saleId,

    /// Numéro attribué par le serveur (0 tant que non synchronisé).
    required int returnNumber,
    required ReturnReason reason,
    String? note,
    required RefundMethod refundMethod,

    /// Montant rendu au client.
    required Decimal refundAmount,
    required DateTime createdAt,
    required ReturnSyncStatus syncStatus,

    /// Code du refus serveur (`quantity_exceeded`…), si refusé.
    String? rejectionCode,
    required List<SaleReturnLine> lines,
  }) = _SaleReturn;
}
