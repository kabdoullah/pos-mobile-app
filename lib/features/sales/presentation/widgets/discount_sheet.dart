import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/utils/fcfa_amount_input.dart';
import '../../../../core/widgets/index.dart';
import '../../domain/entities/discount.dart';
import 'choice_row.dart';

/// Résultat de la feuille de réduction : réduction appliquée, ou retrait
/// ([discount] `null`).
typedef DiscountSheetResult = ({Discount? discount});

/// Ouvre la feuille de réduction sur un montant brut [gross] (une ligne du
/// panier ou le sous-total de la vente).
///
/// Retourne `null` si la feuille est fermée sans choix, sinon la réduction à
/// appliquer (ou `discount: null` pour retirer la réduction [initial]).
Future<DiscountSheetResult?> showDiscountSheet(
  BuildContext context, {
  required String title,
  required Decimal gross,
  Discount? initial,
}) {
  return showModalBottomSheet<DiscountSheetResult>(
    context: context,
    isScrollControlled: true,
    builder: (_) =>
        _DiscountSheet(title: title, gross: gross, initial: initial),
  );
}

class _DiscountSheet extends StatefulWidget {
  const _DiscountSheet({
    required this.title,
    required this.gross,
    required this.initial,
  });

  final String title;
  final Decimal gross;
  final Discount? initial;

  @override
  State<_DiscountSheet> createState() => _DiscountSheetState();
}

/// Pourcentages proposés en un appui.
final _percentPresets = [5, 10, 15, 20].map(Decimal.fromInt).toList();

/// Montants (FCFA) proposés en un appui ; ceux qui dépassent le montant brut
/// sont masqués.
final _amountPresets = [500, 1000, 2000, 5000].map(Decimal.fromInt).toList();

class _DiscountSheetState extends State<_DiscountSheet> {
  late DiscountType _type = widget.initial?.type ?? DiscountType.percentage;
  late final _controller = TextEditingController(
    text: widget.initial?.value.toString() ?? '',
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _isPercent => _type == DiscountType.percentage;

  List<Decimal> get _presets => _isPercent
      ? _percentPresets
      : _amountPresets.where((value) => value <= widget.gross).toList();

  /// Valeur saisie, ou `null` si le champ est vide ou invalide.
  Decimal? get _value {
    final text = _controller.text.trim();
    // Montant FCFA : francs entiers, une virgule rend la saisie invalide.
    return _isPercent ? Decimal.tryParse(text) : parseFcfaAmount(text);
  }

  void _setText(String text) {
    _controller.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final text = _controller.text.trim();
    final value = _value;
    final discount = value == null ? null : Discount(type: _type, value: value);
    final error = text.isEmpty
        ? null
        : !_isPercent && hasDecimalSeparator(text)
        ? fcfaWholeAmountError
        : discount == null
        ? 'Entrez un nombre valide'
        : discount.validate(widget.gross);
    final amount = error == null && discount != null
        ? discount.amountOn(widget.gross)
        : Decimal.zero;
    final canApply = discount != null && error == null;
    final presets = _presets;

    // Défilante : le clavier peut recouvrir le bas de la feuille.
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.lg,
            AppSpacing.md,
            AppSpacing.md + MediaQuery.viewInsetsOf(context).bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(widget.title, style: AppTypography.sectionTitle),
              const SizedBox(height: AppSpacing.md),
              SegmentedControl<DiscountType>(
                segments: const [
                  (value: DiscountType.amount, label: 'Montant'),
                  (value: DiscountType.percentage, label: 'Pourcentage'),
                ],
                selected: _type,
                onChanged: (type) {
                  if (type == _type) return;
                  _type = type;
                  _setText('');
                },
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                label: 'Remise',
                large: true,
                suffixText: _isPercent ? '%' : 'FCFA',
                errorText: error,
                controller: _controller,
                keyboardType: TextInputType.numberWithOptions(
                  decimal: _isPercent,
                ),
                inputFormatters: _isPercent
                    ? [
                        // Jusqu'à 2 décimales pour un pourcentage (ex. 12,5).
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^\d{0,3}([.,]\d{0,2})?'),
                        ),
                        // Virgule française → point décimal.
                        TextInputFormatter.withFunction(
                          (_, next) => next.copyWith(
                            text: next.text.replaceAll(',', '.'),
                          ),
                        ),
                        LengthLimitingTextInputFormatter(10),
                      ]
                    // Montant : virgule gardée visible pour être refusée,
                    // jamais recollée aux chiffres (« 50,5 » ≠ 505).
                    : fcfaAmountInputFormatters,
                onChanged: (_) => setState(() {}),
              ),
              if (presets.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.sm + AppSpacing.xs),
                ChoiceRow<Decimal>(
                  choices: [
                    for (final preset in presets)
                      (
                        value: preset,
                        label: _isPercent
                            ? '${preset.toBigInt()} %'
                            : formatAmount(preset),
                      ),
                  ],
                  selected: value,
                  onSelected: (preset) {
                    FocusScope.of(context).unfocus();
                    _setText(preset.toString());
                  },
                ),
              ],
              const SizedBox(height: AppSpacing.sm),
              _PreviewRow(label: 'Sous-total', amount: widget.gross),
              _PreviewRow(label: 'Remise', amount: amount, negative: true),
              _PreviewRow(
                label: 'Nouveau total',
                amount: widget.gross - amount,
                emphasized: true,
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: widget.initial == null
                        ? SecondaryButton(
                            label: 'Annuler',
                            onPressed: () => Navigator.of(context).pop(),
                          )
                        : SecondaryButton(
                            label: 'Retirer la remise',
                            onPressed: () =>
                                Navigator.of(context).pop((discount: null)),
                          ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: PrimaryButton(
                      label: 'Appliquer',
                      onPressed: canApply
                          ? () =>
                                Navigator.of(context).pop((discount: discount))
                          : null,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Ligne de l'aperçu (définition) : libellé à gauche, montant à droite.
class _PreviewRow extends StatelessWidget {
  const _PreviewRow({
    required this.label,
    required this.amount,
    this.negative = false,
    this.emphasized = false,
  });

  final String label;
  final Decimal amount;
  final bool negative;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final showMinus = negative && amount > Decimal.zero;
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(
          top: emphasized
              ? BorderSide(color: colors.borderStrong)
              : BorderSide.none,
          bottom: emphasized
              ? BorderSide.none
              : BorderSide(color: colors.border),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm + 2),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            // Le montant garde toute sa largeur ; le libellé cède la place.
            Expanded(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: emphasized
                    ? AppTypography.bodyStrong
                    : AppTypography.body.copyWith(color: colors.textSecondary),
              ),
            ),
            Text(
              '${showMinus ? '−' : ''}${formatFcfa(amount)}',
              style:
                  (emphasized
                          ? AppTypography.sectionTitle
                          : AppTypography.bodyStrong)
                      .copyWith(fontFeatures: AppTypography.tabularFigures),
            ),
          ],
        ),
      ),
    );
  }
}
