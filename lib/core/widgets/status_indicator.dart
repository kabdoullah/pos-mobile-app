import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_typography.dart';

/// Tonalité d'un [StatusIndicator].
enum StatusTone {
  /// Positif : à jour, stock disponible, caisse équilibrée.
  success,

  /// Alerte : stock bas, excédent, en attente.
  warning,

  /// Erreur : rupture, déficit, échec.
  error,

  /// Neutre : non suivi, fermé.
  neutral;

  /// Couleur de texte de la tonalité dans le thème courant. Lisible (AA) sur
  /// la surface comme sur le fond d'écran.
  Color colorIn(BuildContext context) {
    final c = AppColors.of(context);
    return switch (this) {
      StatusTone.success => c.success,
      StatusTone.warning => c.warning,
      StatusTone.error => c.error,
      StatusTone.neutral => c.textSecondary,
    };
  }
}

/// Statut v2 : point de 8 dp et mot dans la couleur sémantique, sans pastille
/// de fond. Le statut se lit toujours par le mot, jamais par la couleur seule.
class StatusIndicator extends StatelessWidget {
  /// Crée un indicateur [label] de tonalité [tone].
  const StatusIndicator({
    required this.label,
    required this.tone,
    this.emphasized = false,
    super.key,
  });

  /// Le mot du statut (« Rupture », « Stock bas : 4 »).
  final String label;

  /// Tonalité (couleur du point et du texte).
  final StatusTone tone;

  /// Texte 16/600 au lieu de 14/500, pour un statut qui résume l'écran
  /// (écart de caisse).
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    final color = tone.colorIn(context);
    final style = emphasized ? AppTypography.labelLarge : AppTypography.meta;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Flexible(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: style.copyWith(
              color: color,
              fontFeatures: AppTypography.tabularFigures,
            ),
          ),
        ),
      ],
    );
  }
}
