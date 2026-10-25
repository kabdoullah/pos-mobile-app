import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/widgets/index.dart';
import '../../../catalog/domain/entities/product.dart';
import '../../../catalog/presentation/widgets/product_thumbnail.dart';
import '../../../catalog/presentation/widgets/stock_status_badge.dart';
import '../providers/home_providers.dart';

/// Nombre de produits en alerte affichés sur l'accueil.
const _previewCount = 3;

/// Alerte stock : ruptures (critiques) et stocks sous le seuil
/// (avertissements) comptés séparément, puis un aperçu des produits les plus
/// urgents — chacun ouvre sa fiche (détail et ajustement du stock).
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

    final outCount = products
        .where((p) => p.stockLevel == StockLevel.outOfStock)
        .length;
    final lowCount = products.length - outCount;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeader(
          title: 'Alertes de stock',
          count: products.length,
          countColor: outCount > 0 ? cs.error : cs.tertiary,
          actionLabel: 'Voir le stock',
          onAction: onSeeStock,
        ),
        _AlertCounts(outCount: outCount, lowCount: lowCount),
        const SizedBox(height: AppSpacing.sm),
        for (final (i, product) in products.take(_previewCount).indexed) ...[
          if (i > 0) const SizedBox(height: AppSpacing.sm),
          _LowStockRow(product: product),
        ],
      ],
    );
  }
}

/// « 2 en rupture · 3 sous le seuil » : la gravité se lit avant la liste.
class _AlertCounts extends StatelessWidget {
  const _AlertCounts({required this.outCount, required this.lowCount});

  final int outCount;
  final int lowCount;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    const style = AppTypography.labelMedium;
    return Text.rich(
      TextSpan(
        children: [
          if (outCount > 0)
            TextSpan(
              text: '$outCount en rupture',
              style: style.copyWith(color: cs.error),
            ),
          if (outCount > 0 && lowCount > 0)
            TextSpan(
              text: ' · ',
              style: style.copyWith(color: cs.onSurfaceVariant),
            ),
          if (lowCount > 0)
            TextSpan(
              text: '$lowCount sous le seuil',
              style: style.copyWith(color: cs.tertiary),
            ),
        ],
      ),
    );
  }
}

class _LowStockRow extends StatelessWidget {
  const _LowStockRow({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    // Même carte que l'onglet Stock et la caisse.
    return Card.filled(
      margin: EdgeInsets.zero,
      color: cs.surfaceContainerLow,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
      child: InkWell(
        onTap: () =>
            context.push(Routes.productDetail.replaceFirst(':id', product.id)),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: AppSpacing.buttonHeight),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.sm,
              AppSpacing.xs,
              AppSpacing.sm,
            ),
            child: Row(
              children: [
                ProductThumbnail(product: product, size: 36),
                const SizedBox(width: AppSpacing.md - AppSpacing.xs),
                Expanded(
                  child: Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.bodyMedium.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                // Même badge qu'en caisse : « Rupture » ou « Faible : 3 ».
                StockStatusBadge(product: product, showQuantity: true),
                Icon(Icons.chevron_right, color: cs.onSurfaceVariant),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
