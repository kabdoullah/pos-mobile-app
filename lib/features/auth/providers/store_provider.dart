import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/entities/store.dart';
import 'auth_di_providers.dart';

part 'store_provider.g.dart';

/// Configuration boutique du compte connecté (utilisée partout : accueil,
/// paramètres, écran PIN, reçus).
///
/// keepAlive : la config boutique doit survivre d'un écran à l'autre. Sans
/// cela, le provider est libéré pendant la configuration de la boutique (aucun
/// widget ne l'y écoute) et `save()` lève une exception en modifiant l'état
/// d'un notifier libéré. Invalidé par [Auth] à chaque changement de compte.
@Riverpod(keepAlive: true)
class StoreConfig extends _$StoreConfig {
  @override
  Future<Store?> build() => ref.read(storeRepositoryProvider).getStore();

  /// Persist store configuration locally then sync to backend.
  ///
  /// Si le PATCH backend échoue, l'exception remonte pour que l'UI l'affiche
  /// (le nom de la boutique compte pour l'utilisateur et doit atteindre le
  /// serveur). L'état n'est mis à jour qu'une fois les deux réussis.
  Future<void> save(Store store) async {
    await ref.read(storeRepositoryProvider).saveStore(store);
    state = AsyncData(store);
  }
}
