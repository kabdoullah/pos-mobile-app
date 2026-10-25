import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../domain/entities/category.dart';
import '../providers/category_providers.dart';
import 'category_name_dialog.dart';

/// Valeur interne de l'entrée « Nouvelle catégorie… ».
const _newCategory = '__new__';

/// Sélecteur de catégorie du formulaire produit, avec création en place.
///
/// Même présentation que `AppTextField` : libellé au-dessus, texte courant.
class CategoryPicker extends ConsumerStatefulWidget {
  /// Crée le sélecteur ; [value] `null` = sans catégorie.
  const CategoryPicker({
    required this.value,
    required this.onChanged,
    super.key,
  });

  /// Catégorie sélectionnée.
  final String? value;

  /// Nouvelle catégorie choisie (`null` = sans catégorie).
  final ValueChanged<String?> onChanged;

  @override
  ConsumerState<CategoryPicker> createState() => _CategoryPickerState();
}

class _CategoryPickerState extends ConsumerState<CategoryPicker> {
  // Change à chaque choix de « Nouvelle catégorie… » : le champ est recréé
  // et n'affiche jamais cette entrée comme valeur.
  int _resets = 0;

  Future<void> _createAndSelect() async {
    setState(() => _resets++);
    final name = await showCategoryNameDialog(
      context,
      title: 'Nouvelle catégorie',
      confirmLabel: 'Créer',
    );
    if (name == null) return;
    try {
      final category = await ref
          .read(categoryEditorProvider.notifier)
          .create(name);
      widget.onChanged(category.id);
    } on CategoryNameTakenException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final categories =
        ref.watch(categoriesProvider).value ?? const <Category>[];
    // Catégorie supprimée entre-temps : on affiche « Sans catégorie ».
    final value = widget.value;
    final selected = categories.any((c) => c.id == value) ? value : null;
    final itemStyle = AppTypography.bodyMedium.copyWith(color: cs.onSurface);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Catégorie',
          style: AppTypography.labelMedium.copyWith(color: cs.onSurface),
        ),
        const SizedBox(height: AppSpacing.xs),
        // DropdownMenu (Material 3) : menu ancré à la largeur du champ, au
        // lieu du menu de DropdownButton qui déborde du bord de l'écran.
        DropdownMenu<String?>(
          // Clé : recrée le champ quand la sélection change de l'extérieur,
          // ou après « Nouvelle catégorie… ».
          key: ValueKey((selected, _resets)),
          initialSelection: selected,
          expandedInsets: EdgeInsets.zero,
          requestFocusOnTap: false,
          textStyle: itemStyle,
          menuHeight: 360,
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: cs.surfaceContainerHighest,
            constraints: const BoxConstraints.tightFor(height: 56),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              borderSide: BorderSide(color: cs.outline),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              borderSide: BorderSide(color: cs.primary),
            ),
          ),
          menuStyle: MenuStyle(
            backgroundColor: WidgetStatePropertyAll(cs.surface),
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              ),
            ),
          ),
          dropdownMenuEntries: [
            DropdownMenuEntry<String?>(
              value: null,
              label: 'Sans catégorie',
              style: MenuItemButton.styleFrom(textStyle: itemStyle),
            ),
            for (final category in categories)
              DropdownMenuEntry<String?>(
                value: category.id,
                label: category.name,
                style: MenuItemButton.styleFrom(textStyle: itemStyle),
              ),
            DropdownMenuEntry<String?>(
              value: _newCategory,
              label: '+ Nouvelle catégorie…',
              style: MenuItemButton.styleFrom(
                foregroundColor: cs.primary,
                textStyle: itemStyle.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
          ],
          onSelected: (id) {
            if (id == _newCategory) {
              unawaited(_createAndSelect());
              return;
            }
            widget.onChanged(id);
          },
        ),
      ],
    );
  }
}
