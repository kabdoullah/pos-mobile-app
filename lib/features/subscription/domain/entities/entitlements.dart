import 'subscription.dart';

/// Droits effectifs de la boutique : seule abstraction que l'interface
/// consulte pour savoir si une fonctionnalité est accessible (ADR-0017).
///
/// Calculés depuis le dernier abonnement connu, même hors connexion : une
/// période dont la fin est passée ne donne plus aucun droit, sans attendre
/// le serveur. Le serveur reste juge des opérations sensibles.
class Entitlements {
  /// Crée les droits de [subscription], évalués à [now].
  factory Entitlements.of(MySubscription subscription, DateTime now) {
    final expiresAt = subscription.expiresAt;
    // Hors ligne, une période payée à la suite (renouvellement anticipé)
    // prolonge les droits jusqu'à sa propre fin.
    final end = subscription.paidUntil ?? expiresAt;
    if (expiresAt != null && end != null && !now.isBefore(end)) return free;
    return Entitlements._(
      plan: subscription.plan,
      features: subscription.features,
      historyDays: subscription.historyDays,
    );
  }

  const Entitlements._({
    required this.plan,
    required this.features,
    required this.historyDays,
  });

  /// Droits de la formule gratuite.
  static const free = Entitlements._(
    plan: PlanId.discovery,
    features: {},
    historyDays: 30,
  );

  /// Formule en vigueur.
  final PlanId plan;

  /// Fonctionnalités accessibles.
  final Set<PlanFeature> features;

  /// Profondeur d'historique en jours, null si illimitée.
  final int? historyDays;

  /// Vrai si [feature] est accessible.
  bool can(PlanFeature feature) => features.contains(feature);

  /// Premier jour consultable de l'historique (début de journée locale), ou
  /// null si l'historique est illimité.
  DateTime? historyStart(DateTime now) {
    final days = historyDays;
    if (days == null) return null;
    final today = DateTime(now.year, now.month, now.day);
    return today.subtract(Duration(days: days - 1));
  }
}
