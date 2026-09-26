import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/responsive/responsive.dart';
import '../../../../core/router/app_router.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../app/theme/illustrations.dart';
import '../../../../core/widgets/index.dart';
import '../../../catalog/domain/entities/product.dart';
import '../../../catalog/presentation/providers/catalog_providers.dart';
import '../../../catalog/presentation/widgets/stock_status.dart';
import '../providers/inventory_providers.dart';
import '../widgets/stock_adjustment_sheet.dart';

/// Filtre appliqué à la liste des produits de l'onglet Stock.
enum _StockFilter {
  /// Seulement les produits en rupture ou sous leur seuil de
  /// réapprovisionnement.
  lowStock,

  /// Tout le catalogue.
  all,
}

/// Vue d'ensemble du stock : fait remonter les produits qui demandent attention
/// (rupture / stock bas) avec un ajustement en un tap, au lieu de l'enfouir
/// dans le formulaire produit ou dans l'historique de chaque produit.
class StockOverviewPage extends ConsumerStatefulWidget {
  /// Crée une [StockOverviewPage].
  const StockOverviewPage({super.key});

  @override
  ConsumerState<StockOverviewPage> createState() => _StockOverviewPageState();
}

class _StockOverviewPageState extends ConsumerState<StockOverviewPage> {
  _StockFilter _filter = _StockFilter.lowStock;

  Future<void> _openAdjustmentSheet(String productId) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => StockAdjustmentSheet(productId: productId),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hPad = responsiveValue(
      context,
      small: AppSpacing.md,
      medium: AppSpacing.lg,
    );
    final isLowStockFilter = _filter == _StockFilter.lowStock;
    final productsAsync = isLowStockFilter
        ? ref.watch(lowStockProductsProvider)
        : ref.watch(catalogListProvider);

    return AppScaffold(
      title: 'Stock',
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(hPad),
            child: SegmentedButton<_StockFilter>(
              segments: const [
                ButtonSegment(
                  value: _StockFilter.lowStock,
                  label: Text('Stock bas'),
                  icon: Icon(Icons.warning_amber_rounded, size: 18),
                ),
                ButtonSegment(
                  value: _StockFilter.all,
                  label: Text('Tout'),
                  icon: Icon(Icons.inventory_2_outlined, size: 18),
                ),
              ],
              selected: {_filter},
              onSelectionChanged: (values) =>
                  setState(() => _filter = values.first),
            ),
          ),
          Expanded(
            child: productsAsync.when(
              loading: () => const AppLoadingScreen(),
              error: (error, stack) => LayoutBuilder(
                builder: (context, constraints) => SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: SizedBox(
                    height: constraints.maxHeight,
                    child: EmptyStateIllustrated(
                      illustration: Illustrations.errorState,
                      title: 'Erreur',
                      message: 'Impossible de charger le stock',
                      actionLabel: 'Réessayer',
                      onAction: () => ref.invalidate(
                        isLowStockFilter
                            ? lowStockProductsProvider
                            : catalogListProvider,
                      ),
                    ),
                  ),
                ),
              ),
              data: (products) {
                if (products.isEmpty) {
                  return LayoutBuilder(
                    builder: (context, constraints) => SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: SizedBox(
                        height: constraints.maxHeight,
                        child: isLowStockFilter
                            ? const EmptyStateIllustrated(
                                illustration: Illustrations.successState,
                                title: 'Tout est sous contrôle',
                                message:
                                    'Aucun produit en rupture ou sous son'
                                    ' seuil de réapprovisionnement.',
                              )
                            : const EmptyStateIllustrated(
                                illustration: Illustrations.emptyCatalog,
                                title: 'Aucun produit',
                                message:
                                    'Ajoutez des produits depuis le'
                                    ' catalogue pour suivre leur stock ici.',
                              ),
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: hPad,
                    vertical: AppSpacing.sm,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return _StockRow(
                      product: product,
                      onAdjust: () => _openAdjustmentSheet(product.id),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Une ligne produit : nom, état du stock et action d'ajustement en un tap.
/// Un tap sur la ligne (hors du bouton d'ajustement) ouvre l'historique complet
/// des mouvements de ce produit.
class _StockRow extends StatelessWidget {
  const _StockRow({required this.product, required this.onAdjust});

  final Product product;
  final VoidCallback onAdjust;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final status = stockStatus(cs, product);

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: AppCard(
        onTap: () => context.push(
          Routes.productStockHistory.replaceFirst(':id', product.id),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: AppTypography.titleMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (status != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      status.label,
                      style: AppTypography.bodySmall.copyWith(
                        color: status.color,
                        fontWeight: status.emphasize ? FontWeight.w600 : null,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            IconButton(
              onPressed: onAdjust,
              icon: const Icon(Icons.add_circle_outline),
              tooltip: 'Ajuster le stock',
              style: IconButton.styleFrom(
                backgroundColor: cs.primaryContainer,
                foregroundColor: cs.onPrimaryContainer,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
