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
import '../providers/home_providers.dart';

/// Nombre de produits en alerte affichés sur l'accueil.
const _previewCount = 3;

/// « Alertes de stock » : les produits les plus urgents (ruptures d'abord),
/// chacun ouvre sa fiche. Sans alerte, la section n'apparaît pas.
class LowStockSection extends ConsumerWidget {
  /// Crée la section ; [onSeeStock] ouvre l'onglet Stock.
  const LowStockSection({required this.onSeeStock, super.key});

  /// Ouvre l'onglet Stock.
  final VoidCallback onSeeStock;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Alerte secondaire : rien pendant le chargement ni en cas d'erreur.
    final products = ref.watch(homeLowStockProvider).value;
    if (products == null || products.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        OverlineHeader(
          'Alertes de stock',
          actionLabel: 'Voir tout',
          onAction: onSeeStock,
        ),
        FlatList(
          children: [
            for (final product in products.take(_previewCount))
              _LowStockRow(product: product),
          ],
        ),
      ],
    );
  }
}

/// Vignette, nom et gravité (rupture / stock bas), quantité restante à
/// droite.
class _LowStockRow extends StatelessWidget {
  const _LowStockRow({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final out = product.stockLevel == StockLevel.outOfStock;
    final stock = product.currentStock ?? 0;
    return InkWell(
      onTap: () =>
          context.push(Routes.productDetail.replaceFirst(':id', product.id)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 56),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          child: Row(
            children: [
              ProductThumbnail(product: product, size: 40),
              const SizedBox(width: AppSpacing.sm + 4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.bodyStrong,
                    ),
                    StatusIndicator(
                      label: out ? 'Rupture' : 'Stock bas',
                      tone: out ? StatusTone.error : StatusTone.warning,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                switch (stock) {
                  <= 0 => '0',
                  1 => '1 restant',
                  _ => '$stock restants',
                },
                style: AppTypography.metaRegular.copyWith(
                  color: AppColors.of(context).textSecondary,
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
