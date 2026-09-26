import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme/app_animations.dart';

/// Constructeurs de transitions de page personnalisées pour une navigation
/// fluide.
///
/// Fournit des transitions en fondu, glissement et zoom selon le type de route.
/// Utilisées par GoRouter pour un mouvement cohérent et soigné.
abstract class PageTransitions {
  /// Transition en fondu. Pour les parcours de type modale (pages d'auth,
  /// paramètres).
  static CustomTransitionPage<T> fade<T>(
    BuildContext context,
    GoRouterState state,
    Widget child,
  ) {
    return CustomTransitionPage<T>(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
      transitionDuration: AppAnimations.standard,
      reverseTransitionDuration: AppAnimations.standard,
    );
  }

  /// Transition en glissement (de gauche à droite). Pour la navigation vers
  /// l'avant.
  static CustomTransitionPage<T> slideRight<T>(
    BuildContext context,
    GoRouterState state,
    Widget child,
  ) {
    return CustomTransitionPage<T>(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(-1.0, 0.0);
        const end = Offset.zero;
        final tween = Tween(begin: begin, end: end);
        final offsetAnimation = animation.drive(tween);
        return SlideTransition(position: offsetAnimation, child: child);
      },
      transitionDuration: AppAnimations.standard,
      reverseTransitionDuration: AppAnimations.standard,
    );
  }

  /// Transition en glissement (de droite à gauche, sortie). Pour le retour
  /// arrière.
  static CustomTransitionPage<T> slideLeft<T>(
    BuildContext context,
    GoRouterState state,
    Widget child,
  ) {
    return CustomTransitionPage<T>(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        final tween = Tween(begin: begin, end: end);
        final offsetAnimation = animation.drive(tween);
        return SlideTransition(position: offsetAnimation, child: child);
      },
      transitionDuration: AppAnimations.standard,
      reverseTransitionDuration: AppAnimations.standard,
    );
  }

  /// Transition en zoom. Pour l'ouverture de détails/modales (détail produit,
  /// détail vente).
  static CustomTransitionPage<T> scale<T>(
    BuildContext context,
    GoRouterState state,
    Widget child,
  ) {
    return CustomTransitionPage<T>(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = 0.95;
        const end = 1.0;
        final tween = Tween(begin: begin, end: end);
        final scaleAnimation = animation.drive(tween);
        return ScaleTransition(scale: scaleAnimation, child: child);
      },
      transitionDuration: AppAnimations.standard,
      reverseTransitionDuration: AppAnimations.standard,
    );
  }

  /// Transition fondu + zoom. Rendu soigné pour les modales importantes.
  static CustomTransitionPage<T> fadeScale<T>(
    BuildContext context,
    GoRouterState state,
    Widget child,
  ) {
    return CustomTransitionPage<T>(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const beginScale = 0.9;
        const endScale = 1.0;
        final scaleTween = Tween(begin: beginScale, end: endScale);
        final scaleAnimation = animation.drive(scaleTween);

        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(scale: scaleAnimation, child: child),
        );
      },
      transitionDuration: AppAnimations.moderate,
      reverseTransitionDuration: AppAnimations.standard,
    );
  }
}
