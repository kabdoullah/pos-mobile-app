import 'dart:io';
import 'dart:typed_data';

import '../entities/product.dart';
import '../entities/product_import_result.dart';
import '../entities/product_page.dart';

/// Repository abstrait pour les opérations du catalogue.
abstract class CatalogRepository {
  /// Récupère les produits, filtrés en option par une recherche, et paginés par
  /// curseur.
  /// Retourne une page avec ses métadonnées de pagination.
  Future<ProductPage> getProducts({
    String? query,
    String? cursor,
    int limit = 50,
  });

  /// Crée un nouveau produit.
  Future<Product> createProduct({
    required String name,
    required String unitPrice,
    String? barcode,
    int? currentStock,
    int? minStock,
  });

  /// Met à jour un produit existant.
  Future<Product> updateProduct({
    required String id,
    String? name,
    String? unitPrice,
    String? barcode,
    int? currentStock,
    int? minStock,
  });

  /// Supprime (logiquement) un produit par ID.
  Future<void> deleteProduct(String id);

  /// Récupère un produit par ID.
  Future<Product?> getProduct(String id);

  /// Cherche un produit par code-barres. Retourne null s'il est introuvable.
  Future<Product?> getByBarcode(String barcode);

  /// Diffuse tous les produits non supprimés, triés par nom — réémet à chaque
  /// changement du catalogue local.
  Stream<List<Product>> watchProducts();

  /// Diffuse les produits en rupture (stock = 0) ou sous leur seuil de
  /// réapprovisionnement, triés par stock croissant (ruptures d'abord) — réémet
  /// à chaque changement du catalogue local.
  Stream<List<Product>> watchLowStockProducts();

  /// Importe des produits en masse depuis un fichier CSV ou Excel (au mieux,
  /// ligne par ligne).
  Future<ProductImportResult> importProductsFromFile(File file);

  /// Télécharge un modèle d'import vierge (`csv` ou `xlsx`).
  Future<Uint8List> downloadImportTemplate({required String format});
}
