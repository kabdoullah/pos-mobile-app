import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/index.dart';
import '../providers/cart_provider.dart';

/// Barre d'encaissement fixe en bas de « Vendre », une seule rangée :
/// « N articles ▴ » (ouvre le panier) et « Encaisser X FCFA » (ouvre le
/// paiement). Caisse fermée : le bouton devient « Ouvrir la caisse », le
/// panier reste utilisable.
class SaleCheckoutBar extends ConsumerWidget {
  /// Crée la barre d'encaissement.
  const SaleCheckoutBar({
    required this.isCashClosed,
    required this.onShowCart,
    required this.onCheckout,
    required this.onOpenCash,
    super.key,
  });

  /// Aucune session de caisse ouverte.
  final bool isCashClosed;

  /// Ouvre le panier.
  final VoidCallback onShowCart;

  /// Ouvre l'écran Paiement.
  final VoidCallback onCheckout;

  /// Ouvre la caisse.
  final VoidCallback onOpenCash;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final semantic = theme.extension<AppSemanticColors>()!;
    final cart = ref.watch(cartProvider);
    final units = cart.unitCount;

    final button = isCashClosed
        ? PrimaryButton(
            label: 'Ouvrir la caisse',
            icon: Icons.lock_open_outlined,
            onPressed: onOpenCash,
          )
        : PrimaryButton(
            label: cart.isEmpty
                ? 'Encaisser'
                : 'Encaisser ${formatFcfa(cart.total)}',
            onPressed: cart.isEmpty ? null : onCheckout,
          );

    return DecoratedBox(
      decoration: BoxDecoration(
        color: semantic.raisedSurface,
        border: Border(top: BorderSide(color: cs.outlineVariant)),
        // Mode sombre : l'élévation se lit au ton de surface, sans ombre.
        boxShadow: theme.brightness == Brightness.light
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 12,
                  offset: const Offset(0, -4),
                ),
              ]
            : null,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm + 4,
        ),
        child: Row(
          children: [
            if (units > 0) ...[
              _CartCountButton(units: units, onPressed: onShowCart),
              const SizedBox(width: AppSpacing.sm),
            ],
            Expanded(child: button),
          ],
        ),
      ),
    );
  }
}

/// « N articles ▴ » : ouvre le panier ; le compteur grossit brièvement à
/// chaque ajout.
class _CartCountButton extends StatelessWidget {
  const _CartCountButton({required this.units, required this.onPressed});

  final int units;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final label = units <= 1 ? '$units article' : '$units articles';
    return TweenAnimationBuilder<double>(
      key: ValueKey(units),
      tween: Tween(begin: 1.15, end: 1),
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeOut,
      builder: (context, scale, child) =>
          Transform.scale(scale: scale, child: child),
      child: TextButton.icon(
        onPressed: onPressed,
        icon: const Icon(Icons.expand_less, size: 22),
        label: Text(
          label,
          maxLines: 1,
          style: AppTypography.labelLarge.copyWith(
            fontFeatures: AppTypography.tabularFigures,
          ),
        ),
        style: TextButton.styleFrom(
          foregroundColor: cs.onSurface,
          minimumSize: const Size(0, AppSpacing.buttonHeightSm),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
        ),
      ),
    );
  }
}
