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
import '../providers/sales_providers.dart';
import 'date_range_filter_sheet.dart';

/// Onglet Ventes : historique par période, avec total, recherche par numéro
/// de reçu et accès au détail.
class SalesHistoryPage extends ConsumerStatefulWidget {
  /// Crée l'onglet Ventes.
  const SalesHistoryPage({super.key});

  @override
  ConsumerState<SalesHistoryPage> createState() => _SalesHistoryPageState();
}

class _SalesHistoryPageState extends ConsumerState<SalesHistoryPage> {
  late DateTimeRange _range;
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    _range = DateTimeRange(start: today, end: today);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _pickPeriod() async {
    final picked = await showModalBottomSheet<DateTimeRange>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DateRangeFilterSheet(initialRange: _range),
    );
    if (picked != null && mounted) setState(() => _range = picked);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final provider = salesHistoryProvider(
      startDate: _range.start,
      endDate: _range.end,
    );
    final salesAsync = ref.watch(provider);
    final isSingleDay = DateUtils.isSameDay(_range.start, _range.end);

    return AppScaffold(
      title: 'Ventes',
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.sm,
              AppSpacing.md,
              0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    ActionChip(
                      avatar: const Icon(Icons.calendar_today, size: 18),
                      label: Text(periodLabel(_range)),
                      onPressed: _pickPeriod,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    // Gros totaux : réduits pour tenir à côté de la période.
                    if (salesAsync.value case final sales?)
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: _PeriodTotals(sales: sales),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                AppSearchBar(
                  controller: _searchController,
                  onChanged: (value) => setState(() => _query = value),
                  hintText: 'Rechercher un n° de reçu',
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
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
                  return EmptyState(
                    icon: Icons.receipt_long_outlined,
                    title: 'Aucune vente',
                    message: isSingleDay
                        ? 'Vos ventes de ce jour apparaîtront ici.'
                        : 'Aucune vente sur cette période.',
                    actionLabel: 'Faire une vente',
                    onAction: () => StatefulNavigationShell.of(
                      context,
                    ).goBranch(ShellBranch.sale.index),
                  );
                }
                final visible = searchSalesByReceipt(sales, _query);
                if (visible.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Text(
                      'Aucun reçu ne correspond à « $_query ».',
                      textAlign: TextAlign.center,
                      style: AppTypography.bodyMedium.copyWith(
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  );
                }
                return ListView.separated(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  padding: const EdgeInsets.only(bottom: AppSpacing.xl),
                  itemCount: visible.length,
                  separatorBuilder: (_, _) => Divider(
                    height: 1,
                    indent: AppSpacing.md,
                    endIndent: AppSpacing.md,
                    color: cs.outlineVariant,
                  ),
                  itemBuilder: (context, index) =>
                      _SaleTile(sale: visible[index], showDate: !isSingleDay),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _PeriodTotals extends StatelessWidget {
  const _PeriodTotals({required this.sales});

  final List<Sale> sales;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final totals = salesTotals(sales);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        AmountDisplay(amount: totals.total, size: AmountSize.medium),
        Text(
          totals.count <= 1
              ? '${totals.count} vente'
              : '${totals.count} ventes',
          style: AppTypography.bodySmall.copyWith(color: cs.onSurfaceVariant),
        ),
      ],
    );
  }
}

class _SaleTile extends StatelessWidget {
  const _SaleTile({required this.sale, required this.showDate});

  final Sale sale;
  final bool showDate;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    // Numéro 0 = pas encore attribué par le serveur : jamais affiché.
    final isSynced = sale.receiptNumber > 0;
    final when = DateFormat(
      showDate ? 'd MMM · HH:mm' : 'HH:mm',
      'fr_FR',
    ).format(sale.createdAt);

    return ListTile(
      onTap: () => context.push(Routes.saleDetail, extra: sale),
      title: Text(
        isSynced ? 'Reçu #${sale.receiptNumber}' : 'En attente de synchro',
        style: AppTypography.titleMedium.copyWith(
          color: isSynced ? null : cs.onSurfaceVariant,
        ),
      ),
      subtitle: Text('$when · ${sale.paymentMethod.label}'),
      trailing: AmountDisplay(amount: sale.totalAmount),
    );
  }
}
