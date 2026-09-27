import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/index.dart';
import '../../domain/entities/discount.dart';
import 'quantity_stepper.dart';

/// Choix fait dans la feuille de quantité.
sealed class QuantitySheetResult {
  const QuantitySheetResult();
}

/// Quantité validée.
final class QuantityChosen extends QuantitySheetResult {
  /// Crée le résultat pour [quantity].
  const QuantityChosen(this.quantity);

  /// Quantité choisie.
  final int quantity;
}

/// Le vendeur veut appliquer (ou modifier) une réduction sur la ligne.
final class DiscountRequested extends QuantitySheetResult {
  /// Crée le résultat.
  const DiscountRequested();
}

/// Ouvre une feuille compacte de choix de quantité (`null` si fermée sans
/// valider).
///
/// [maxQuantity] `null` = pas de limite de stock. [offerDiscount] affiche
/// l'action « Réduction » (ligne déjà dans le panier) ; [discount] est la
/// réduction actuelle de la ligne, prise en compte dans le total affiché.
Future<QuantitySheetResult?> showQuantitySheet(
  BuildContext context, {
  required String productName,
  required Decimal unitPrice,
  required String confirmLabel,
  int initialQuantity = 1,
  int? maxQuantity,
  int? stock,
  bool offerDiscount = false,
  Discount? discount,
}) {
  return showModalBottomSheet<QuantitySheetResult>(
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
      offerDiscount: offerDiscount,
      discount: discount,
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
    required this.offerDiscount,
    required this.discount,
  });

  final String productName;
  final Decimal unitPrice;
  final String confirmLabel;
  final int initialQuantity;
  final int? maxQuantity;
  final int? stock;
  final bool offerDiscount;
  final Discount? discount;

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
    final gross = widget.unitPrice * Decimal.fromInt(_quantity);
    final discountAmount =
        widget.discount?.fitTo(gross)?.amountOn(gross) ?? Decimal.zero;

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
            if (discountAmount > Decimal.zero) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Réduction −${formatFcfa(discountAmount)}',
                textAlign: TextAlign.center,
                style: AppTypography.bodySmall.copyWith(color: cs.primary),
              ),
            ],
            const SizedBox(height: AppSpacing.lg),
            if (widget.offerDiscount) ...[
              OutlinedButton.icon(
                onPressed: () =>
                    Navigator.of(context).pop(const DiscountRequested()),
                icon: const Icon(Icons.local_offer_outlined),
                label: Text(
                  widget.discount == null
                      ? 'Réduction'
                      : 'Modifier la réduction',
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
            ],
            PrimaryButton(
              label:
                  '${widget.confirmLabel} · '
                  '${formatFcfa(gross - discountAmount)}',
              onPressed: () =>
                  Navigator.of(context).pop(QuantityChosen(_quantity)),
            ),
          ],
        ),
      ),
    );
  }
}
