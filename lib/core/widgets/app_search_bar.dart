import 'package:flutter/material.dart';

import '../../app/theme/app_spacing.dart';

/// Barre de recherche commune (caisse, stock, ventes) : loupe, bouton
/// « Effacer » dès qu'un texte est saisi, et [actions] optionnelles à droite
/// (scan…).
class AppSearchBar extends StatelessWidget {
  /// Crée une barre de recherche.
  const AppSearchBar({
    required this.controller,
    required this.hintText,
    required this.onChanged,
    this.focusNode,
    this.keyboardType,
    this.actions = const [],
    super.key,
  });

  /// Contrôleur du texte.
  final TextEditingController controller;

  /// Texte indicatif.
  final String hintText;

  /// Appelé à chaque modification (y compris `''` quand on efface).
  final ValueChanged<String> onChanged;

  /// Focus optionnel (la caisse replie la caméra pendant la saisie).
  final FocusNode? focusNode;

  /// Clavier (ex. numérique pour un n° de reçu).
  final TextInputType? keyboardType;

  /// Boutons supplémentaires après « Effacer ».
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SearchBar(
      controller: controller,
      focusNode: focusNode,
      onChanged: onChanged,
      hintText: hintText,
      keyboardType: keyboardType,
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
        ...actions,
      ],
    );
  }
}
