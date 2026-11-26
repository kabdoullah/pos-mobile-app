import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/index.dart';
import '../../../cash_register/presentation/providers/cash_register_providers.dart';
import '../../../sales/domain/repositories/sales_repository.dart';
import '../providers/home_providers.dart';

/// Section « Aujourd'hui », dans l'ordre de lecture de la v3 : chiffre
/// d'affaires (le chiffre fort de l'accueil, cacao 500 en 32 pt : une
/// couleur de marque, pas celle des actions, car il ne se touche pas), ventes par heure
/// (teal), bénéfice estimé et marge moyenne sur une bande teal pleine largeur
/// — la seule surface teintée de l'accueil —, ventes et panier moyen, puis la
/// répartition des paiements (indigo). Sous le chiffre d'affaires, l'écart
/// avec hier à la même heure (indigo). Sans vente, le repère d'hier plutôt
/// que des zéros ; caisse fermée et journée vide, le récapitulatif d'hier.
class TodaySummary extends ConsumerWidget {
  /// Crée la section du jour.
  const TodaySummary({this.leading = false, super.key});

  /// En tête de l'accueil (sous la barre) : sur-titre sans grande marge haute.
  final bool leading;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(dailySummaryProvider);
    final stats = summary.value;
    final hourly = ref.watch(todayHourlySalesProvider).value;
    final session = ref.watch(activeCashSessionProvider);
    final yesterday = ref.watch(yesterdayRecapProvider).value;

    // Avant l'ouverture, la journée d'hier est la seule qui ait des chiffres.
    final showYesterday =
        stats != null &&
        stats.saleCount == 0 &&
        session.hasValue &&
        session.value == null &&
        yesterday != null &&
        yesterday.count > 0;
    if (showYesterday) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const OverlineHeader('Hier'),
          _YesterdayRecap(recap: yesterday),
        ],
      );
    }

    const inset = EdgeInsets.symmetric(horizontal: AppSpacing.md);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        OverlineHeader(
          'Aujourd’hui',
          padding: EdgeInsets.fromLTRB(
            AppSpacing.md,
            leading ? AppSpacing.sm : AppSpacing.lg,
            AppSpacing.md,
            AppSpacing.xs + 2,
          ),
        ),
        switch (summary) {
          _ when stats != null && stats.saleCount == 0 => const Padding(
            padding: inset,
            child: _NoSaleYet(),
          ),
          // Sans marge : la bande du bénéfice et la grille vont d'un bord à
          // l'autre ; chaque bloc pose sa propre marge.
          _ when stats != null => _Figures(stats: stats, hourly: hourly),
          AsyncError() => _SummaryError(
            onRetry: () => ref.invalidate(dailySummaryProvider),
          ),
          _ => const Padding(padding: inset, child: _Skeleton()),
        },
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

/// Début de journée : une phrase plutôt qu'un « 0 FCFA » en grand (un zéro
/// grisé se lisait comme désactivé), et le repère d'hier à la même heure.
class _NoSaleYet extends ConsumerWidget {
  const _NoSaleYet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = AppColors.of(context);
    final yesterday = ref.watch(yesterdayAtSameTimeProvider).value?.amount;
    final meta = AppTypography.metaRegular.copyWith(
      color: colors.textSecondary,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('Pas encore de vente', style: AppTypography.heading),
        Text('Le chiffre d’affaires du jour s’affichera ici.', style: meta),
        // Un repère plutôt qu'un zéro : ce que la boutique avait fait hier
        // à cette heure-ci.
        if (yesterday != null && yesterday > Decimal.zero)
          Text(
            'Hier à la même heure : ${formatFcfa(yesterday)}',
            style: meta.copyWith(
              color: colors.compareText,
              fontFeatures: AppTypography.tabularFigures,
            ),
          ),
      ],
    );
  }
}

/// Caisse fermée et aucune vente aujourd'hui : chiffre d'affaires d'hier,
/// ventes et panier moyen, bénéfice estimé sur la bande teal.
class _YesterdayRecap extends ConsumerWidget {
  const _YesterdayRecap({required this.recap});

  final DayRecap recap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = AppColors.of(context);
    final margin = ref.watch(yesterdayMarginSummaryProvider).value;
    final meta = AppTypography.metaRegular.copyWith(
      color: colors.textSecondary,
      fontFeatures: AppTypography.tabularFigures,
    );
    final average = averageOf(recap.gross, recap.count);
    final count = recap.count == 1 ? '1 vente' : '${recap.count} ventes';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Chiffre d’affaires', style: meta),
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  // Net des retours, comme le chiffre du jour.
                  formatFcfa(margin?.revenue ?? recap.gross),
                  maxLines: 1,
                  softWrap: false,
                  style: AppTypography.figureHero.copyWith(color: colors.brand),
                ),
              ),
              Text(
                average == null
                    ? count
                    : '$count · panier moyen ${formatFcfa(average)}',
                style: meta,
              ),
            ],
          ),
        ),
        _ProfitBand(profit: margin == null ? '—' : formatFcfa(margin.margin)),
      ],
    );
  }
}

/// Écart du chiffre d'affaires brut du jour avec celui d'hier à la même
/// heure, en indigo (neutre : une baisse n'est pas une erreur), flèche à
/// l'appui. Rien sans base de comparaison (aucune vente hier à cette heure).
class _VersusYesterday extends ConsumerWidget {
  const _VersusYesterday({required this.todayGross});

  /// Ventes brutes du jour (avant remboursements), comme la référence.
  final Decimal todayGross;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reference = ref.watch(yesterdayAtSameTimeProvider).value;
    if (reference == null) return const SizedBox.shrink();
    final change = percentChange(todayGross, reference.amount);
    if (change == null) return const SizedBox.shrink();
    final colors = AppColors.of(context);
    final time = DateFormat.Hm('fr_FR').format(reference.at);
    final text = switch (change) {
      0 => 'Comme hier à $time',
      > 0 => '+$change % par rapport à hier à $time',
      _ => '−${-change} % par rapport à hier à $time',
    };
    final style = AppTypography.meta.copyWith(
      color: colors.compareText,
      fontFeatures: AppTypography.tabularFigures,
    );
    return Semantics(
      label: switch (change) {
        0 => 'Autant qu’hier à $time',
        > 0 => '$change % de plus qu’hier à $time',
        _ => '${-change} % de moins qu’hier à $time',
      },
      child: ExcludeSemantics(
        child: Row(
          children: [
            if (change != 0) ...[
              Icon(
                change > 0 ? Icons.trending_up : Icons.trending_down,
                size: 16,
                color: colors.compareText,
              ),
              const SizedBox(width: AppSpacing.xs),
            ],
            Flexible(child: Text(text, style: style)),
          ],
        ),
      ),
    );
  }
}

class _Figures extends ConsumerWidget {
  const _Figures({required this.stats, required this.hourly});

  final DailyStats stats;
  final List<Decimal>? hourly;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = AppColors.of(context);
    final meta = AppTypography.metaRegular.copyWith(
      color: colors.textSecondary,
      fontFeatures: AppTypography.tabularFigures,
    );
    final average = averageBasket(stats);
    final margin = ref.watch(todayMarginSummaryProvider).value;
    final rate = margin?.marginRate;
    const inset = EdgeInsets.symmetric(horizontal: AppSpacing.md);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: inset,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Chiffre d’affaires', style: meta),
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  formatFcfa(stats.totalAmount),
                  maxLines: 1,
                  softWrap: false,
                  style: AppTypography.figureHero.copyWith(color: colors.brand),
                ),
              ),
              if (stats.refundTotal > Decimal.zero)
                Text(
                  'net de ${formatFcfa(stats.refundTotal)} remboursés',
                  style: meta,
                ),
              _VersusYesterday(
                todayGross: stats.totalAmount + stats.refundTotal,
              ),
              if (hourly case final hourly?) _HourlyBars(hourly: hourly),
            ],
          ),
        ),
        _ProfitBand(
          profit: margin == null ? '—' : formatFcfa(margin.margin),
          rate: rate == null ? '—' : '${rate.round().toBigInt()} %',
        ),
        if (margin?.hasUnknownCost ?? false)
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.xs,
              AppSpacing.md,
              0,
            ),
            child: Text(
              'Estimation partielle : des produits n’ont pas de prix d’achat.',
              style: meta,
            ),
          ),
        _KpiRow(
          left: ('Ventes', '${stats.saleCount}'),
          right: ('Panier moyen', average == null ? '—' : formatFcfa(average)),
        ),
        Padding(
          padding: inset,
          child: _PaymentSplit(stats: stats),
        ),
      ],
    );
  }
}

/// Ventes du jour heure par heure, en barres teal : l'heure de pointe en
/// plein, les autres en teinte claire. La plage couvre au moins 7 h – 19 h ;
/// l'axe nomme le début, la fin et le pic, sous sa barre.
class _HourlyBars extends StatelessWidget {
  const _HourlyBars({required this.hourly});

  /// 24 montants, index = heure locale.
  final List<Decimal> hourly;

  static const _firstHour = 7;
  static const _lastHour = 19;

  /// Écart minimal (en barres) entre le pic et un bord pour garder le
  /// repère de ce bord : en deçà, les libellés se chevaucheraient.
  static const _labelGap = 3;

  @override
  Widget build(BuildContext context) {
    final peak = peakHour(hourly);
    if (peak == null) return const SizedBox.shrink();
    final colors = AppColors.of(context);
    final active = [
      for (final (h, amount) in hourly.indexed)
        if (amount > Decimal.zero) h,
    ];
    final start = active.first < _firstHour ? active.first : _firstHour;
    final end = active.last > _lastHour ? active.last : _lastHour;
    final count = end - start + 1;
    final max = hourly[peak];
    // Légende d'axe en 13 pt : le 12 pt est réservé à la barre de navigation.
    final meta = AppTypography.caption.copyWith(
      color: colors.textSecondary,
      fontFeatures: AppTypography.tabularFigures,
    );
    final peakLabel = Text(
      'Pic $peak h',
      style: meta.copyWith(
        color: colors.performanceText,
        fontWeight: FontWeight.w600,
      ),
    );

    return Semantics(
      label: 'Ventes par heure, pic entre $peak h et ${peak + 1} h',
      child: ExcludeSemantics(
        child: Padding(
          padding: const EdgeInsets.only(top: AppSpacing.sm + 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 56,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    for (var h = start; h <= end; h++) ...[
                      if (h > start) const SizedBox(width: 4),
                      Expanded(
                        child: FractionallySizedBox(
                          // Une heure sans vente garde un trait, pour lire
                          // la plage.
                          heightFactor: hourly[h] > Decimal.zero
                              ? (hourly[h] / max).toDouble().clamp(0.08, 1.0)
                              : 0.04,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: h == peak
                                  ? colors.performance
                                  : colors.performanceMuted,
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(3),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Stack(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Opacity(
                        opacity: peak - start < _labelGap ? 0 : 1,
                        child: Text('$start h', style: meta),
                      ),
                      Opacity(
                        opacity: end - peak < _labelGap ? 0 : 1,
                        child: Text('${end + 1} h', style: meta),
                      ),
                    ],
                  ),
                  Positioned.fill(
                    child: Align(
                      // Centre de la barre du pic, de -1 (gauche) à 1.
                      alignment: Alignment(
                        count == 1 ? 0 : (peak - start) / (count - 1) * 2 - 1,
                        0,
                      ),
                      child: peakLabel,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Bénéfice estimé et marge sur la bande teal (performance), d'un bord à
/// l'autre de l'écran. Sans [rate] (récapitulatif d'hier), une seule ligne.
class _ProfitBand extends StatelessWidget {
  const _ProfitBand({required this.profit, this.rate});

  final String profit;
  final String? rate;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final label = AppTypography.label.copyWith(color: colors.performanceText);
    final rate = this.rate;

    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.md),
      child: ColoredBox(
        color: colors.performanceSubtle,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm + 6,
          ),
          child: rate == null
              ? Row(
                  children: [
                    Expanded(child: Text('Bénéfice estimé', style: label)),
                    Text(
                      profit,
                      style: AppTypography.figureSmall.copyWith(
                        color: colors.performanceText,
                      ),
                    ),
                  ],
                )
              : Row(
                  // Les deux libellés sur la même ligne.
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Bénéfice estimé', style: label),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              profit,
                              maxLines: 1,
                              softWrap: false,
                              style: AppTypography.figureLarge.copyWith(
                                color: colors.performanceText,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('Marge', style: label),
                        Text(
                          rate,
                          style: AppTypography.figureSmall.copyWith(
                            color: colors.performanceText,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

/// Ventes et panier moyen côte à côte, encadrés de filets d'un bord à
/// l'autre. La comparaison avec hier n'est faite qu'une fois, sous le
/// chiffre d'affaires.
class _KpiRow extends StatelessWidget {
  const _KpiRow({required this.left, required this.right});

  final (String, String) left;
  final (String, String) right;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final divider = BorderSide(color: colors.border);
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(top: divider, bottom: divider),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: _Kpi(label: left.$1, value: left.$2),
            ),
            VerticalDivider(width: 1, thickness: 1, color: colors.border),
            Expanded(
              child: _Kpi(label: right.$1, value: right.$2),
            ),
          ],
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
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm + 4,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTypography.metaRegular.copyWith(
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
              style: AppTypography.figureSmall,
            ),
          ),
        ],
      ),
    );
  }
}

/// « Paiements » : barre espèces / mobile money en indigo, puis une légende
/// à pastilles avec les deux montants.
class _PaymentSplit extends StatelessWidget {
  const _PaymentSplit({required this.stats});

  final DailyStats stats;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final share = cashSharePercent(stats);
    if (share == null) return const SizedBox.shrink();
    final meta = AppTypography.metaRegular.copyWith(
      color: colors.textSecondary,
      fontFeatures: AppTypography.tabularFigures,
    );
    final title = Text('Paiements', style: meta);
    const top = EdgeInsets.only(top: AppSpacing.sm + 6);
    // Un seul moyen de paiement : une barre pleine n'apprend rien.
    if (share == 0 || share == 100) {
      return Padding(
        padding: top,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            title,
            Text(
              share == 100 ? 'Tout en espèces' : 'Tout en mobile money',
              style: AppTypography.body,
            ),
          ],
        ),
      );
    }
    Widget legend(Color color, String text) => Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
          child: const SizedBox.square(dimension: 8),
        ),
        const SizedBox(width: AppSpacing.xs + 2),
        // Gros montants sur écran étroit : le libellé passe à la ligne.
        Flexible(child: Text(text, style: meta)),
      ],
    );
    return Semantics(
      label: 'Paiements : espèces $share %, mobile money ${100 - share} %',
      child: ExcludeSemantics(
        child: Padding(
          padding: top,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              title,
              const SizedBox(height: AppSpacing.sm),
              ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: SizedBox(
                  height: 10,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        flex: share,
                        child: ColoredBox(color: colors.compare),
                      ),
                      Expanded(
                        flex: 100 - share,
                        child: ColoredBox(color: colors.compareMuted),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.xs,
                children: [
                  legend(
                    colors.compare,
                    'Espèces · ${formatFcfa(stats.cashTotal)}',
                  ),
                  legend(
                    colors.compareMuted,
                    'Mobile money · ${formatFcfa(stats.mobileMoneyTotal)}',
                  ),
                ],
              ),
            ],
          ),
        ),
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
        SkeletonBox(width: 200, height: 32),
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
    // Erreur locale au bloc : le reste de l'accueil fonctionne.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ColoredBox(
          color: colors.errorSubtle,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm + 4,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  size: 20,
                  color: colors.error,
                ),
                const SizedBox(width: AppSpacing.sm + 2),
                Expanded(
                  child: Text.rich(
                    const TextSpan(
                      children: [
                        TextSpan(
                          text: 'Résumé du jour indisponible. ',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        TextSpan(text: 'Vos ventes sont bien enregistrées.'),
                      ],
                    ),
                    style: AppTypography.body.copyWith(
                      color: colors.onErrorSubtle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.sm,
            AppSpacing.md,
            0,
          ),
          child: SecondaryButton(
            label: 'Réessayer',
            icon: Icons.refresh,
            onPressed: onRetry,
          ),
        ),
      ],
    );
  }
}
