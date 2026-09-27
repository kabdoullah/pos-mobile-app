import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/product.dart';
import '../../providers/catalog_di_providers.dart';

part 'catalog_providers.g.dart';

/// Écritures sur les produits (création, modification, suppression).
///
/// keepAlive : le formulaire produit ne l'écoute pas et attend l'écriture —
/// une instance auto-dispose serait libérée pendant l'`await` et lèverait une
/// erreur après que le produit a bien été enregistré. Les listes (onglet
/// Stock, caisse) se mettent à jour d'elles-mêmes via les flux drift.
@Riverpod(keepAlive: true)
class ProductEditor extends _$ProductEditor {
  @override
  void build() {}

  /// Crée un produit.
  Future<void> create({
    required String name,
    required String unitPrice,
    String? barcode,
    int? currentStock,
    int? minStock,
    String? categoryId,
  }) async {
    await ref
        .read(catalogRepositoryProvider)
        .createProduct(
          name: name,
          unitPrice: unitPrice,
          barcode: barcode,
          currentStock: currentStock,
          minStock: minStock,
          categoryId: categoryId,
        );
  }

  /// Met à jour un produit (champs fournis uniquement).
  Future<void> update({
    required String id,
    String? name,
    String? unitPrice,
    String? barcode,
    int? currentStock,
    int? minStock,
  }) async {
    await ref
        .read(catalogRepositoryProvider)
        .updateProduct(
          id: id,
          name: name,
          unitPrice: unitPrice,
          barcode: barcode,
          currentStock: currentStock,
          minStock: minStock,
        );
    ref.invalidate(productProvider(id));
  }

  /// Supprime (logiquement) un produit.
  Future<void> delete(String id) async {
    await ref.read(catalogRepositoryProvider).deleteProduct(id);
    ref.invalidate(productProvider(id));
  }
}

/// Récupère un produit par ID pour le formulaire d'édition.
@riverpod
Future<Product?> product(Ref ref, String id) async {
  final repo = ref.watch(catalogRepositoryProvider);
  return repo.getProduct(id);
}
