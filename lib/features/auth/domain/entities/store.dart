import 'package:freezed_annotation/freezed_annotation.dart';

part 'store.freezed.dart';

/// Configuration de la boutique du commerçant.
///
/// Contient les informations de base de la boutique affichées sur les reçus et
/// dans les paramètres.
@freezed
sealed class Store with _$Store {
  /// Crée un [Store].
  const factory Store({
    /// Nom de la boutique (obligatoire).
    required String name,

    /// Adresse de la boutique (optionnelle).
    String? address,

    /// Numéro de Compte Contribuable DGI (optional).
    String? ncc,

    /// Indique si la boutique est assujettie à la TVA (par défaut : false).
    required bool isSubjectToVat,

    /// Texte de pied de reçu personnalisé (optionnel).
    String? receiptFooterText,
  }) = _Store;
}
