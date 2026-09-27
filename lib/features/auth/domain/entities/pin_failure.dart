/// Échec de la vérification du PIN, levé par `AuthRepository.verifyPin`.
///
/// Typé (et non un simple message) pour que l'écran PIN affiche le nombre exact
/// de tentatives restantes et un compte à rebours pendant le blocage.
sealed class PinFailure implements Exception {
  /// Constructeur.
  const PinFailure();
}

/// PIN erroné, le blocage n'est pas encore atteint.
class WrongPin extends PinFailure {
  /// Crée un échec « PIN erroné ».
  const WrongPin({required this.remainingAttempts});

  /// Tentatives restantes avant le blocage (au moins 1).
  final int remainingAttempts;

  @override
  String toString() => 'PIN incorrect.';
}

/// PIN temporairement bloqué après trop d'échecs.
class PinLocked extends PinFailure {
  /// Crée un échec « PIN bloqué ».
  const PinLocked({required this.until});

  /// Fin du blocage.
  final DateTime until;

  @override
  String toString() => 'PIN temporairement bloqué.';
}
