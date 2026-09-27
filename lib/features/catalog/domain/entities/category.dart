import 'package:freezed_annotation/freezed_annotation.dart';

part 'category.freezed.dart';

/// Catégorie de produits (ADR-0008).
@freezed
sealed class Category with _$Category {
  /// Crée une [Category].
  const factory Category({required String id, required String name}) =
      _Category;
}

/// Levée quand une autre catégorie active porte déjà ce nom (casse ignorée).
class CategoryNameTakenException implements Exception {
  /// Crée l'exception pour [name].
  const CategoryNameTakenException(this.name);

  /// Nom refusé.
  final String name;

  @override
  String toString() => 'Une catégorie « $name » existe déjà.';
}
