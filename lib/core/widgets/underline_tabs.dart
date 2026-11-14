import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_typography.dart';

/// Un onglet de [UnderlineTabs].
typedef UnderlineTab<T> = ({T value, String label});

/// Onglets soulignés v2 (catégories, filtres de stock, périodes) : ligne
/// défilante, onglet actif souligné 2 dp couleur action, filet dessous.
/// Pas de `TabController` : la valeur active est fournie par l'appelant.
class UnderlineTabs<T> extends StatelessWidget {
  /// Crée les onglets.
  const UnderlineTabs({
    required this.tabs,
    required this.selected,
    required this.onSelected,
    super.key,
  });

  /// Onglets, de gauche à droite.
  final List<UnderlineTab<T>> tabs;

  /// Valeur de l'onglet actif.
  final T selected;

  /// Appelé au toucher d'un onglet.
  final ValueChanged<T> onSelected;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: colors.border)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
        child: Row(
          children: [
            for (final tab in tabs)
              _Tab(
                label: tab.label,
                isSelected: tab.value == selected,
                onTap: () => onSelected(tab.value),
              ),
          ],
        ),
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  const _Tab({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Semantics(
      button: true,
      selected: isSelected,
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm + 3),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected ? colors.action : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Text(
            label,
            style: AppTypography.bodyStrong.copyWith(
              fontSize: 15,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: isSelected ? colors.textPrimary : colors.textSecondary,
              fontFeatures: AppTypography.tabularFigures,
            ),
          ),
        ),
      ),
    );
  }
}
