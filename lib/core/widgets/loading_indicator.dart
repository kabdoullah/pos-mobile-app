import 'package:flutter/material.dart';

/// Widget d'indicateur de chargement cohérent.
///
/// Deux tailles : 40 pt pour un chargement de page ou de liste, 20 pt
/// ([AppLoadingIndicator.small]) en ligne — dans un bouton, une tuile, à la
/// place d'une action.
class AppLoadingIndicator extends StatelessWidget {
  /// Crée un indicateur de chargement de page (40 pt).
  const AppLoadingIndicator({super.key})
    : _dimension = 40,
      _strokeWidth = 4,
      color = null;

  /// Crée un indicateur en ligne (20 pt). [color] remplace la couleur
  /// d'action, par exemple sur un fond plein.
  const AppLoadingIndicator.small({this.color, super.key})
    : _dimension = 20,
      _strokeWidth = 2;

  /// Couleur du trait ; par défaut la couleur primaire (action) du thème.
  final Color? color;

  final double _dimension;
  final double _strokeWidth;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: _dimension,
      child: CircularProgressIndicator(
        color: color ?? Theme.of(context).colorScheme.primary,
        strokeWidth: _strokeWidth,
      ),
    );
  }
}
