import 'package:flutter/material.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/index.dart';
import '../../domain/entities/stock_summary.dart';
import '../providers/inventory_providers.dart';

/// En-tête de l'onglet Stock : 4 indicateurs. Les tuiles « Stock faible » et
/// « Ruptures » appliquent le filtre correspondant.
class StockSummaryHeader extends StatelessWidget {
  /// Crée l'en-tête.
  const StockSummaryHeader({
    required this.summary,
    required this.filter,
    required this.onFilter,
    super.key,
  });

  /// Synthèse à afficher.
  final StockSummary summary;

  /// Filtre actif (surligne la tuile correspondante).
  final StockFilter filter;

  /// Applique un filtre ; retaper une tuile active revient à « Tous ».
  final ValueChanged<StockFilter> onFilter;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    void toggle(StockFilter target) =>
        onFilter(filter == target ? StockFilter.all : target);

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _Tile(label: 'Produits', value: '${summary.productCount}'),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _Tile(
                label: 'Valeur du stock',
                value: formatFcfa(summary.stockValue),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Expanded(
              child: _Tile(
                label: 'Stock faible',
                value: '${summary.lowStockCount}',
                accent: summary.lowStockCount > 0 ? cs.tertiary : null,
                icon: Icons.warning_amber,
                isSelected: filter == StockFilter.lowStock,
                onTap: () => toggle(StockFilter.lowStock),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _Tile(
                label: 'Ruptures',
                value: '${summary.outOfStockCount}',
                accent: summary.outOfStockCount > 0 ? cs.error : null,
                icon: Icons.remove_shopping_cart_outlined,
                isSelected: filter == StockFilter.outOfStock,
                onTap: () => toggle(StockFilter.outOfStock),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({
    required this.label,
    required this.value,
    this.accent,
    this.icon,
    this.isSelected = false,
    this.onTap,
  });

  final String label;
  final String value;
  final Color? accent;
  final IconData? icon;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final valueColor = accent ?? cs.onSurface;
    final icon = this.icon;

    return Semantics(
      button: onTap != null,
      selected: isSelected,
      child: Material(
        color: cs.surfaceContainerLow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          side: BorderSide(
            color: isSelected ? cs.primary : Colors.transparent,
            width: 2,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    if (icon != null) ...[
                      Icon(
                        icon,
                        size: 16,
                        color: accent ?? cs.onSurfaceVariant,
                      ),
                      const SizedBox(width: AppSpacing.xs),
                    ],
                    Expanded(
                      child: Text(
                        label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.labelMedium.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    value,
                    style: AppTypography.titleLarge.copyWith(color: valueColor),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
