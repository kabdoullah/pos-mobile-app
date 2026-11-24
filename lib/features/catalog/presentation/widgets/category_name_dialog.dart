import 'package:flutter/material.dart';

import '../../../../app/theme/app_typography.dart';

import '../../../../app/theme/app_colors.dart';

import '../../../../core/widgets/index.dart';

/// Longueur maximale d'un nom de catégorie (colonne serveur : 60).
const categoryNameMaxLength = 60;

/// Demande un nom de catégorie. Retourne le nom saisi (sans espaces autour),
/// ou `null` si l'utilisateur annule.
Future<String?> showCategoryNameDialog(
  BuildContext context, {
  required String title,
  String initialName = '',
  String confirmLabel = 'Enregistrer',
}) {
  return showDialog<String>(
    context: context,
    builder: (_) => _CategoryNameDialog(
      title: title,
      initialName: initialName,
      confirmLabel: confirmLabel,
    ),
  );
}

/// Choix fait dans « Modifier la catégorie ».
sealed class CategoryEditResult {
  const CategoryEditResult();
}

/// Nouveau nom à enregistrer.
final class CategoryRenamed extends CategoryEditResult {
  /// Crée le résultat pour [name].
  const CategoryRenamed(this.name);

  /// Nom saisi (sans espaces autour).
  final String name;
}

/// Suppression demandée (à confirmer par l'appelant).
final class CategoryDeleteRequested extends CategoryEditResult {
  /// Crée le résultat.
  const CategoryDeleteRequested();
}

/// « Modifier la catégorie » : renommer, avec l'impact annoncé ([productCount]
/// produits), ou demander la suppression. `null` si fermé sans choix.
Future<CategoryEditResult?> showCategoryEditDialog(
  BuildContext context, {
  required String name,
  required int productCount,
}) async {
  final result = await showDialog<Object>(
    context: context,
    builder: (_) => _CategoryNameDialog(
      title: 'Modifier la catégorie',
      initialName: name,
      confirmLabel: 'Enregistrer',
      message: productCount == 0
          ? 'Aucun produit dans cette catégorie.'
          : productCount == 1
          ? '1 produit est dans cette catégorie.'
          : '$productCount produits sont dans cette catégorie.',
      canDelete: true,
    ),
  );
  return switch (result) {
    final String newName => CategoryRenamed(newName),
    CategoryDeleteRequested() => const CategoryDeleteRequested(),
    _ => null,
  };
}

class _CategoryNameDialog extends StatefulWidget {
  const _CategoryNameDialog({
    required this.title,
    required this.initialName,
    required this.confirmLabel,
    this.message,
    this.canDelete = false,
  });

  final String title;
  final String initialName;
  final String confirmLabel;
  final String? message;
  final bool canDelete;

  @override
  State<_CategoryNameDialog> createState() => _CategoryNameDialogState();
}

class _CategoryNameDialogState extends State<_CategoryNameDialog> {
  late final _controller = TextEditingController(text: widget.initialName);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final name = _controller.text.trim();
    if (name.isNotEmpty) Navigator.of(context).pop(name);
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final message = widget.message;
    final canSave = _controller.text.trim().isNotEmpty;
    return AppDialog(
      title: widget.title,
      body: [
        AppTextField(
          label: 'Nom',
          hint: 'Ex. : Boissons',
          controller: _controller,
          autofocus: true,
          maxLength: categoryNameMaxLength,
          textCapitalization: TextCapitalization.sentences,
          textInputAction: TextInputAction.done,
          onChanged: (_) => setState(() {}),
          onSubmitted: (_) => _submit(),
        ),
        if (message != null)
          Text(
            message,
            style: AppTypography.body.copyWith(color: colors.textSecondary),
          ),
      ],
      actions: [
        PrimaryButton(
          label: widget.confirmLabel,
          onPressed: canSave ? _submit : null,
        ),
        if (widget.canDelete)
          AppDialogTextAction(
            label: 'Supprimer la catégorie',
            isDangerous: true,
            onPressed: () =>
                Navigator.of(context).pop(const CategoryDeleteRequested()),
          )
        else
          AppDialogTextAction(
            label: 'Annuler',
            onPressed: () => Navigator.of(context).pop(),
          ),
      ],
    );
  }
}
