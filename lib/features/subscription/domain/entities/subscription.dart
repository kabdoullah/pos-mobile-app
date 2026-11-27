import 'package:decimal/decimal.dart';

/// Formule d'abonnement (ADR-0017). La grille (prix, fonctionnalités) vient
/// du serveur : l'app n'en garde aucune copie.
enum PlanId {
  /// Gratuite.
  discovery('Découverte'),

  /// Formule intermédiaire.
  starter('Starter'),

  /// Formule complète.
  business('Business');

  const PlanId(this.label);

  /// Nom affiché.
  final String label;

  /// Formule correspondant à la clé API, Découverte si inconnue.
  static PlanId fromKey(String? key) =>
      values.firstWhere((p) => p.name == key, orElse: () => discovery);
}

/// Fonctionnalité soumise à une formule. Les clés sont celles de l'API.
enum PlanFeature {
  /// Historique au-delà des 30 derniers jours.
  unlimitedHistory('unlimited_history', 'Historique complet des ventes'),

  /// Gestion des dépenses.
  expenses('expenses', 'Gestion des dépenses'),

  /// Retours clients.
  returns('returns', 'Retours clients'),

  /// Entrées et sorties d'espèces, historique des sessions.
  cashMovements('cash_movements', 'Entrées, sorties et historique de caisse'),

  /// Billetterie et écarts de caisse.
  cashCount('cash_count', 'Comptage par billets et pièces'),

  /// Rapports de ventes.
  salesReports('sales_reports', 'Rapports de ventes'),

  /// Gestion des employés.
  employees('employees', 'Gestion des employés'),

  /// Rôles et permissions.
  roles('roles', 'Rôles et permissions'),

  /// Suivi des activités par employé.
  employeeActivity('employee_activity', 'Suivi des activités par employé'),

  /// Rapports avancés.
  advancedReports('advanced_reports', 'Rapports avancés'),

  /// Assistance prioritaire.
  prioritySupport('priority_support', 'Assistance prioritaire');

  const PlanFeature(this.key, this.label);

  /// Clé API.
  final String key;

  /// Nom affiché.
  final String label;

  /// Fonctionnalité de clé [key], ou null si l'app ne la connaît pas encore.
  static PlanFeature? fromKey(String key) {
    for (final f in values) {
      if (f.key == key) return f;
    }
    return null;
  }
}

/// Statut d'abonnement affiché au commerçant.
enum SubscriptionStatus {
  /// Formule gratuite, aucune demande.
  free,

  /// Paiement envoyé, en attente de vérification.
  pending,

  /// Abonnement en cours.
  active,

  /// Dernière demande rejetée.
  rejected,

  /// Abonnement terminé, retour à Découverte.
  expired;

  /// Statut de clé API, `free` si inconnu.
  static SubscriptionStatus fromKey(String? key) =>
      values.firstWhere((s) => s.name == key, orElse: () => free);
}

/// Statut d'une demande de paiement.
enum PaymentRequestStatus {
  /// En attente de vérification.
  pending,

  /// Validée : formule activée.
  approved,

  /// Rejetée, avec un motif.
  rejected;

  /// Statut de clé API.
  static PaymentRequestStatus fromKey(String key) =>
      values.firstWhere((s) => s.name == key, orElse: () => pending);
}

/// Formule proposée.
class PlanOffer {
  /// Crée une formule.
  const PlanOffer({
    required this.plan,
    required this.name,
    required this.price,
    required this.durationMonths,
    required this.features,
    required this.highlights,
  });

  /// Identifiant.
  final PlanId plan;

  /// Nom affiché.
  final String name;

  /// Prix d'une période, en FCFA.
  final Decimal price;

  /// Durée d'une période payée, en mois.
  final int durationMonths;

  /// Fonctionnalités incluses.
  final Set<PlanFeature> features;

  /// Points forts affichés, dans l'ordre.
  final List<String> highlights;
}

/// Où envoyer le paiement Wave.
class PaymentInstructions {
  /// Crée les instructions.
  const PaymentInstructions({
    required this.available,
    this.receiverPhone,
    this.receiverName,
  });

  /// Faux tant que l'éditeur n'a pas réglé le numéro de réception.
  final bool available;

  /// Numéro Wave de réception (E.164).
  final String? receiverPhone;

  /// Nom du bénéficiaire.
  final String? receiverName;
}

/// Catalogue des formules et instructions de paiement.
class SubscriptionCatalog {
  /// Crée le catalogue.
  const SubscriptionCatalog({
    required this.plans,
    required this.payment,
    required this.freeHistoryDays,
  });

  /// Formules, de la moins chère à la plus chère.
  final List<PlanOffer> plans;

  /// Instructions Wave.
  final PaymentInstructions payment;

  /// Profondeur d'historique de la formule gratuite.
  final int freeHistoryDays;

  /// Formule la moins chère qui inclut [feature].
  PlanOffer? cheapestWith(PlanFeature feature) {
    for (final offer in plans) {
      if (offer.features.contains(feature)) return offer;
    }
    return null;
  }

  /// Formule [plan], si proposée.
  PlanOffer? offer(PlanId plan) {
    for (final offer in plans) {
      if (offer.plan == plan) return offer;
    }
    return null;
  }
}

/// Demande de validation d'un paiement Wave.
class PaymentRequest {
  /// Crée une demande.
  const PaymentRequest({
    required this.id,
    required this.plan,
    required this.amount,
    required this.senderPhone,
    required this.paidOn,
    required this.status,
    required this.createdAt,
    this.waveReference,
    this.rejectionReason,
  });

  /// Identifiant.
  final String id;

  /// Formule demandée.
  final PlanId plan;

  /// Montant payé en FCFA.
  final Decimal amount;

  /// Numéro Wave de l'expéditeur.
  final String senderPhone;

  /// Référence de la transaction Wave.
  final String? waveReference;

  /// Date du paiement.
  final DateTime paidOn;

  /// Statut.
  final PaymentRequestStatus status;

  /// Motif du rejet.
  final String? rejectionReason;

  /// Date d'envoi de la demande.
  final DateTime createdAt;
}

/// Abonnement de la boutique tel que connu du serveur.
class MySubscription {
  /// Crée l'état d'abonnement.
  const MySubscription({
    required this.plan,
    required this.status,
    required this.features,
    this.startsAt,
    this.expiresAt,
    this.paidUntil,
    this.historyDays,
    this.latestRequest,
  });

  /// Formule gratuite, sans demande : état par défaut avant toute réponse.
  static const free = MySubscription(
    plan: PlanId.discovery,
    status: SubscriptionStatus.free,
    features: {},
    historyDays: 30,
  );

  /// Formule en vigueur.
  final PlanId plan;

  /// Statut affiché.
  final SubscriptionStatus status;

  /// Fonctionnalités incluses.
  final Set<PlanFeature> features;

  /// Début de la période en cours.
  final DateTime? startsAt;

  /// Fin de la période en cours.
  final DateTime? expiresAt;

  /// Fin de la dernière période payée (renouvellement anticipé inclus).
  final DateTime? paidUntil;

  /// Profondeur d'historique, null si illimitée.
  final int? historyDays;

  /// Dernière demande de paiement.
  final PaymentRequest? latestRequest;

  /// Vrai si une demande attend une vérification.
  bool get hasPendingRequest =>
      latestRequest?.status == PaymentRequestStatus.pending;
}
