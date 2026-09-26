/// Résultat d'une ligne dans un import produits en masse.
enum ProductImportItemStatus {
  /// La ligne a été créée avec succès.
  created,

  /// L'import de la ligne a échoué.
  failed,
}

/// Résultat du traitement d'une ligne d'un import produits en masse.
class ProductImportItemResult {
  /// Crée un ProductImportItemResult.
  const ProductImportItemResult({
    required this.index,
    required this.status,
    this.error,
    this.field,
  });

  /// Index de la ligne (à partir de 0) dans le fichier importé.
  final int index;

  /// Indique si la ligne a été créée ou a échoué.
  final ProductImportItemStatus status;

  /// Message d'erreur quand [status] est en échec.
  final String? error;

  /// Nom du champ à l'origine de l'échec, le cas échéant.
  final String? field;
}

/// Résultat récapitulatif d'un import produits en masse (au mieux, ligne par
/// ligne).
class ProductImportResult {
  /// Crée un ProductImportResult.
  const ProductImportResult({
    required this.processed,
    required this.createdCount,
    required this.failedCount,
    required this.items,
  });

  /// Nombre total de lignes traitées.
  final int processed;

  /// Nombre de lignes créées avec succès.
  final int createdCount;

  /// Nombre de lignes en échec.
  final int failedCount;

  /// Résultats ligne par ligne.
  final List<ProductImportItemResult> items;
}
