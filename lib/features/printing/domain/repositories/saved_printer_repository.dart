/// Imprimante mémorisée après la dernière connexion réussie.
typedef SavedPrinter = ({String mac, String name});

/// Mémorise l'imprimante choisie, pour s'y reconnecter à la prochaine
/// impression sans repasser par l'appairage.
abstract interface class SavedPrinterRepository {
  /// L'imprimante mémorisée, ou null si aucune n'a été choisie.
  Future<SavedPrinter?> read();

  /// Mémorise [printer] (remplace la précédente).
  Future<void> save(SavedPrinter printer);

  /// Oublie l'imprimante mémorisée.
  Future<void> clear();
}
