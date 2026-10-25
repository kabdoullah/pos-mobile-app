import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/network/network_providers.dart';
import '../../../../core/sync/sync_orchestrator.dart';
import '../../domain/repositories/catalog_repository.dart';
import '../../providers/catalog_di_providers.dart';

part 'product_image_providers.g.dart';

/// Image d'un produit à une version donnée (cache disque, sinon
/// téléchargement). La version dans la clé invalide l'ancienne photo.
@riverpod
ImageProvider productImage(Ref ref, String productId, String version) {
  return CachedNetworkImageProvider(
    ref.watch(catalogRepositoryProvider).productImageUrl(productId),
    cacheKey: 'product_${productId}_$version',
    cacheManager: ref.watch(imageCacheManagerProvider),
  );
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
