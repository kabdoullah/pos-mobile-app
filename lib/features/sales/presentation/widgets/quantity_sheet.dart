import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/index.dart';
import 'quantity_stepper.dart';

/// Ouvre une feuille compacte de choix de quantité et retourne la quantité
/// validée (`null` si fermée sans valider).
///
/// [maxQuantity] `null` = pas de limite de stock.
Future<int?> showQuantitySheet(
  BuildContext context, {
  required String productName,
  required Decimal unitPrice,
  required String confirmLabel,
  int initialQuantity = 1,
  int? maxQuantity,
  int? stock,
}) {
  return showModalBottomSheet<int>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (_) => _QuantitySheet(
      productName: productName,
      unitPrice: unitPrice,
      confirmLabel: confirmLabel,
      initialQuantity: initialQuantity,
      maxQuantity: maxQuantity,
      stock: stock,
    ),
  );
}

class _QuantitySheet extends StatefulWidget {
  const _QuantitySheet({
    required this.productName,
    required this.unitPrice,
    required this.confirmLabel,
    required this.initialQuantity,
    required this.maxQuantity,
    required this.stock,
  });

  final String productName;
  final Decimal unitPrice;
  final String confirmLabel;
  final int initialQuantity;
  final int? maxQuantity;
  final int? stock;

  @override
  State<_QuantitySheet> createState() => _QuantitySheetState();
}

class _QuantitySheetState extends State<_QuantitySheet> {
  late int _quantity = widget.initialQuantity;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final max = widget.maxQuantity;
    final canIncrease = max == null || _quantity < max;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          0,
          AppSpacing.md,
          AppSpacing.md,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(widget.productName, style: AppTypography.titleLarge),
            const SizedBox(height: AppSpacing.xs),
            Row(
              children: [
                AmountDisplay(amount: widget.unitPrice),
                const Spacer(),
                if (widget.stock != null)
                  Text(
                    'Stock : ${widget.stock}',
                    style: AppTypography.bodySmall.copyWith(
                      color: cs.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            Center(
              child: QuantityStepper(
                quantity: _quantity,
                large: true,
                onDecrease: _quantity > 1
                    ? () => setState(() => _quantity--)
                    : null,
                onIncrease: canIncrease
                    ? () => setState(() => _quantity++)
                    : null,
              ),
            ),
            if (!canIncrease) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Stock disponible atteint',
                textAlign: TextAlign.center,
                style: AppTypography.bodySmall.copyWith(
                  color: cs.onSurfaceVariant,
                ),
              ),
            ],
            const SizedBox(height: AppSpacing.lg),
            PrimaryButton(
              label:
                  '${widget.confirmLabel} · '
                  '${formatFcfa(widget.unitPrice * Decimal.fromInt(_quantity))}',
              onPressed: () => Navigator.of(context).pop(_quantity),
            ),
          ],
        ),
      ),
    );
  }
}
