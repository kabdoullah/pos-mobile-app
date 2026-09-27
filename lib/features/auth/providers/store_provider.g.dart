// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Configuration boutique du compte connecté (utilisée partout : accueil,
/// paramètres, écran PIN, reçus).
///
/// keepAlive : la config boutique doit survivre d'un écran à l'autre. Sans
/// cela, le provider est libéré pendant la configuration de la boutique (aucun
/// widget ne l'y écoute) et `save()` lève une exception en modifiant l'état
/// d'un notifier libéré. Invalidé par [Auth] à chaque changement de compte.

@ProviderFor(StoreConfig)
final storeConfigProvider = StoreConfigProvider._();

/// Configuration boutique du compte connecté (utilisée partout : accueil,
/// paramètres, écran PIN, reçus).
///
/// keepAlive : la config boutique doit survivre d'un écran à l'autre. Sans
/// cela, le provider est libéré pendant la configuration de la boutique (aucun
/// widget ne l'y écoute) et `save()` lève une exception en modifiant l'état
/// d'un notifier libéré. Invalidé par [Auth] à chaque changement de compte.
final class StoreConfigProvider
    extends $AsyncNotifierProvider<StoreConfig, Store?> {
  /// Configuration boutique du compte connecté (utilisée partout : accueil,
  /// paramètres, écran PIN, reçus).
  ///
  /// keepAlive : la config boutique doit survivre d'un écran à l'autre. Sans
  /// cela, le provider est libéré pendant la configuration de la boutique (aucun
  /// widget ne l'y écoute) et `save()` lève une exception en modifiant l'état
  /// d'un notifier libéré. Invalidé par [Auth] à chaque changement de compte.
  StoreConfigProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'storeConfigProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$storeConfigHash();

  @$internal
  @override
  StoreConfig create() => StoreConfig();
}

String _$storeConfigHash() => r'901e51c4b1d53f010245f114f525b0f1850df3dd';

/// Configuration boutique du compte connecté (utilisée partout : accueil,
/// paramètres, écran PIN, reçus).
///
/// keepAlive : la config boutique doit survivre d'un écran à l'autre. Sans
/// cela, le provider est libéré pendant la configuration de la boutique (aucun
/// widget ne l'y écoute) et `save()` lève une exception en modifiant l'état
/// d'un notifier libéré. Invalidé par [Auth] à chaque changement de compte.

abstract class _$StoreConfig extends $AsyncNotifier<Store?> {
  FutureOr<Store?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<Store?>, Store?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<Store?>, Store?>,
              AsyncValue<Store?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Octets du logo courant (cache disque, sinon serveur) — aperçu et impression.

@ProviderFor(storeLogoBytes)
final storeLogoBytesProvider = StoreLogoBytesProvider._();

/// Octets du logo courant (cache disque, sinon serveur) — aperçu et impression.

final class StoreLogoBytesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<int>?>,
          List<int>?,
          FutureOr<List<int>?>
        >
    with $FutureModifier<List<int>?>, $FutureProvider<List<int>?> {
  /// Octets du logo courant (cache disque, sinon serveur) — aperçu et impression.
  StoreLogoBytesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'storeLogoBytesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$storeLogoBytesHash();

  @$internal
  @override
  $FutureProviderElement<List<int>?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<int>?> create(Ref ref) {
    return storeLogoBytes(ref);
  }
}

String _$storeLogoBytesHash() => r'28fb5bd7571965d00e42e560460a0dbd5afba1fa';
