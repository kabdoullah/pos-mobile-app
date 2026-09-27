import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
import '../widgets/stock_status_badge.dart';

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

    return AppScaffold(
      title: product.name,
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          _PhotoSection(product: product),
          const SizedBox(height: AppSpacing.md),
          Text(product.name, style: AppTypography.titleLarge),
          const SizedBox(height: AppSpacing.xs),
          AmountDisplay(amount: product.unitPrice, size: AmountSize.large),
          const SizedBox(height: AppSpacing.md),
          DecoratedBox(
            decoration: BoxDecoration(
              color: cs.surfaceContainerLow,
              borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                children: [
                  _InfoRow(
                    label: 'Stock',
                    value: isTracked ? '${product.currentStock}' : 'Non suivi',
                    trailing: StockStatusBadge(product: product),
                  ),
                  _InfoRow(
                    label: "Seuil d'alerte",
                    value: product.minStock?.toString() ?? 'Aucun',
                  ),
                  _InfoRow(label: 'Catégorie', value: categoryName ?? 'Aucune'),
                  _InfoRow(
                    label: 'Code-barres',
                    value: product.barcode ?? 'Aucun',
                  ),
                ],
              ),
            ),
          ),
          if (!isTracked) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Le stock de ce produit n\'est pas suivi. Indiquez un stock '
              'initial dans « Modifier » pour le suivre.',
              style: AppTypography.bodySmall.copyWith(
                color: cs.onSurfaceVariant,
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.md),
          if (isTracked) ...[
            PrimaryButton(
              label: 'Ajuster le stock',
              icon: Icons.tune,
              onPressed: () => showStockAdjustmentSheet(context, product.id),
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
          OutlinedButton.icon(
            onPressed: () => context.push(editRoute),
            icon: const Icon(Icons.edit_outlined),
            label: const Text('Modifier'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(AppSpacing.buttonHeightSm),
            ),
          ),
          if (isTracked) ...[
            const SizedBox(height: AppSpacing.lg),
            _RecentMovements(productId: product.id),
          ],
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value, this.trailing});

  final String label;
  final String value;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final trailing = this.trailing;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTypography.bodyMedium.copyWith(
                color: cs.onSurfaceVariant,
              ),
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: AppTypography.titleMedium,
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: AppSpacing.sm),
            trailing,
          ],
        ],
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
    final muted = AppTypography.bodySmall.copyWith(color: cs.onSurfaceVariant);

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
          error: (_, _) => Row(
            children: [
              Expanded(
                child: Text(
                  "L'historique est disponible avec une connexion internet.",
                  style: muted,
                ),
              ),
              TextButton(
                onPressed: () =>
                    ref.invalidate(stockHistoryProvider(productId)),
                child: const Text('Réessayer'),
              ),
            ],
          ),
          data: (movements) => movements.isEmpty
              ? Text('Aucun mouvement pour ce produit.', style: muted)
              : Column(
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
    final version = widget.product.imageVersion;
    final file = version == null
        ? null
        : ref.watch(productImageFileProvider(widget.product.id, version)).value;

    return Row(
      children: [
        AppThumbnail(file: file, size: 96),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: _busy
              ? const Align(
                  alignment: Alignment.centerLeft,
                  child: SizedBox.square(
                    dimension: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
              : Align(
                  alignment: Alignment.centerLeft,
                  child: OutlinedButton.icon(
                    onPressed: _edit,
                    icon: const Icon(Icons.photo_camera_outlined),
                    label: Text(
                      version == null
                          ? 'Ajouter une photo'
                          : 'Changer la photo',
                    ),
                  ),
                ),
        ),
      ],
    );
  }
}
