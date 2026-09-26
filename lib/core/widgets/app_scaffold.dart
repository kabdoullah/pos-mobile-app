import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'sync_status_indicator.dart';

/// Scaffold standard de l'app avec bandeau hors ligne optionnel.
///
/// Affiche un bandeau d'avertissement jaune hors ligne pour prévenir
/// l'utilisateur que ses actions seront synchronisées au retour de la
/// connexion. La navigation du bas est gérée par MainShell pour les routes
/// authentifiées.
class AppScaffold extends ConsumerWidget {
  /// Crée un scaffold d'app.
  const AppScaffold({
    required this.title,
    required this.body,
    this.actions,
    this.floatingActionButton,
    this.showOfflineBanner = true,
    super.key,
  });

  /// Titre de l'AppBar.
  final String title;

  /// Contenu principal du scaffold.
  final Widget body;

  /// Actions à afficher dans l'AppBar.
  final List<Widget>? actions;

  /// Bouton d'action flottant.
  final Widget? floatingActionButton;

  /// Affiche ou non le bandeau hors ligne en cas de déconnexion.
  final bool showOfflineBanner;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text(title), actions: actions),
      body: Column(
        children: [
          if (showOfflineBanner) const SyncStatusIndicator(),
          Expanded(child: body),
        ],
      ),
      floatingActionButton: floatingActionButton,
    );
  }
}
