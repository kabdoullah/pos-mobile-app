import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/index.dart';
import '../../domain/entities/cash_session_detail.dart';
import '../../domain/entities/cash_summary.dart';

/// Solde théorique mis en avant, puis le détail de la formule : fond de
/// caisse + ventes en espèces + entrées − sorties − remboursements espèces
/// (ligne masquée s'il n'y en a pas).
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
    this.header,
    this.showMobileMoney = true,
    this.elevated = false,
    super.key,
  });

  /// Carte du récapitulatif calculé sur l'appareil.
  factory CashSummaryCard.fromSummary(
    CashSummary summary, {
    Decimal? expectedAmount,
    String expectedLabel = 'Solde théorique',
    String? caption,
    Widget? header,
    bool showMobileMoney = true,
    bool elevated = false,
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
    header: header,
    showMobileMoney: showMobileMoney,
    elevated: elevated,
    key: key,
  );

  /// Carte du récapitulatif calculé par le serveur.
  factory CashSummaryCard.fromServer(
    CashServerSummary summary, {
    Decimal? expectedAmount,
    String expectedLabel = 'Solde théorique',
    String? caption,
    Widget? header,
    bool showMobileMoney = true,
    bool elevated = false,
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
    header: header,
    showMobileMoney: showMobileMoney,
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

  /// Ligne d'état au-dessus du solde (pastille « Ouverte », heure).
  final Widget? header;

  /// Affiche la ligne « Mobile money (hors tiroir) » sous la formule ; à
  /// masquer quand l'écran présente le mobile money dans sa propre carte.
  final bool showMobileMoney;

  /// Surface élevée (objet principal de l'écran).
  final bool elevated;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final muted = AppTypography.bodyMedium.copyWith(color: cs.onSurfaceVariant);
    final isNegative = expectedAmount < Decimal.zero;
    final count = cashSalesCount;
    final mobileMoney = mobileMoneySales;
    final caption = this.caption;
    final header = this.header;

    return AppCard(
      elevated: elevated,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (header != null) ...[
            header,
            const SizedBox(height: AppSpacing.sm),
          ],
          Text(expectedLabel, style: muted),
          Semantics(
            container: true,
            label: '$expectedLabel : ${formatFcfa(expectedAmount)}',
            excludeSemantics: true,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                formatFcfa(expectedAmount),
                maxLines: 1,
                style: AppTypography.amountDisplay.copyWith(
                  color: isNegative ? cs.error : cs.onSurface,
                  fontFeatures: AppTypography.tabularFigures,
                ),
              ),
            ),
          ),
          if (isNegative) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Solde négatif : vérifiez les sorties et les remboursements.',
              style: AppTypography.bodyMedium.copyWith(color: cs.error),
            ),
          ],
          if (caption != null) Text(caption, style: muted),
          const SizedBox(height: AppSpacing.xs),
          _FormulaLine(label: 'Fond de caisse', amount: openingAmount),
          _FormulaLine(
            label: count == null
                ? 'Ventes en espèces'
                : 'Ventes en espèces ($count)',
            amount: cashSales,
            sign: '+',
          ),
          _FormulaLine(label: 'Entrées', amount: cashIn, sign: '+'),
          _FormulaLine(label: 'Sorties', amount: cashOut, sign: '−'),
          // Rares : la ligne n'apparaît que s'il y a eu un remboursement.
          if (cashRefunds != Decimal.zero)
            _FormulaLine(
              label: 'Remboursements espèces',
              amount: cashRefunds,
              sign: '−',
            ),
          if (showMobileMoney &&
              mobileMoney != null &&
              mobileMoney > Decimal.zero) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Mobile money (hors tiroir) : ${formatFcfa(mobileMoney)}',
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
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: cs.outlineVariant)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
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
              Text(
                sign == null
                    ? formatFcfa(amount)
                    : '$sign ${formatFcfa(amount)}',
                style: AppTypography.bodyMedium.copyWith(
                  fontWeight: FontWeight.w700,
                  fontFeatures: AppTypography.tabularFigures,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
