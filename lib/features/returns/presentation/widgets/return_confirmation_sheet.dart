import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
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
    final colors = AppColors.of(context);
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
          AppSpacing.lg,
          AppSpacing.md,
          AppSpacing.md,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Confirmer le retour',
              style: AppTypography.sectionTitle,
            ),
            const SizedBox(height: AppSpacing.sm),
            for (final s in widget.selections)
              DefinitionRow(
                label:
                    '${s.quantity} × ${s.line.productName} · '
                    '${s.condition.label}',
                value: formatFcfa(s.line.refundFor(s.quantity)),
              ),
            DefinitionRow(
              label: 'Motif',
              value: widget.reason == ReturnReason.other
                  ? widget.note.trim()
                  : widget.reason.label,
            ),
            DefinitionRow(
              label: 'Stock',
              value: [
                if (restocked > 0) '$restocked remis en stock',
                if (notRestocked > 0) '$notRestocked non remis en stock',
              ].join(' · '),
            ),
            DefinitionRow(
              label: 'Remboursement · ${widget.refundMethod.label}',
              value: formatFcfa(widget.total),
              emphasized: true,
              showDivider: false,
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
                style: AppTypography.body.copyWith(color: colors.textPrimary),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            PrimaryButton(
              label: 'Enregistrer le retour',
              onPressed: _refunded
                  ? () => Navigator.of(context).pop(true)
                  : null,
            ),
            const SizedBox(height: AppSpacing.xs),
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Revenir'),
            ),
          ],
        ),
      ),
    );
  }
}
