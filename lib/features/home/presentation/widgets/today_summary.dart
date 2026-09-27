import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/index.dart';
import '../../../sales/domain/repositories/sales_repository.dart';
import '../providers/home_providers.dart';

/// Chiffres du jour : chiffre d'affaires, nombre de ventes, panier moyen et
/// répartition espèces / mobile money.
class TodaySummary extends ConsumerWidget {
  /// Crée la synthèse du jour.
  const TodaySummary({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(dailySummaryProvider);

    return summary.when(
      // Données locales (drift) : le squelette n'est visible qu'un instant.
      loading: () => const Column(
        children: [
          SkeletonBox(height: 104, radius: AppSpacing.radiusLg),
          SizedBox(height: AppSpacing.sm),
          SkeletonBox(height: 76, radius: AppSpacing.radiusLg),
        ],
      ),
      error: (_, _) =>
          _SummaryError(onRetry: () => ref.invalidate(dailySummaryProvider)),
      data: (stats) => _SummaryContent(stats: stats),
    );
  }
}

class _SummaryContent extends StatelessWidget {
  const _SummaryContent({required this.stats});

  final DailyStats stats;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final average = averageBasket(stats);
    final cashShare = cashSharePercent(stats);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Chiffre d'affaires : l'information n°1 de l'écran.
        _Tile(
          color: cs.primaryContainer,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Chiffre d'affaires",
                style: AppTypography.labelMedium.copyWith(
                  color: cs.onPrimaryContainer,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              AmountDisplay(
                amount: stats.totalAmount,
                size: AmountSize.hero,
                color: cs.onPrimaryContainer,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Expanded(
              child: _Metric(label: 'Ventes', value: '${stats.saleCount}'),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _Metric(
                label: 'Panier moyen',
                value: average == null ? '—' : formatFcfa(average),
              ),
            ),
          ],
        ),
        if (cashShare != null) ...[
          const SizedBox(height: AppSpacing.sm),
          _PaymentSplit(cashPercent: cashShare, stats: stats),
        ],
      ],
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return _Tile(
      color: cs.surfaceContainerLow,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTypography.labelMedium.copyWith(
              color: cs.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(value, style: AppTypography.titleLarge),
          ),
        ],
      ),
    );
  }
}

/// Répartition de l'encaissé : barre à deux segments + montants.
class _PaymentSplit extends StatelessWidget {
  const _PaymentSplit({required this.cashPercent, required this.stats});

  final int cashPercent;
  final DailyStats stats;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final muted = AppTypography.bodySmall.copyWith(color: cs.onSurfaceVariant);

    return Semantics(
      label: 'Espèces $cashPercent %, mobile money ${100 - cashPercent} %',
      child: _Tile(
        color: cs.surfaceContainerLow,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
              child: SizedBox(
                height: 8,
                child: Row(
                  children: [
                    if (cashPercent > 0)
                      Expanded(
                        flex: cashPercent,
                        child: ColoredBox(color: cs.primary),
                      ),
                    if (cashPercent < 100)
                      Expanded(
                        flex: 100 - cashPercent,
                        child: ColoredBox(color: cs.secondary),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            _Legend(
              color: cs.primary,
              label: 'Espèces',
              amount: formatFcfa(stats.cashTotal),
              style: muted,
            ),
            _Legend(
              color: cs.secondary,
              label: 'Mobile money',
              amount: formatFcfa(stats.mobileMoneyTotal),
              style: muted,
            ),
          ],
        ),
      ),
    );
  }
}

/// Ligne de légende : pastille, libellé et montant aligné à droite (une ligne
/// par moyen : les gros montants ne tiennent pas côte à côte sur 360 dp).
class _Legend extends StatelessWidget {
  const _Legend({
    required this.color,
    required this.label,
    required this.amount,
    required this.style,
  });

  final Color color;
  final String label;
  final String amount;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 2),
      child: Row(
        children: [
          DecoratedBox(
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            child: const SizedBox.square(dimension: 8),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(child: Text(label, style: style)),
          Text(amount, style: style),
        ],
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({required this.color, required this.child});

  final Color color;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: child,
      ),
    );
  }
}

class _SummaryError extends StatelessWidget {
  const _SummaryError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return _Tile(
      color: cs.errorContainer,
      child: Row(
        children: [
          Icon(Icons.error_outline, color: cs.onErrorContainer),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              'Impossible de charger les chiffres du jour.',
              style: AppTypography.bodyMedium.copyWith(
                color: cs.onErrorContainer,
              ),
            ),
          ),
          TextButton(onPressed: onRetry, child: const Text('Réessayer')),
        ],
      ),
    );
  }
}
