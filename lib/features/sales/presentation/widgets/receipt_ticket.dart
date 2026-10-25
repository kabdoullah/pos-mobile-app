import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/index.dart';
import '../../../../app/theme/app_colors.dart';

/// Ligne d'article d'un [ReceiptTicket].
class ReceiptTicketLine {
  /// Crée une ligne d'article.
  const ReceiptTicketLine({
    required this.name,
    required this.quantity,
    required this.unitPrice,
    required this.amount,
    this.discount,
    this.leading,
  });

  /// Nom du produit.
  final String name;

  /// Quantité vendue.
  final int quantity;

  /// Prix unitaire.
  final Decimal unitPrice;

  /// Montant brut de la ligne (quantité × prix unitaire).
  final Decimal amount;

  /// Réduction sur la ligne ; affichée sous le montant si elle est positive.
  final Decimal? discount;

  /// Vignette optionnelle à gauche (photo du produit).
  final Widget? leading;
}

/// Vente présentée comme le reçu thermique 58 mm que la boutique imprime :
/// papier blanc, colonnes alignées, pointillés, total en grand et bord
/// inférieur dentelé.
///
/// À poser sur un fond qui contraste avec `surface` (fond de page ivoire).
class ReceiptTicket extends StatelessWidget {
  /// Crée un ticket.
  const ReceiptTicket({
    required this.lines,
    required this.total,
    this.discount,
    this.title,
    this.subtitle,
    this.linesPlaceholder,
    this.footer = const [],
    super.key,
  });

  /// Articles vendus.
  final List<ReceiptTicketLine> lines;

  /// Total payé, remise déduite.
  final Decimal total;

  /// Remise globale ; sous-total et remise ne sont affichés que si elle est
  /// positive.
  final Decimal? discount;

  /// En-tête centré (ex. « Reçu #12 »).
  final String? title;

  /// Ligne sous l'en-tête (ex. la date).
  final String? subtitle;

  /// Affiché à la place des articles quand [lines] est vide (chargement,
  /// détail indisponible).
  final Widget? linesPlaceholder;

  /// Lignes libellé / valeur sous le total (paiement, statut…).
  final List<(String, String)> footer;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final muted = AppTypography.bodySmall.copyWith(
      color: cs.onSurfaceVariant,
      fontFeatures: AppTypography.tabularFigures,
    );
    final body = AppTypography.bodyMedium.copyWith(
      color: cs.onSurface,
      fontFeatures: AppTypography.tabularFigures,
    );
    final reduction = muted.copyWith(color: cs.primary);
    final discount = this.discount;
    final hasDiscount = discount != null && discount > Decimal.zero;
    final title = this.title;
    final subtitle = this.subtitle;
    final linesPlaceholder = this.linesPlaceholder;

    return PhysicalShape(
      clipper: const ZigzagClipper(),
      color: cs.surface,
      elevation: 2,
      shadowColor: Theme.of(
        context,
      ).extension<AppSemanticColors>()!.elevationShadow.withValues(alpha: 0.4),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.md,
          AppSpacing.md,
          AppSpacing.md + ZigzagClipper.toothHeight,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (title != null || subtitle != null) ...[
              if (title != null)
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: AppTypography.titleMedium,
                ),
              if (subtitle != null)
                // Date : chiffres proportionnels, sinon « 17 : 21 ».
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: AppTypography.bodySmall.copyWith(
                    color: cs.onSurfaceVariant,
                  ),
                ),
              const _DashedRule(),
            ],
            if (lines.isEmpty && linesPlaceholder != null)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: linesPlaceholder,
              ),
            for (final line in lines)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (line.leading case final leading?) ...[
                      leading,
                      const SizedBox(width: AppSpacing.sm),
                    ],
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(child: Text(line.name, style: body)),
                              const SizedBox(width: AppSpacing.sm),
                              Text(formatAmount(line.amount), style: body),
                            ],
                          ),
                          Text(
                            '${line.quantity} × '
                            '${formatAmount(line.unitPrice)}',
                            style: muted,
                          ),
                          if (line.discount case final lineDiscount?
                              when lineDiscount > Decimal.zero)
                            _Row(
                              label: 'Réduction',
                              value: '−${formatAmount(lineDiscount)}',
                              style: reduction,
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            if (hasDiscount) ...[
              const _DashedRule(),
              _Row(
                label: 'Sous-total',
                value: formatAmount(total + discount),
                style: muted,
              ),
              _Row(
                label: 'Remise',
                value: '−${formatAmount(discount)}',
                style: muted,
              ),
            ],
            const _DashedRule(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                const Text('Total', style: AppTypography.titleMedium),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: AmountDisplay(
                        amount: total,
                        size: AmountSize.hero,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (footer.isNotEmpty) ...[
              const _DashedRule(),
              for (final (label, value) in footer)
                _Row(label: label, value: value, style: muted),
            ],
          ],
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.label, required this.value, required this.style});

  final String label;
  final String value;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: Row(
        children: [
          Expanded(child: Text(label, style: style)),
          Text(value, style: style),
        ],
      ),
    );
  }
}

/// Pointillés de séparation, comme les tirets d'un ticket imprimé.
class _DashedRule extends StatelessWidget {
  const _DashedRule();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: CustomPaint(
        size: const Size.fromHeight(1),
        painter: _DashPainter(Theme.of(context).colorScheme.outline),
      ),
    );
  }
}

class _DashPainter extends CustomPainter {
  const _DashPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;
    const dash = 4.0;
    for (var x = 0.0; x < size.width; x += dash * 2) {
      canvas.drawLine(Offset(x, 0), Offset(x + dash, 0), paint);
    }
  }

  @override
  bool shouldRepaint(_DashPainter oldDelegate) => oldDelegate.color != color;
}
