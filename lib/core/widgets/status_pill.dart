import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_typography.dart';

/// Ton d'une [StatusPill].
enum StatusPillTone {
  /// État normal (« Caisse ouverte »).
  success,

  /// État qui demande une action (« Caisse fermée »).
  warning,
}

/// Pastille d'état de 32 dp : icône et libellé sur fond teinté.
class StatusPill extends StatelessWidget {
  /// Crée une pastille.
  const StatusPill({
    required this.label,
    required this.icon,
    required this.tone,
    super.key,
  });

  /// Libellé de l'état.
  final String label;

  /// Icône devant le libellé.
  final IconData icon;

  /// Couleur de la pastille.
  final StatusPillTone tone;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final semantic = Theme.of(context).extension<AppSemanticColors>()!;
    final (background, foreground) = switch (tone) {
      StatusPillTone.success => (
        semantic.successContainer,
        semantic.onSuccessContainer,
      ),
      StatusPillTone.warning => (cs.tertiaryContainer, cs.onTertiaryContainer),
    };
    return Container(
      height: 32,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm + 4),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: foreground),
          const SizedBox(width: 6),
          Text(
            label,
            style: AppTypography.labelMedium.copyWith(
              color: foreground,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
