import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/router/main_shell.dart';
import '../../../../core/widgets/index.dart';
import '../../domain/entities/sale.dart';
import '../../domain/entities/payment_method_label.dart';
import '../../domain/repositories/sales_repository.dart';
import '../providers/sales_providers.dart';
import 'date_range_filter_sheet.dart';

/// Période rapide de l'historique.
enum _Period { today, yesterday, last7Days, custom }

/// Onglet Historique : on retrouve une vente par ce qu'on a vendu. Période en
/// puces, total de la période, recherche par produit, montant ou n° de reçu,
/// et aperçu des articles sur chaque ligne.
class SalesHistoryPage extends ConsumerStatefulWidget {
  /// Crée l'onglet Historique.
  const SalesHistoryPage({super.key});

  @override
  ConsumerState<SalesHistoryPage> createState() => _SalesHistoryPageState();
}

class _SalesHistoryPageState extends ConsumerState<SalesHistoryPage> {
  _Period _period = _Period.today;
  late DateTimeRange _range = _rangeFor(_Period.today);
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  static DateTimeRange _rangeFor(_Period period) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return switch (period) {
      _Period.yesterday => DateTimeRange(
        start: today.subtract(const Duration(days: 1)),
        end: today.subtract(const Duration(days: 1)),
      ),
      _Period.last7Days => DateTimeRange(
        start: today.subtract(const Duration(days: 6)),
        end: today,
      ),
      _Period.today ||
      _Period.custom => DateTimeRange(start: today, end: today),
    };
  }

  void _select(_Period period) => setState(() {
    _period = period;
    _range = _rangeFor(period);
  });

  Future<void> _pickDates() async {
    final picked = await showModalBottomSheet<DateTimeRange>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DateRangeFilterSheet(initialRange: _range),
    );
    if (picked == null || !mounted) return;
    setState(() {
      _range = picked;
      // Une plage choisie qui tombe sur un préréglage reprend sa puce.
      _period = switch (periodLabel(picked)) {
        "Aujourd'hui" => _Period.today,
        'Hier' => _Period.yesterday,
        '7 derniers jours' => _Period.last7Days,
        _ => _Period.custom,
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = salesHistoryProvider(
      startDate: _range.start,
      endDate: _range.end,
    );
    final salesAsync = ref.watch(provider);
    // Lignes des ventes : aperçu et recherche par produit. Facultatives —
    // sans elles, la liste reste lisible.
    final lines =
        ref
            .watch(
              salesHistoryLinesProvider(
                startDate: _range.start,
                endDate: _range.end,
              ),
            )
            .value ??
        const <String, List<SaleLinePreview>>{};
    final isSingleDay = DateUtils.isSameDay(_range.start, _range.end);
    final sales = salesAsync.value;
    final visible = sales == null
        ? null
        : searchSales(sales, _query, lines: lines);

    return AppScaffold(
      title: 'Historique',
      actions: const [
        Padding(
          padding: EdgeInsets.only(right: AppSpacing.md),
          child: OfflineStatusIndicator(),
        ),
      ],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.xs,
              AppSpacing.md,
              AppSpacing.sm,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (final (period, label) in [
                        (_Period.today, "Aujourd'hui"),
                        (_Period.yesterday, 'Hier'),
                        (_Period.last7Days, '7 jours'),
                      ]) ...[
                        ChoiceChip(
                          showCheckmark: false,
                          label: Text(label),
                          selected: _period == period,
                          onSelected: (_) => _select(period),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                      ],
                      ChoiceChip(
                        showCheckmark: false,
                        avatar: const Icon(Icons.calendar_today, size: 18),
                        label: Text(
                          _period == _Period.custom
                              ? periodLabel(_range)
                              : 'Dates',
                        ),
                        selected: _period == _Period.custom,
                        onSelected: (_) => _pickDates(),
                      ),
                    ],
                  ),
                ),
                if (visible != null && sales!.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.sm),
                  _PeriodTotals(sales: visible),
                ],
                const SizedBox(height: AppSpacing.sm),
                AppSearchBar(
                  controller: _searchController,
                  onChanged: (value) => setState(() => _query = value),
                  hintText: 'Produit, montant ou n° de reçu',
                ),
              ],
            ),
          ),
          Expanded(
            child: salesAsync.when(
              loading: () => const _HistorySkeleton(),
              error: (_, _) => EmptyState(
                icon: Icons.error_outline,
                tone: EmptyStateTone.error,
                title: "L'historique ne s'affiche pas",
                message:
                    'Vos ventes sont gardées sur ce téléphone. Réessayez '
                    'dans un instant.',
                actionLabel: 'Réessayer',
                onAction: () => ref.invalidate(provider),
              ),
              data: (sales) {
                if (sales.isEmpty) {
                  return _EmptyPeriod(
                    period: _period,
                    onPickDates: _pickDates,
                    onNewSale: () => StatefulNavigationShell.of(
                      context,
                    ).goBranch(ShellBranch.sale.index),
                  );
                }
                if (visible!.isEmpty) {
                  return EmptyState(
                    icon: Icons.search_off,
                    tone: EmptyStateTone.neutral,
                    title: 'Aucune vente « ${_query.trim()} »',
                    message:
                        'Cherchez un produit vendu, un montant ou un n° de '
                        'reçu.',
                  );
                }
                // Plusieurs jours : un en-tête par jour (libellé, sous-total)
                // puis ses ventes ; chaque groupe est construit à la demande,
                // même sur un mois de ventes.
                return CustomScrollView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  slivers: [
                    for (final group in groupSalesByDay(visible)) ...[
                      if (!isSingleDay)
                        SliverToBoxAdapter(
                          child: _DayHeader(day: group.day, sales: group.sales),
                        ),
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(
                          AppSpacing.md,
                          0,
                          AppSpacing.md,
                          AppSpacing.sm,
                        ),
                        sliver: SliverAppListGroup(
                          itemCount: group.sales.length,
                          itemBuilder: (context, index) {
                            final sale = group.sales[index];
                            return _SaleTile(
                              sale: sale,
                              lines: lines[sale.id] ?? const [],
                            );
                          },
                        ),
                      ),
                    ],
                    const SliverToBoxAdapter(
                      child: SizedBox(height: AppSpacing.xl),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// « 3 ventes … 43 200 FCFA ».
class _PeriodTotals extends StatelessWidget {
  const _PeriodTotals({required this.sales});

  final List<Sale> sales;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final totals = salesTotals(sales);
    return Row(
      children: [
        Expanded(
          child: Text(
            totals.count <= 1
                ? '${totals.count} vente'
                : '${totals.count} ventes',
            style: AppTypography.bodyMedium.copyWith(
              color: cs.onSurfaceVariant,
            ),
          ),
        ),
        Text(
          formatFcfa(totals.total),
          style: AppTypography.bodyMedium.copyWith(
            fontWeight: FontWeight.w700,
            fontFeatures: AppTypography.tabularFigures,
          ),
        ),
      ],
    );
  }
}

/// Période sans vente : proposer une autre période (ou, aujourd'hui, de
/// vendre).
class _EmptyPeriod extends StatelessWidget {
  const _EmptyPeriod({
    required this.period,
    required this.onPickDates,
    required this.onNewSale,
  });

  final _Period period;
  final VoidCallback onPickDates;
  final VoidCallback onNewSale;

  @override
  Widget build(BuildContext context) {
    final pickDates = OutlinedButton.icon(
      onPressed: onPickDates,
      icon: const Icon(Icons.calendar_today, size: 18),
      label: const Text('Choisir des dates'),
    );
    return switch (period) {
      _Period.today => EmptyState(
        icon: Icons.receipt_long_outlined,
        title: "Aucune vente aujourd'hui",
        message: 'Vos ventes de la journée apparaîtront ici.',
        actionLabel: 'Faire une vente',
        actionIcon: Icons.point_of_sale,
        onAction: onNewSale,
      ),
      _Period.yesterday => EmptyState(
        icon: Icons.receipt_long_outlined,
        tone: EmptyStateTone.neutral,
        title: 'Aucune vente hier',
        message:
            'La boutique était peut-être fermée. Essayez une autre '
            'période.',
        secondaryActions: [Center(child: pickDates)],
      ),
      _Period.last7Days || _Period.custom => EmptyState(
        icon: Icons.receipt_long_outlined,
        tone: EmptyStateTone.neutral,
        title: 'Aucune vente sur cette période',
        message: 'Essayez une autre période.',
        secondaryActions: [Center(child: pickDates)],
      ),
    };
  }
}

/// En-tête de jour (période sur plusieurs jours) : « Aujourd'hui », « Hier »
/// ou la date, puis le total et le nombre de ventes du jour.
class _DayHeader extends StatelessWidget {
  const _DayHeader({required this.day, required this.sales});

  final DateTime day;
  final List<Sale> sales;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final totals = salesTotals(sales);
    final label = switch (periodLabel(DateTimeRange(start: day, end: day))) {
      final relative && ("Aujourd'hui" || 'Hier') => relative,
      _ => toBeginningOfSentenceCase(
        DateFormat('EEEE d MMMM', 'fr_FR').format(day),
        'fr_FR',
      ),
    };
    final muted = AppTypography.bodySmall.copyWith(color: cs.onSurfaceVariant);

    return Semantics(
      header: true,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.md,
          AppSpacing.md,
          AppSpacing.sm,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.labelLarge,
              ),
            ),
            Text(
              totals.count <= 1
                  ? '${totals.count} vente · '
                  : '${totals.count} ventes · ',
              style: muted,
            ),
            Text(
              formatFcfa(totals.total),
              style: AppTypography.labelMedium.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Une vente : heure et n° de reçu, montant, articles vendus, moyen de
/// paiement et état d'envoi.
class _SaleTile extends StatelessWidget {
  const _SaleTile({required this.sale, required this.lines});

  final Sale sale;
  final List<SaleLinePreview> lines;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final muted = AppTypography.bodyMedium.copyWith(color: cs.onSurfaceVariant);
    // Numéro 0 = pas encore attribué par le serveur : jamais affiché.
    final isSynced = sale.receiptNumber > 0;
    final time = DateFormat.Hm('fr_FR').format(sale.createdAt.toLocal());
    final title = isSynced ? '$time · n° ${sale.receiptNumber}' : time;
    final preview = saleLinesPreview(lines);

    return InkWell(
      onTap: () => context.push(Routes.saleDetail, extra: sale),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm + 4,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.bodyMedium.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  formatFcfa(sale.totalAmount),
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.w700,
                    fontFeatures: AppTypography.tabularFigures,
                  ),
                ),
              ],
            ),
            if (preview.isNotEmpty)
              Text(
                preview,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: muted,
              ),
            const SizedBox(height: 2),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.xs,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  sale.paymentMethod.label,
                  style: AppTypography.bodySmall.copyWith(
                    color: cs.onSurfaceVariant,
                  ),
                ),
                if (!isSynced)
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: cs.tertiaryContainer,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: 3,
                      ),
                      child: Text(
                        "En attente d'envoi",
                        style: AppTypography.labelMedium.copyWith(
                          color: cs.onTertiaryContainer,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _HistorySkeleton extends StatelessWidget {
  const _HistorySkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      physics: const NeverScrollableScrollPhysics(),
      children: [
        for (var i = 0; i < 4; i++)
          const Padding(
            padding: EdgeInsets.only(bottom: AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(child: SkeletonBox(height: 18)),
                    SizedBox(width: AppSpacing.xl),
                    SkeletonBox(height: 18, width: 90),
                  ],
                ),
                SizedBox(height: AppSpacing.sm),
                SkeletonBox(height: 16, width: 200),
                SizedBox(height: AppSpacing.sm),
                SkeletonBox(height: 14, width: 100),
              ],
            ),
          ),
      ],
    );
  }
}
