import 'package:flutter/material.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';

/// Nature d'un retour de la caisse.
enum SaleToastKind {
  /// Produit ajouté.
  success,

  /// Action refusée (stock insuffisant…).
  error,

  /// Information avec action possible (produit introuvable).
  info,
}

/// Contenu d'un retour léger de la caisse.
class SaleToastData {
  /// Crée un retour. [actionLabel] et [onAction] vont ensemble.
  const SaleToastData({
    required this.message,
    required this.kind,
    this.actionLabel,
    this.onAction,
  });

  /// Texte affiché.
  final String message;

  /// Nature du retour (couleur, icône).
  final SaleToastKind kind;

  /// Libellé de l'action optionnelle.
  final String? actionLabel;

  /// Action optionnelle.
  final VoidCallback? onAction;
}

/// Pastille de retour affichée en haut du panier, sans bloquer la caisse.
class SaleToast extends StatelessWidget {
  /// Crée la pastille ; [data] `null` la masque.
  const SaleToast({required this.data, required this.onDismiss, super.key});

  /// Retour affiché.
  final SaleToastData? data;

  /// Masque la pastille.
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final data = this.data;
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 150),
      transitionBuilder: (child, animation) => FadeTransition(
        opacity: animation,
        child: SlideTransition(
          position: Tween(
            begin: const Offset(0, -0.2),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        ),
      ),
      child: data == null
          ? const SizedBox.shrink()
          : _ToastBody(key: ObjectKey(data), data: data, onDismiss: onDismiss),
    );
  }
}

class _ToastBody extends StatelessWidget {
  const _ToastBody({required this.data, required this.onDismiss, super.key});

  final SaleToastData data;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final (background, foreground, icon) = switch (data.kind) {
      SaleToastKind.success => (
        cs.inverseSurface,
        cs.onInverseSurface,
        Icons.check_circle,
      ),
      SaleToastKind.error => (
        cs.errorContainer,
        cs.onErrorContainer,
        Icons.error_outline,
      ),
      SaleToastKind.info => (
        cs.inverseSurface,
        cs.onInverseSurface,
        Icons.help_outline,
      ),
    };
    final onAction = data.onAction;

    return Semantics(
      liveRegion: true,
      child: Material(
        color: background,
        elevation: 3,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.sm,
            onAction == null ? AppSpacing.md : AppSpacing.xs,
            AppSpacing.sm,
          ),
          child: Row(
            children: [
              Icon(icon, size: 20, color: foreground),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  data.message,
                  style: AppTypography.bodyMedium.copyWith(color: foreground),
                ),
              ),
              if (onAction != null) ...[
                TextButton(
                  onPressed: onDismiss,
                  style: TextButton.styleFrom(foregroundColor: foreground),
                  child: const Text('Annuler'),
                ),
                TextButton(
                  onPressed: () {
                    onDismiss();
                    onAction();
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: cs.inversePrimary,
                  ),
                  child: Text(data.actionLabel ?? 'OK'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
