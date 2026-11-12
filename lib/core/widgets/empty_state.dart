import 'package:flutter/material.dart';

import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_typography.dart';
import 'primary_button.dart';

/// Ton de la pastille d'icône d'un [EmptyState].
enum EmptyStateTone {
  /// Invitation (catalogue vide, première utilisation).
  primary,

  /// Information neutre (recherche sans résultat).
  neutral,

  /// Action attendue avant de continuer (caisse fermée).
  warning,

  /// Erreur (chargement impossible).
  error,
}

/// Affichage d'état vide pour les listes et conteneurs.
///
/// Icône dans un cercle de 96 dp, titre, phrase, puis une action principale
/// et d'éventuelles actions secondaires. Centré, sur un ton encourageant :
/// une action, pas un écran blanc.
class EmptyState extends StatelessWidget {
  /// Crée un état vide.
  const EmptyState({
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.actionIcon,
    this.onAction,
    this.secondaryActions = const [],
    this.tone = EmptyStateTone.primary,
    super.key,
  });

  /// Icône à afficher dans la pastille.
  final IconData icon;

  /// Texte du titre.
  final String title;

  /// Texte du message descriptif.
  final String message;

  /// Libellé du bouton d'action optionnel.
  final String? actionLabel;

  /// Icône du bouton d'action.
  final IconData? actionIcon;

  /// Callback au tap sur le bouton d'action.
  final VoidCallback? onAction;

  /// Actions secondaires sous l'action principale (bouton bordé, bouton
  /// texte).
  final List<Widget> secondaryActions;

  /// Couleur de la pastille d'icône.
  final EmptyStateTone tone;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final (ringColor, iconColor) = switch (tone) {
      EmptyStateTone.primary => (cs.primaryContainer, cs.onPrimaryContainer),
      EmptyStateTone.neutral => (cs.surfaceContainerLow, cs.onSurfaceVariant),
      EmptyStateTone.warning => (cs.tertiaryContainer, cs.onTertiaryContainer),
      EmptyStateTone.error => (cs.errorContainer, cs.onErrorContainer),
    };
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    color: ringColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 44, color: iconColor),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                title,
                style: AppTypography.appBarTitle,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                message,
                style: AppTypography.bodyMedium.copyWith(
                  color: cs.onSurfaceVariant,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              if (actionLabel != null && onAction != null) ...[
                const SizedBox(height: AppSpacing.lg),
                PrimaryButton(
                  label: actionLabel!,
                  icon: actionIcon,
                  onPressed: onAction,
                ),
              ],
              for (final action in secondaryActions) ...[
                const SizedBox(height: AppSpacing.sm),
                action,
              ],
            ],
          ),
        ),
      ),
    );
  }
}
