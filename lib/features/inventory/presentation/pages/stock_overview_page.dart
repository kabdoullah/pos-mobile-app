import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/widgets/index.dart';
import '../../../catalog/domain/entities/product.dart';
import '../providers/inventory_providers.dart';
import '../widgets/stock_adjustment_sheet.dart';
import '../widgets/stock_product_tile.dart';
import '../widgets/stock_summary_header.dart';

/// Onglet Stock : point d'entrée de la gestion des produits et de
/// l'inventaire — synthèse, recherche/scan, filtres et liste des produits.
class StockOverviewPage extends ConsumerStatefulWidget {
  /// Crée l'onglet Stock.
  const StockOverviewPage({super.key});

  @override
  ConsumerState<StockOverviewPage> createState() => _StockOverviewPageState();
}

class _StockOverviewPageState extends ConsumerState<StockOverviewPage> {
  final _searchController = TextEditingController();
  StockFilter _filter = StockFilter.all;
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _setQuery(String query) => setState(() => _query = query);

  void _openProduct(Product product) => unawaited(
    context.push(Routes.productDetail.replaceFirst(':id', product.id)),
  );

  /// Scanne un code-barres : ouvre directement le produit s'il est unique,
  /// sinon filtre la liste sur ce code.
  Future<void> _scan() async {
    final code = await context.push<String>(Routes.barcodeScanner);
    if (code == null || !mounted) return;
    final products = ref.read(stockProductsProvider).value ?? const [];
    final matches = products.where((p) => p.barcode == code).toList();
    if (matches.length == 1) {
      _openProduct(matches.single);
      return;
    }
    _searchController.text = code;
    setState(() {
      _query = code;
      _filter = StockFilter.all;
    });
  }

  @override
  Widget build(BuildContext context) {
    final productsAsync = ref.watch(stockProductsProvider);

    return AppScaffold(
      title: 'Stock',
      actions: [
        IconButton(
          tooltip: 'Mouvements de stock',
          icon: const Icon(Icons.swap_vert),
          onPressed: () => context.push(Routes.stockMovements),
        ),
        PopupMenuButton<void>(
          tooltip: "Plus d'options",
          itemBuilder: (context) => [
            PopupMenuItem(
              onTap: () => context.push(Routes.productImport),
              child: const ListTile(
                leading: Icon(Icons.upload_file_outlined),
                title: Text('Importer des produits'),
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
      ],
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(Routes.productNew),
        icon: const Icon(Icons.add),
        label: const Text('Produit'),
      ),
      body: productsAsync.when(
        loading: () => const _LoadingList(),
        error: (_, _) => EmptyState(
          icon: Icons.error_outline,
          title: 'Impossible de charger les produits',
          message: 'Réessayez dans un instant.',
          actionLabel: 'Réessayer',
          onAction: () => ref.invalidate(stockProductsProvider),
        ),
        data: (products) {
          if (products.isEmpty) {
            return EmptyState(
              icon: Icons.inventory_2_outlined,
              title: 'Aucun produit',
              message: 'Ajoutez votre premier produit.',
              actionLabel: 'Ajouter un produit',
              onAction: () => context.push(Routes.productNew),
            );
          }
          return _StockList(
            products: products,
            filter: _filter,
            query: _query,
            searchController: _searchController,
            onQueryChanged: _setQuery,
            onFilterChanged: (filter) => setState(() => _filter = filter),
            onScan: _scan,
            onOpen: _openProduct,
          );
        },
      ),
    );
  }
}

class _StockList extends ConsumerWidget {
  const _StockList({
    required this.products,
    required this.filter,
    required this.query,
    required this.searchController,
    required this.onQueryChanged,
    required this.onFilterChanged,
    required this.onScan,
    required this.onOpen,
  });

  final List<Product> products;
  final StockFilter filter;
  final String query;
  final TextEditingController searchController;
  final ValueChanged<String> onQueryChanged;
  final ValueChanged<StockFilter> onFilterChanged;
  final VoidCallback onScan;
  final ValueChanged<Product> onOpen;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final summary = ref.watch(stockSummaryProvider).value;
    final visible = filterStockProducts(products, filter: filter, query: query);

    return CustomScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.sm,
            AppSpacing.md,
            AppSpacing.sm,
          ),
          sliver: SliverList.list(
            children: [
              if (summary != null)
                StockSummaryHeader(
                  summary: summary,
                  filter: filter,
                  onFilter: onFilterChanged,
                ),
              const SizedBox(height: AppSpacing.md),
              AppSearchBar(
                controller: searchController,
                onChanged: onQueryChanged,
                hintText: 'Rechercher un produit…',
                actions: [
                  IconButton(
                    tooltip: 'Scanner un code-barres',
                    icon: const Icon(Icons.qr_code_scanner),
                    onPressed: onScan,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.sm,
                children: [
                  for (final (value, label) in const [
                    (StockFilter.all, 'Tous'),
                    (StockFilter.lowStock, 'Stock faible'),
                    (StockFilter.outOfStock, 'Ruptures'),
                  ])
                    ChoiceChip(
                      label: Text(label),
                      selected: filter == value,
                      onSelected: (_) => onFilterChanged(value),
                    ),
                ],
              ),
            ],
          ),
        ),
        if (visible.isEmpty)
          SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Text(
                query.isNotEmpty
                    ? 'Aucun produit ne correspond à « $query ».'
                    : switch (filter) {
                        StockFilter.lowStock =>
                          'Aucun produit à réapprovisionner.',
                        StockFilter.outOfStock => 'Aucune rupture de stock.',
                        StockFilter.all => 'Aucun produit.',
                      },
                textAlign: TextAlign.center,
                style: AppTypography.bodyMedium.copyWith(
                  color: cs.onSurfaceVariant,
                ),
              ),
            ),
          )
        else
          SliverList.separated(
            itemCount: visible.length,
            separatorBuilder: (_, _) => Divider(
              height: 1,
              indent: AppSpacing.md,
              endIndent: AppSpacing.md,
              color: cs.outlineVariant,
            ),
            itemBuilder: (context, index) {
              final product = visible[index];
              return StockProductTile(
                key: ValueKey(product.id),
                product: product,
                onTap: () => onOpen(product),
                onAdjust: product.currentStock == null
                    ? null
                    : () => showStockAdjustmentSheet(context, product.id),
              );
            },
          ),
        // Place pour le bouton flottant.
        const SliverToBoxAdapter(child: SizedBox(height: 88)),
      ],
    );
  }
}

class _LoadingList extends StatelessWidget {
  const _LoadingList();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      physics: const NeverScrollableScrollPhysics(),
      children: const [
        SkeletonBox(height: 160, radius: AppSpacing.radiusLg),
        SizedBox(height: AppSpacing.md),
        SkeletonBox(height: 56),
        SizedBox(height: AppSpacing.md),
        SkeletonBox(height: 64),
        SizedBox(height: AppSpacing.sm),
        SkeletonBox(height: 64),
      ],
    );
  }
}
