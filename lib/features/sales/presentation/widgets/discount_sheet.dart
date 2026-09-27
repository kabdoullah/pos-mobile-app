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

  Decimal? get _value => Decimal.tryParse(_controller.text.trim());

  /// Réduction saisie, ou `null` si le champ est vide / invalide.
  Discount? get _discount {
    final value = _value;
    return value == null ? null : Discount(type: _type, value: value);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final discount = _discount;
    final error = _controller.text.trim().isEmpty
        ? null
        : discount == null
        ? 'Entrez un nombre valide'
        : discount.validate(widget.gross);
    final amount = error == null && discount != null
        ? discount.amountOn(widget.gross)
        : Decimal.zero;
    final canApply = discount != null && error == null;

    return SafeArea(
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
                _controller.clear();
              }),
            ),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: _controller,
              autofocus: true,
              keyboardType: TextInputType.numberWithOptions(
                decimal: _type == DiscountType.percentage,
              ),
              inputFormatters: [
                _type == DiscountType.percentage
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
                suffixText: _type == DiscountType.percentage ? '%' : 'FCFA',
                errorText: error,
              ),
              onChanged: (_) => setState(() {}),
            ),
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
                        ? () => Navigator.of(context).pop((discount: discount))
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
          Text(label, style: style),
          const Spacer(),
          Text('${showMinus ? '−' : ''}${formatFcfa(amount)}', style: style),
        ],
      ),
    );
  }
}
