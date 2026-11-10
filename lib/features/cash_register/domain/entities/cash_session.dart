import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'cash_session.freezed.dart';

/// Statut d'une session de caisse.
enum CashSessionStatus {
  /// Session en cours.
  open,

  /// Session clôturée.
  closed,
}

/// État de synchronisation d'une session ou d'un mouvement de caisse.
enum CashSyncStatus {
  /// Enregistré sur l'appareil, pas encore accepté par le serveur.
  pending,

  /// Accepté par le serveur.
  synced,

  /// Refusé définitivement par le serveur.
  rejected,
}

/// Session de caisse : du fond de caisse d'ouverture à la clôture.
@freezed
sealed class CashSession with _$CashSession {
  /// Crée une session de caisse.
  const factory CashSession({
    /// UUID v4 généré côté client.
    required String id,

    /// Appareil qui a ouvert la session.
    required String deviceId,

    /// Statut de la session.
    required CashSessionStatus status,

    /// Fond de caisse à l'ouverture.
    required Decimal openingAmount,

    /// Date d'ouverture (UTC).
    required DateTime openedAt,

    /// État de synchronisation.
    required CashSyncStatus syncStatus,

    /// Le serveur a recalculé un solde théorique différent de l'appareil.
    required bool serverRecalculated,

    /// Commentaire d'ouverture.
    String? openingNote,

    /// Solde théorique retenu par le serveur, null avant clôture.
    Decimal? expectedAmount,

    /// Solde théorique calculé sur l'appareil à la clôture.
    Decimal? clientExpectedAmount,

    /// Montant compté à la clôture.
    Decimal? countedAmount,

    /// Écart (compté moins théorique).
    Decimal? discrepancyAmount,

    /// Commentaire de clôture.
    String? closingNote,

    /// Date de clôture (UTC), identique à chaque retry.
    DateTime? closedAt,

    /// Code du refus serveur, null sinon.
    String? rejectionCode,
  }) = _CashSession;
}
