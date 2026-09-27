import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/index.dart';
import '../../domain/entities/discount.dart';

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
    showDragHandle: true,
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
final _percentPresets = [5, 10, 15, 20, 25, 50].map(Decimal.fromInt).toList();

/// Montants (FCFA) proposés en un appui ; ceux qui dépassent le montant brut
/// sont masqués.
final _amountPresets = [
  100,
  200,
  500,
  1000,
  2000,
  5000,
].map(Decimal.fromInt).toList();

class _DiscountSheetState extends State<_DiscountSheet> {
  late DiscountType _type = widget.initial?.type ?? DiscountType.percentage;

  /// Valeur prédéfinie choisie (`null` : aucune, ou saisie libre).
  Decimal? _preset;

  /// Saisie libre (« Autre »), pour une valeur absente des choix.
  bool _isCustom = false;
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    final initial = widget.initial;
    if (initial == null) return;
    if (_presetsFor(initial.type).contains(initial.value)) {
      _preset = initial.value;
    } else {
      _isCustom = true;
      _controller.text = initial.value.toString();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<Decimal> _presetsFor(DiscountType type) => switch (type) {
    DiscountType.percentage => _percentPresets,
    DiscountType.amount =>
      _amountPresets.where((value) => value <= widget.gross).toList(),
  };

  /// Réduction choisie, ou `null` si rien n'est choisi / la saisie est
  /// invalide.
  Discount? get _discount {
    final value = _isCustom
        ? Decimal.tryParse(_controller.text.trim())
        : _preset;
    return value == null ? null : Discount(type: _type, value: value);
  }

  void _selectPreset(Decimal value) => setState(() {
    _preset = value;
    _isCustom = false;
    FocusScope.of(context).unfocus();
  });

  void _selectCustom() => setState(() {
    _preset = null;
    _isCustom = true;
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final discount = _discount;
    final customText = _controller.text.trim();
    final error = !_isCustom || customText.isEmpty
        ? null
        : discount == null
        ? 'Entrez un nombre valide'
        : discount.validate(widget.gross);
    final amount = error == null && discount != null
        ? discount.amountOn(widget.gross)
        : Decimal.zero;
    final canApply = discount != null && error == null;
    final isPercent = _type == DiscountType.percentage;

    // Défilante : choix + clavier (« Autre ») peuvent dépasser l'écran.
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.md,
            0,
            AppSpacing.md,
            AppSpacing.md + MediaQuery.viewInsetsOf(context).bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(widget.title, style: AppTypography.titleLarge),
              const SizedBox(height: AppSpacing.md),
              SegmentedButton<DiscountType>(
                segments: const [
                  ButtonSegment(
                    value: DiscountType.percentage,
                    label: Text('Pourcentage'),
                    icon: Icon(Icons.percent),
                  ),
                  ButtonSegment(
                    value: DiscountType.amount,
                    label: Text('Montant'),
                    icon: Icon(Icons.payments_outlined),
                  ),
                ],
                selected: {_type},
                onSelectionChanged: (selection) => setState(() {
                  _type = selection.first;
                  _preset = null;
                  _isCustom = false;
                  _controller.clear();
                }),
              ),
              const SizedBox(height: AppSpacing.md),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: [
                  for (final value in _presetsFor(_type))
                    ChoiceChip(
                      label: Text(
                        isPercent ? '${value.toBigInt()} %' : formatFcfa(value),
                      ),
                      selected: !_isCustom && _preset == value,
                      onSelected: (_) => _selectPreset(value),
                    ),
                  ChoiceChip(
                    avatar: const Icon(Icons.edit_outlined, size: 18),
                    label: const Text('Autre'),
                    selected: _isCustom,
                    onSelected: (_) => _selectCustom(),
                  ),
                ],
              ),
              if (_isCustom) ...[
                const SizedBox(height: AppSpacing.md),
                TextField(
                  controller: _controller,
                  autofocus: true,
                  keyboardType: TextInputType.numberWithOptions(
                    decimal: isPercent,
                  ),
                  inputFormatters: [
                    isPercent
                        // Jusqu'à 2 décimales pour un pourcentage (ex. 12,5).
                        ? FilteringTextInputFormatter.allow(
                            RegExp(r'^\d{0,3}([.,]\d{0,2})?'),
                          )
                        : FilteringTextInputFormatter.digitsOnly,
                    // Virgule française → point décimal.
                    TextInputFormatter.withFunction(
                      (_, next) =>
                          next.copyWith(text: next.text.replaceAll(',', '.')),
                    ),
                    LengthLimitingTextInputFormatter(10),
                  ],
                  decoration: InputDecoration(
                    labelText: 'Valeur',
                    suffixText: isPercent ? '%' : 'FCFA',
                    errorText: error,
                  ),
                  onChanged: (_) => setState(() {}),
                ),
              ],
              const SizedBox(height: AppSpacing.md),
              Text(
                'Aperçu',
                style: AppTypography.labelMedium.copyWith(
                  color: cs.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              _PreviewRow(label: 'Prix initial', amount: widget.gross),
              _PreviewRow(label: 'Réduction', amount: amount, negative: true),
              const Divider(height: AppSpacing.md),
              _PreviewRow(
                label: 'Prix final',
                amount: widget.gross - amount,
                emphasized: true,
              ),
              const SizedBox(height: AppSpacing.lg),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Annuler'),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: FilledButton(
                      onPressed: canApply
                          ? () =>
                                Navigator.of(context).pop((discount: discount))
                          : null,
                      child: const Text('Appliquer'),
                    ),
                  ),
                ],
              ),
              if (widget.initial != null) ...[
                const SizedBox(height: AppSpacing.sm),
                TextButton.icon(
                  onPressed: () => Navigator.of(context).pop((discount: null)),
                  icon: const Icon(Icons.close),
                  label: const Text('Retirer la réduction'),
                  style: TextButton.styleFrom(foregroundColor: cs.error),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

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
    final cs = Theme.of(context).colorScheme;
    final style = emphasized
        ? AppTypography.titleMedium
        : AppTypography.bodyMedium.copyWith(color: cs.onSurfaceVariant);
    final showMinus = negative && amount > Decimal.zero;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          // Le montant garde toute sa largeur ; le libellé cède la place.
          Expanded(
            child: Text(label, style: style, overflow: TextOverflow.ellipsis),
          ),
          Text('${showMinus ? '−' : ''}${formatFcfa(amount)}', style: style),
        ],
      ),
    );
  }
}
