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
      onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
      controller: controller,
      focusNode: focusNode,
      onChanged: onChanged,
      hintText: hintText,
      keyboardType: keyboardType,
      textInputAction: TextInputAction.search,
      elevation: const WidgetStatePropertyAll(0),
      // Comme les champs : fond de l'écran, bordure outline, 2 dp au focus.
      backgroundColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.focused)
            ? cs.surface
            : Theme.of(context).scaffoldBackgroundColor,
      ),
      side: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.focused)
            ? BorderSide(color: cs.primary, width: 2)
            : BorderSide(color: cs.outline),
      ),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
      ),
      constraints: const BoxConstraints(minHeight: AppSpacing.inputHeight),
      padding: const WidgetStatePropertyAll(
        EdgeInsets.only(left: AppSpacing.md, right: AppSpacing.xs),
      ),
      leading: Icon(Icons.search, color: cs.onSurfaceVariant),
      // Pendant une saisie, « Effacer » remplace les actions : les deux ne
      // tiennent pas ensemble sur 360 dp.
      trailing: [
        ListenableBuilder(
          listenable: controller,
          builder: (context, _) => controller.text.isEmpty
              ? Row(mainAxisSize: MainAxisSize.min, children: actions)
              : TextButton(
                  onPressed: () {
                    controller.clear();
                    onChanged('');
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: cs.onSurfaceVariant,
                  ),
                  child: const Text('Effacer'),
                ),
        ),
      ],
    );
  }
}
