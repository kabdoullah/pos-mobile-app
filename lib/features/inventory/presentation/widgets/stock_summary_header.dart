import 'package:flutter/material.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/index.dart';
import '../../domain/entities/stock_summary.dart';
import '../providers/inventory_providers.dart';

/// En-tête de l'onglet Stock : nombre de produits et valeur du stock sur une
/// ligne. Les compteurs d'alerte sont portés par [StockFilterChips].
class StockSummaryHeader extends StatelessWidget {
  /// Crée l'en-tête.
  const StockSummaryHeader({required this.summary, super.key});

  /// Synthèse à afficher.
  final StockSummary summary;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final muted = AppTypography.bodyMedium.copyWith(color: cs.onSurfaceVariant);
    final strong = AppTypography.bodyMedium.copyWith(
      color: cs.onSurface,
      fontWeight: FontWeight.w700,
      fontFeatures: AppTypography.tabularFigures,
    );
    final count = summary.productCount;

    return Text.rich(
      TextSpan(
        style: muted,
        children: [
          TextSpan(text: count <= 1 ? '$count produit' : '$count produits'),
          const TextSpan(text: ' · valeur '),
          TextSpan(text: formatFcfa(summary.stockValue), style: strong),
        ],
      ),
    );
  }
}

/// Filtres d'état du stock sur une seule rangée : Tous, Bas et Ruptures avec
/// leur compteur, puis [trailing] (filtre de catégorie).
class StockFilterChips extends StatelessWidget {
  /// Crée les filtres ; [summary] fournit les compteurs (masqués si `null`).
  const StockFilterChips({
    required this.filter,
    required this.onFilter,
    this.summary,
    this.trailing,
    super.key,
  });

  /// Filtre actif.
  final StockFilter filter;

  /// Applique un filtre.
  final ValueChanged<StockFilter> onFilter;

  /// Synthèse portant les compteurs.
  final StockSummary? summary;

  /// Puce affichée après les filtres d'état.
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final summary = this.summary;
    final trailing = this.trailing;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final (value, label, count) in [
            (StockFilter.all, 'Tous', null),
            (StockFilter.lowStock, 'Bas', summary?.lowStockCount),
            (StockFilter.outOfStock, 'Ruptures', summary?.outOfStockCount),
          ]) ...[
            ChoiceChip(
              showCheckmark: false,
              selected: filter == value,
              onSelected: (_) => onFilter(value),
              label: Text.rich(
                TextSpan(
                  text: label,
                  children: [
                    if (count != null)
                      TextSpan(
                        text: ' $count',
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontFeatures: AppTypography.tabularFigures,
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
          ],
          ?trailing,
        ],
      ),
    );
  }
}
