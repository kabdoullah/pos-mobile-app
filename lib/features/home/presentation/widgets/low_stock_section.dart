import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/widgets/index.dart';
import '../../../catalog/domain/entities/product.dart';
import '../../../catalog/presentation/widgets/stock_status_badge.dart';
import '../providers/home_providers.dart';

/// Nombre de produits en alerte affichés sur l'accueil.
const _previewCount = 3;

/// Alertes de stock : les produits en rupture puis sous leur seuil, les plus
/// urgents d'abord — chacun ouvre sa fiche (détail et ajustement du stock).
class LowStockSection extends ConsumerWidget {
  /// Crée la section ; [onSeeStock] ouvre l'onglet Stock.
  const LowStockSection({required this.onSeeStock, super.key});

  /// Ouvre l'onglet Stock.
  final VoidCallback onSeeStock;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lowStock = ref.watch(homeLowStockProvider);

    // Alerte secondaire : on ne réserve pas de place pendant le chargement et
    // on ne bloque pas l'accueil en cas d'erreur.
    final products = lowStock.value;
    if (products == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeader(
          title: 'Alertes de stock',
          actionLabel: products.isEmpty ? null : 'Voir tout',
          onAction: onSeeStock,
        ),
        const SizedBox(height: AppSpacing.xs),
        AppListGroup(
          children: [
            if (products.isEmpty)
              const _NoAlertRow()
            else
              for (final product in products.take(_previewCount))
                _LowStockRow(product: product),
          ],
        ),
      ],
    );
  }
}

class _NoAlertRow extends StatelessWidget {
  const _NoAlertRow();

  @override
  Widget build(BuildContext context) {
    final semantic = Theme.of(context).extension<AppSemanticColors>()!;
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 60),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        child: Row(
          children: [
            Icon(
              Icons.check_circle_outline,
              color: semantic.onSuccessContainer,
            ),
            const SizedBox(width: AppSpacing.sm + 4),
            const Expanded(
              child: Text(
                'Aucun produit en rupture',
                style: AppTypography.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LowStockRow extends StatelessWidget {
  const _LowStockRow({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: () =>
            context.push(Routes.productDetail.replaceFirst(':id', product.id)),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 60),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                // Même badge qu'en caisse : « Rupture » ou « Stock bas : 3 ».
                StockStatusBadge(product: product, showQuantity: true),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
