import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/index.dart';
import '../../../catalog/domain/entities/product.dart';
import '../providers/inventory_providers.dart';
import '../widgets/stock_adjustment_sheet.dart';
import '../widgets/stock_movement_tile.dart';

/// Historique paginé des mouvements de stock (journal d'audit), d'un produit
/// ou de tous les produits ([productId] `null`).
///
/// Données serveur uniquement : hors ligne, la page l'explique et propose de
/// réessayer (la règle online-only des mouvements est conservée).
class StockHistoryPage extends ConsumerWidget {
  /// Crée l'historique ; [productId] `null` = tous les produits.
  const StockHistoryPage({this.productId, super.key});

  /// Produit filtré, ou `null` pour tous les produits.
  final String? productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productId = this.productId;
    final historyState = ref.watch(stockHistoryProvider(productId));
    final colors = AppColors.of(context);
    final divider = BorderSide(color: colors.border);
    final notifier = ref.read(stockHistoryProvider(productId).notifier);
    // Vue globale : les mouvements ne portent que l'id du produit, on affiche
    // son nom depuis le catalogue local.
    final names = productId == null
        ? <String, String>{
            for (final p
                in ref.watch(stockProductsProvider).value ?? const <Product>[])
              p.id: p.name,
          }
        : const <String, String>{};

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: Text(
          productId == null ? 'Mouvements de stock' : 'Historique du stock',
        ),
        actions: [
          if (productId != null)
            TextButton(
              onPressed: () => showStockAdjustmentSheet(context, productId),
              child: const Text('Ajuster'),
            ),
          const SizedBox(width: AppSpacing.xs),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: notifier.refresh,
        child: historyState.when(
          loading: () => ListView(
            padding: const EdgeInsets.only(top: AppSpacing.sm),
            children: [
              FlatList(
                children: [
                  for (var i = 0; i < 6; i++) const _MovementSkeleton(),
                ],
              ),
            ],
          ),
          error: (_, _) => _FullHeight(
            child: EmptyState(
              icon: Icons.cloud_off_outlined,
              title: 'Disponible en ligne uniquement',
              message:
                  "L'historique des mouvements et les ajustements de stock "
                  'demandent une connexion internet. Le stock affiché reste '
                  'disponible hors ligne.',
              actionLabel: 'Réessayer',
              onAction: notifier.refresh,
            ),
          ),
          data: (movements) {
            if (movements.isEmpty) {
              return _FullHeight(
                child: EmptyState(
                  icon: Icons.swap_vert,
                  title: 'Aucun mouvement',
                  message: productId == null
                      ? 'Les ventes et ajustements apparaîtront ici.'
                      : 'Les ventes et ajustements de ce produit '
                            'apparaîtront ici.',
                  actionLabel: productId == null ? null : 'Ajuster le stock',
                  onAction: productId == null
                      ? null
                      : () => showStockAdjustmentSheet(context, productId),
                ),
              );
            }

            return NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                if (notification is ScrollEndNotification) {
                  final px = notification.metrics.pixels;
                  final max = notification.metrics.maxScrollExtent;
                  if (max > 0 && px >= max - 300) {
                    unawaited(notifier.loadMore());
                  }
                }
                return false;
              },
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.only(top: AppSpacing.sm),
                    sliver: SliverList.builder(
                      itemCount: movements.length,
                      itemBuilder: (context, index) {
                        final movement = movements[index];
                        return DecoratedBox(
                          position: DecorationPosition.foreground,
                          decoration: BoxDecoration(
                            border: Border(
                              top: index == 0 ? divider : BorderSide.none,
                              bottom: divider,
                            ),
                          ),
                          child: ColoredBox(
                            color: colors.surface,
                            child: StockMovementTile(
                              movement: movement,
                              productName: productId == null
                                  ? names[movement.productId] ??
                                        'Produit supprimé'
                                  : null,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  // Page suivante : indicateur tant qu'il reste des
                  // mouvements à charger (le chargement part en fin de
                  // défilement).
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(
                        0,
                        AppSpacing.md,
                        0,
                        AppSpacing.xxl,
                      ),
                      child: notifier.hasMore
                          ? const Center(
                              child: SizedBox.square(
                                dimension: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Garde l'état vide/erreur scrollable pour que « tirer pour rafraîchir »
/// fonctionne.
class _FullHeight extends StatelessWidget {
  const _FullHeight({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SizedBox(height: constraints.maxHeight, child: child),
      ),
    );
  }
}

/// Ligne fantôme de [StockMovementTile] : pastille, deux lignes de texte,
/// quantité à droite.
class _MovementSkeleton extends StatelessWidget {
  const _MovementSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm + AppSpacing.xs,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonBox(width: 140, height: 14, radius: AppSpacing.xs),
                SizedBox(height: AppSpacing.sm),
                SkeletonBox(width: 190, height: 12, radius: AppSpacing.xs),
              ],
            ),
          ),
          SizedBox(width: AppSpacing.md),
          SkeletonBox(width: 32, height: 14, radius: AppSpacing.xs),
        ],
      ),
    );
  }
}
