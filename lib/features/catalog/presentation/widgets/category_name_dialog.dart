import 'package:flutter/material.dart';

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

class _CategoryNameDialog extends StatefulWidget {
  const _CategoryNameDialog({
    required this.title,
    required this.initialName,
    required this.confirmLabel,
  });

  final String title;
  final String initialName;
  final String confirmLabel;

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
    return AlertDialog(
      title: Text(widget.title),
      content: TextField(
        controller: _controller,
        autofocus: true,
        maxLength: categoryNameMaxLength,
        textCapitalization: TextCapitalization.sentences,
        textInputAction: TextInputAction.done,
        decoration: const InputDecoration(
          labelText: 'Nom',
          hintText: 'Ex. : Boissons',
        ),
        onChanged: (_) => setState(() {}),
        onSubmitted: (_) => _submit(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Annuler'),
        ),
        FilledButton(
          onPressed: _controller.text.trim().isEmpty ? null : _submit,
          child: Text(widget.confirmLabel),
        ),
      ],
    );
  }
}
