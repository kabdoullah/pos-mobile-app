import 'package:flutter/material.dart';

import '../../../../core/widgets/index.dart';

/// Barre de recherche de l'écran Vendre, avec le bouton « Scanner » (scanner
/// plein écran).
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

  /// Focus du champ (la saisie manuelle d'un code le reprend).
  final FocusNode focusNode;

  /// Appelé à chaque modification du texte.
  final ValueChanged<String> onChanged;

  /// Ouvre le scanner.
  final VoidCallback onScan;

  @override
  Widget build(BuildContext context) {
    return AppSearchBar(
      controller: controller,
      focusNode: focusNode,
      onChanged: onChanged,
      hintText: 'Nom ou code-barres',
      actions: [
        TextButton.icon(
          onPressed: onScan,
          icon: const Icon(Icons.qr_code_scanner, size: 20),
          label: const Text('Scanner'),
        ),
      ],
    );
  }
}
