import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/responsive/responsive.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/illustrations.dart';
import '../../../../shared/widgets/index.dart';
import '../../domain/entities/sale.dart';
import '../providers/sales_providers.dart';
import 'date_range_filter_sheet.dart';

/// Sales history page — displays past sales with date filtering.
class SalesHistoryPage extends ConsumerStatefulWidget {
  /// Creates a [SalesHistoryPage].
  const SalesHistoryPage({super.key});

  @override
  ConsumerState<SalesHistoryPage> createState() => _SalesHistoryPageState();
}

class _SalesHistoryPageState extends ConsumerState<SalesHistoryPage> {
  late DateTimeRange _selectedRange;

  @override
  void initState() {
    super.initState();
    final today = DateTime.now();
    _selectedRange = DateTimeRange(start: today, end: today);
  }

  Future<void> _selectDateRange() async {
    final picked = await showModalBottomSheet<DateTimeRange>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DateRangeFilterSheet(initialRange: _selectedRange),
    );
    if (picked != null && mounted) {
      setState(() => _selectedRange = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final salesAsync = ref.watch(
      salesHistoryProvider(
        startDate: _selectedRange.start,
        endDate: _selectedRange.end,
      ),
    );
    final dateFormat = DateFormat('dd MMMM yyyy', 'fr_FR');
    final isSingleDay = _isSameDay(_selectedRange.start, _selectedRange.end);
    final dateLabel = isSingleDay
        ? dateFormat.format(_selectedRange.start)
        : '${dateFormat.format(_selectedRange.start)} – ${dateFormat.format(_selectedRange.end)}';

    return AppScaffold(
      title: 'Historique des ventes',
      actions: [
        IconButton(
          icon: const Icon(Icons.calendar_today),
          onPressed: _selectDateRange,
          tooltip: 'Changer la période',
        ),
      ],
      body: Column(
        children: [
          // Date filter header
          Container(
            width: double.infinity,
            color: Theme.of(context).colorScheme.surfaceContainerLow,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            child: Text(
              dateLabel,
              style: Theme.of(context).textTheme.titleSmall,
              textAlign: TextAlign.center,
            ),
          ),
          // Sales list
          Expanded(
            child: salesAsync.when(
              loading: () => const AppLoadingScreen(),
              error: (err, stack) => const EmptyStateIllustrated(
                illustration: Illustrations.errorState,
                title: 'Erreur',
                message: 'Impossible de charger l\'historique',
              ),
              data: (sales) {
                if (sales.isEmpty) {
                  return EmptyStateIllustrated(
                    illustration: Illustrations.emptySales,
                    title: 'Aucune vente',
                    message: isSingleDay
                        ? 'Pas de vente enregistrée ce jour.'
                        : 'Pas de vente enregistrée sur cette période.',
                  );
                }
                return RefreshIndicator(
                  onRefresh: () async => ref.invalidate(
                    salesHistoryProvider(
                      startDate: _selectedRange.start,
                      endDate: _selectedRange.end,
                    ),
                  ),
                  child: ListView.separated(
                    padding: EdgeInsets.all(
                      responsiveValue(
                        context,
                        small: AppSpacing.md,
                        medium: AppSpacing.lg,
                      ),
                    ),
                    itemCount: sales.length,
                    separatorBuilder: (_, _) =>
                        const SizedBox(height: AppSpacing.sm),
                    itemBuilder: (context, index) {
                      final sale = sales[index];
                      return _SaleCard(sale: sale);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}

/// Private sale card widget — displays a single sale in history.
class _SaleCard extends ConsumerWidget {
  /// Creates a [_SaleCard].
  const _SaleCard({required this.sale});

  /// The sale to display.
  final Sale sale;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final timeLabel = DateFormat('HH:mm', 'fr_FR').format(sale.createdAt);
    final receiptLabel = sale.receiptNumber > 0
        ? '#${sale.receiptNumber}'
        : 'Provisoire';
    final paymentLabel = _paymentMethodLabel(sale.paymentMethod);

    return AppCard(
      onTap: () => context.push(Routes.saleDetail, extra: sale),
      child: ListTile(
        leading: Icon(Icons.receipt_outlined, color: cs.primary),
        title: Text(receiptLabel),
        subtitle: Text('$timeLabel • $paymentLabel'),
        // ✨ amount seul — paymentLabel déjà dans subtitle, chip supprimé (redondant)
        trailing: AmountDisplay(
          amount: sale.totalAmount,
          size: AmountSize.small,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
      ),
    );
  }

  static String _paymentMethodLabel(PaymentMethod method) {
    return switch (method) {
      PaymentMethod.cash => 'Espèces',
      PaymentMethod.orangeMoney => 'Orange',
      PaymentMethod.mtn => 'MTN',
      PaymentMethod.wave => 'Wave',
      PaymentMethod.mixed => 'Mixte',
    };
  }
}
