import 'dart:io';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/sync/sync_orchestrator.dart';
import '../../domain/repositories/catalog_repository.dart';
import '../../providers/catalog_di_providers.dart';

part 'product_image_providers.g.dart';

/// Fichier de l'image d'un produit à une version donnée (cache, sinon
/// téléchargement) ; null si indisponible.
@riverpod
Future<File?> productImageFile(Ref ref, String productId, String version) {
  return ref.watch(catalogRepositoryProvider).productImage(productId, version);
}

/// Envoi et retrait des photos produit (en ligne, ADR-0008).
///
/// keepAlive : l'envoi continue si l'écran se ferme pendant le téléversement.
@Riverpod(keepAlive: true)
class ProductImageEditor extends _$ProductImageEditor {
  @override
  void build() {}

  /// Envoie [image]. Un produit créé hors ligne n'existe pas encore sur le
  /// serveur : on synchronise puis on réessaie une fois.
  Future<void> upload(String productId, File image) async {
    final repo = ref.read(catalogRepositoryProvider);
    try {
      await repo.uploadProductImage(productId, image);
    } on ProductNotOnServerException {
      await ref.read(syncOrchestratorProvider.notifier).syncNow();
      await repo.uploadProductImage(productId, image);
    }
  }

  /// Retire la photo du produit.
  Future<void> remove(String productId) =>
      ref.read(catalogRepositoryProvider).deleteProductImage(productId);
}
