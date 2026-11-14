import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/index.dart';
import '../../domain/entities/cash_session_detail.dart';
import '../../domain/entities/cash_summary.dart';

/// Solde du tiroir en chiffre héros, puis le calcul ligne par ligne (fond de
/// caisse + ventes espèces + entrées − sorties − remboursements) et le mobile
/// money, toujours à part (« Hors tiroir »). Bloc à plat, pleine largeur, avec
/// ses propres marges.
///
/// Un solde négatif s'affiche tel quel, en couleur d'erreur, avec un statut
/// explicite.
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
    this.status,
    super.key,
  });

  /// Carte du récapitulatif calculé sur l'appareil.
  factory CashSummaryCard.fromSummary(
    CashSummary summary, {
    Decimal? expectedAmount,
    String expectedLabel = 'Solde théorique',
    String? caption,
    Widget? status,
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
    status: status,
    key: key,
  );

  /// Carte du récapitulatif calculé par le serveur.
  factory CashSummaryCard.fromServer(
    CashServerSummary summary, {
    Decimal? expectedAmount,
    String expectedLabel = 'Solde théorique',
    String? caption,
    Widget? status,
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
    status: status,
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

  /// Statut au-dessus du solde (ex. « Ouverte depuis 7:45 »).
  final Widget? status;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final meta = AppTypography.bodySmall.copyWith(
      color: colors.textSecondary,
      fontFeatures: AppTypography.tabularFigures,
    );
    final isNegative = expectedAmount < Decimal.zero;
    final count = cashSalesCount;
    final mobileMoney = mobileMoneySales;
    final caption = this.caption;
    final status = this.status;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (status != null) ...[
                status,
                const SizedBox(height: AppSpacing.sm + 2),
              ],
              Text(expectedLabel, style: meta),
              Semantics(
                container: true,
                label: '$expectedLabel : ${formatFcfa(expectedAmount)}',
                excludeSemantics: true,
                child: Text(
                  formatFcfa(expectedAmount),
                  style: AppTypography.figureHero.copyWith(
                    color: isNegative ? colors.error : colors.textPrimary,
                  ),
                ),
              ),
              if (isNegative) ...[
                const SizedBox(height: AppSpacing.xs),
                const StatusIndicator(
                  label:
                      'Solde négatif : vérifiez les sorties et '
                      'remboursements',
                  tone: StatusTone.error,
                ),
              ],
              if (caption != null) ...[
                const SizedBox(height: AppSpacing.xs),
                Text(caption, style: meta),
              ],
            ],
          ),
        ),
        const OverlineHeader('Calcul'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _line('Fond de caisse', openingAmount),
              _line(
                count == null
                    ? 'Ventes en espèces'
                    : 'Ventes en espèces ($count)',
                cashSales,
                sign: '+',
              ),
              _line('Entrées', cashIn, sign: '+'),
              _line('Sorties', cashOut, sign: '−'),
              _line('Remboursements', cashRefunds, sign: '−', last: true),
            ],
          ),
        ),
        if (mobileMoney != null && mobileMoney > Decimal.zero) ...[
          const OverlineHeader('Hors tiroir'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: DefinitionRow(
              label: 'Mobile money',
              value: formatFcfa(mobileMoney),
              showDivider: false,
            ),
          ),
        ],
      ],
    );
  }

  /// Ligne de la formule, montant signé (« + 40 175 FCFA »).
  static Widget _line(
    String label,
    Decimal amount, {
    String? sign,
    bool last = false,
  }) {
    final spoken = switch (sign) {
      '+' => 'plus ',
      '−' => 'moins ',
      _ => '',
    };
    return DefinitionRow(
      label: label,
      value: '${sign == null ? '' : '$sign '}${formatFcfa(amount)}',
      showDivider: !last,
      semanticsLabel: '$label : $spoken${formatFcfa(amount)}',
    );
  }
}
