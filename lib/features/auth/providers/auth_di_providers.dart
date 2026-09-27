import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/network_providers.dart';
import '../data/datasources/auth_remote_datasource.dart';
import '../data/datasources/stores_remote_datasource.dart';
import '../data/repositories/auth_repository_impl.dart';
import '../data/repositories/store_repository_impl.dart';
import '../domain/repositories/auth_repository.dart';
import '../domain/repositories/store_repository.dart';
import '../data/repositories/profile_repository_impl.dart';
import '../domain/repositories/profile_repository.dart';
import '../../../core/sync/sync_providers.dart';

part 'auth_di_providers.g.dart';

/// Fournit la data source distante pour les appels API d'auth.
@riverpod
AuthRemoteDataSource authRemoteDataSource(Ref ref) {
  return AuthRemoteDataSource(ref.read(dioProvider));
}

/// Fournit la data source distante pour les appels API boutique.
@riverpod
StoresRemoteDataSource storesRemoteDataSource(Ref ref) {
  return StoresRemoteDataSource(ref.read(dioProvider));
}

/// Fournit l'implémentation du repository d'auth.
@riverpod
AuthRepository authRepository(Ref ref) {
  return AuthRepositoryImpl(
    dataSource: ref.read(authRemoteDataSourceProvider),
    tokenStorage: ref.read(secureTokenStorageProvider),
    pinStorage: ref.read(pinStorageProvider),
  );
}

/// Fournit le repository boutique (cache secure storage + `/stores/me`).
@riverpod
StoreRepository storeRepository(Ref ref) {
  return StoreRepositoryImpl(
    remoteDataSource: ref.read(storesRemoteDataSourceProvider),
    imageCache: ref.read(imageFileCacheProvider),
  );
}

/// Fournit le repository du profil (nom du vendeur, cache + `/users/me`).
@riverpod
ProfileRepository profileRepository(Ref ref) {
  return ProfileRepositoryImpl(
    remoteDataSource: ref.read(authRemoteDataSourceProvider),
  );
}
