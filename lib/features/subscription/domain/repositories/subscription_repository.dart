import '../entities/subscription.dart';

/// Données d'une demande de validation de paiement saisies par le commerçant.
class PaymentRequestDraft {
  /// Crée une demande à envoyer.
  const PaymentRequestDraft({
    required this.plan,
    required this.amountFcfa,
    required this.senderPhone,
    required this.paidOn,
    this.waveReference,
    this.proofPath,
  });

  /// Formule payée.
  final PlanId plan;

  /// Montant payé, en FCFA entiers (vérifié par le serveur).
  final int amountFcfa;

  /// Numéro Wave de l'expéditeur (E.164).
  final String senderPhone;

  /// Date du paiement.
  final DateTime paidOn;

  /// Référence de la transaction Wave.
  final String? waveReference;

  /// Chemin local de la capture du justificatif.
  final String? proofPath;
}

/// Abonnements : lecture de l'état et envoi des demandes (ADR-0017).
///
/// Le dernier état et le dernier catalogue reçus sont gardés sur l'appareil
/// pour que les droits restent connus hors connexion.
abstract interface class SubscriptionRepository {
  /// État d'abonnement mémorisé, ou null.
  Future<MySubscription?> cachedSubscription();

  /// État d'abonnement du serveur (mémorisé au passage).
  Future<MySubscription> fetchSubscription();

  /// Catalogue mémorisé, ou null.
  Future<SubscriptionCatalog?> cachedCatalog();

  /// Catalogue du serveur (mémorisé au passage).
  Future<SubscriptionCatalog> fetchCatalog();

  /// Envoie une demande de validation de paiement (en ligne uniquement).
  Future<PaymentRequest> submitPaymentRequest(PaymentRequestDraft draft);

  /// Oublie l'état et le catalogue mémorisés (changement de compte).
  Future<void> clearLocal();
}
