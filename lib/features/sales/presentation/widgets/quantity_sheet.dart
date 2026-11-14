import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/utils/whole_number_input.dart';
import '../../../../core/widgets/index.dart';
import '../../domain/entities/discount.dart';
import 'choice_row.dart';

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

/// Quantités proposées en un appui (celles au-delà du stock sont masquées).
const _quantityPresets = [1, 5, 10, 25];

/// Ouvre la feuille de quantité (`null` si fermée sans valider) : la quantité
/// se règle avec [-]/[+], se tape au clavier ou se choisit parmi 1, 5, 10, 25.
///
/// [maxQuantity] `null` = pas de limite de stock. [discount] est la réduction
/// actuelle de la ligne, prise en compte dans le total affiché.
Future<QuantitySheetResult?> showQuantitySheet(
  BuildContext context, {
  required String productName,
  required Decimal unitPrice,
  required String confirmLabel,
  int initialQuantity = 1,
  int? maxQuantity,
  int? stock,
  Discount? discount,
}) {
  return showModalBottomSheet<QuantitySheetResult>(
    context: context,
    isScrollControlled: true,
    builder: (_) => _QuantitySheet(
      productName: productName,
      unitPrice: unitPrice,
      confirmLabel: confirmLabel,
      initialQuantity: initialQuantity,
      maxQuantity: maxQuantity,
      stock: stock,
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
    required this.discount,
  });

  final String productName;
  final Decimal unitPrice;
  final String confirmLabel;
  final int initialQuantity;
  final int? maxQuantity;
  final int? stock;
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

  /// Vrai si la saisie contient une virgule ou un point (quantité refusée).
  bool _hasSeparator = false;

  void _onTyped(String text) {
    final value = parseWholeQuantity(text);
    setState(() {
      _hasSeparator = hasDecimalSeparator(text);
      _quantity = value == null || value <= 0 ? null : value;
    });
  }

  /// Applique une quantité venant des boutons [-]/[+] au champ.
  void _step(int quantity) {
    _controller.value = TextEditingValue(
      text: '$quantity',
      selection: TextSelection.collapsed(offset: '$quantity'.length),
    );
    setState(() {
      _hasSeparator = false;
      _quantity = quantity;
    });
  }

  /// Message sous la quantité, sinon `null`.
  String? _errorFor(int? quantity, int? max) {
    if (_hasSeparator) return wholeQuantityError;
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
    final colors = AppColors.of(context);
    final max = widget.maxQuantity;
    final quantity = _quantity;
    final error = _errorFor(quantity, max);
    final gross = widget.unitPrice * Decimal.fromInt(quantity ?? 0);
    final discountAmount =
        widget.discount?.fitTo(gross)?.amountOn(gross) ?? Decimal.zero;
    final presets = [
      for (final preset in _quantityPresets)
        if (max == null || preset <= max) preset,
    ];
    final stock = widget.stock;

    return Padding(
      // Le clavier numérique ne doit pas masquer le bouton de validation.
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.lg,
            AppSpacing.md,
            AppSpacing.md,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(widget.productName, style: AppTypography.sectionTitle),
              const SizedBox(height: 2),
              Text(
                [
                  '${formatFcfa(widget.unitPrice)} l’unité',
                  if (stock != null) '$stock en stock',
                ].join(' · '),
                style: AppTypography.bodySmall.copyWith(
                  color: colors.textSecondary,
                  fontFeatures: AppTypography.tabularFigures,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              const Text('Quantité', style: AppTypography.bodyStrong),
              const SizedBox(height: AppSpacing.xs + 2),
              Align(
                alignment: Alignment.centerLeft,
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
                      onTapOutside: (_) =>
                          FocusManager.instance.primaryFocus?.unfocus(),
                      controller: _controller,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      textAlign: TextAlign.center,
                      style: AppTypography.figureLarge,
                      // Virgule gardée visible pour être refusée, jamais
                      // recollée aux chiffres (« 2,5 » ≠ 25).
                      inputFormatters: wholeNumberInputFormatters(maxLength: 5),
                      // Un appui sélectionne tout : la saisie remplace la valeur.
                      onTap: () => _controller.selection = TextSelection(
                        baseOffset: 0,
                        extentOffset: _controller.text.length,
                      ),
                      onChanged: _onTyped,
                      onSubmitted: (_) => _confirm(),
                      // Le cadre du stepper suffit : ni fond ni contour.
                      decoration: const InputDecoration(
                        isDense: true,
                        hintText: '0',
                        filled: false,
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          vertical: AppSpacing.sm,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              if (error != null || (max != null && quantity == max)) ...[
                const SizedBox(height: AppSpacing.sm),
                Text(
                  error ?? 'Stock disponible atteint',
                  style: AppTypography.meta.copyWith(
                    color: error == null ? colors.textSecondary : colors.error,
                  ),
                ),
              ],
              if (presets.length > 1) ...[
                const SizedBox(height: AppSpacing.sm + AppSpacing.xs),
                ChoiceRow<int>(
                  choices: [
                    for (final preset in presets)
                      (value: preset, label: '$preset'),
                  ],
                  selected: quantity,
                  onSelected: _step,
                ),
              ],
              const SizedBox(height: AppSpacing.sm),
              _LineTotal(
                total: gross - discountAmount,
                discountAmount: discountAmount,
              ),
              const SizedBox(height: AppSpacing.sm),
              PrimaryButton(
                label: widget.confirmLabel,
                onPressed: error == null ? _confirm : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// « Total de la ligne », réduction de la ligne déduite.
class _LineTotal extends StatelessWidget {
  const _LineTotal({required this.total, required this.discountAmount});

  final Decimal total;
  final Decimal discountAmount;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: colors.border)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm + 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Expanded(
              child: Text(
                discountAmount > Decimal.zero
                    ? 'Total de la ligne (remise '
                          '−${formatAmount(discountAmount)})'
                    : 'Total de la ligne',
                style: AppTypography.body.copyWith(
                  color: colors.textSecondary,
                  fontFeatures: AppTypography.tabularFigures,
                ),
              ),
            ),
            Text(
              formatFcfa(total),
              style: AppTypography.bodyStrong.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                fontFeatures: AppTypography.tabularFigures,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
