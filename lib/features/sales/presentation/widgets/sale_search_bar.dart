import 'package:flutter/material.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/index.dart';

/// Barre de recherche de la caisse, avec le bouton d'ouverture du scanner.
class SaleSearchBar extends StatelessWidget {
  /// Crée la barre de recherche.
  const SaleSearchBar({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.onScan,
    super.key,
  });

  /// Contrôleur du champ de recherche.
  final TextEditingController controller;

  /// Focus du champ.
  final FocusNode focusNode;

  /// Appelé à chaque modification du texte.
  final ValueChanged<String> onChanged;

  /// Ouvre le scanner plein écran.
  final VoidCallback onScan;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return AppSearchBar(
      controller: controller,
      focusNode: focusNode,
      onChanged: onChanged,
      hintText: 'Nom ou code-barres',
      actions: [
        // Bouton libellé intégré au champ : pas d'icône seule pour scanner.
        TextButton.icon(
          onPressed: onScan,
          icon: const Icon(Icons.qr_code_scanner),
          label: const Text('Scanner'),
          style: TextButton.styleFrom(
            backgroundColor: cs.primaryContainer,
            foregroundColor: cs.onPrimaryContainer,
            minimumSize: const Size(0, AppSpacing.buttonHeightSm),
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm + 4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
          ),
        ),
      ],
    );
  }
}
