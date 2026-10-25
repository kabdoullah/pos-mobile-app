import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../storage/pin_storage.dart';
import '../storage/secure_token_storage.dart';
import 'dio_client.dart';
import 'dio_file_service.dart';
import 'token_storage.dart';
import '../sync/sync_remote_datasource.dart';

part 'network_providers.g.dart';

/// Fournit l'implémentation de TokenStorage.
/// Doit être surchargé dans ProviderScope avant utilisation.
@Riverpod(keepAlive: true)
TokenStorage tokenStorage(Ref ref) {
  throw UnimplementedError(
    'Override tokenStorageProvider with SecureTokenStorage implementation',
  );
}

/// Diffuse un événement vide quand l'authentification expire (session
/// invalide).
/// La couche auth écoute ce flux et redirige vers l'écran de connexion.
@Riverpod(keepAlive: true)
Raw<StreamController<void>> authExpiredController(Ref ref) {
  final controller = StreamController<void>.broadcast();
  ref.onDispose(controller.close);
  return controller;
}

/// Fournit une instance Dio configurée avec auth JWT, rafraîchissement et
/// gestion des erreurs.
@Riverpod(keepAlive: true)
Dio dio(Ref ref) {
  final storage = ref.watch(tokenStorageProvider);
  // ignore: close_sinks
  final controller = ref.watch(authExpiredControllerProvider);

  return buildDio(
    tokenStorage: storage,
    onAuthExpired: () => controller.add(null),
  );
}

/// Cache disque et mémoire des photos produit (`cached_network_image`),
/// téléchargées via le [Dio] authentifié. Clé = `product_<id>_<version>`.
@Riverpod(keepAlive: true)
BaseCacheManager imageCacheManager(Ref ref) {
  return CacheManager(
    Config(
      'productImages',
      stalePeriod: const Duration(days: 365),
      maxNrOfCacheObjects: 1000,
      fileService: DioFileService(ref.watch(dioProvider)),
    ),
  );
}

/// Fournit l'implémentation concrète SecureTokenStorage.
@Riverpod(keepAlive: true)
SecureTokenStorage secureTokenStorage(Ref ref) {
  return SecureTokenStorage();
}

/// Fournit le stockage du PIN pour sa gestion locale.
@Riverpod(keepAlive: true)
PinStorage pinStorage(Ref ref) {
  return PinStorage();
}

/// Fournit la data source distante de synchronisation.
@Riverpod(keepAlive: true)
SyncRemoteDataSource syncRemoteDataSource(Ref ref) {
  final dio = ref.watch(dioProvider);
  return SyncRemoteDataSource(dio);
}
