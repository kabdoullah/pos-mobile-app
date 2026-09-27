import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/category.dart';
import '../../providers/catalog_di_providers.dart';

part 'category_providers.g.dart';

/// Diffuse les catégories actives, triées par nom (ADR-0008).
@riverpod
Stream<List<Category>> categories(Ref ref) {
  return ref.watch(catalogRepositoryProvider).watchCategories();
}

/// Nombre de produits actifs par catégorie (tout le catalogue local, pas une
/// page).
@riverpod
Stream<Map<String, int>> categoryProductCounts(Ref ref) {
  return ref.watch(catalogRepositoryProvider).watchProducts().map((products) {
    final counts = <String, int>{};
    for (final product in products) {
      final id = product.categoryId;
      if (id != null) counts[id] = (counts[id] ?? 0) + 1;
    }
    return counts;
  });
}

/// Écritures sur les catégories et la catégorie des produits.
///
/// keepAlive : appelé depuis des feuilles et dialogues qui ne l'écoutent pas —
/// une instance auto-dispose serait libérée pendant l'écriture.
@Riverpod(keepAlive: true)
class CategoryEditor extends _$CategoryEditor {
  @override
  void build() {}

  /// Crée une catégorie. Lève `CategoryNameTakenException` si le nom est pris.
  Future<Category> create(String name) =>
      ref.read(catalogRepositoryProvider).createCategory(name);

  /// Renomme une catégorie. Lève `CategoryNameTakenException` si le nom est
  /// pris.
  Future<void> rename(String id, String name) =>
      ref.read(catalogRepositoryProvider).renameCategory(id, name);

  /// Supprime une catégorie ; ses produits deviennent « sans catégorie ».
  Future<void> delete(String id) =>
      ref.read(catalogRepositoryProvider).deleteCategory(id);

  /// Change (ou retire, avec null) la catégorie d'un produit.
  Future<void> setProductCategory(String productId, String? categoryId) => ref
      .read(catalogRepositoryProvider)
      .setProductCategory(productId, categoryId);
}
