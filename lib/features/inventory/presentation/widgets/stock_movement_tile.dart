import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../domain/entities/stock_movement.dart';

/// Ligne d'un mouvement de stock (liste à plat) : motif ou produit, date,
/// variation signée et stock obtenu (« + 60 → 60 »).
class StockMovementTile extends StatelessWidget {
  /// Crée la ligne. [productName] s'affiche en titre dans la vue « tous les
  /// produits ».
  const StockMovementTile({
    required this.movement,
    this.productName,
    super.key,
  });

  /// Mouvement affiché.
  final StockMovement movement;

  /// Nom du produit concerné (vue globale uniquement).
  final String? productName;

  static String _reasonLabel(StockMovementReason reason) => switch (reason) {
    StockMovementReason.sale => 'Vente',
    StockMovementReason.manualAdjustment => 'Ajustement',
    StockMovementReason.catalogUpdate => 'Modification du produit',
    StockMovementReason.customerReturn => 'Retour client',
  };

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final delta = movement.quantityDelta;
    final isPositive = (delta ?? 0) >= 0;
    final deltaLabel = delta == null
        ? '—'
        : isPositive
        ? '+ $delta'
        : '− ${delta.abs()}';
    final meta = AppTypography.bodySmall.copyWith(
      color: colors.textSecondary,
      fontFeatures: AppTypography.tabularFigures,
    );
    final note = movement.note;
    final productName = this.productName;
    final resulting = movement.resultingStock;

    final details = [
      DateFormat('d MMM · HH:mm', 'fr_FR').format(movement.createdAt),
      if (productName != null) _reasonLabel(movement.reason),
      if (note != null && note.isNotEmpty) note,
    ].join(' · ');

    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 60),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    productName ?? _reasonLabel(movement.reason),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.bodyStrong,
                  ),
                  Text(details, style: meta),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  deltaLabel,
                  style: AppTypography.bodyStrong.copyWith(
                    fontWeight: FontWeight.w600,
                    color: delta == null
                        ? colors.textSecondary
                        : isPositive
                        ? colors.success
                        : colors.error,
                    fontFeatures: AppTypography.tabularFigures,
                  ),
                ),
                if (resulting != null) Text('→ $resulting', style: meta),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
