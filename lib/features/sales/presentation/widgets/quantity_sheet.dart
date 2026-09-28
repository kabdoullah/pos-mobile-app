import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
/// valider). La quantité se règle avec [-]/[+] ou se tape au clavier.
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
  late final _controller = TextEditingController(
    text: '${widget.initialQuantity}',
  );

  /// Quantité saisie ; `null` si le champ est vide ou vaut 0.
  late int? _quantity = widget.initialQuantity;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTyped(String text) {
    final value = int.tryParse(text);
    setState(() => _quantity = value == null || value <= 0 ? null : value);
  }

  /// Applique une quantité venant des boutons [-]/[+] au champ.
  void _step(int quantity) {
    _controller.value = TextEditingValue(
      text: '$quantity',
      selection: TextSelection.collapsed(offset: '$quantity'.length),
    );
    setState(() => _quantity = quantity);
  }

  /// Message sous la quantité, sinon `null`.
  String? _errorFor(int? quantity, int? max) {
    if (quantity == null) return 'Saisissez une quantité';
    if (max != null && quantity > max) return 'Stock disponible : $max';
    return null;
  }

  void _confirm() {
    final quantity = _quantity;
    if (quantity == null || _errorFor(quantity, widget.maxQuantity) != null) {
      return;
    }
    Navigator.of(context).pop(QuantityChosen(quantity));
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final max = widget.maxQuantity;
    final quantity = _quantity;
    final error = _errorFor(quantity, max);
    final gross = widget.unitPrice * Decimal.fromInt(quantity ?? 0);
    final discountAmount =
        widget.discount?.fitTo(gross)?.amountOn(gross) ?? Decimal.zero;

    return Padding(
      // Le clavier numérique ne doit pas masquer le bouton de validation.
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SafeArea(
        child: SingleChildScrollView(
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
                  quantity: quantity ?? 0,
                  large: true,
                  onDecrease: quantity != null && quantity > 1
                      ? () => _step(
                          max != null && quantity > max ? max : quantity - 1,
                        )
                      : null,
                  onIncrease: max == null || (quantity ?? 0) < max
                      ? () => _step((quantity ?? 0) + 1)
                      : null,
                  field: Semantics(
                    label: 'Quantité',
                    child: TextField(
                      controller: _controller,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      textAlign: TextAlign.center,
                      style: AppTypography.titleLarge,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(5),
                      ],
                      // Un appui sélectionne tout : la saisie remplace la valeur.
                      onTap: () => _controller.selection = TextSelection(
                        baseOffset: 0,
                        extentOffset: _controller.text.length,
                      ),
                      onChanged: _onTyped,
                      onSubmitted: (_) => _confirm(),
                      decoration: const InputDecoration(
                        isDense: true,
                        hintText: '0',
                      ),
                    ),
                  ),
                ),
              ),
              if (error != null || (max != null && quantity == max)) ...[
                const SizedBox(height: AppSpacing.sm),
                Text(
                  error ?? 'Stock disponible atteint',
                  textAlign: TextAlign.center,
                  style: AppTypography.bodySmall.copyWith(
                    color: error == null ? cs.onSurfaceVariant : cs.error,
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
                onPressed: error == null ? _confirm : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
