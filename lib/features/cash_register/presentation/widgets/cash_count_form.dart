import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/index.dart';
import '../../domain/entities/cash_count.dart';
import '../../domain/entities/denomination.dart';

/// « 7 billets, 13 pièces » ; chaîne vide si rien n'est compté.
String countBreakdown(CashCount count) {
  String plural(int n, String word) => '$n $word${n > 1 ? 's' : ''}';
  return [
    if (count.billCount > 0) plural(count.billCount, 'billet'),
    if (count.coinCount > 0) plural(count.coinCount, 'pièce'),
  ].join(', ');
}

/// Choix du mode de comptage : billets et pièces, ou total seulement. Le
/// choix est mémorisé par l'appelant.
class CashCountModeSelector extends StatelessWidget {
  /// Crée le sélecteur ; [byDenomination] vrai = billets et pièces.
  const CashCountModeSelector({
    required this.byDenomination,
    required this.onChanged,
    super.key,
  });

  /// Mode courant.
  final bool byDenomination;

  /// Appelé au changement de mode.
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) => SegmentedControl<bool>(
    segments: const [
      (value: true, label: 'Billets et pièces'),
      (value: false, label: 'Total seulement'),
    ],
    selected: byDenomination,
    onChanged: onChanged,
  );
}

/// Billetterie (ADR-0016) : une ligne par coupure de [CashCount], billets
/// puis pièces, avec quantité (− n +, ou saisie au clavier), sous-total et
/// total de chaque section. Utilisée à l'ouverture et à la clôture.
///
/// Composant contrôlé : [count] est la seule source de vérité, chaque saisie
/// remonte un nouveau comptage par [onChanged].
class CashCountForm extends StatelessWidget {
  /// Crée le formulaire de comptage.
  const CashCountForm({
    required this.count,
    required this.onChanged,
    super.key,
  });

  /// Comptage affiché.
  final CashCount count;

  /// Appelé avec le comptage modifié.
  final ValueChanged<CashCount> onChanged;

  @override
  Widget build(BuildContext context) {
    // Toujours la liste complète des coupures proposées, même si le comptage
    // repris n'en contient qu'une partie.
    final bills = fcfaDenominations.where((d) => d.isBill).toList();
    final coins = fcfaDenominations.where((d) => !d.isBill).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        OverlineHeader('Billets', trailing: formatFcfa(count.billsTotal)),
        _Section(denominations: bills, count: count, onChanged: onChanged),
        OverlineHeader('Pièces', trailing: formatFcfa(count.coinsTotal)),
        _Section(denominations: coins, count: count, onChanged: onChanged),
      ],
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({
    required this.denominations,
    required this.count,
    required this.onChanged,
  });

  final List<Denomination> denominations;
  final CashCount count;
  final ValueChanged<CashCount> onChanged;

  @override
  Widget build(BuildContext context) => FlatList(
    children: [
      for (final d in denominations)
        _DenominationRow(
          key: ValueKey(d),
          denomination: d,
          quantity: count.quantityOf(d),
          subtotal: count.subtotalOf(d),
          unusual: count.isUnusual(d),
          onChanged: (q) => onChanged(count.withQuantity(d, q)),
        ),
    ],
  );
}

/// Ligne d'une coupure : valeur, quantité (boutons ou clavier), sous-total,
/// et avertissement non bloquant si la quantité est inhabituelle.
class _DenominationRow extends StatefulWidget {
  const _DenominationRow({
    required this.denomination,
    required this.quantity,
    required this.subtotal,
    required this.unusual,
    required this.onChanged,
    super.key,
  });

  final Denomination denomination;
  final int quantity;
  final Decimal subtotal;
  final bool unusual;
  final ValueChanged<int> onChanged;

  @override
  State<_DenominationRow> createState() => _DenominationRowState();
}

class _DenominationRowState extends State<_DenominationRow> {
  late final TextEditingController _controller = TextEditingController(
    text: _textOf(widget.quantity),
  );

  /// Saisie refusée (au-delà du plafond) ; la quantité précédente est gardée.
  bool _invalid = false;

  static String _textOf(int quantity) => quantity == 0 ? '' : '$quantity';

  @override
  void didUpdateWidget(_DenominationRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Quantité changée par les boutons ou par la reprise d'un comptage : le
    // champ suit, sauf s'il affiche déjà cette valeur (saisie en cours).
    if (CashCount.parseQuantity(_controller.text) != widget.quantity) {
      _controller.text = _textOf(widget.quantity);
      _invalid = false;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTyped(String text) {
    final quantity = CashCount.parseQuantity(text);
    setState(() => _invalid = quantity == null);
    if (quantity != null && quantity != widget.quantity) {
      widget.onChanged(quantity);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final d = widget.denomination;
    final quantity = widget.quantity;
    final kind = d.isBill ? 'billet' : 'pièce';
    final valueLabel = formatAmount(Decimal.fromInt(d.value));
    final isZero = quantity == 0;
    final figures = AppTypography.bodyStrong.copyWith(
      fontFeatures: AppTypography.tabularFigures,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              SizedBox(
                width: 72,
                child: Text(
                  valueLabel,
                  style: figures.copyWith(
                    fontWeight: isZero ? FontWeight.w500 : FontWeight.w600,
                    color: isZero ? colors.textSecondary : colors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              QuantityStepper(
                quantity: quantity,
                valueWidth: 56,
                onDecrease: isZero
                    ? null
                    : () => widget.onChanged(quantity - 1),
                onIncrease: quantity >= CashCount.maxQuantity
                    ? null
                    : () => widget.onChanged(quantity + 1),
                field: Semantics(
                  label: 'Nombre de ${kind}s de $valueLabel',
                  child: TextField(
                    controller: _controller,
                    onChanged: _onTyped,
                    keyboardType: TextInputType.number,
                    // « Suivant » passe à la coupure suivante.
                    textInputAction: TextInputAction.next,
                    textAlign: TextAlign.center,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(6),
                    ],
                    style: figures,
                    decoration: InputDecoration.collapsed(
                      hintText: '0',
                      hintStyle: figures.copyWith(
                        color: colors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  isZero ? '—' : formatAmount(widget.subtotal),
                  textAlign: TextAlign.right,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: figures.copyWith(
                    fontWeight: FontWeight.w500,
                    color: isZero ? colors.textDisabled : colors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          if (_invalid)
            _RowMessage(
              'Quantité invalide : un nombre entier, '
              '${formatAmount(Decimal.fromInt(CashCount.maxQuantity))} '
              'au plus.',
              color: colors.error,
            )
          else if (widget.unusual)
            _RowMessage(
              '$quantity ${kind}s de $valueLabel, soit '
              '${formatFcfa(widget.subtotal)}. Vérifiez la quantité.',
              color: colors.warning,
            ),
        ],
      ),
    );
  }
}

class _RowMessage extends StatelessWidget {
  const _RowMessage(this.text, {required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: AppSpacing.xs, bottom: AppSpacing.xs),
    child: Semantics(
      liveRegion: true,
      child: Text(
        text,
        style: AppTypography.meta.copyWith(
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
  );
}

/// Barre basse fixe : libellé et détail (« Fond de caisse · 7 billets »),
/// montant total, puis l'action principale.
class CashCountTotalBar extends StatelessWidget {
  /// Crée la barre.
  const CashCountTotalBar({
    required this.label,
    required this.amount,
    required this.action,
    super.key,
  });

  /// Libellé du total.
  final String label;

  /// Montant affiché ; null = rien encore saisi.
  final Decimal? amount;

  /// Bouton principal.
  final Widget action;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final amount = this.amount;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(top: BorderSide(color: colors.border)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.sm + AppSpacing.xs,
            AppSpacing.md,
            AppSpacing.sm + AppSpacing.xs,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Semantics(
                liveRegion: true,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Expanded(
                      child: Text(
                        label,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.meta.copyWith(
                          color: colors.textSecondary,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      amount == null ? '—' : formatFcfa(amount),
                      style: AppTypography.sectionTitle.copyWith(
                        fontFeatures: AppTypography.tabularFigures,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              action,
            ],
          ),
        ),
      ),
    );
  }
}
