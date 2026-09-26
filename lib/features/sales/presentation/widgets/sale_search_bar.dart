import 'package:flutter/material.dart';

import '../../../../app/theme/app_spacing.dart';

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
    return SearchBar(
      controller: controller,
      focusNode: focusNode,
      onChanged: onChanged,
      hintText: 'Rechercher un produit…',
      textInputAction: TextInputAction.search,
      elevation: const WidgetStatePropertyAll(0),
      backgroundColor: WidgetStatePropertyAll(cs.surfaceContainerHigh),
      constraints: const BoxConstraints(minHeight: AppSpacing.inputHeight),
      padding: const WidgetStatePropertyAll(
        EdgeInsets.only(left: AppSpacing.md, right: AppSpacing.xs),
      ),
      leading: Icon(Icons.search, color: cs.onSurfaceVariant),
      trailing: [
        ListenableBuilder(
          listenable: controller,
          builder: (context, _) => controller.text.isEmpty
              ? const SizedBox.shrink()
              : IconButton(
                  tooltip: 'Effacer',
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    controller.clear();
                    onChanged('');
                  },
                ),
        ),
        IconButton.filledTonal(
          tooltip: isScannerOpen ? 'Replier le scanner' : 'Scanner',
          isSelected: isScannerOpen,
          icon: const Icon(Icons.qr_code_scanner),
          onPressed: onToggleScanner,
        ),
      ],
    );
  }
}
