import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'cash_movement.dart';
import 'cash_session.dart';

part 'cash_session_detail.freezed.dart';

/// Récapitulatif du tiroir calculé par le serveur pour une session.
///
/// Session ouverte : [expectedAmount] est le solde courant. Session
/// clôturée : c'est le montant figé, et [lateImpact] l'effet des opérations
/// arrivées après la clôture.
@freezed
sealed class CashServerSummary with _$CashServerSummary {
  /// Crée un récapitulatif serveur.
  const factory CashServerSummary({
    /// Fond de caisse à l'ouverture.
    required Decimal openingAmount,

    /// Part espèces des ventes.
    required Decimal cashSales,

    /// Nombre de ventes avec une part espèces.
    required int cashSalesCount,

    /// Ventes payées par mobile money (hors tiroir).
    required Decimal mobileMoneySales,

    /// Total des entrées d'espèces.
    required Decimal cashIn,

    /// Total des sorties d'espèces.
    required Decimal cashOut,

    /// Remboursements en espèces.
    required Decimal cashRefunds,

    /// Solde théorique (courant, ou figé à la clôture).
    required Decimal expectedAmount,

    /// Recalcul actuel moins montant figé ; zéro pour une session ouverte.
    required Decimal lateImpact,

    /// Le montant figé diffère du solde affiché par l'app à la clôture.
    required bool serverRecalculated,
  }) = _CashServerSummary;
}

/// Session de caisse vue par le serveur : session, récapitulatif et
/// mouvements (du plus récent au plus ancien).
@freezed
sealed class CashSessionDetail with _$CashSessionDetail {
  /// Crée un détail de session.
  const factory CashSessionDetail({
    /// La session.
    required CashSession session,

    /// Récapitulatif calculé par le serveur.
    required CashServerSummary summary,

    /// Mouvements, du plus récent au plus ancien.
    required List<CashMovement> movements,
  }) = _CashSessionDetail;
}

/// Page de l'historique distant des sessions.
@freezed
sealed class CashSessionPage with _$CashSessionPage {
  /// Crée une page d'historique.
  const factory CashSessionPage({
    /// Sessions de la page, de la plus récente à la plus ancienne.
    required List<CashSession> items,

    /// Curseur opaque de la page suivante, null en fin d'historique.
    String? nextCursor,

    /// Il reste des sessions après cette page.
    required bool hasMore,
  }) = _CashSessionPage;
}
