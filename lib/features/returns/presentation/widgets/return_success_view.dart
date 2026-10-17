import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/index.dart';
import '../../../sales/domain/entities/sale.dart';
import '../../domain/entities/return_labels.dart';
import '../../domain/entities/returnable_line.dart';
import '../../domain/entities/sale_return.dart';
import '../print_return.dart';
import '../providers/returns_providers.dart';

/// Confirmation après enregistrement : numéro, vente d'origine, date, montant,
/// moyen et statut (suivi en direct : le numéro arrive avec la synchro).
class ReturnSuccessView extends ConsumerWidget {
  /// Crée une [ReturnSuccessView].
  const ReturnSuccessView({
    required this.sale,
    required this.saved,
    required this.lines,
    required this.onDone,
    super.key,
  });

  /// Vente d'origine.
  final Sale sale;

  /// Retour tel qu'enregistré.
  final SaleReturn saved;

  /// Lignes de la vente (noms des articles pour le reçu).
  final List<ReturnableLine> lines;

  /// Fin du parcours.
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final semantic = Theme.of(context).extension<AppSemanticColors>()!;
    final live = ref
        .watch(saleReturnsProvider(sale.id))
        .value
        ?.where((r) => r.id == saved.id)
        .firstOrNull;
    final r = live ?? saved;
    final status = switch (r.syncStatus) {
      ReturnSyncStatus.synced => 'Synchronisé',
      ReturnSyncStatus.pending => 'Enregistré · en attente de synchro',
      ReturnSyncStatus.rejected => returnRejectionMessage(r.rejectionCode),
    };

    // Actions fixées en bas : visibles même sur un petit écran avec la
    // bannière hors ligne.
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.md),
            children: [
              Icon(
                Icons.check_circle_outline,
                size: 56,
                color: semantic.success,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                r.returnNumber > 0
                    ? 'Retour #${r.returnNumber}'
                    : 'Retour enregistré',
                textAlign: TextAlign.center,
                style: AppTypography.titleLarge,
              ),
              const SizedBox(height: AppSpacing.md),
              Center(
                child: AmountDisplay(
                  amount: r.refundAmount,
                  size: AmountSize.large,
                ),
              ),
              Text(
                'remboursé · ${r.refundMethod.label}',
                textAlign: TextAlign.center,
                style: AppTypography.bodyMedium.copyWith(
                  color: cs.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              _Info(label: 'Vente', value: '#${sale.receiptNumber}'),
              _Info(
                label: 'Date',
                value: DateFormat(
                  'dd/MM/yyyy HH:mm',
                  'fr_FR',
                ).format(r.createdAt.toLocal()),
              ),
              _Info(
                label: 'Statut',
                value: status,
                color: r.syncStatus == ReturnSyncStatus.rejected
                    ? cs.error
                    : null,
              ),
            ],
          ),
        ),
        SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                PrimaryButton(
                  label: 'Imprimer le reçu de retour',
                  icon: Icons.print_outlined,
                  onPressed: () => printReturnReceipt(
                    context,
                    ref,
                    sale: sale,
                    saleReturn: r,
                    lines: lines,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                OutlinedButton(
                  onPressed: onDone,
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(
                      AppSpacing.buttonHeightSm,
                    ),
                  ),
                  child: const Text('Terminer'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _Info extends StatelessWidget {
  const _Info({required this.label, required this.value, this.color});

  final String label;
  final String value;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTypography.bodyMedium.copyWith(
                color: cs.onSurfaceVariant,
              ),
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: AppTypography.labelLarge.copyWith(color: color),
            ),
          ),
        ],
      ),
    );
  }
}
