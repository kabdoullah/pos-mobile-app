import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/connectivity_provider.dart';
import 'app_dialog.dart';
import 'primary_button.dart';

/// Titre du message affiché hors ligne.
const offlineTitle = 'Pas de connexion internet';

/// Vérifie la connexion avant une opération qui passe par le serveur.
///
/// Hors ligne : dialogue « Pas de connexion internet » qui dit ce qui est
/// impossible et quoi faire, puis `false` : l'appelant n'appelle pas le
/// serveur. [action] nomme l'opération en début de phrase (« La connexion »,
/// « L’ajustement du stock »).
///
/// Un dialogue plutôt qu'un snackbar : il reste visible au-dessus d'une
/// feuille ou d'un clavier ouvert. État du réseau encore inconnu (démarrage) :
/// `true`, la requête tranche et `ConnectionException` donne le même conseil.
Future<bool> ensureOnline(
  BuildContext context,
  WidgetRef ref, {
  required String action,
}) async {
  if (ref.read(isOnlineProvider).value ?? true) return true;
  FocusManager.instance.primaryFocus?.unfocus();
  await showDialog<void>(
    context: context,
    builder: (context) => AppDialog(
      title: offlineTitle,
      message:
          '$action demande internet. Activez le Wi-Fi ou les données '
          'mobiles, puis réessayez.',
      actions: [
        PrimaryButton(
          label: 'Compris',
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    ),
  );
  return false;
}
