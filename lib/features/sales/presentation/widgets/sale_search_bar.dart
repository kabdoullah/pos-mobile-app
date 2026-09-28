import 'package:flutter/material.dart';

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
    return AppSearchBar(
      controller: controller,
      focusNode: focusNode,
      onChanged: onChanged,
      hintText: 'Nom ou code-barres',
      actions: [
        IconButton.filledTonal(
          tooltip: isScannerOpen
              ? 'Replier le scanner'
              : 'Scanner un code-barres',
          isSelected: isScannerOpen,
          icon: const Icon(Icons.qr_code_scanner),
          onPressed: onToggleScanner,
        ),
      ],
    );
  }
}
