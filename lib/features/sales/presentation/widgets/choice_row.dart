import 'package:flutter/material.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/index.dart';

/// Un choix de [ChoiceRow].
typedef Choice<T> = ({T value, String label});

/// Rangée de choix de largeurs égales (montants rapides, opérateurs) : 44 dp,
/// filet 1 dp, choix actif bordé 2 dp couleur action.
class ChoiceRow<T> extends StatelessWidget {
  /// Crée la rangée.
  const ChoiceRow({
    required this.choices,
    required this.selected,
    required this.onSelected,
    super.key,
  });

  /// Choix, de gauche à droite.
  final List<Choice<T>> choices;

  /// Valeur active ; `null` = aucune.
  final T? selected;

  /// Appelé au choix d'une valeur.
  final ValueChanged<T> onSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final (i, choice) in choices.indexed) ...[
          if (i > 0) const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: QuickChoiceButton(
              label: choice.label,
              isSelected: choice.value == selected,
              onTap: () => onSelected(choice.value),
            ),
          ),
        ],
      ],
    );
  }
}
