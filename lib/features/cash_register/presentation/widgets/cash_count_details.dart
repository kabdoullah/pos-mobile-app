import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/index.dart';
import '../../domain/entities/cash_count.dart';
import 'cash_count_form.dart';

/// Comptage enregistré (ouverture ou clôture), en lecture seule pour
/// l'audit : coupures comptées avec quantité et sous-total, total des
/// billets, des pièces et total.
class CashCountDetails extends StatelessWidget {
  /// Crée le détail du comptage [count] titré [title].
  const CashCountDetails({required this.title, required this.count, super.key});

  /// Sur-titre (« Comptage d'ouverture »).
  final String title;

  /// Comptage à afficher.
  final CashCount count;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final counted = [
      for (final entry in count.quantities.entries)
        if (entry.value > 0) entry,
    ];
    final breakdown = countBreakdown(count);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        OverlineHeader(title, trailing: breakdown.isEmpty ? null : breakdown),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (counted.isEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: Text(
                    'Tiroir vide : aucune espèce comptée.',
                    style: AppTypography.body.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                ),
              for (final MapEntry(key: d, value: quantity) in counted)
                DefinitionRow(
                  label:
                      '${d.isBill ? 'Billet' : 'Pièce'} '
                      '${formatAmount(Decimal.fromInt(d.value))} × $quantity',
                  value: formatFcfa(count.subtotalOf(d)),
                ),
              DefinitionRow(
                label: 'Total billets',
                value: formatFcfa(count.billsTotal),
              ),
              DefinitionRow(
                label: 'Total pièces',
                value: formatFcfa(count.coinsTotal),
              ),
              DefinitionRow(
                label: 'Total compté',
                value: formatFcfa(count.total),
                emphasized: true,
                showDivider: false,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
