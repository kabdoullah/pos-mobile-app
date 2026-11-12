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
    final cs = Theme.of(context).colorScheme;
    final isTracked = product.currentStock != null;
    final categoryName = (ref.watch(categoriesProvider).value ?? const [])
        .where((c) => c.id == product.categoryId)
        .firstOrNull
        ?.name;
    final editRoute = Routes.productEdit.replaceFirst(':id', product.id);
    final margin = product.unitMargin;
    final marginColor = margin == null
        ? null
        : margin < Decimal.zero
        ? cs.error
        : Theme.of(context).extension<AppSemanticColors>()!.onSuccessContainer;

    return AppScaffold(
      title: 'Produit',
      actions: [
        TextButton(
          onPressed: () => context.push(editRoute),
          child: const Text('Modifier'),
        ),
        const SizedBox(width: AppSpacing.xs),
      ],
      bottomActions: isTracked
          ? [
              PrimaryButton(
                label: 'Ajuster le stock',
                icon: Icons.tune,
                onPressed: () => showStockAdjustmentSheet(context, product.id),
              ),
            ]
          : null,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.sm,
          AppSpacing.md,
          AppSpacing.lg,
        ),
        children: [
          Row(
            children: [
              _PhotoSection(product: product),
              const SizedBox(width: AppSpacing.sm + 6),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: AppTypography.appBarTitle.copyWith(height: 1.2),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        formatFcfa(product.sellingPrice),
                        style: AppTypography.amountLarge.copyWith(
                          color: cs.onSurface,
                          fontFeatures: AppTypography.tabularFigures,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          AppListGroup(
            children: [
              _InfoRow(
                label: 'Stock',
                value: isTracked ? '${product.currentStock}' : 'Non suivi',
                trailing: isTracked ? StockStatusBadge(product: product) : null,
              ),
              _InfoRow(
                label: "Seuil d'alerte",
                value: product.minStock?.toString() ?? 'Aucun',
              ),
              _InfoRow(label: 'Catégorie', value: categoryName ?? 'Aucune'),
              _InfoRow(label: 'Code-barres', value: product.barcode ?? 'Aucun'),
            ],
          ),
          if (!isTracked) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Le stock de ce produit n\'est pas suivi. Indiquez un stock '
              'initial dans « Modifier » pour le suivre.',
              style: AppTypography.bodyMedium.copyWith(
                color: cs.onSurfaceVariant,
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.md),
          // Prix et marge : informations internes au commerçant (ADR-0009).
          AppListGroup(
            children: [
              _InfoRow(
                label: "Prix d'achat",
                value: product.purchasePrice == null
                    ? 'Non renseigné'
                    : formatFcfa(product.purchasePrice!),
              ),
              _InfoRow(
                label: 'Prix de vente',
                value: formatFcfa(product.sellingPrice),
              ),
              _InfoRow(
                label: 'Marge',
                value: margin == null
                    ? '—'
                    : margin > Decimal.zero
                    ? '+ ${formatFcfa(margin)}'
                    : formatFcfa(margin),
                valueColor: marginColor,
              ),
            ],
          ),
          if (isTracked) ...[
            const SizedBox(height: AppSpacing.md),
            _RecentMovements(productId: product.id),
          ],
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
    this.trailing,
    this.valueColor,
  });

  final String label;
  final String value;
  final Widget? trailing;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final trailing = this.trailing;
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: AppSpacing.buttonHeightSm),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        child: Row(
          children: [
            Text(
              label,
              style: AppTypography.bodyMedium.copyWith(
                color: cs.onSurfaceVariant,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            // Valeur calée à droite, comme une colonne de ticket.
            Expanded(
              child: Text(
                value,
                textAlign: TextAlign.end,
                style: AppTypography.bodyMedium.copyWith(
                  fontWeight: FontWeight.w700,
                  color: valueColor,
                  fontFeatures: AppTypography.tabularFigures,
                ),
              ),
            ),
            if (trailing != null) ...[
              const SizedBox(width: AppSpacing.sm),
              trailing,
            ],
          ],
        ),
      ),
    );
  }
}

/// Aperçu des derniers mouvements — données serveur : en ligne uniquement.
class _RecentMovements extends ConsumerWidget {
  const _RecentMovements({required this.productId});

  final String productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final history = ref.watch(stockHistoryProvider(productId));
    final muted = AppTypography.bodyMedium.copyWith(color: cs.onSurfaceVariant);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeader(
          title: 'Derniers mouvements',
          actionLabel: 'Voir tout',
          onAction: () => context.push(
            Routes.productStockHistory.replaceFirst(':id', productId),
          ),
        ),
        history.when(
          loading: () => const SkeletonBox(height: 64),
          // Historique serveur : hors ligne, on le dit sans bloquer
          // l'ajustement.
          error: (_, _) => Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: cs.surfaceContainerLow,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              border: Border.all(color: cs.outlineVariant),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "L'historique des mouvements s'affiche uniquement en "
                  'ligne. Vous pouvez quand même ajuster le stock.',
                  style: AppTypography.bodyMedium,
                ),
                TextButton(
                  style: TextButton.styleFrom(padding: EdgeInsets.zero),
                  onPressed: () =>
                      ref.invalidate(stockHistoryProvider(productId)),
                  child: const Text('Réessayer'),
                ),
              ],
            ),
          ),
          data: (movements) => movements.isEmpty
              ? Text('Aucun mouvement pour ce produit.', style: muted)
              : AppListGroup(
                  children: [
                    for (final movement in movements.take(
                      _movementPreviewCount,
                    ))
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                        ),
                        child: StockMovementTile(movement: movement),
                      ),
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
    final cs = Theme.of(context).colorScheme;
    final hasPhoto = widget.product.imageVersion != null;
    // Toucher la photo pour la changer : le libellé reste visible dessous.
    return Semantics(
      button: true,
      label: hasPhoto ? 'Changer la photo' : 'Ajouter une photo',
      excludeSemantics: true,
      onTap: _busy ? null : _edit,
      child: InkWell(
        onTap: _busy ? null : _edit,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        child: SizedBox(
          width: 96,
          height: 96,
          child: Stack(
            fit: StackFit.expand,
            children: [
              ProductThumbnail(product: widget.product, size: 96),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  decoration: BoxDecoration(
                    color: cs.inverseSurface.withValues(alpha: 0.8),
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(AppSpacing.radiusSm),
                    ),
                  ),
                  child: _busy
                      ? Center(
                          child: SizedBox.square(
                            dimension: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: cs.onInverseSurface,
                            ),
                          ),
                        )
                      : Text(
                          hasPhoto ? 'Changer' : 'Ajouter',
                          textAlign: TextAlign.center,
                          style: AppTypography.labelMedium.copyWith(
                            color: cs.onInverseSurface,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
