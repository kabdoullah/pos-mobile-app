import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/index.dart';
import '../../domain/entities/cash_session_detail.dart';
import '../../domain/entities/cash_summary.dart';

/// Solde théorique mis en avant, puis le détail de la formule : fond de
/// caisse + ventes espèces + entrées − sorties − remboursements espèces.
///
/// Un solde négatif s'affiche tel quel, en couleur d'erreur.
class CashSummaryCard extends StatelessWidget {
  /// Crée la carte à partir de chaque terme de la formule.
  const CashSummaryCard({
    required this.expectedAmount,
    required this.openingAmount,
    required this.cashSales,
    required this.cashIn,
    required this.cashOut,
    required this.cashRefunds,
    this.cashSalesCount,
    this.mobileMoneySales,
    this.expectedLabel = 'Solde théorique',
    this.caption,
    this.elevated = true,
    super.key,
  });

  /// Carte du récapitulatif calculé sur l'appareil.
  factory CashSummaryCard.fromSummary(
    CashSummary summary, {
    Decimal? expectedAmount,
    String expectedLabel = 'Solde théorique',
    String? caption,
    bool elevated = true,
    Key? key,
  }) => CashSummaryCard(
    expectedAmount: expectedAmount ?? summary.expectedAmount,
    openingAmount: summary.openingAmount,
    cashSales: summary.cashSales,
    cashSalesCount: summary.cashSalesCount,
    cashIn: summary.cashIn,
    cashOut: summary.cashOut,
    cashRefunds: summary.cashRefunds,
    mobileMoneySales: summary.mobileMoneySales,
    expectedLabel: expectedLabel,
    caption: caption,
    elevated: elevated,
    key: key,
  );

  /// Carte du récapitulatif calculé par le serveur.
  factory CashSummaryCard.fromServer(
    CashServerSummary summary, {
    Decimal? expectedAmount,
    String expectedLabel = 'Solde théorique',
    String? caption,
    bool elevated = true,
    Key? key,
  }) => CashSummaryCard(
    expectedAmount: expectedAmount ?? summary.expectedAmount,
    openingAmount: summary.openingAmount,
    cashSales: summary.cashSales,
    cashSalesCount: summary.cashSalesCount,
    cashIn: summary.cashIn,
    cashOut: summary.cashOut,
    cashRefunds: summary.cashRefunds,
    mobileMoneySales: summary.mobileMoneySales,
    expectedLabel: expectedLabel,
    caption: caption,
    elevated: elevated,
    key: key,
  );

  /// Solde théorique affiché en grand.
  final Decimal expectedAmount;

  /// Fond de caisse.
  final Decimal openingAmount;

  /// Part espèces des ventes.
  final Decimal cashSales;

  /// Nombre de ventes avec une part espèces.
  final int? cashSalesCount;

  /// Entrées d'espèces.
  final Decimal cashIn;

  /// Sorties d'espèces.
  final Decimal cashOut;

  /// Remboursements en espèces.
  final Decimal cashRefunds;

  /// Ventes mobile money (hors tiroir), affichées pour mémoire.
  final Decimal? mobileMoneySales;

  /// Libellé du solde mis en avant.
  final String expectedLabel;

  /// Ligne discrète sous le solde (ex. date d'ouverture).
  final String? caption;

  /// Surface élevée (objet principal de l'écran).
  final bool elevated;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final muted = AppTypography.bodySmall.copyWith(color: cs.onSurfaceVariant);
    final isNegative = expectedAmount < Decimal.zero;
    final count = cashSalesCount;
    final mobileMoney = mobileMoneySales;
    final caption = this.caption;

    return AppCard(
      elevated: elevated,
      padding: AppSpacing.lg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(expectedLabel, style: muted),
          const SizedBox(height: AppSpacing.xs),
          Semantics(
            container: true,
            label: '$expectedLabel : ${formatFcfa(expectedAmount)}',
            excludeSemantics: true,
            child: Align(
              alignment: Alignment.centerLeft,
              child: AmountDisplay(
                amount: expectedAmount,
                size: AmountSize.hero,
                color: isNegative ? cs.error : null,
              ),
            ),
          ),
          if (isNegative) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Solde négatif : vérifiez les sorties et les remboursements.',
              style: AppTypography.bodySmall.copyWith(color: cs.error),
            ),
          ],
          if (caption != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(caption, style: muted),
          ],
          const SizedBox(height: AppSpacing.md),
          Divider(height: 1, color: cs.outlineVariant),
          const SizedBox(height: AppSpacing.sm),
          _FormulaLine(label: 'Fond de caisse', amount: openingAmount),
          _FormulaLine(
            label: count == null ? 'Ventes espèces' : 'Ventes espèces ($count)',
            amount: cashSales,
            sign: '+',
          ),
          _FormulaLine(label: 'Entrées', amount: cashIn, sign: '+'),
          _FormulaLine(label: 'Sorties', amount: cashOut, sign: '−'),
          _FormulaLine(
            label: 'Remboursements espèces',
            amount: cashRefunds,
            sign: '−',
          ),
          if (mobileMoney != null && mobileMoney > Decimal.zero) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Mobile money : ${formatFcfa(mobileMoney)} (hors tiroir)',
              style: muted,
            ),
          ],
        ],
      ),
    );
  }
}

/// Une ligne de la formule : libellé à gauche, montant signé à droite.
class _FormulaLine extends StatelessWidget {
  const _FormulaLine({required this.label, required this.amount, this.sign});

  final String label;
  final Decimal amount;
  final String? sign;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final sign = this.sign;
    final spoken = switch (sign) {
      '+' => 'plus ',
      '−' => 'moins ',
      _ => '',
    };
    return Semantics(
      container: true,
      label: '$label : $spoken${formatFcfa(amount)}',
      excludeSemantics: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: AppTypography.bodyMedium.copyWith(
                  color: cs.onSurfaceVariant,
                ),
              ),
            ),
            if (sign != null)
              Text(
                '$sign ',
                style: AppTypography.bodyMedium.copyWith(
                  color: cs.onSurfaceVariant,
                ),
              ),
            AmountDisplay(amount: amount, size: AmountSize.small),
          ],
        ),
      ),
    );
  }
}
