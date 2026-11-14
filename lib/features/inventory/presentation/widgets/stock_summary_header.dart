import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/index.dart';
import '../../domain/entities/stock_summary.dart';

/// En-tête de l'onglet Stock : « 17 produits · valeur du stock » et la
/// valeur à droite. Les compteurs d'alerte sont portés par les onglets.
class StockSummaryHeader extends StatelessWidget {
  /// Crée l'en-tête.
  const StockSummaryHeader({required this.summary, super.key});

  /// Synthèse à afficher.
  final StockSummary summary;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final count = summary.productCount;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '$count ${count <= 1 ? 'produit' : 'produits'} · valeur du stock',
              style: AppTypography.bodySmall.copyWith(
                color: colors.textSecondary,
              ),
            ),
          ),
          Text(
            formatFcfa(summary.stockValue),
            style: AppTypography.bodyStrong.copyWith(
              fontFeatures: AppTypography.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}
