import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/index.dart';

/// Barre fixe de l'écran Vendre, au-dessus de la navigation : nombre
/// d'articles et « Encaisser · total ». Panier vide : une phrase d'amorce.
/// Caisse fermée : le bouton devient « Ouvrir la caisse » (panier gardé).
class SaleCartBar extends StatelessWidget {
  /// Crée la barre.
  const SaleCartBar({
    required this.units,
    required this.total,
    required this.isRegisterClosed,
    required this.onCheckout,
    required this.onOpenRegister,
    super.key,
  });

  /// Nombre d'unités au panier.
  final int units;

  /// Total du panier.
  final Decimal total;

  /// Aucune session de caisse ouverte.
  final bool isRegisterClosed;

  /// Ouvre l'écran Encaisser.
  final VoidCallback onCheckout;

  /// Ouvre la caisse (fond de caisse).
  final VoidCallback onOpenRegister;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final Widget content;
    if (units == 0 && !isRegisterClosed) {
      content = ConstrainedBox(
        constraints: const BoxConstraints(minHeight: AppSpacing.buttonHeight),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Touchez un produit ou scannez-le pour commencer.',
            style: AppTypography.body.copyWith(color: colors.textSecondary),
          ),
        ),
      );
    } else {
      content = Row(
        children: [
          if (units > 0)
            TextButton.icon(
              onPressed: onCheckout,
              icon: const Icon(Icons.expand_less, size: 20),
              label: Text(units == 1 ? '1 article' : '$units articles'),
              style: TextButton.styleFrom(
                foregroundColor: colors.textPrimary,
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
              ),
            ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: PrimaryButton(
              height: AppSpacing.buttonHeight,
              label: isRegisterClosed
                  ? 'Ouvrir la caisse'
                  : 'Encaisser · ${formatFcfa(total)}',
              onPressed: isRegisterClosed ? onOpenRegister : onCheckout,
            ),
          ),
        ],
      );
    }
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(top: BorderSide(color: colors.border)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm + AppSpacing.xs,
        ),
        child: content,
      ),
    );
  }
}
