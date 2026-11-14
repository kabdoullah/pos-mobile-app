import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/widgets/index.dart';
import '../../../sales/domain/entities/payment_method_label.dart';
import '../../../sales/domain/entities/sale.dart';
import '../providers/home_providers.dart';

/// « Dernières ventes » du jour, avec accès à l'historique. Masquée tant
/// qu'il n'y a pas de vente (la section du jour le dit déjà).
class RecentSalesSection extends ConsumerWidget {
  /// Crée la section.
  const RecentSalesSection({required this.onSeeAll, super.key});

  /// Ouvre l'onglet Historique.
  final VoidCallback onSeeAll;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sales = ref.watch(recentSalesProvider).value;
    if (sales == null || sales.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        OverlineHeader(
          'Dernières ventes',
          actionLabel: 'Voir l’historique',
          onAction: onSeeAll,
        ),
        FlatList(children: [for (final sale in sales) _SaleRow(sale: sale)]),
      ],
    );
  }
}

class _SaleRow extends StatelessWidget {
  const _SaleRow({required this.sale});

  final Sale sale;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    // Numéro 0 = pas encore attribué par le serveur : jamais affiché comme tel.
    final isSynced = sale.receiptNumber > 0;
    return InkWell(
      onTap: () => context.push(Routes.saleDetail, extra: sale),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 56),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isSynced
                          ? 'Vente n° ${sale.receiptNumber}'
                          : 'En attente de synchro',
                      style: AppTypography.bodyStrong.copyWith(
                        color: isSynced ? null : colors.textSecondary,
                      ),
                    ),
                    Text(
                      '${DateFormat.Hm('fr_FR').format(sale.createdAt)}'
                      ' · ${sale.paymentMethod.label}',
                      style: AppTypography.bodySmall.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                formatFcfa(sale.totalAmount),
                style: AppTypography.bodyStrong.copyWith(
                  fontFeatures: AppTypography.tabularFigures,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
