import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/index.dart';
import '../../domain/entities/return_labels.dart';
import '../../domain/entities/sale_return.dart';
import '../../domain/usecases/create_sale_return_usecase.dart';

/// Récapitulatif avant enregistrement : articles, motif, état, conséquence sur
/// le stock, montant et moyen. Le commerçant atteste avoir rendu l'argent
/// (remboursement manuel, ADR-0010). Retourne true s'il confirme.
Future<bool> showReturnConfirmationSheet(
  BuildContext context, {
  required List<ReturnSelection> selections,
  required ReturnReason reason,
  required String note,
  required RefundMethod refundMethod,
  required Decimal total,
}) async {
  final confirmed = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (context) => _ConfirmationSheet(
      selections: selections,
      reason: reason,
      note: note,
      refundMethod: refundMethod,
      total: total,
    ),
  );
  return confirmed ?? false;
}

class _ConfirmationSheet extends StatefulWidget {
  const _ConfirmationSheet({
    required this.selections,
    required this.reason,
    required this.note,
    required this.refundMethod,
    required this.total,
  });

  final List<ReturnSelection> selections;
  final ReturnReason reason;
  final String note;
  final RefundMethod refundMethod;
  final Decimal total;

  @override
  State<_ConfirmationSheet> createState() => _ConfirmationSheetState();
}

class _ConfirmationSheetState extends State<_ConfirmationSheet> {
  // Case à cocher éphémère, propre à la feuille : pas de provider.
  bool _refunded = false;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final muted = AppTypography.bodySmall.copyWith(color: cs.onSurfaceVariant);
    final restocked = widget.selections
        .where((s) => s.condition.restocks)
        .fold(0, (sum, s) => sum + s.quantity);
    final notRestocked = widget.selections
        .where((s) => !s.condition.restocks)
        .fold(0, (sum, s) => sum + s.quantity);

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          0,
          AppSpacing.md,
          AppSpacing.md,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Confirmer le retour', style: AppTypography.titleLarge),
            const SizedBox(height: AppSpacing.md),
            for (final s in widget.selections)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${s.quantity} × ${s.line.productName}',
                            style: AppTypography.bodyLarge,
                          ),
                          Text(s.condition.label, style: muted),
                        ],
                      ),
                    ),
                    Text(
                      formatFcfa(s.line.refundFor(s.quantity)),
                      style: AppTypography.labelLarge,
                    ),
                  ],
                ),
              ),
            const Divider(),
            _Row(
              label: 'Motif',
              value: widget.reason == ReturnReason.other
                  ? widget.note.trim()
                  : widget.reason.label,
            ),
            _Row(label: 'Remboursement', value: widget.refundMethod.label),
            _Row(
              label: 'Stock',
              value: [
                if (restocked > 0) '$restocked remis en stock',
                if (notRestocked > 0) '$notRestocked non remis en stock',
              ].join(' · '),
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                const Expanded(
                  child: Text('À REMBOURSER', style: AppTypography.titleMedium),
                ),
                AmountDisplay(amount: widget.total, size: AmountSize.large),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            CheckboxListTile(
              value: _refunded,
              onChanged: (v) => setState(() => _refunded = v ?? false),
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
              title: Text(
                'J’ai remis ${formatFcfa(widget.total)} au client '
                '(${widget.refundMethod.label})',
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            PrimaryButton(
              label: 'Enregistrer le retour',
              icon: Icons.check,
              onPressed: _refunded
                  ? () => Navigator.of(context).pop(true)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Libellé à sa largeur naturelle : jamais coupé en milieu de mot.
          Text(
            label,
            style: AppTypography.bodyMedium.copyWith(
              color: cs.onSurfaceVariant,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: AppTypography.labelLarge,
            ),
          ),
        ],
      ),
    );
  }
}
