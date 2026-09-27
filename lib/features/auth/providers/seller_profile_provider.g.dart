// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'seller_profile_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Nom du vendeur imprimé « Vendeur : … » sur les reçus (ADR-0008).
///
/// keepAlive : lu à l'impression et modifié depuis une feuille qui ne
/// l'écoute pas (même raison que `StoreConfig`). Invalidé par `Auth` à chaque
/// changement de compte.

@ProviderFor(SellerProfile)
final sellerProfileProvider = SellerProfileProvider._();

/// Nom du vendeur imprimé « Vendeur : … » sur les reçus (ADR-0008).
///
/// keepAlive : lu à l'impression et modifié depuis une feuille qui ne
/// l'écoute pas (même raison que `StoreConfig`). Invalidé par `Auth` à chaque
/// changement de compte.
final class SellerProfileProvider
    extends $AsyncNotifierProvider<SellerProfile, String?> {
  /// Nom du vendeur imprimé « Vendeur : … » sur les reçus (ADR-0008).
  ///
  /// keepAlive : lu à l'impression et modifié depuis une feuille qui ne
  /// l'écoute pas (même raison que `StoreConfig`). Invalidé par `Auth` à chaque
  /// changement de compte.
  SellerProfileProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sellerProfileProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sellerProfileHash();

  @$internal
  @override
  SellerProfile create() => SellerProfile();
}

String _$sellerProfileHash() => r'cf7c3338c1fa922dc95d0b404c8e87f6e997254a';

/// Nom du vendeur imprimé « Vendeur : … » sur les reçus (ADR-0008).
///
/// keepAlive : lu à l'impression et modifié depuis une feuille qui ne
/// l'écoute pas (même raison que `StoreConfig`). Invalidé par `Auth` à chaque
/// changement de compte.

abstract class _$SellerProfile extends $AsyncNotifier<String?> {
  FutureOr<String?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<String?>, String?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<String?>, String?>,
              AsyncValue<String?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
