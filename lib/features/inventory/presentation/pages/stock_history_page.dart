import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../app/theme/illustrations.dart';
import '../../../../core/widgets/index.dart';
import '../../domain/entities/stock_movement.dart';
import '../providers/inventory_providers.dart';
import '../widgets/stock_adjustment_sheet.dart';

/// Affiche l'historique des mouvements de stock d'un produit (journal d'audit)
/// avec pagination, et un point d'entrée pour enregistrer un ajustement manuel.
class StockHistoryPage extends ConsumerWidget {
  /// Crée une [StockHistoryPage].
  const StockHistoryPage({required this.productId, super.key});

  /// Produit auquel appartient cet historique.
  final String productId;

  Future<void> _openAdjustmentSheet(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => StockAdjustmentSheet(productId: productId),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyState = ref.watch(stockHistoryProvider(productId));
    final cs = Theme.of(context).colorScheme;

    return AppScaffold(
      title: 'Historique du stock',
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openAdjustmentSheet(context),
        tooltip: 'Ajuster le stock',
        child: const Icon(Icons.add),
      ),
      body: RefreshIndicator(
        onRefresh: () =>
            ref.read(stockHistoryProvider(productId).notifier).refresh(),
        color: cs.primary,
        backgroundColor: cs.primaryContainer,
        strokeWidth: 3,
        child: historyState.when(
          loading: () => const AppLoadingScreen(),
          error: (error, stack) => LayoutBuilder(
            builder: (context, constraints) => SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: SizedBox(
                height: constraints.maxHeight,
                child: EmptyStateIllustrated(
                  illustration: Illustrations.errorState,
                  title: 'Erreur',
                  message: 'Impossible de charger l\'historique du stock',
                  actionLabel: 'Réessayer',
                  onAction: () => ref
                      .read(stockHistoryProvider(productId).notifier)
                      .refresh(),
                ),
              ),
            ),
          ),
          data: (movements) {
            if (movements.isEmpty) {
              return LayoutBuilder(
                builder: (context, constraints) => SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: SizedBox(
                    height: constraints.maxHeight,
                    child: EmptyStateIllustrated(
                      illustration: Illustrations.emptySales,
                      title: 'Aucun mouvement',
                      message:
                          'Les ventes et ajustements de ce produit'
                          ' apparaîtront ici',
                      actionLabel: 'Ajuster le stock',
                      onAction: () => _openAdjustmentSheet(context),
                    ),
                  ),
                ),
              );
            }

            return NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                if (notification is ScrollEndNotification) {
                  final px = notification.metrics.pixels;
                  final max = notification.metrics.maxScrollExtent;
                  if (max > 0 && px >= max - 300) {
                    unawaited(
                      ref
                          .read(stockHistoryProvider(productId).notifier)
                          .loadMore(),
                    );
                  }
                }
                return false;
              },
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.sm,
                ),
                itemCount: movements.length,
                itemBuilder: (context, index) =>
                    _StockMovementTile(movement: movements[index]),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _StockMovementTile extends StatelessWidget {
  const _StockMovementTile({required this.movement});

  final StockMovement movement;

  static String _reasonLabel(StockMovementReason reason) => switch (reason) {
    StockMovementReason.sale => 'Vente',
    StockMovementReason.manualAdjustment => 'Ajustement manuel',
    StockMovementReason.catalogUpdate => 'Mise à jour catalogue',
  };

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final semantic = Theme.of(context).extension<AppSemanticColors>()!;
    final delta = movement.quantityDelta;
    final isPositive = (delta ?? 0) >= 0;
    final color = isPositive ? semantic.success : cs.error;
    final deltaLabel = delta == null
        ? '—'
        : (isPositive ? '+$delta' : '$delta');
    final dateFormat = DateFormat('dd MMM yyyy à HH:mm', 'fr_FR');

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: AppCard(
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(isPositive ? Icons.add : Icons.remove, color: color),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _reasonLabel(movement.reason),
                    style: AppTypography.titleMedium,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    dateFormat.format(movement.createdAt),
                    style: AppTypography.bodySmall.copyWith(
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                  if (movement.note != null && movement.note!.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      movement.note!,
                      style: AppTypography.bodySmall.copyWith(
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  deltaLabel,
                  style: AppTypography.titleMedium.copyWith(color: color),
                ),
                if (movement.resultingStock != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    'Stock: ${movement.resultingStock}',
                    style: AppTypography.bodySmall.copyWith(
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
