import 'dart:async';

import 'package:clock/clock.dart';
import 'package:flutter/widgets.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/network/api_exception.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../domain/entities/entitlements.dart';
import '../../domain/entities/subscription.dart';
import '../../domain/repositories/subscription_repository.dart';
import '../../providers/subscription_di_providers.dart';

part 'subscription_providers.g.dart';

/// Abonnement de la boutique : le dernier état mémorisé tout de suite (hors
/// connexion compris), puis celui du serveur.
///
/// Rafraîchi au lancement, à chaque connexion, au retour au premier plan et
/// après l'envoi d'une demande. Une erreur réseau garde l'état connu.
@Riverpod(keepAlive: true)
class CurrentSubscription extends _$CurrentSubscription
    with WidgetsBindingObserver {
  static final _logger = Logger();

  @override
  Future<MySubscription> build() async {
    // Le cache est effacé et ce provider invalidé au changement de compte
    // (`Auth._resetStoreCache`) ; l'appel serveur exige d'être connecté.
    ref.listen(authProvider, (previous, next) {
      final wasIn = previous?.value is AuthAuthenticated;
      if (!wasIn && next.value is AuthAuthenticated) unawaited(refresh());
    });
    WidgetsBinding.instance.addObserver(this);
    ref.onDispose(() => WidgetsBinding.instance.removeObserver(this));

    final cached = await ref
        .read(subscriptionRepositoryProvider)
        .cachedSubscription();
    unawaited(Future.microtask(refresh));
    return cached ?? MySubscription.free;
  }

  bool get _authenticated => ref.read(authProvider).value is AuthAuthenticated;

  /// Relit l'abonnement sur le serveur ; garde l'état connu en cas d'échec.
  Future<void> refresh() async {
    if (!ref.mounted || !_authenticated) return;
    try {
      final fresh = await ref
          .read(subscriptionRepositoryProvider)
          .fetchSubscription();
      if (ref.mounted) state = AsyncData(fresh);
    } on NetworkException {
      // Hors ligne ou serveur endormi : les droits mémorisés restent valables.
    } catch (e, stackTrace) {
      // Rafraîchissement en arrière-plan : jamais d'erreur non gérée, l'état
      // connu reste affiché.
      _logger.w(
        '[CurrentSubscription] refresh failed',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) unawaited(refresh());
  }
}

/// Droits effectifs : seule source que l'interface consulte pour savoir si
/// une fonctionnalité est accessible (ADR-0017).
@Riverpod(keepAlive: true)
Entitlements entitlements(Ref ref) {
  final subscription =
      ref.watch(currentSubscriptionProvider).value ?? MySubscription.free;
  return Entitlements.of(subscription, clock.now());
}

/// Formules et instructions Wave : serveur d'abord, sinon dernier catalogue
/// mémorisé (consultation hors connexion).
@riverpod
Future<SubscriptionCatalog> subscriptionCatalog(Ref ref) async {
  final repository = ref.watch(subscriptionRepositoryProvider);
  try {
    return await repository.fetchCatalog();
  } on NetworkException {
    final cached = await repository.cachedCatalog();
    if (cached != null) return cached;
    rethrow;
  }
}

/// Envoi d'une demande de validation de paiement.
///
/// `keepAlive` : l'envoi survit à la fermeture de l'écran pendant l'appel
/// (sinon le provider serait détruit après la réponse du serveur et le
/// commerçant renverrait une demande déjà enregistrée).
@Riverpod(keepAlive: true)
class PaymentRequestSubmission extends _$PaymentRequestSubmission {
  @override
  AsyncValue<PaymentRequest?> build() => const AsyncData(null);

  /// Envoie [draft] ; vrai si la demande est enregistrée.
  Future<bool> submit(PaymentRequestDraft draft) async {
    if (state.isLoading) return false;
    state = const AsyncLoading();
    final result = await AsyncValue.guard(
      () =>
          ref.read(subscriptionRepositoryProvider).submitPaymentRequest(draft),
    );
    state = result;
    if (result.hasError) return false;
    await ref.read(currentSubscriptionProvider.notifier).refresh();
    return true;
  }

  /// Revient à l'état initial (nouvel écran de paiement).
  void reset() => state = const AsyncData(null);
}

/// Message en français pour une erreur d'abonnement.
String subscriptionErrorMessage(Object error) {
  if (error is ConnectionException) return error.message;
  if (error is ApiException) {
    return switch ((error.code, error.field)) {
      ('SUBSCRIPTIONS_UNAVAILABLE', _) =>
        'Le paiement par Wave n’est pas encore ouvert. Réessayez plus tard.',
      ('PAYMENT_REQUEST_PENDING', _) =>
        'Une demande est déjà en cours de vérification.',
      ('WAVE_REFERENCE_ALREADY_USED', _) =>
        'Cette référence Wave a déjà été envoyée. Vérifiez-la.',
      ('VALIDATION_ERROR', 'amount_fcfa') =>
        'Le prix a changé. Revenez à la liste des formules.',
      ('VALIDATION_ERROR', 'paid_on') =>
        'Date de paiement invalide (pas dans le futur, 31 jours au plus).',
      ('VALIDATION_ERROR', 'sender_phone') =>
        'Numéro Wave invalide : 10 chiffres, commençant par 01, 05 ou 07.',
      ('VALIDATION_ERROR', 'file') || ('PAYLOAD_TOO_LARGE', _) =>
        'Capture illisible ou trop lourde. Choisissez une autre image.',
      _ => 'Une erreur est survenue. Réessayez.',
    };
  }
  return 'Une erreur est survenue. Réessayez.';
}
