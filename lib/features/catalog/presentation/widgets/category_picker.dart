import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/category.dart';
import '../providers/category_providers.dart';
import 'category_name_dialog.dart';

/// Valeur interne de l'entrée « Nouvelle catégorie… ».
const _newCategory = '__new__';

/// Sélecteur de catégorie du formulaire produit, avec création en place.
class CategoryPicker extends ConsumerWidget {
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

  Future<void> _createAndSelect(BuildContext context, WidgetRef ref) async {
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
      onChanged(category.id);
    } on CategoryNameTakenException catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories =
        ref.watch(categoriesProvider).value ?? const <Category>[];
    // Catégorie supprimée entre-temps : on affiche « Sans catégorie ».
    final selected = categories.any((c) => c.id == value) ? value : null;

    return DropdownButtonFormField<String?>(
      // Clé : reconstruit le champ quand la sélection change de l'extérieur.
      key: ValueKey(selected),
      initialValue: selected,
      isExpanded: true,
      decoration: const InputDecoration(labelText: 'Catégorie'),
      items: [
        const DropdownMenuItem<String?>(child: Text('Sans catégorie')),
        for (final category in categories)
          DropdownMenuItem<String?>(
            value: category.id,
            child: Text(category.name, overflow: TextOverflow.ellipsis),
          ),
        const DropdownMenuItem<String?>(
          value: _newCategory,
          child: Text('+ Nouvelle catégorie…'),
        ),
      ],
      onChanged: (id) {
        if (id == _newCategory) {
          unawaited(_createAndSelect(context, ref));
          return;
        }
        onChanged(id);
      },
    );
  }
}
