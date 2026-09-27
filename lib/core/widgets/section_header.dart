import 'package:flutter/material.dart';

import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_typography.dart';

/// En-tête de section : titre, badge de compteur optionnel et action à droite
/// (« Voir tout »…).
class SectionHeader extends StatelessWidget {
  /// Crée un en-tête de section.
  const SectionHeader({
    required this.title,
    this.count,
    this.countColor,
    this.actionLabel,
    this.onAction,
    super.key,
  });

  /// Titre de la section.
  final String title;

  /// Compteur affiché en badge à côté du titre.
  final int? count;

  /// Couleur du badge (par défaut : couleur neutre).
  final Color? countColor;

  /// Libellé de l'action ; masquée si `null`.
  final String? actionLabel;

  /// Action déclenchée par le bouton.
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final count = this.count;
    final actionLabel = this.actionLabel;

    return SizedBox(
      height: AppSpacing.buttonHeightSm,
      child: Row(
        children: [
          Flexible(
            child: Semantics(
              header: true,
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.titleMedium,
              ),
            ),
          ),
          if (count != null) ...[
            const SizedBox(width: AppSpacing.sm),
            Badge(
              label: Text('$count'),
              backgroundColor: countColor ?? cs.surfaceContainerHighest,
              textColor: countColor == null ? cs.onSurfaceVariant : null,
            ),
          ],
          const Spacer(),
          if (actionLabel != null)
            TextButton(onPressed: onAction, child: Text(actionLabel)),
        ],
      ),
    );
  }
}
