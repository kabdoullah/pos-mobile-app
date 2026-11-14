import 'package:flutter/material.dart';

import 'app_dialog.dart';
import 'primary_button.dart';

/// Affiche un dialogue de confirmation (maquette v2) : l'action en bouton
/// principal pleine largeur, « Annuler » en bouton texte dessous.
///
/// Retourne true si l'utilisateur confirme, false s'il annule.
Future<bool> showConfirmDialog(
  BuildContext context, {
  required String title,
  required String message,
  String confirmLabel = 'Confirmer',
  String cancelLabel = 'Annuler',
  bool isDangerous = false,
}) async {
  final result = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (context) => AppDialog(
      title: title,
      message: message,
      actions: [
        PrimaryButton(
          label: confirmLabel,
          isDangerous: isDangerous,
          onPressed: () => Navigator.pop(context, true),
        ),
        AppDialogTextAction(
          label: cancelLabel,
          onPressed: () => Navigator.pop(context, false),
        ),
      ],
    ),
  );

  return result ?? false;
}
