import 'package:flutter/material.dart';

/// Scaffold standard de l'app : en-tête sur le fond de page, titre 22/600.
///
/// v2 : plus de bandeau de synchro permanent ; l'état de synchro se lit en
/// point + mot (`OfflineStatusIndicator`) là où l'écran en a besoin. La
/// navigation du bas est gérée par MainShell pour les routes authentifiées.
class AppScaffold extends StatelessWidget {
  /// Crée un scaffold d'app.
  const AppScaffold({
    required this.title,
    required this.body,
    this.actions,
    this.floatingActionButton,
    super.key,
  });

  /// Titre de l'AppBar.
  final String title;

  /// Contenu principal du scaffold.
  final Widget body;

  /// Actions à afficher dans l'AppBar.
  final List<Widget>? actions;

  /// Bouton flottant optionnel.
  final Widget? floatingActionButton;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title), actions: actions),
      body: body,
      floatingActionButton: floatingActionButton,
    );
  }
}
