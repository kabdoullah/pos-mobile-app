import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/index.dart';
import '../../../sales/domain/repositories/sales_repository.dart';
import '../providers/home_providers.dart';

/// Section « Aujourd'hui » : chiffre d'affaires, répartition espèces / mobile
/// money, ventes, panier moyen, bénéfice estimé et marge moyenne. Sans vente,
/// une phrase plutôt que des zéros.
class TodaySummary extends ConsumerWidget {
  /// Crée la section du jour.
  const TodaySummary({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(dailySummaryProvider);
    final stats = summary.value;
    final peak = peakHour(ref.watch(todayHourlySalesProvider).value);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        OverlineHeader(
          'Aujourd’hui',
          trailing: peak == null ? null : 'Pic : $peak h – ${peak + 1} h',
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: switch (summary) {
            _ when stats != null && stats.saleCount == 0 => const _NoSaleYet(),
            _ when stats != null => _Figures(stats: stats),
            AsyncError() => _SummaryError(
              onRetry: () => ref.invalidate(dailySummaryProvider),
            ),
            _ => const _Skeleton(),
          },
        ),
      ],
    );
  }
}

/// Heure de la plus grosse tranche de ventes du jour ; `null` sans vente.
int? peakHour(List<Decimal>? hourly) {
  if (hourly == null) return null;
  var best = -1;
  var bestAmount = Decimal.zero;
  for (final (hour, amount) in hourly.indexed) {
    if (amount > bestAmount) {
      best = hour;
      bestAmount = amount;
    }
  }
  return best < 0 ? null : best;
}

class _NoSaleYet extends StatelessWidget {
  const _NoSaleYet();

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Aucune vente pour l’instant.', style: AppTypography.body),
        Text(
          'Votre chiffre d’affaires et votre bénéfice estimé s’afficheront ici.',
          style: AppTypography.body.copyWith(color: colors.textSecondary),
        ),
      ],
    );
  }
}

class _Figures extends ConsumerWidget {
  const _Figures({required this.stats});

  final DailyStats stats;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = AppColors.of(context);
    final meta = AppTypography.bodySmall.copyWith(
      color: colors.textSecondary,
      fontFeatures: AppTypography.tabularFigures,
    );
    final average = averageBasket(stats);
    final margin = ref.watch(todayMarginSummaryProvider).value;
    final rate = margin?.marginRate;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Chiffre d’affaires', style: meta),
        Text(formatFcfa(stats.totalAmount), style: AppTypography.figureLarge),
        if (stats.refundTotal > Decimal.zero)
          Text(
            'net de ${formatFcfa(stats.refundTotal)} remboursés',
            style: meta,
          ),
        _PaymentSplit(stats: stats),
        _KpiRow(
          left: ('Ventes', '${stats.saleCount}'),
          right: ('Panier moyen', average == null ? '—' : formatFcfa(average)),
        ),
        _KpiRow(
          left: (
            'Bénéfice estimé',
            margin == null ? '—' : formatFcfa(margin.margin),
          ),
          right: (
            'Marge moyenne',
            rate == null ? '—' : '${rate.round().toBigInt()} %',
          ),
        ),
        if (margin?.hasUnknownCost ?? false)
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.xs),
            child: Text(
              'Estimation partielle : des produits n’ont pas de prix d’achat.',
              style: meta,
            ),
          ),
      ],
    );
  }
}

/// Barre fine espèces / mobile money, puis les deux montants.
class _PaymentSplit extends StatelessWidget {
  const _PaymentSplit({required this.stats});

  final DailyStats stats;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final share = cashSharePercent(stats);
    if (share == null) return const SizedBox.shrink();
    final meta = AppTypography.bodySmall.copyWith(
      color: colors.textSecondary,
      fontFeatures: AppTypography.tabularFigures,
    );
    return Semantics(
      label: 'Espèces $share %, mobile money ${100 - share} %',
      child: Padding(
        padding: const EdgeInsets.only(top: AppSpacing.sm + 2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: SizedBox(
                height: 6,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (share > 0)
                      Expanded(
                        flex: share,
                        child: ColoredBox(color: colors.textPrimary),
                      ),
                    if (share > 0 && share < 100) const SizedBox(width: 2),
                    if (share < 100)
                      Expanded(
                        flex: 100 - share,
                        child: ColoredBox(color: colors.brand),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xs + 2),
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              spacing: AppSpacing.sm,
              children: [
                Text('Espèces · ${formatFcfa(stats.cashTotal)}', style: meta),
                Text(
                  'Mobile money · ${formatFcfa(stats.mobileMoneyTotal)}',
                  style: meta,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Deux indicateurs côte à côte, séparés par des filets.
class _KpiRow extends StatelessWidget {
  const _KpiRow({required this.left, required this.right});

  final (String, String) left;
  final (String, String) right;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final divider = BorderSide(color: colors.border);
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.sm + 4),
      child: DecoratedBox(
        decoration: BoxDecoration(border: Border(top: divider)),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: _Kpi(label: left.$1, value: left.$2),
              ),
              VerticalDivider(width: 1, thickness: 1, color: colors.border),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: AppSpacing.md),
                  child: _Kpi(label: right.$1, value: right.$2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Kpi extends StatelessWidget {
  const _Kpi({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.sm + 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTypography.bodySmall.copyWith(
              color: colors.textSecondary,
            ),
          ),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              maxLines: 1,
              softWrap: false,
              style: AppTypography.bodyStrong.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                fontFeatures: AppTypography.tabularFigures,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Skeleton extends StatelessWidget {
  const _Skeleton();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SkeletonBox(width: 140, height: 14),
        SizedBox(height: AppSpacing.sm),
        SkeletonBox(width: 200, height: 24),
      ],
    );
  }
}

class _SummaryError extends StatelessWidget {
  const _SummaryError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Row(
      children: [
        Expanded(
          child: Text(
            'Impossible de charger les chiffres du jour.',
            style: AppTypography.body.copyWith(color: colors.error),
          ),
        ),
        TextButton(onPressed: onRetry, child: const Text('Réessayer')),
      ],
    );
  }
}
