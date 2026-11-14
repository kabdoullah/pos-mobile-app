import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/widgets/index.dart';
import '../../domain/entities/payment_method_label.dart';
import '../../domain/entities/sale.dart';
import '../../domain/entities/sale_item_brief.dart';
import '../providers/sales_providers.dart';
import 'date_range_filter_sheet.dart';

/// Période de l'historique, choisie par onglet.
enum _Period { today, yesterday, week, month, custom }

/// Onglet Historique : période en onglets (Aujourd'hui, Hier, 7 jours, Ce
/// mois-ci, Dates), recherche par montant ou n° de reçu, ventes groupées par
/// jour avec le total du jour, statut de synchro en point + mot.
class SalesHistoryPage extends ConsumerStatefulWidget {
  /// Crée l'onglet Historique.
  const SalesHistoryPage({super.key});

  @override
  ConsumerState<SalesHistoryPage> createState() => _SalesHistoryPageState();
}

class _SalesHistoryPageState extends ConsumerState<SalesHistoryPage> {
  late DateTimeRange _range = _rangeFor(_Period.today);
  _Period _period = _Period.today;
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
    final yesterday = today.subtract(const Duration(days: 1));
    return switch (period) {
      _Period.yesterday => DateTimeRange(start: yesterday, end: yesterday),
      _Period.week => DateTimeRange(
        start: today.subtract(const Duration(days: 6)),
        end: today,
      ),
      _Period.month => DateTimeRange(
        start: DateTime(today.year, today.month),
        end: today,
      ),
      _Period.today ||
      _Period.custom => DateTimeRange(start: today, end: today),
    };
  }

  Future<void> _select(_Period period) async {
    if (period != _Period.custom) {
      setState(() {
        _period = period;
        _range = _rangeFor(period);
      });
      return;
    }
    final picked = await showModalBottomSheet<DateTimeRange>(
      context: context,
      isScrollControlled: true,
      builder: (_) => DateRangeFilterSheet(initialRange: _range),
    );
    if (picked == null || !mounted) return;
    setState(() {
      _range = picked;
      // Une plage qui correspond à un onglet l'active.
      _period = _Period.values.firstWhere(
        (p) => p != _Period.custom && _rangeFor(p) == picked,
        orElse: () => _Period.custom,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final provider = salesHistoryProvider(
      startDate: _range.start,
      endDate: _range.end,
    );
    final salesAsync = ref.watch(provider);
    // Articles par vente : résumé de chaque ligne et recherche par produit.
    // Absents (chargement, erreur) : la liste s'affiche quand même.
    final items =
        ref
            .watch(
              salesHistoryItemsProvider(
                startDate: _range.start,
                endDate: _range.end,
              ),
            )
            .value ??
        const <String, List<SaleItemBrief>>{};
    final isSingleDay = DateUtils.isSameDay(_range.start, _range.end);

    return Scaffold(
      appBar: AppBar(
        titleSpacing: AppSpacing.md,
        title: const Text('Historique'),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: AppSpacing.md),
            child: OfflineStatusIndicator(),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              0,
              AppSpacing.md,
              AppSpacing.sm,
            ),
            child: AppSearchBar(
              controller: _searchController,
              onChanged: (value) => setState(() => _query = value),
              hintText: 'Produit, montant ou n° de reçu',
            ),
          ),
          UnderlineTabs<_Period>(
            tabs: [
              (value: _Period.today, label: 'Aujourd’hui'),
              (value: _Period.yesterday, label: 'Hier'),
              (value: _Period.week, label: '7 jours'),
              (value: _Period.month, label: 'Ce mois-ci'),
              (
                value: _Period.custom,
                label: _period == _Period.custom
                    ? periodLabel(_range)
                    : 'Dates',
              ),
            ],
            selected: _period,
            onSelected: _select,
          ),
          Expanded(
            child: salesAsync.when(
              loading: () => ListView(
                padding: const EdgeInsets.all(AppSpacing.md),
                physics: const NeverScrollableScrollPhysics(),
                children: const [
                  SkeletonBox(height: 56),
                  SizedBox(height: AppSpacing.sm),
                  SkeletonBox(height: 56),
                  SizedBox(height: AppSpacing.sm),
                  SkeletonBox(height: 56),
                ],
              ),
              error: (_, _) => EmptyState(
                icon: Icons.error_outline,
                title: 'Impossible de charger les ventes',
                message: 'Réessayez dans un instant.',
                actionLabel: 'Réessayer',
                onAction: () => ref.invalidate(provider),
              ),
              data: (sales) {
                if (sales.isEmpty) {
                  return _EmptyPeriod(
                    period: _period,
                    onPickDates: () => _select(_Period.custom),
                  );
                }
                final visible = searchSales(sales, _query, items: items);
                final totals = salesTotals(visible);
                return CustomScrollView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  slivers: [
                    if (isSingleDay)
                      SliverToBoxAdapter(
                        child: _TotalsLine(
                          count: totals.count,
                          total: formatFcfa(totals.total),
                        ),
                      ),
                    if (visible.isEmpty)
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.all(AppSpacing.lg),
                          child: Text(
                            'Aucune vente ne correspond à « $_query ».',
                            textAlign: TextAlign.center,
                            style: AppTypography.body.copyWith(
                              color: colors.textSecondary,
                            ),
                          ),
                        ),
                      ),
                    // Plusieurs jours : un sur-titre par jour avec son total,
                    // puis ses ventes à plat ; construit à la demande.
                    for (final group in groupSalesByDay(visible)) ...[
                      if (!isSingleDay)
                        SliverToBoxAdapter(
                          child: _DayHeader(day: group.day, sales: group.sales),
                        ),
                      SliverList.builder(
                        itemCount: group.sales.length,
                        itemBuilder: (context, index) => DecoratedBox(
                          position: DecorationPosition.foreground,
                          decoration: BoxDecoration(
                            border: Border(
                              top: index == 0
                                  ? BorderSide(color: colors.border)
                                  : BorderSide.none,
                              bottom: BorderSide(color: colors.border),
                            ),
                          ),
                          child: ColoredBox(
                            color: colors.surface,
                            child: _SaleTile(
                              sale: group.sales[index],
                              items: items[group.sales[index].id] ?? const [],
                            ),
                          ),
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

/// « 3 ventes » et le total de la période, au-dessus de la liste.
class _TotalsLine extends StatelessWidget {
  const _TotalsLine({required this.count, required this.total});

  final int count;
  final String total;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.sm + AppSpacing.xs,
        AppSpacing.md,
        AppSpacing.sm,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              count <= 1 ? '$count vente' : '$count ventes',
              style: AppTypography.bodySmall.copyWith(
                color: colors.textSecondary,
              ),
            ),
          ),
          Text(
            total,
            style: AppTypography.bodyStrong.copyWith(
              fontFeatures: AppTypography.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}

/// Sur-titre de jour (période sur plusieurs jours) : « Aujourd'hui »,
/// « Hier · mardi 10 » ou la date, avec le nombre de ventes et le total.
class _DayHeader extends StatelessWidget {
  const _DayHeader({required this.day, required this.sales});

  final DateTime day;
  final List<Sale> sales;

  @override
  Widget build(BuildContext context) {
    final totals = salesTotals(sales);
    final count = totals.count <= 1
        ? '${totals.count} vente'
        : '${totals.count} ventes';
    final label = switch (periodLabel(DateTimeRange(start: day, end: day))) {
      "Aujourd'hui" => 'Aujourd’hui',
      'Hier' => 'Hier · ${DateFormat('EEEE d', 'fr_FR').format(day)}',
      _ => DateFormat('EEEE d MMMM', 'fr_FR').format(day),
    };
    return OverlineHeader(
      label,
      trailing: '$count · ${formatFcfa(totals.total)}',
    );
  }
}

/// Une vente : n° et heure, montant, moyen de paiement ; statut de synchro
/// tant que le reçu n'a pas de numéro.
class _SaleTile extends StatelessWidget {
  const _SaleTile({required this.sale, required this.items});

  final Sale sale;

  /// Articles de la vente (vide si pas encore sur le téléphone).
  final List<SaleItemBrief> items;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    // Numéro 0 = pas encore attribué par le serveur : jamais affiché.
    final isSynced = sale.receiptNumber > 0;
    final time = DateFormat.Hm('fr_FR').format(sale.createdAt);
    return InkWell(
      onTap: () => context.push(Routes.saleDetail, extra: sale),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 60),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      isSynced
                          ? 'Vente n° ${sale.receiptNumber} · $time'
                          : 'Vente · $time',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.bodyStrong,
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
              Text(
                items.isEmpty
                    ? sale.paymentMethod.label
                    : '${summarizeSaleItems(items)} · '
                          '${sale.paymentMethod.label}',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.bodySmall.copyWith(
                  color: colors.textSecondary,
                ),
              ),
              if (!isSynced)
                const StatusIndicator(
                  label: 'En attente de synchro',
                  tone: StatusTone.warning,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Période sans vente : proposer une autre période.
class _EmptyPeriod extends StatelessWidget {
  const _EmptyPeriod({required this.period, required this.onPickDates});

  final _Period period;
  final VoidCallback onPickDates;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final title = switch (period) {
      _Period.today => 'Aucune vente aujourd’hui',
      _Period.yesterday => 'Aucune vente hier',
      _Period.week => 'Aucune vente ces 7 derniers jours',
      _Period.month => 'Aucune vente ce mois-ci',
      _Period.custom => 'Aucune vente sur cette période',
    };
    final message = period == _Period.today
        ? 'Vos ventes du jour apparaîtront ici.'
        : 'La boutique était peut-être fermée. Essayez une autre période.';
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppTypography.bodyStrong.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            message,
            textAlign: TextAlign.center,
            style: AppTypography.body.copyWith(color: colors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.md),
          Center(
            child: SecondaryButton(
              label: 'Choisir des dates',
              onPressed: onPickDates,
            ),
          ),
        ],
      ),
    );
  }
}
