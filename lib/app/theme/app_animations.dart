import 'package:flutter/material.dart';

/// Courbes et durées d'animation pour POS Mobile CI.
///
/// Mouvement standardisé pour un rendu fluide et soigné. Toutes les animations
/// utilisent les courbes Material 3 (easeIn, easeOut, easeInOut) avec des
/// durées réglées d'un retour rapide (short : 150 ms) à une attente modérée
/// (long : 600 ms).
class AppAnimations {
  /// Empêche l'instanciation
  AppAnimations._();

  // Jetons de durée
  /// Retour très rapide (ripple de bouton, bascule). 150 ms.
  static const Duration quick = Duration(milliseconds: 150);

  /// Transition standard (glissement de page, fondu). 300 ms.
  static const Duration standard = Duration(milliseconds: 300);

  /// Animation modérée (bottom sheet, modale). 400 ms.
  static const Duration moderate = Duration(milliseconds: 400);

  /// Lente pour l'emphase (spinner de chargement, cascade de liste). 600 ms.
  static const Duration slow = Duration(milliseconds: 600);

  // Jetons de courbe (Material 3)
  /// Courbe de décélération. Pour les animations d'entrée/apparition.
  static const Curve easeOut = Curves.easeOutCubic;

  /// Courbe d'accélération. Pour les animations de sortie/disparition.
  static const Curve easeIn = Curves.easeInCubic;

  /// Courbe symétrique. Pour les animations bidirectionnelles (bascule, focus).
  static const Curve easeInOut = Curves.easeInOutCubic;

  /// Courbe rebondissante pour un retour ludique (rare, optionnel).
  static const Curve bounce = Curves.elasticOut;
}
