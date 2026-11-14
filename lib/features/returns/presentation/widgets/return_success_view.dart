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
    final colors = AppColors.of(context);
    final live = ref
        .watch(saleReturnsProvider(sale.id))
        .value
        ?.where((r) => r.id == saved.id)
        .firstOrNull;
    final r = live ?? saved;
    final (String status, StatusTone tone) = switch (r.syncStatus) {
      ReturnSyncStatus.synced => ('Synchronisé', StatusTone.success),
      ReturnSyncStatus.pending => (
        'Enregistré · en attente de synchro',
        StatusTone.warning,
      ),
      ReturnSyncStatus.rejected => (
        returnRejectionMessage(r.rejectionCode),
        StatusTone.error,
      ),
    };
    final restocked = r.lines
        .where((l) => l.restocked)
        .fold(0, (sum, l) => sum + l.quantity);

    // Actions fixées en bas : visibles même sur un petit écran.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.lg,
              AppSpacing.md,
              AppSpacing.md,
            ),
            children: [
              Icon(Icons.check_circle_outline, size: 32, color: colors.success),
              const SizedBox(height: AppSpacing.sm),
              const Text('Retour enregistré', style: AppTypography.screenTitle),
              Text(
                'La vente n° ${sale.receiptNumber} n’est pas modifiée.',
                style: AppTypography.body.copyWith(color: colors.textSecondary),
              ),
              const SizedBox(height: AppSpacing.md),
              DefinitionRow(
                label: 'N° de retour',
                value: r.returnNumber > 0 ? '#${r.returnNumber}' : 'À venir',
              ),
              DecoratedBox(
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: colors.border)),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: AppSpacing.sm + 3,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Synchro',
                          style: AppTypography.body.copyWith(
                            color: colors.textSecondary,
                          ),
                        ),
                      ),
                      Flexible(
                        child: StatusIndicator(label: status, tone: tone),
                      ),
                    ],
                  ),
                ),
              ),
              DefinitionRow(
                label: 'Remboursé · ${r.refundMethod.label}',
                value: formatFcfa(r.refundAmount),
              ),
              DefinitionRow(
                label: 'Date',
                value: DateFormat(
                  'dd/MM/yyyy HH:mm',
                  'fr_FR',
                ).format(r.createdAt.toLocal()),
              ),
              DefinitionRow(
                label: 'Stock',
                value: restocked == 0
                    ? 'Rien remis en stock'
                    : '+ $restocked remis en stock',
                showDivider: false,
              ),
            ],
          ),
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            color: colors.surface,
            border: Border(top: BorderSide(color: colors.border)),
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm + AppSpacing.xs,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  PrimaryButton(
                    label: 'Imprimer le reçu de retour',
                    onPressed: () => printReturnReceipt(
                      context,
                      ref,
                      sale: sale,
                      saleReturn: r,
                      lines: lines,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  SecondaryButton(label: 'Terminé', onPressed: onDone),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
