// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkout_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Brouillon de paiement de l'écran de caisse.
///
/// Auto-dispose : l'écran de caisse le `watch` pendant toute sa durée de vie.

@ProviderFor(Checkout)
final checkoutProvider = CheckoutProvider._();

/// Brouillon de paiement de l'écran de caisse.
///
/// Auto-dispose : l'écran de caisse le `watch` pendant toute sa durée de vie.
final class CheckoutProvider
    extends $NotifierProvider<Checkout, CheckoutState> {
  /// Brouillon de paiement de l'écran de caisse.
  ///
  /// Auto-dispose : l'écran de caisse le `watch` pendant toute sa durée de vie.
  CheckoutProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'checkoutProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$checkoutHash();

  @$internal
  @override
  Checkout create() => Checkout();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CheckoutState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CheckoutState>(value),
    );
  }
}

String _$checkoutHash() => r'45297df590ccb47f6b68d337cc0b7d4932ad0af7';

/// Brouillon de paiement de l'écran de caisse.
///
/// Auto-dispose : l'écran de caisse le `watch` pendant toute sa durée de vie.

abstract class _$Checkout extends $Notifier<CheckoutState> {
  CheckoutState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<CheckoutState, CheckoutState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<CheckoutState, CheckoutState>,
              CheckoutState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
