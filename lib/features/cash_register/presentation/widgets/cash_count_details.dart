import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/index.dart';
import '../../domain/entities/cash_count.dart';
import 'cash_count_form.dart';

/// Comptage enregistré (ouverture ou clôture), en lecture seule pour
/// l'audit : coupures comptées (quantité et sous-total), totaux des billets
/// et des pièces, total compté.
///
/// [collapsible] : une ligne « 10 000 FCFA · 7 billets » qui se déplie au
/// toucher (comptage d'ouverture) ; sinon sur-titre et détail toujours
/// visibles (comptage de clôture).
class CashCountDetails extends StatefulWidget {
  /// Crée le détail du comptage [count] titré [title].
  const CashCountDetails({
    required this.title,
    required this.count,
    this.collapsible = false,
    super.key,
  });

  /// Titre (« Comptage d'ouverture · 7:45 »).
  final String title;

  /// Comptage à afficher.
  final CashCount count;

  /// Replié par défaut, dépliable.
  final bool collapsible;

  @override
  State<CashCountDetails> createState() => _CashCountDetailsState();
}

class _CashCountDetailsState extends State<CashCountDetails> {
  late bool _expanded = !widget.collapsible;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final count = widget.count;
    final breakdown = countBreakdown(count);
    final summary = [
      formatFcfa(count.total),
      if (breakdown.isNotEmpty) breakdown,
    ].join(' · ');

    final Widget header;
    if (widget.collapsible) {
      header = Padding(
        padding: const EdgeInsets.only(top: AppSpacing.md),
        child: Material(
          color: colors.surface,
          shape: Border.symmetric(horizontal: BorderSide(color: colors.border)),
          child: InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            child: Semantics(
              button: true,
              expanded: _expanded,
              child: ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 56),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.md,
                    AppSpacing.xs + 2,
                    AppSpacing.sm,
                    AppSpacing.xs + 2,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.title,
                              style: AppTypography.bodyStrong.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              summary,
                              style: AppTypography.meta.copyWith(
                                color: colors.textSecondary,
                                fontFeatures: AppTypography.tabularFigures,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: AppSpacing.sm),
                        child: Icon(
                          _expanded ? Icons.expand_less : Icons.expand_more,
                          color: colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    } else {
      header = OverlineHeader(widget.title, trailing: formatFcfa(count.total));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        header,
        if (_expanded)
          Padding(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.md,
              widget.collapsible ? AppSpacing.xs : 0,
              AppSpacing.md,
              0,
            ),
            child: _CountGrid(count: count),
          ),
      ],
    );
  }
}

/// Grille « Billet 10 000 · × 2 · 20 000 FCFA » des coupures comptées, puis
/// totaux des billets et des pièces.
class _CountGrid extends StatelessWidget {
  const _CountGrid({required this.count});

  final CashCount count;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final figures = AppTypography.body.copyWith(
      fontSize: 15,
      fontFeatures: AppTypography.tabularFigures,
    );
    final counted = [
      for (final entry in count.quantities.entries)
        if (entry.value > 0) entry,
    ];
    final divider = BorderSide(color: colors.border);
    Widget cell(String text, TextStyle style, {bool right = false}) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Text(
        text,
        style: style,
        textAlign: right ? TextAlign.right : null,
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (counted.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
            child: Text(
              'Tiroir vide : aucune espèce comptée.',
              style: AppTypography.body.copyWith(color: colors.textSecondary),
            ),
          )
        else
          Table(
            columnWidths: const {
              0: IntrinsicColumnWidth(),
              1: IntrinsicColumnWidth(),
              2: FlexColumnWidth(),
            },
            children: [
              for (final MapEntry(key: d, value: quantity) in counted)
                TableRow(
                  decoration: BoxDecoration(border: Border(bottom: divider)),
                  children: [
                    cell(
                      '${d.isBill ? 'Billet' : 'Pièce'} '
                      '${formatAmount(Decimal.fromInt(d.value))}',
                      figures.copyWith(fontWeight: FontWeight.w500),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: cell(
                        '× $quantity',
                        figures.copyWith(color: colors.textSecondary),
                      ),
                    ),
                    cell(formatFcfa(count.subtotalOf(d)), figures, right: true),
                  ],
                ),
            ],
          ),
        Padding(
          padding: const EdgeInsets.only(top: AppSpacing.xs),
          child: Text(
            'Billets ${formatFcfa(count.billsTotal)} · '
            'Pièces ${formatFcfa(count.coinsTotal)}',
            style: AppTypography.meta.copyWith(
              color: colors.textSecondary,
              fontFeatures: AppTypography.tabularFigures,
            ),
          ),
        ),
      ],
    );
  }
}
