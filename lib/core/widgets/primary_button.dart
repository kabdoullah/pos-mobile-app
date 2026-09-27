import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_typography.dart';

/// Bouton d'action principal pleine largeur aux couleurs de la marque
/// (terracotta).
///
/// Conçu pour l'accessibilité et une UX mobile d'abord. Hauteur minimale de 56
/// dp pour des zones tactiles confortables. Gère les états de chargement et
/// désactivé.
class PrimaryButton extends StatelessWidget {
  /// Crée un bouton principal.
  const PrimaryButton({
    required this.label,
    required this.onPressed,
    this.isLoading = false,
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

  /// Libellé affiché à côté de l'indicateur pendant le chargement (ex.
  /// « Connexion… »). Sans libellé, seul l'indicateur est affiché.
  final String? loadingLabel;

  /// Icône de début optionnelle.
  final IconData? icon;

  /// Icône de fin optionnelle (ex. flèche pour les actions directionnelles).
  final IconData? trailingIcon;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDisabled = onPressed == null;
    final borderRadius = BorderRadius.circular(AppSpacing.radiusMd);

    return SizedBox(
      height: 56,
      width: double.infinity,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          boxShadow: isDisabled
              ? []
              : [
                  BoxShadow(
                    color: cs.primary.withValues(alpha: 0.25),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                    spreadRadius: 0,
                  ),
                ],
        ),
        child: Material(
          color: isDisabled ? cs.onSurface.withValues(alpha: 0.12) : cs.primary,
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
                              cs.onPrimary,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Flexible(
                          child: Text(
                            loadingLabel!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.labelLarge.copyWith(
                              color: cs.onPrimary,
                            ),
                          ),
                        ),
                      ],
                    )
                  : isLoading
                  ? SizedBox.square(
                      dimension: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        valueColor: AlwaysStoppedAnimation<Color>(cs.onPrimary),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (icon != null) ...[
                          Icon(icon, color: cs.onPrimary, size: 20),
                          const SizedBox(width: AppSpacing.sm),
                        ],
                        // Libellé trop long : tronqué plutôt qu'un débordement.
                        Flexible(
                          child: Text(
                            label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.labelLarge.copyWith(
                              color: cs.onPrimary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        if (trailingIcon != null) ...[
                          const SizedBox(width: AppSpacing.sm),
                          Icon(trailingIcon, color: cs.onPrimary, size: 20),
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
