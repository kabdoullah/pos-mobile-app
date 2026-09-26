import 'package:flutter/material.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../domain/entities/sale.dart';

// Pastilles aux couleurs des opérateurs : repère visuel immédiat, gardé petit
// pour ne pas charger l'interface.
const _orangeMoneyColor = Color(0xFFFF7900);
const _mtnColor = Color(0xFFFFCC00);
const _waveColor = Color(0xFF1DC8FF);

/// Sélecteur de moyen de paiement : 5 tuiles égales, toutes visibles.
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
    return Row(
      children: [
        for (final method in PaymentMethod.values) ...[
          if (method != PaymentMethod.values.first)
            const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: _MethodTile(
              method: method,
              isSelected: method == selected,
              onTap: () => onSelected(method),
            ),
          ),
        ],
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
    final (label, leading) = switch (method) {
      PaymentMethod.cash => (
        'Espèces',
        _icon(Icons.payments_outlined, foreground),
      ),
      PaymentMethod.orangeMoney => ('Orange', _dot(_orangeMoneyColor)),
      PaymentMethod.mtn => ('MTN', _dot(_mtnColor)),
      PaymentMethod.wave => ('Wave', _dot(_waveColor)),
      PaymentMethod.mixed => ('Mixte', _icon(Icons.call_split, foreground)),
    };

    return Semantics(
      selected: isSelected,
      button: true,
      child: Material(
        color: isSelected ? cs.primaryContainer : cs.surfaceContainerHigh,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          side: BorderSide(
            color: isSelected ? cs.primary : Colors.transparent,
            width: 2,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: SizedBox(
            height: 56,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 20, child: Center(child: leading)),
                const SizedBox(height: 2),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.fade,
                  softWrap: false,
                  style: AppTypography.labelSmall.copyWith(
                    color: foreground,
                    fontWeight: isSelected ? FontWeight.w700 : null,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Widget _icon(IconData icon, Color color) =>
      Icon(icon, size: 20, color: color);

  static Widget _dot(Color color) => DecoratedBox(
    decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    child: const SizedBox.square(dimension: 14),
  );
}
