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
    final muted = AppTypography.labelMedium.copyWith(
      color: cs.onSurfaceVariant,
    );
    final strong = AppTypography.labelMedium.copyWith(
      color: cs.onSurface,
      fontWeight: FontWeight.w600,
    );
    final count = summary.productCount;

    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: '$count', style: strong),
          TextSpan(text: count <= 1 ? ' produit' : ' produits', style: muted),
          TextSpan(text: '  ·  Valeur du stock ', style: muted),
          TextSpan(text: formatFcfa(summary.stockValue), style: strong),
        ],
      ),
    );
  }
}

/// Filtres d'état du stock : Tous, Stock faible et Ruptures, avec leur
/// compteur (accentué tant que le filtre n'est pas actif).
class StockFilterChips extends StatelessWidget {
  /// Crée les filtres ; [summary] fournit les compteurs (masqués si `null`).
  const StockFilterChips({
    required this.filter,
    required this.onFilter,
    this.summary,
    super.key,
  });

  /// Filtre actif.
  final StockFilter filter;

  /// Applique un filtre.
  final ValueChanged<StockFilter> onFilter;

  /// Synthèse portant les compteurs.
  final StockSummary? summary;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final summary = this.summary;

    return Wrap(
      spacing: AppSpacing.sm,
      children: [
        for (final (value, label, count, accent) in [
          (StockFilter.all, 'Tous', null, null),
          (
            StockFilter.lowStock,
            'Stock faible',
            summary?.lowStockCount,
            cs.tertiary,
          ),
          (
            StockFilter.outOfStock,
            'Ruptures',
            summary?.outOfStockCount,
            cs.error,
          ),
        ])
          ChoiceChip(
            // Padding réduit : les 3 filtres tiennent sur une ligne à 360 dp.
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
            showCheckmark: false,
            selected: filter == value,
            onSelected: (_) => onFilter(value),
            label: Text.rich(
              TextSpan(
                text: label,
                children: [
                  if (count != null)
                    TextSpan(
                      text: ' · $count',
                      style: AppTypography.labelMedium.copyWith(
                        fontWeight: FontWeight.w700,
                        // Compteur d'alerte en couleur tant qu'il y a quelque
                        // chose à voir et que le filtre n'est pas déjà actif.
                        color: count > 0 && filter != value ? accent : null,
                      ),
                    ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
