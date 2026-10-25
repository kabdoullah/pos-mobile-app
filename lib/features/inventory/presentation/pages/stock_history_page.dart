import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

    return AppScaffold(
      title: productId == null ? 'Mouvements de stock' : 'Historique du stock',
      floatingActionButton: productId == null
          ? null
          : FloatingActionButton(
              onPressed: () => showStockAdjustmentSheet(context, productId),
              tooltip: 'Ajuster le stock',
              child: const Icon(Icons.tune),
            ),
      body: RefreshIndicator(
        onRefresh: notifier.refresh,
        child: historyState.when(
          loading: () => ListView(
            padding: const EdgeInsets.all(AppSpacing.md),
            children: [
              AppListGroup(
                dividerIndent: AppSpacing.md + 36 + AppSpacing.md,
                children: [
                  for (var i = 0; i < 6; i++) const _MovementSkeleton(),
                ],
              ),
            ],
          ),
          error: (_, _) => _FullHeight(
            child: EmptyState(
              icon: Icons.cloud_off_outlined,
              title: 'Impossible de charger les mouvements',
              message:
                  'Vérifiez votre connexion puis réessayez. Le stock affiché '
                  'reste disponible hors ligne.',
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
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.md,
                      AppSpacing.sm,
                      AppSpacing.md,
                      0,
                    ),
                    sliver: SliverAppListGroup(
                      itemCount: movements.length,
                      dividerIndent: AppSpacing.md + 36 + AppSpacing.md,
                      itemBuilder: (context, index) {
                        final movement = movements[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md,
                          ),
                          child: StockMovementTile(
                            movement: movement,
                            productName: productId == null
                                ? names[movement.productId] ??
                                      'Produit supprimé'
                                : null,
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
          SkeletonBox(width: 36, height: 36, radius: AppSpacing.radiusFull),
          SizedBox(width: AppSpacing.md),
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
