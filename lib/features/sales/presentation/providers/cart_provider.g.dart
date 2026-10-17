// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// CartNotifier gère l'état du panier.
///
/// `keepAlive` : le panier survit au verrouillage de session (la caisse quitte
/// l'arbre pendant la saisie du PIN). Vidé au changement de compte par
/// `Auth._resetStoreCache`.

@ProviderFor(Cart)
final cartProvider = CartProvider._();

/// CartNotifier gère l'état du panier.
///
/// `keepAlive` : le panier survit au verrouillage de session (la caisse quitte
/// l'arbre pendant la saisie du PIN). Vidé au changement de compte par
/// `Auth._resetStoreCache`.
final class CartProvider extends $NotifierProvider<Cart, CartState> {
  /// CartNotifier gère l'état du panier.
  ///
  /// `keepAlive` : le panier survit au verrouillage de session (la caisse quitte
  /// l'arbre pendant la saisie du PIN). Vidé au changement de compte par
  /// `Auth._resetStoreCache`.
  CartProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cartProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cartHash();

  @$internal
  @override
  Cart create() => Cart();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CartState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CartState>(value),
    );
  }
}

String _$cartHash() => r'9e5c9eb1b84e0a01ada54a6fa6c5e76ed7834161';

/// CartNotifier gère l'état du panier.
///
/// `keepAlive` : le panier survit au verrouillage de session (la caisse quitte
/// l'arbre pendant la saisie du PIN). Vidé au changement de compte par
/// `Auth._resetStoreCache`.

abstract class _$Cart extends $Notifier<CartState> {
  CartState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<CartState, CartState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<CartState, CartState>,
              CartState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
