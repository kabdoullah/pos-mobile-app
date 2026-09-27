import 'package:flutter/material.dart';

/// Occupe toute la hauteur disponible (les `Spacer` d'une colonne
/// fonctionnent), mais défile si le contenu ne tient pas — petit téléphone,
/// grande police système, clavier ouvert.
class FillOrScroll extends StatelessWidget {
  /// Enveloppe [child] (en général une `Column` avec des `Spacer`).
  const FillOrScroll({required this.child, super.key});

  /// Contenu à afficher.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: IntrinsicHeight(child: child),
        ),
      ),
    );
  }
}
