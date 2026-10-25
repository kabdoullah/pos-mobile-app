import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/index.dart';

/// Ligne d'article d'un [ReceiptTicket].
class ReceiptTicketLine {
  /// Crée une ligne d'article.
  const ReceiptTicketLine({
    required this.name,
    required this.quantity,
    required this.unitPrice,
    required this.total,
  });

  /// Nom du produit.
  final String name;

  /// Quantité vendue.
  final int quantity;

  /// Prix unitaire.
  final Decimal unitPrice;

  /// Total de la ligne, réduction déduite.
  final Decimal total;
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
    this.footer = const [],
    super.key,
  });

  /// Articles vendus.
  final List<ReceiptTicketLine> lines;

  /// Total payé.
  final Decimal total;

  /// Remise globale ; la ligne n'est affichée que si elle est positive.
  final Decimal? discount;

  /// Lignes libellé / valeur sous le total (paiement, reçu, date…).
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
    final discount = this.discount;

    return PhysicalShape(
      clipper: const _ZigzagClipper(),
      color: cs.surface,
      elevation: 2,
      shadowColor: cs.primary.withValues(alpha: 0.4),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.md,
          AppSpacing.md,
          AppSpacing.md + _ZigzagClipper.toothHeight,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final line in lines)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(line.name, style: body),
                          Text(
                            '${line.quantity} × '
                            '${formatAmount(line.unitPrice)}',
                            style: muted,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(formatAmount(line.total), style: body),
                  ],
                ),
              ),
            if (discount != null && discount > Decimal.zero)
              _Row(
                label: 'Remise',
                value: '−${formatAmount(discount)}',
                style: muted,
              ),
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

/// Bord inférieur en dents de scie : le papier déchiré du ticket.
class _ZigzagClipper extends CustomClipper<Path> {
  const _ZigzagClipper();

  static const double toothHeight = 6;
  static const double _toothWidth = 12;

  @override
  Path getClip(Size size) {
    final bottom = size.height - toothHeight;
    final path = Path()
      ..lineTo(size.width, 0)
      ..lineTo(size.width, bottom);
    final teeth = (size.width / _toothWidth).ceil();
    final step = size.width / teeth;
    for (var i = teeth; i > 0; i--) {
      final x = i * step;
      path
        ..lineTo(x - step / 2, size.height)
        ..lineTo(x - step, bottom);
    }
    return path..close();
  }

  @override
  bool shouldReclip(_ZigzagClipper oldClipper) => false;
}
