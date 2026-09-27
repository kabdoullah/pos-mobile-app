import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/index.dart';
import '../../../catalog/domain/entities/product.dart';
import '../providers/home_providers.dart';

/// Nombre de produits en alerte affichés sur l'accueil.
const _previewCount = 3;

/// Alerte stock : aperçu des produits en rupture ou sous leur seuil.
class LowStockSection extends ConsumerWidget {
  /// Crée la section ; [onSeeStock] ouvre l'onglet Stock.
  const LowStockSection({required this.onSeeStock, super.key});

  /// Ouvre l'onglet Stock.
  final VoidCallback onSeeStock;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final lowStock = ref.watch(homeLowStockProvider);

    // Alerte secondaire : on ne réserve pas de place pendant le chargement et
    // on ne bloque pas l'accueil en cas d'erreur.
    final products = lowStock.value;
    if (products == null) return const SizedBox.shrink();

    if (products.isEmpty) {
      final success = Theme.of(context).extension<AppSemanticColors>()!.success;
      return Row(
        children: [
          Icon(Icons.check_circle_outline, color: success, size: 20),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              'Aucune alerte de stock',
              style: AppTypography.bodyMedium.copyWith(
                color: cs.onSurfaceVariant,
              ),
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeader(
          title: 'Stock faible',
          count: products.length,
          countColor: cs.tertiary,
          actionLabel: 'Voir le stock',
          onAction: onSeeStock,
        ),
        for (final product in products.take(_previewCount))
          _LowStockRow(product: product),
      ],
    );
  }
}

class _LowStockRow extends StatelessWidget {
  const _LowStockRow({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isOut = product.stockLevel == StockLevel.outOfStock;
    final color = isOut ? cs.error : cs.tertiary;
    final stock = product.currentStock ?? 0;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        children: [
          Icon(
            isOut ? Icons.remove_shopping_cart_outlined : Icons.warning_amber,
            size: 20,
            color: color,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              product.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.bodyLarge,
            ),
          ),
          Text(
            isOut ? 'Rupture' : '$stock restant${stock > 1 ? 's' : ''}',
            style: AppTypography.labelMedium.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}
