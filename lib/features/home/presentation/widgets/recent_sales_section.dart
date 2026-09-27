import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/widgets/index.dart';
import '../../../sales/domain/entities/sale.dart';
import '../providers/home_providers.dart';

/// Dernières ventes du jour, avec accès à l'historique complet.
class RecentSalesSection extends ConsumerWidget {
  /// Crée la section.
  const RecentSalesSection({
    required this.onSeeAll,
    required this.onNewSale,
    super.key,
  });

  /// Ouvre l'onglet Historique.
  final VoidCallback onSeeAll;

  /// Ouvre l'onglet Caisse (état vide).
  final VoidCallback onNewSale;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final recent = ref.watch(recentSalesProvider);
    final sales = recent.value;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeader(
          title: 'Dernières ventes',
          actionLabel: sales == null || sales.isEmpty
              ? null
              : 'Voir l’historique',
          onAction: onSeeAll,
        ),
        if (recent.hasError && sales == null)
          Text(
            'Impossible de charger les ventes.',
            style: AppTypography.bodySmall.copyWith(color: cs.error),
          )
        else if (sales == null)
          const SkeletonBox(height: 56)
        else if (sales.isEmpty)
          _EmptyToday(onNewSale: onNewSale)
        else
          for (final sale in sales) _SaleRow(sale: sale),
      ],
    );
  }
}

class _SaleRow extends StatelessWidget {
  const _SaleRow({required this.sale});

  final Sale sale;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    // Numéro 0 = pas encore attribué par le serveur : jamais affiché comme tel.
    final title = sale.receiptNumber > 0
        ? 'Reçu #${sale.receiptNumber}'
        : 'En attente de synchro';

    return InkWell(
      onTap: () => context.push(Routes.saleDetail, extra: sale),
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTypography.bodyLarge),
                  Text(
                    DateFormat.Hm('fr_FR').format(sale.createdAt),
                    style: AppTypography.bodySmall.copyWith(
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            AmountDisplay(amount: sale.totalAmount),
            Icon(Icons.chevron_right, color: cs.onSurfaceVariant),
          ],
        ),
      ),
    );
  }
}

class _EmptyToday extends StatelessWidget {
  const _EmptyToday({required this.onNewSale});

  final VoidCallback onNewSale;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      children: [
        Expanded(
          child: Text(
            "Aucune vente aujourd'hui.",
            style: AppTypography.bodyMedium.copyWith(
              color: cs.onSurfaceVariant,
            ),
          ),
        ),
        TextButton.icon(
          onPressed: onNewSale,
          icon: const Icon(Icons.point_of_sale, size: 18),
          label: const Text('Faire une vente'),
        ),
      ],
    );
  }
}
