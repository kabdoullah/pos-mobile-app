import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../domain/entities/stock_movement.dart';
import '../../../catalog/presentation/widgets/product_thumbnail.dart';

/// Ligne d'un mouvement de stock : motif, date, variation et stock obtenu.
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
    final cs = Theme.of(context).colorScheme;
    final semantic = Theme.of(context).extension<AppSemanticColors>()!;
    final delta = movement.quantityDelta;
    final isPositive = (delta ?? 0) >= 0;
    final color = isPositive ? semantic.onSuccessContainer : cs.error;
    final deltaLabel = delta == null
        ? '—'
        : (isPositive ? '+ $delta' : '− ${delta.abs()}');
    final muted = AppTypography.bodySmall.copyWith(color: cs.onSurfaceVariant);
    final note = movement.note;
    final productName = this.productName;

    final details = [
      if (productName != null) _reasonLabel(movement.reason),
      DateFormat('d MMM à HH:mm', 'fr_FR').format(movement.createdAt),
      if (note != null && note.isNotEmpty) note,
    ].join(' · ');

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        children: [
          if (productName != null)
            ProductThumbnailById(productId: movement.productId)
          else
            DecoratedBox(
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.sm),
                child: Icon(
                  isPositive ? Icons.add : Icons.remove,
                  size: 20,
                  color: color,
                ),
              ),
            ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  productName ?? _reasonLabel(movement.reason),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(details, style: muted),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                deltaLabel,
                style: AppTypography.bodyMedium.copyWith(
                  color: color,
                  fontWeight: FontWeight.w700,
                  fontFeatures: AppTypography.tabularFigures,
                ),
              ),
              if (movement.resultingStock != null)
                Text('stock ${movement.resultingStock}', style: muted),
            ],
          ),
        ],
      ),
    );
  }
}
