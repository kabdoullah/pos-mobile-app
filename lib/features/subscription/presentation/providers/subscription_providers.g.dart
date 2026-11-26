// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Abonnement de la boutique : le dernier état mémorisé tout de suite (hors
/// connexion compris), puis celui du serveur.
///
/// Rafraîchi au lancement, à chaque connexion, au retour au premier plan et
/// après l'envoi d'une demande. Une erreur réseau garde l'état connu.

@ProviderFor(CurrentSubscription)
final currentSubscriptionProvider = CurrentSubscriptionProvider._();

/// Abonnement de la boutique : le dernier état mémorisé tout de suite (hors
/// connexion compris), puis celui du serveur.
///
/// Rafraîchi au lancement, à chaque connexion, au retour au premier plan et
/// après l'envoi d'une demande. Une erreur réseau garde l'état connu.
final class CurrentSubscriptionProvider
    extends $AsyncNotifierProvider<CurrentSubscription, MySubscription> {
  /// Abonnement de la boutique : le dernier état mémorisé tout de suite (hors
  /// connexion compris), puis celui du serveur.
  ///
  /// Rafraîchi au lancement, à chaque connexion, au retour au premier plan et
  /// après l'envoi d'une demande. Une erreur réseau garde l'état connu.
  CurrentSubscriptionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentSubscriptionProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentSubscriptionHash();

  @$internal
  @override
  CurrentSubscription create() => CurrentSubscription();
}

String _$currentSubscriptionHash() =>
    r'7d9b281ca5524e3d1e5a2483967c07acc186edad';

/// Abonnement de la boutique : le dernier état mémorisé tout de suite (hors
/// connexion compris), puis celui du serveur.
///
/// Rafraîchi au lancement, à chaque connexion, au retour au premier plan et
/// après l'envoi d'une demande. Une erreur réseau garde l'état connu.

abstract class _$CurrentSubscription extends $AsyncNotifier<MySubscription> {
  FutureOr<MySubscription> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<MySubscription>, MySubscription>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<MySubscription>, MySubscription>,
              AsyncValue<MySubscription>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Droits effectifs : seule source que l'interface consulte pour savoir si
/// une fonctionnalité est accessible (ADR-0017).

@ProviderFor(entitlements)
final entitlementsProvider = EntitlementsProvider._();

/// Droits effectifs : seule source que l'interface consulte pour savoir si
/// une fonctionnalité est accessible (ADR-0017).

final class EntitlementsProvider
    extends $FunctionalProvider<Entitlements, Entitlements, Entitlements>
    with $Provider<Entitlements> {
  /// Droits effectifs : seule source que l'interface consulte pour savoir si
  /// une fonctionnalité est accessible (ADR-0017).
  EntitlementsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'entitlementsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$entitlementsHash();

  @$internal
  @override
  $ProviderElement<Entitlements> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Entitlements create(Ref ref) {
    return entitlements(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Entitlements value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Entitlements>(value),
    );
  }
}

String _$entitlementsHash() => r'6958a43fdbb6b2784956c894b8a0e73f56371707';

/// Formules et instructions Wave : serveur d'abord, sinon dernier catalogue
/// mémorisé (consultation hors connexion).

@ProviderFor(subscriptionCatalog)
final subscriptionCatalogProvider = SubscriptionCatalogProvider._();

/// Formules et instructions Wave : serveur d'abord, sinon dernier catalogue
/// mémorisé (consultation hors connexion).

final class SubscriptionCatalogProvider
    extends
        $FunctionalProvider<
          AsyncValue<SubscriptionCatalog>,
          SubscriptionCatalog,
          FutureOr<SubscriptionCatalog>
        >
    with
        $FutureModifier<SubscriptionCatalog>,
        $FutureProvider<SubscriptionCatalog> {
  /// Formules et instructions Wave : serveur d'abord, sinon dernier catalogue
  /// mémorisé (consultation hors connexion).
  SubscriptionCatalogProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'subscriptionCatalogProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$subscriptionCatalogHash();

  @$internal
  @override
  $FutureProviderElement<SubscriptionCatalog> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<SubscriptionCatalog> create(Ref ref) {
    return subscriptionCatalog(ref);
  }
}

String _$subscriptionCatalogHash() =>
    r'2ff59ee34eb77035e6252f47c2704ff167799535';

/// Envoi d'une demande de validation de paiement.
///
/// `keepAlive` : l'envoi survit à la fermeture de l'écran pendant l'appel
/// (sinon le provider serait détruit après la réponse du serveur et le
/// commerçant renverrait une demande déjà enregistrée).

@ProviderFor(PaymentRequestSubmission)
final paymentRequestSubmissionProvider = PaymentRequestSubmissionProvider._();

/// Envoi d'une demande de validation de paiement.
///
/// `keepAlive` : l'envoi survit à la fermeture de l'écran pendant l'appel
/// (sinon le provider serait détruit après la réponse du serveur et le
/// commerçant renverrait une demande déjà enregistrée).
final class PaymentRequestSubmissionProvider
    extends
        $NotifierProvider<
          PaymentRequestSubmission,
          AsyncValue<PaymentRequest?>
        > {
  /// Envoi d'une demande de validation de paiement.
  ///
  /// `keepAlive` : l'envoi survit à la fermeture de l'écran pendant l'appel
  /// (sinon le provider serait détruit après la réponse du serveur et le
  /// commerçant renverrait une demande déjà enregistrée).
  PaymentRequestSubmissionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'paymentRequestSubmissionProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$paymentRequestSubmissionHash();

  @$internal
  @override
  PaymentRequestSubmission create() => PaymentRequestSubmission();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<PaymentRequest?> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<PaymentRequest?>>(value),
    );
  }
}

String _$paymentRequestSubmissionHash() =>
    r'4536c1ad2169846cdc4af400406bd88227886aa5';

/// Envoi d'une demande de validation de paiement.
///
/// `keepAlive` : l'envoi survit à la fermeture de l'écran pendant l'appel
/// (sinon le provider serait détruit après la réponse du serveur et le
/// commerçant renverrait une demande déjà enregistrée).

abstract class _$PaymentRequestSubmission
    extends $Notifier<AsyncValue<PaymentRequest?>> {
  AsyncValue<PaymentRequest?> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<PaymentRequest?>, AsyncValue<PaymentRequest?>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<PaymentRequest?>,
                AsyncValue<PaymentRequest?>
              >,
              AsyncValue<PaymentRequest?>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
