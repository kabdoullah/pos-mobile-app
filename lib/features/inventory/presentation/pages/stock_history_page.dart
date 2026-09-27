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
            children: const [
              SkeletonBox(height: 56),
              SizedBox(height: AppSpacing.sm),
              SkeletonBox(height: 56),
              SizedBox(height: AppSpacing.sm),
              SkeletonBox(height: 56),
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
              child: ListView.separated(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.md,
                  AppSpacing.sm,
                  AppSpacing.md,
                  AppSpacing.xxl,
                ),
                itemCount: movements.length,
                separatorBuilder: (_, _) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final movement = movements[index];
                  return StockMovementTile(
                    movement: movement,
                    productName: productId == null
                        ? names[movement.productId] ?? 'Produit supprimé'
                        : null,
                  );
                },
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
