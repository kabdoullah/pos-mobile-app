import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'cash_session.dart';

part 'cash_movement.freezed.dart';

/// Sens d'un mouvement d'espèces.
enum CashMovementType {
  /// Entrée d'espèces dans le tiroir.
  cashIn,

  /// Sortie d'espèces du tiroir.
  cashOut,
}

/// Motif d'un mouvement d'espèces.
enum CashMovementReason {
  /// Réapprovisionnement (entrée).
  topUp,

  /// Fond de monnaie (entrée).
  float,

  /// Dépense (sortie).
  expense,

  /// Retrait (sortie).
  withdrawal,

  /// Achat de fournitures (sortie).
  supplies,

  /// Autre motif, commentaire obligatoire.
  other;

  /// Motifs autorisés pour le [type] de mouvement donné.
  static List<CashMovementReason> allowedFor(CashMovementType type) =>
      switch (type) {
        CashMovementType.cashIn => const [topUp, float, other],
        CashMovementType.cashOut => const [
          expense,
          withdrawal,
          supplies,
          other,
        ],
      };
}

/// Entrée ou sortie d'espèces rattachée à une session de caisse.
@freezed
sealed class CashMovement with _$CashMovement {
  /// Crée un mouvement de caisse.
  const factory CashMovement({
    /// UUID v4 généré côté client.
    required String id,

    /// Session de caisse parente.
    required String sessionId,

    /// Sens du mouvement.
    required CashMovementType type,

    /// Motif du mouvement.
    required CashMovementReason reason,

    /// Montant du mouvement.
    required Decimal amount,

    /// Date du mouvement (UTC).
    required DateTime createdAt,

    /// État de synchronisation.
    required CashSyncStatus syncStatus,

    /// Commentaire, obligatoire si le motif est `other`.
    String? note,

    /// Code du refus serveur, null sinon.
    String? rejectionCode,
  }) = _CashMovement;
}
