import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/widgets/index.dart';
import '../../../catalog/domain/entities/product.dart';
import '../../../catalog/presentation/providers/category_providers.dart';
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
  String? _categoryId;

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

  /// Choisit la catégorie filtrée (feuille) ; « Toutes » la retire.
  Future<void> _pickCategory() async {
    final categories = ref.read(categoriesProvider).value ?? const [];
    final picked = await showModalBottomSheet<({String? id})>(
      context: context,
      builder: (context) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.sm,
                AppSpacing.md,
                AppSpacing.sm,
              ),
              child: Text('Catégorie', style: AppTypography.sectionTitle),
            ),
            for (final (id, name) in [
              (null, 'Toutes les catégories'),
              for (final c in categories) (c.id, c.name),
            ])
              ListTile(
                title: Text(name),
                selected: _categoryId == id,
                onTap: () => Navigator.of(context).pop((id: id)),
              ),
          ],
        ),
      ),
    );
    if (picked != null && mounted) setState(() => _categoryId = picked.id);
  }

  @override
  Widget build(BuildContext context) {
    final productsAsync = ref.watch(stockProductsProvider);

    return Scaffold(
      appBar: AppBar(
        titleSpacing: AppSpacing.md,
        title: const Text('Stock'),
        actions: [
          TextButton.icon(
            onPressed: () => context.push(Routes.productNew),
            icon: const Icon(Icons.add, size: 20),
            label: const Text('Produit'),
          ),
          PopupMenuButton<String>(
            tooltip: "Plus d'options",
            onSelected: (route) => context.push(route),
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: Routes.stockMovements,
                child: Text('Mouvements de stock'),
              ),
              PopupMenuItem(
                value: Routes.categories,
                child: Text('Catégories'),
              ),
              PopupMenuItem(
                value: Routes.productImport,
                child: Text('Importer des produits'),
              ),
            ],
          ),
        ],
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
              graphic: const PackageIcon(size: 32),
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
            categoryId: _categoryId,
            onPickCategory: _pickCategory,
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

/// Valeur de l'onglet « Catégorie » (ouvre le choix, n'est jamais actif).
const _categoryTab = 'category';

class _StockList extends ConsumerWidget {
  const _StockList({
    required this.products,
    required this.filter,
    required this.query,
    required this.categoryId,
    required this.onPickCategory,
    required this.searchController,
    required this.onQueryChanged,
    required this.onFilterChanged,
    required this.onScan,
    required this.onOpen,
  });

  final List<Product> products;
  final StockFilter filter;
  final String query;
  final String? categoryId;
  final VoidCallback onPickCategory;
  final TextEditingController searchController;
  final ValueChanged<String> onQueryChanged;
  final ValueChanged<StockFilter> onFilterChanged;
  final VoidCallback onScan;
  final ValueChanged<Product> onOpen;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = AppColors.of(context);
    final summary = ref.watch(stockSummaryProvider).value;
    final categories = ref.watch(categoriesProvider).value ?? const [];
    // Catégorie supprimée entre-temps : le filtre retombe sur « Toutes ».
    final activeCategory = categories
        .where((c) => c.id == categoryId)
        .firstOrNull;
    final visible = filterStockProducts(
      products,
      filter: filter,
      query: query,
      categoryId: activeCategory?.id,
    );
    String counted(String label, int? count) =>
        count == null ? label : '$label $count';

    return CustomScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      slivers: [
        SliverList.list(
          children: [
            if (summary != null) StockSummaryHeader(summary: summary),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.xs,
                AppSpacing.md,
                AppSpacing.sm,
              ),
              child: AppSearchBar(
                controller: searchController,
                onChanged: onQueryChanged,
                hintText: 'Rechercher un produit',
                actions: [
                  TextButton.icon(
                    onPressed: onScan,
                    icon: const Icon(Icons.qr_code_scanner, size: 20),
                    label: const Text('Scanner'),
                  ),
                ],
              ),
            ),
            UnderlineTabs<String>(
              tabs: [
                (value: StockFilter.all.name, label: 'Tous'),
                (
                  value: StockFilter.lowStock.name,
                  label: counted('Stock bas', summary?.lowStockCount),
                ),
                (
                  value: StockFilter.outOfStock.name,
                  label: counted('Ruptures', summary?.outOfStockCount),
                ),
                if (categories.isNotEmpty)
                  (
                    value: _categoryTab,
                    label: activeCategory == null
                        ? 'Catégorie'
                        : 'Catégorie : ${activeCategory.name}',
                  ),
              ],
              selected: filter.name,
              onSelected: (value) => value == _categoryTab
                  ? onPickCategory()
                  : onFilterChanged(StockFilter.values.byName(value)),
            ),
          ],
        ),
        if (visible.isEmpty)
          SliverFillRemaining(
            hasScrollBody: false,
            child: query.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Text(
                      'Aucun produit ne correspond à « $query ».',
                      textAlign: TextAlign.center,
                      style: AppTypography.body.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                  )
                : _EmptyFilter(
                    filter: filter,
                    onShowAll: () => onFilterChanged(StockFilter.all),
                  ),
          )
        else
          SliverList.builder(
            itemCount: visible.length,
            itemBuilder: (context, index) {
              final product = visible[index];
              return DecoratedBox(
                position: DecorationPosition.foreground,
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: colors.border)),
                ),
                child: ColoredBox(
                  color: colors.surface,
                  child: StockProductTile(
                    key: ValueKey(product.id),
                    product: product,
                    onTap: () => onOpen(product),
                    onAdjust: product.currentStock == null
                        ? null
                        : () => showStockAdjustmentSheet(context, product.id),
                  ),
                ),
              );
            },
          ),
        const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.lg)),
      ],
    );
  }
}

/// Filtre sans résultat : une bonne nouvelle formulée comme telle.
class _EmptyFilter extends StatelessWidget {
  const _EmptyFilter({required this.filter, required this.onShowAll});

  final StockFilter filter;
  final VoidCallback onShowAll;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final (title, message) = switch (filter) {
      StockFilter.outOfStock => (
        'Aucun produit en rupture',
        'Tous vos produits sont disponibles à la vente.',
      ),
      StockFilter.lowStock => (
        'Aucun stock bas',
        'Aucun produit n’est sous son seuil d’alerte.',
      ),
      StockFilter.all => ('Aucun produit', 'Aucun produit dans cette vue.'),
    };
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppTypography.bodyStrong.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            message,
            textAlign: TextAlign.center,
            style: AppTypography.body.copyWith(color: colors.textSecondary),
          ),
          if (filter != StockFilter.all)
            TextButton(
              onPressed: onShowAll,
              child: const Text('Voir tous les produits'),
            ),
        ],
      ),
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
        SkeletonBox(height: 20),
        SizedBox(height: AppSpacing.sm),
        SkeletonBox(height: 48),
        SizedBox(height: AppSpacing.md),
        SkeletonBox(height: 64),
        SizedBox(height: AppSpacing.sm),
        SkeletonBox(height: 64),
      ],
    );
  }
}
