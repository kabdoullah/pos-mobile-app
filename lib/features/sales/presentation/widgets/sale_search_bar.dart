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
    required this.isScannerOpen,
    required this.onToggleScanner,
    super.key,
  });

  /// Contrôleur du champ de recherche.
  final TextEditingController controller;

  /// Focus du champ (la page replie la caméra pendant la saisie).
  final FocusNode focusNode;

  /// Appelé à chaque modification du texte.
  final ValueChanged<String> onChanged;

  /// Indique si la caméra est dépliée.
  final bool isScannerOpen;

  /// Déplie ou replie la caméra.
  final VoidCallback onToggleScanner;

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
          onPressed: onToggleScanner,
          icon: Icon(isScannerOpen ? Icons.close : Icons.qr_code_scanner),
          label: Text(isScannerOpen ? 'Fermer' : 'Scanner'),
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
