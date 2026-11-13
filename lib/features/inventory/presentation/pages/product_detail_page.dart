import 'dart:io';

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/network/error_mapper.dart';
import '../../../../core/providers/connectivity_provider.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/widgets/index.dart';
import '../../../catalog/domain/entities/product.dart';
import '../../../catalog/presentation/providers/category_providers.dart';
import '../../../catalog/presentation/providers/product_image_providers.dart';
import '../providers/inventory_providers.dart';
import '../widgets/stock_adjustment_sheet.dart';
import '../widgets/stock_movement_tile.dart';
import '../../../catalog/presentation/widgets/product_thumbnail.dart';
import '../../../catalog/presentation/widgets/stock_status_badge.dart';

/// Nombre de mouvements affichés en aperçu sur la fiche produit.
const _movementPreviewCount = 3;

/// Fiche produit : prix, stock, seuil, code-barres, actions (modifier,
/// ajuster) et derniers mouvements.
class ProductDetailPage extends ConsumerWidget {
  /// Crée la fiche du produit [productId].
  const ProductDetailPage({required this.productId, super.key});

  /// Produit affiché.
  final String productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productAsync = ref.watch(stockProductProvider(productId));

    return productAsync.when(
      loading: () => const AppScaffold(
        title: 'Produit',
        body: Padding(
          padding: EdgeInsets.all(AppSpacing.md),
          child: SkeletonBox(height: 200, radius: AppSpacing.radiusLg),
        ),
      ),
      error: (_, _) => const AppScaffold(
        title: 'Produit',
        body: EmptyState(
          icon: Icons.error_outline,
          title: 'Impossible de charger le produit',
          message: 'Réessayez dans un instant.',
        ),
      ),
      data: (product) => product == null
          ? const AppScaffold(
              title: 'Produit',
              body: EmptyState(
                icon: Icons.search_off,
                title: 'Produit introuvable',
                message: 'Il a peut-être été supprimé.',
              ),
            )
          : _ProductDetail(product: product),
    );
  }
}

class _ProductDetail extends ConsumerWidget {
  const _ProductDetail({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = AppColors.of(context);
    final meta = AppTypography.bodySmall.copyWith(
      color: colors.textSecondary,
      fontFeatures: AppTypography.tabularFigures,
    );
    final stock = product.currentStock;
    final isTracked = stock != null;
    final isOnline = ref.watch(isOnlineProvider).value ?? true;
    final categoryName = (ref.watch(categoriesProvider).value ?? const [])
        .where((c) => c.id == product.categoryId)
        .firstOrNull
        ?.name;
    final editRoute = Routes.productEdit.replaceFirst(':id', product.id);
    final margin = product.unitMargin;
    final purchase = product.purchasePrice;
    final minStock = product.minStock;

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Produit'),
        actions: [
          TextButton(
            onPressed: () => context.push(editRoute),
            child: const Text('Modifier'),
          ),
          const SizedBox(width: AppSpacing.xs),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(
                top: AppSpacing.sm,
                bottom: AppSpacing.lg,
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                  ),
                  child: _PhotoSection(product: product),
                ),
                const OverlineHeader('Stock'),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                  ),
                  child: isTracked
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                Text(
                                  '$stock',
                                  style: AppTypography.figureHero.copyWith(
                                    color: stock < 0 ? colors.error : null,
                                  ),
                                ),
                                const SizedBox(width: AppSpacing.sm),
                                Flexible(
                                  child: Text(
                                    minStock == null
                                        ? 'en stock'
                                        : 'en stock · alerte à $minStock',
                                    style: meta,
                                  ),
                                ),
                              ],
                            ),
                            StockStatusBadge(product: product),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            StockStatusBadge(product: product),
                            const SizedBox(height: AppSpacing.xs),
                            Text(
                              'Le stock de ce produit n\'est pas suivi. '
                              'Indiquez un stock initial dans « Modifier » '
                              'pour le suivre.',
                              style: meta,
                            ),
                          ],
                        ),
                ),
                // Prix et marge : informations internes au commerçant
                // (ADR-0009), jamais affichées en caisse.
                const OverlineHeader('Prix'),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      DefinitionRow(
                        label: 'Prix de vente',
                        value: formatFcfa(product.sellingPrice),
                      ),
                      DefinitionRow(
                        label: "Prix d'achat",
                        value: purchase == null
                            ? 'Non renseigné'
                            : formatFcfa(purchase),
                      ),
                      DefinitionRow(
                        label: 'Marge par unité',
                        value: margin == null
                            ? '—'
                            : margin > Decimal.zero
                            ? '+ ${formatFcfa(margin)}'
                            : margin < Decimal.zero
                            ? '− ${formatFcfa(margin.abs())}'
                            : formatFcfa(margin),
                        color: margin == null
                            ? null
                            : margin < Decimal.zero
                            ? colors.error
                            : colors.success,
                        showDivider: false,
                      ),
                    ],
                  ),
                ),
                const OverlineHeader('Informations'),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      DefinitionRow(
                        label: 'Catégorie',
                        value: categoryName ?? 'Aucune',
                      ),
                      DefinitionRow(
                        label: 'Code-barres',
                        value: product.barcode ?? 'Aucun',
                        showDivider: false,
                      ),
                    ],
                  ),
                ),
                if (isTracked)
                  _RecentMovements(productId: product.id, isOnline: isOnline),
              ],
            ),
          ),
          if (isTracked)
            DecoratedBox(
              decoration: BoxDecoration(
                color: colors.surface,
                border: Border(top: BorderSide(color: colors.border)),
              ),
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm + AppSpacing.xs,
                  ),
                  // Mouvements serveur uniquement : l'ajustement demande une
                  // connexion, dit sans bloquer le reste de l'écran.
                  child: PrimaryButton(
                    label: isOnline
                        ? 'Ajuster le stock'
                        : 'Ajuster le stock · en ligne uniquement',
                    onPressed: isOnline
                        ? () => showStockAdjustmentSheet(context, product.id)
                        : null,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Aperçu des derniers mouvements — données serveur : en ligne uniquement,
/// signalé sans bloquer.
class _RecentMovements extends ConsumerWidget {
  const _RecentMovements({required this.productId, required this.isOnline});

  final String productId;
  final bool isOnline;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = AppColors.of(context);
    final history = ref.watch(stockHistoryProvider(productId));
    final meta = AppTypography.body.copyWith(color: colors.textSecondary);
    final offlineNote = Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Text(
        "L'historique des mouvements et l'ajustement du stock demandent une "
        'connexion internet. Les ventes, elles, continuent normalement.',
        style: meta,
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        OverlineHeader(
          'Derniers mouvements',
          actionLabel: isOnline ? 'Voir tout' : null,
          onAction: () => context.push(
            Routes.productStockHistory.replaceFirst(':id', productId),
          ),
        ),
        history.when(
          loading: () => const Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: SkeletonBox(height: 64),
          ),
          error: (_, _) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              offlineNote,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                child: TextButton(
                  onPressed: () =>
                      ref.invalidate(stockHistoryProvider(productId)),
                  child: const Text('Réessayer'),
                ),
              ),
            ],
          ),
          data: (movements) => movements.isEmpty
              ? Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                  ),
                  child: Text('Aucun mouvement pour ce produit.', style: meta),
                )
              : FlatList(
                  children: [
                    for (final movement in movements.take(
                      _movementPreviewCount,
                    ))
                      StockMovementTile(movement: movement),
                  ],
                ),
        ),
      ],
    );
  }
}

/// Photo du produit (en ligne pour la modifier ; affichée depuis le cache).
class _PhotoSection extends ConsumerStatefulWidget {
  const _PhotoSection({required this.product});

  final Product product;

  @override
  ConsumerState<_PhotoSection> createState() => _PhotoSectionState();
}

class _PhotoSectionState extends ConsumerState<_PhotoSection> {
  bool _busy = false;

  Future<void> _edit() async {
    final messenger = ScaffoldMessenger.of(context);
    if (!(ref.read(isOnlineProvider).value ?? false)) {
      messenger.showSnackBar(
        const SnackBar(
          content: Text('Ajout de photo disponible avec une connexion.'),
        ),
      );
      return;
    }
    final hasPhoto = widget.product.imageVersion != null;
    final choice = await showImageSourceSheet(
      context,
      title: hasPhoto ? 'Photo du produit' : 'Ajouter une photo',
      canRemove: hasPhoto,
    );
    if (choice == null || !mounted) return;

    setState(() => _busy = true);
    final editor = ref.read(productImageEditorProvider.notifier);
    try {
      if (choice is File) {
        await editor.upload(widget.product.id, choice);
      } else if (choice == ImageSourceChoice.remove) {
        await editor.remove(widget.product.id);
      }
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text('Photo non enregistrée : ${errorToFrench(e)}')),
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final hasPhoto = widget.product.imageVersion != null;
    return Row(
      children: [
        Semantics(
          button: true,
          label: hasPhoto ? 'Changer la photo' : 'Ajouter une photo',
          excludeSemantics: true,
          child: InkWell(
            onTap: _busy ? null : _edit,
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            child: Stack(
              alignment: Alignment.center,
              children: [
                ProductThumbnail(product: widget.product, size: 72),
                if (_busy)
                  const SizedBox.square(
                    dimension: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.product.name, style: AppTypography.sectionTitle),
              Text(
                hasPhoto
                    ? 'Toucher la photo pour la changer'
                    : 'Toucher pour ajouter une photo',
                style: AppTypography.bodySmall.copyWith(
                  color: colors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
