import 'package:decimal/decimal.dart';

import '../../returns/domain/entities/sale_return.dart';
import '../../sales/domain/entities/sale.dart';
import 'entities/cash_movement.dart';
import 'entities/cash_summary.dart';

/// Vente vue par le calcul du tiroir-caisse.
class CashSaleLine {
  /// Crée une ligne de vente.
  const CashSaleLine({
    required this.paymentMethod,
    required this.totalAmount,
    this.cashAmount,
  });

  /// Moyen de paiement de la vente.
  final PaymentMethod paymentMethod;

  /// Total encaissé.
  final Decimal totalAmount;

  /// Part en espèces d'un paiement mixte.
  final Decimal? cashAmount;
}

/// Retour vu par le calcul du tiroir-caisse.
class CashRefundLine {
  /// Crée une ligne de remboursement.
  const CashRefundLine({
    required this.refundMethod,
    required this.refundAmount,
    required this.rejected,
  });

  /// Moyen de remboursement.
  final RefundMethod refundMethod;

  /// Montant remboursé.
  final Decimal refundAmount;

  /// Le serveur a refusé définitivement ce retour.
  final bool rejected;
}

/// Calcule le solde théorique du tiroir-caisse, avec les mêmes règles que le
/// serveur.
class CashBalanceCalculator {
  /// Crée le calculateur.
  const CashBalanceCalculator();

  /// Récapitule une session : ouverture + espèces des ventes + entrées
  /// - sorties - remboursements en espèces.
  CashSummary summarize({
    required Decimal openingAmount,
    required List<CashSaleLine> sales,
    required List<CashMovement> movements,
    required List<CashRefundLine> refunds,
  }) {
    var cashSales = Decimal.zero;
    var cashSalesCount = 0;
    var mobileMoneySales = Decimal.zero;
    for (final sale in sales) {
      switch (sale.paymentMethod) {
        case PaymentMethod.cash:
          cashSales += sale.totalAmount;
          cashSalesCount++;
        case PaymentMethod.mixed:
          cashSales += sale.cashAmount ?? Decimal.zero;
          cashSalesCount++;
        case PaymentMethod.orangeMoney:
        case PaymentMethod.mtn:
        case PaymentMethod.wave:
          mobileMoneySales += sale.totalAmount;
      }
    }

    var cashIn = Decimal.zero;
    var cashOut = Decimal.zero;
    for (final movement in movements) {
      switch (movement.type) {
        case CashMovementType.cashIn:
          cashIn += movement.amount;
        case CashMovementType.cashOut:
          cashOut += movement.amount;
      }
    }

    var cashRefunds = Decimal.zero;
    var rejectedCashRefunds = Decimal.zero;
    for (final refund in refunds) {
      if (refund.refundMethod != RefundMethod.cash) continue;
      if (refund.rejected) {
        rejectedCashRefunds += refund.refundAmount;
      } else {
        cashRefunds += refund.refundAmount;
      }
    }

    return CashSummary(
      openingAmount: openingAmount,
      cashSales: cashSales,
      cashSalesCount: cashSalesCount,
      mobileMoneySales: mobileMoneySales,
      cashIn: cashIn,
      cashOut: cashOut,
      cashRefunds: cashRefunds,
      rejectedCashRefunds: rejectedCashRefunds,
      expectedAmount:
          openingAmount + cashSales + cashIn - cashOut - cashRefunds,
    );
  }
}
