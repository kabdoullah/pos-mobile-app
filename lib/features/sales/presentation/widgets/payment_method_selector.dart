import 'package:flutter/material.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../domain/entities/sale.dart';

/// Sélecteur de moyen de paiement : « Espèces » en tuile pleine largeur (le
/// cas le plus fréquent), puis Orange Money, MTN Mobile Money, Wave et Mixte
/// en grille 2 × 2.
///
/// Libellés en toutes lettres, sans logo ni pastille de couleur : au soleil,
/// la couleur seule ne suffit pas (le jaune MTN se confond avec l'or). La
/// sélection se lit au fond, à la bordure de 2 dp et à la coche.
class PaymentMethodSelector extends StatelessWidget {
  /// Crée le sélecteur.
  const PaymentMethodSelector({
    required this.selected,
    required this.onSelected,
    super.key,
  });

  /// Moyen actuellement choisi.
  final PaymentMethod selected;

  /// Appelé au choix d'un moyen.
  final ValueChanged<PaymentMethod> onSelected;

  @override
  Widget build(BuildContext context) {
    Widget tile(PaymentMethod method) => _MethodTile(
      method: method,
      isSelected: method == selected,
      onTap: () => onSelected(method),
    );
    Widget pair(PaymentMethod a, PaymentMethod b) => IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: tile(a)),
          const SizedBox(width: AppSpacing.sm),
          Expanded(child: tile(b)),
        ],
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        tile(PaymentMethod.cash),
        const SizedBox(height: AppSpacing.sm),
        pair(PaymentMethod.orangeMoney, PaymentMethod.mtn),
        const SizedBox(height: AppSpacing.sm),
        pair(PaymentMethod.wave, PaymentMethod.mixed),
      ],
    );
  }
}

class _MethodTile extends StatelessWidget {
  const _MethodTile({
    required this.method,
    required this.isSelected,
    required this.onTap,
  });

  final PaymentMethod method;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final foreground = isSelected ? cs.onPrimaryContainer : cs.onSurface;
    final (label, icon) = switch (method) {
      PaymentMethod.cash => ('Espèces', Icons.payments_outlined),
      PaymentMethod.orangeMoney => ('Orange Money', null),
      PaymentMethod.mtn => ('MTN Mobile Money', null),
      PaymentMethod.wave => ('Wave', null),
      PaymentMethod.mixed => ('Mixte', null),
    };

    return Semantics(
      selected: isSelected,
      button: true,
      inMutuallyExclusiveGroup: true,
      excludeSemantics: true,
      label: label,
      child: Material(
        color: isSelected ? cs.primaryContainer : cs.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          side: isSelected
              ? BorderSide(color: cs.primary, width: 2)
              : BorderSide(color: cs.outline),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 56),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: AppSpacing.sm,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, color: foreground),
                    const SizedBox(width: AppSpacing.sm),
                  ],
                  Flexible(
                    child: Text(
                      label,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      style: AppTypography.labelLarge.copyWith(
                        color: foreground,
                        height: 1.2,
                      ),
                    ),
                  ),
                  if (isSelected) ...[
                    const SizedBox(width: AppSpacing.sm),
                    Icon(Icons.check, color: foreground),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
