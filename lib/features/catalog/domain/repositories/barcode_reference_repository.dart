/// Référentiel de produits connus par code-barres (GTIN), commun à toutes les
/// boutiques et embarqué dans l'application : fonctionne hors ligne.
abstract class BarcodeReferenceRepository {
  /// Nom suggéré pour [barcode], ou null si le code est inconnu ou invalide.
  ///
  /// Le nom vient d'un catalogue tiers (souvent abrégé) : c'est une
  /// suggestion à faire vérifier, jamais une valeur sûre.
  Future<String?> suggestName(String barcode);
}
