import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_typography.dart';

/// Structure commune de `PrimaryButton` et `SecondaryButton` : pleine
/// largeur, 56 dp de haut, retour haptique, états désactivé et chargement.
///
/// Seul le style (fond, bordure, ombre, couleurs) varie d'un bouton à
/// l'autre. Volontairement absent de `index.dart` : les écrans utilisent les
/// boutons nommés, jamais ce cadre directement.
class ButtonFrame extends StatelessWidget {
  /// Crée le cadre d'un bouton.
  const ButtonFrame({
    required this.label,
    required this.onPressed,
    required this.isLoading,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.progressColor,
    required this.boxShadow,
    this.border,
    this.loadingLabel,
    this.icon,
    this.trailingIcon,
    super.key,
  });

  /// Texte du bouton.
  final String label;

  /// Callback à l'appui sur le bouton. Si null, le bouton est désactivé.
  final VoidCallback? onPressed;

  /// Indique si le bouton est en état de chargement.
  final bool isLoading;

  /// Couleur de fond.
  final Color backgroundColor;

  /// Couleur du libellé et des icônes.
  final Color foregroundColor;

  /// Couleur de l'indicateur de chargement.
  final Color progressColor;

  /// Ombre portée (vide quand le bouton est désactivé).
  final List<BoxShadow> boxShadow;

  /// Bordure optionnelle.
  final BoxBorder? border;

  /// Libellé affiché à côté de l'indicateur pendant le chargement. Sans
  /// libellé, seul l'indicateur est affiché.
  final String? loadingLabel;

  /// Icône de début optionnelle.
  final IconData? icon;

  /// Icône de fin optionnelle.
  final IconData? trailingIcon;

  @override
  Widget build(BuildContext context) {
    final isDisabled = onPressed == null;
    final borderRadius = BorderRadius.circular(AppSpacing.radiusMd);
    final labelStyle = AppTypography.labelLarge.copyWith(
      color: foregroundColor,
    );

    return SizedBox(
      height: 56,
      width: double.infinity,
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: borderRadius,
          border: border,
          boxShadow: boxShadow,
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: borderRadius,
          child: InkWell(
            onTap: isLoading || isDisabled
                ? null
                : () {
                    unawaited(HapticFeedback.lightImpact());
                    onPressed?.call();
                  },
            borderRadius: borderRadius,
            child: Center(
              child: isLoading && loadingLabel != null
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox.square(
                          dimension: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              progressColor,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Flexible(
                          child: Text(
                            loadingLabel!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: labelStyle,
                          ),
                        ),
                      ],
                    )
                  : isLoading
                  ? SizedBox.square(
                      dimension: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          progressColor,
                        ),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (icon != null) ...[
                          Icon(icon, color: foregroundColor, size: 20),
                          const SizedBox(width: AppSpacing.sm),
                        ],
                        // Libellé trop long : tronqué plutôt qu'un débordement.
                        Flexible(
                          child: Text(
                            label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: labelStyle,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        if (trailingIcon != null) ...[
                          const SizedBox(width: AppSpacing.sm),
                          Icon(trailingIcon, color: foregroundColor, size: 20),
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
