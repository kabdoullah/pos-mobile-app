import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/widgets/index.dart';
import '../../../catalog/domain/entities/product.dart';
import '../providers/home_providers.dart';

/// Nombre de produits en alerte affichés sur l'accueil.
const _previewCount = 3;

/// « Alertes de stock » : les produits les plus urgents (ruptures d'abord),
/// chacun ouvre sa fiche. Sans alerte, un statut rassurant.
class LowStockSection extends ConsumerWidget {
  /// Crée la section ; [onSeeStock] ouvre l'onglet Stock.
  const LowStockSection({required this.onSeeStock, super.key});

  /// Ouvre l'onglet Stock.
  final VoidCallback onSeeStock;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Alerte secondaire : rien pendant le chargement ni en cas d'erreur.
    final products = ref.watch(homeLowStockProvider).value;
    if (products == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        OverlineHeader(
          'Alertes de stock',
          actionLabel: products.isEmpty ? null : 'Voir tout',
          onAction: onSeeStock,
        ),
        FlatList(
          children: products.isEmpty
              ? const [
                  _Row(
                    child: StatusIndicator(
                      label: 'Aucun produit en rupture',
                      tone: StatusTone.success,
                    ),
                  ),
                ]
              : [
                  for (final product in products.take(_previewCount))
                    _LowStockRow(product: product),
                ],
        ),
      ],
    );
  }
}

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
      child: _Row(
        child: Row(
          children: [
            Expanded(
              child: Text(
                product.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.bodyStrong,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            StatusIndicator(
              label: out
                  ? 'Rupture'
                  : stock == 1
                  ? '1 restant'
                  : '$stock restants',
              tone: out ? StatusTone.error : StatusTone.warning,
            ),
          ],
        ),
      ),
    );
  }
}

/// Ligne de liste 56 dp.
class _Row extends StatelessWidget {
  const _Row({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 56),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        child: Align(alignment: Alignment.centerLeft, child: child),
      ),
    );
  }
}
