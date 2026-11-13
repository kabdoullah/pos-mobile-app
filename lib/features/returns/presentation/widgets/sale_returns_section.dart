import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/widgets/index.dart';
import '../../../sales/domain/entities/sale.dart';
import '../../domain/entities/return_labels.dart';
import '../../domain/entities/sale_return.dart';
import '../providers/returns_providers.dart';

/// Section « Retours » du détail d'une vente : retours déjà enregistrés et
/// action « Retourner des articles » quand il reste une quantité retournable.
class SaleReturnsSection extends ConsumerWidget {
  /// Crée une [SaleReturnsSection].
  const SaleReturnsSection({required this.sale, super.key});

  /// Vente concernée.
  final Sale sale;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final returns = ref.watch(saleReturnsProvider(sale.id)).value ?? const [];
    final lines = ref.watch(returnableLinesProvider(sale)).value;
    if (lines == null || lines.isEmpty) return const SizedBox.shrink();

    final isSynced = sale.receiptNumber > 0;
    final canReturn = isSynced && lines.any((l) => l.returnableQuantity > 0);
    final names = {for (final l in lines) l.saleItemId: l.productName};

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (returns.isNotEmpty) ...[
          const OverlineHeader('Retours', padding: EdgeInsets.only(bottom: 6)),
          for (final saleReturn in returns)
            _ReturnTile(saleReturn: saleReturn, names: names),
          const SizedBox(height: AppSpacing.md),
        ],
        if (canReturn)
          SecondaryButton(
            label: 'Retourner des articles',
            onPressed: () => context.push(Routes.saleReturn, extra: sale),
          )
        else if (!isSynced)
          const StatusIndicator(
            label: 'Retour possible après synchronisation de la vente.',
            tone: StatusTone.warning,
          ),
      ],
    );
  }
}

/// Un retour : numéro, date, montant, statut de synchro et articles.
class _ReturnTile extends StatelessWidget {
  const _ReturnTile({required this.saleReturn, required this.names});

  final SaleReturn saleReturn;
  final Map<String, String> names;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final meta = AppTypography.bodySmall.copyWith(color: colors.textSecondary);
    final r = saleReturn;
    final (String status, StatusTone tone) = switch (r.syncStatus) {
      ReturnSyncStatus.synced => ('Synchronisé', StatusTone.success),
      ReturnSyncStatus.pending => ('En attente de synchro', StatusTone.warning),
      ReturnSyncStatus.rejected => (
        returnRejectionMessage(r.rejectionCode),
        StatusTone.error,
      ),
    };

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: colors.border)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm + 2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    r.returnNumber > 0
                        ? 'Retour #${r.returnNumber}'
                        : 'Retour (numéro à venir)',
                    style: AppTypography.bodyStrong,
                  ),
                ),
                Text(
                  '− ${formatFcfa(r.refundAmount)}',
                  style: AppTypography.bodyStrong.copyWith(
                    fontFeatures: AppTypography.tabularFigures,
                  ),
                ),
              ],
            ),
            Text(
              '${DateFormat('d MMM · HH:mm', 'fr_FR').format(r.createdAt.toLocal())}'
              ' · ${r.reason.label} · ${r.refundMethod.label}',
              style: meta,
            ),
            for (final line in r.lines)
              Text(
                '${line.quantity} × ${names[line.saleItemId] ?? 'Article'} · '
                '${line.restocked ? 'remis en stock' : line.condition.label.toLowerCase()}',
                style: AppTypography.body,
              ),
            const SizedBox(height: 2),
            StatusIndicator(label: status, tone: tone),
          ],
        ),
      ),
    );
  }
}
