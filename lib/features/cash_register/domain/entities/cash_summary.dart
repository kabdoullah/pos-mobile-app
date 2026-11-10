import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'cash_summary.freezed.dart';

/// Récapitulatif du tiroir-caisse d'une session, avec le solde théorique.
@freezed
sealed class CashSummary with _$CashSummary {
  /// Crée un récapitulatif.
  const factory CashSummary({
    /// Fond de caisse à l'ouverture.
    required Decimal openingAmount,

    /// Part espèces des ventes.
    required Decimal cashSales,

    /// Nombre de ventes payées en espèces ou en mixte.
    required int cashSalesCount,

    /// Ventes payées par mobile money (hors tiroir).
    required Decimal mobileMoneySales,

    /// Total des entrées d'espèces.
    required Decimal cashIn,

    /// Total des sorties d'espèces.
    required Decimal cashOut,

    /// Remboursements en espèces comptabilisés.
    required Decimal cashRefunds,

    /// Remboursements en espèces rejetés par le serveur, non comptabilisés.
    required Decimal rejectedCashRefunds,

    /// Solde théorique du tiroir.
    required Decimal expectedAmount,
  }) = _CashSummary;
}
