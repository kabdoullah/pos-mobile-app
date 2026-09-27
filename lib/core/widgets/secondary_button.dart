import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_typography.dart';

/// Bouton d'action secondaire pleine largeur avec contour émeraude.
///
/// Pour les actions moins importantes comme Annuler ou Retour. Hauteur minimale
/// de 56 dp pour des zones tactiles confortables.
class SecondaryButton extends StatelessWidget {
  /// Crée un bouton secondaire.
  const SecondaryButton({
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
    super.key,
  });

  /// Texte du bouton.
  final String label;

  /// Callback à l'appui sur le bouton. Si null, le bouton est désactivé.
  final VoidCallback? onPressed;

  /// Indique si le bouton est en état de chargement.
  final bool isLoading;

  /// Icône de début optionnelle.
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDisabled = onPressed == null;
    final disabledColor = cs.onSurface.withValues(alpha: 0.38);
    final borderRadius = BorderRadius.circular(AppSpacing.radiusMd);

    return SizedBox(
      height: 56,
      width: double.infinity,
      child: Container(
        decoration: BoxDecoration(
          color: isDisabled ? cs.surfaceContainerHighest : cs.surface,
          borderRadius: borderRadius,
          border: Border.all(
            color: isDisabled ? cs.outlineVariant : cs.secondary,
            width: 2,
          ),
          boxShadow: isDisabled
              ? []
              : [
                  BoxShadow(
                    color: cs.secondary.withValues(alpha: 0.12),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                    spreadRadius: 0,
                  ),
                ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isLoading || isDisabled
                ? null
                : () {
                    unawaited(HapticFeedback.lightImpact());
                    onPressed?.call();
                  },
            borderRadius: borderRadius,
            child: Center(
              child: isLoading
                  ? SizedBox.square(
                      dimension: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        valueColor: AlwaysStoppedAnimation<Color>(cs.secondary),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (icon != null) ...[
                          Icon(
                            icon,
                            color: isDisabled ? disabledColor : cs.secondary,
                            size: 20,
                          ),
                          const SizedBox(width: AppSpacing.sm),
                        ],
                        // Libellé trop long : tronqué plutôt qu'un débordement.
                        Flexible(
                          child: Text(
                            label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.labelLarge.copyWith(
                              color: isDisabled ? disabledColor : cs.secondary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
