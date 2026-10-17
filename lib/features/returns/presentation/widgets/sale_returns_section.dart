import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

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
    final cs = Theme.of(context).colorScheme;
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
          SectionHeader(title: 'Retours', count: returns.length),
          for (final saleReturn in returns)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: _ReturnTile(saleReturn: saleReturn, names: names),
            ),
        ],
        if (canReturn)
          OutlinedButton.icon(
            onPressed: () => context.push(Routes.saleReturn, extra: sale),
            icon: const Icon(Icons.assignment_return_outlined),
            label: const Text('Retourner des articles'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(AppSpacing.buttonHeightSm),
            ),
          )
        else if (!isSynced)
          Text(
            'Retour possible après synchronisation de la vente.',
            textAlign: TextAlign.center,
            style: AppTypography.bodySmall.copyWith(color: cs.onSurfaceVariant),
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
    final cs = Theme.of(context).colorScheme;
    final muted = AppTypography.bodySmall.copyWith(color: cs.onSurfaceVariant);
    final r = saleReturn;
    final (IconData icon, String status, Color color) = switch (r.syncStatus) {
      ReturnSyncStatus.synced => (
        Icons.cloud_done_outlined,
        'Synchronisé',
        cs.onSurfaceVariant,
      ),
      ReturnSyncStatus.pending => (
        Icons.cloud_upload_outlined,
        'En attente de synchro',
        cs.onSurfaceVariant,
      ),
      ReturnSyncStatus.rejected => (
        Icons.error_outline,
        returnRejectionMessage(r.rejectionCode),
        cs.error,
      ),
    };

    return AppCard(
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
                  style: AppTypography.titleMedium,
                ),
              ),
              Text(
                '−${formatFcfa(r.refundAmount)}',
                style: AppTypography.labelLarge,
              ),
            ],
          ),
          Text(
            '${DateFormat('dd/MM/yyyy HH:mm', 'fr_FR').format(r.createdAt.toLocal())}'
            ' · ${r.reason.label} · ${r.refundMethod.label}',
            style: muted,
          ),
          const SizedBox(height: AppSpacing.xs),
          for (final line in r.lines)
            Text(
              '${line.quantity} × ${names[line.saleItemId] ?? 'Article'} · '
              '${line.restocked ? 'remis en stock' : line.condition.label.toLowerCase()}',
              style: AppTypography.bodyMedium,
            ),
          const SizedBox(height: AppSpacing.xs),
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(status, style: muted.copyWith(color: color)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
