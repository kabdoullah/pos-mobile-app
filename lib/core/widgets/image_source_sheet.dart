import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

/// Côté maximal envoyé au serveur : la photo est redimensionnée sur le
/// téléphone avant l'envoi (données mobiles), le serveur la ramène ensuite à
/// 512 px (ADR-0008).
const _maxUploadSide = 1024.0;

/// Propose « Prendre une photo » / « Choisir dans la galerie » (et « Retirer »
/// si [canRemove]). Retourne le fichier choisi, [ImageSourceChoice.remove],
/// ou null si l'utilisateur annule.
Future<Object?> showImageSourceSheet(
  BuildContext context, {
  required String title,
  bool canRemove = false,
}) async {
  final choice = await showModalBottomSheet<Object>(
    context: context,
    showDragHandle: true,
    builder: (context) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(title: Text(title)),
          ListTile(
            leading: const Icon(Icons.photo_camera_outlined),
            title: const Text('Prendre une photo'),
            onTap: () => Navigator.of(context).pop(ImageSource.camera),
          ),
          ListTile(
            leading: const Icon(Icons.photo_library_outlined),
            title: const Text('Choisir dans la galerie'),
            onTap: () => Navigator.of(context).pop(ImageSource.gallery),
          ),
          if (canRemove)
            ListTile(
              leading: Icon(
                Icons.delete_outline,
                color: Theme.of(context).colorScheme.error,
              ),
              title: Text(
                'Retirer',
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
              onTap: () => Navigator.of(context).pop(ImageSourceChoice.remove),
            ),
        ],
      ),
    ),
  );
  if (choice is! ImageSource) return choice;
  final picked = await ImagePicker().pickImage(
    source: choice,
    maxWidth: _maxUploadSide,
    maxHeight: _maxUploadSide,
    imageQuality: 85,
  );
  return picked == null ? null : File(picked.path);
}

/// Choix « Retirer l'image » de [showImageSourceSheet].
enum ImageSourceChoice {
  /// Retirer l'image actuelle.
  remove,
}
