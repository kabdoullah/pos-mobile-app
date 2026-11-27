import 'package:decimal/decimal.dart';

import '../domain/entities/subscription.dart';

/// Objet JSON de l'API.
typedef Json = Map<String, Object?>;

DateTime? _date(Object? value) =>
    value is String ? DateTime.parse(value) : null;

Set<PlanFeature> _features(Object? value) => {
  ...(value as List<Object?>? ?? const [])
      .whereType<String>()
      .map(PlanFeature.fromKey)
      .whereType<PlanFeature>(),
};

/// Demande de paiement. Les montants arrivent en FCFA entiers.
PaymentRequest paymentRequestFromJson(Json json) => PaymentRequest(
  id: json['id']! as String,
  plan: PlanId.fromKey(json['plan'] as String?),
  amount: Decimal.fromInt(json['amount_fcfa']! as int),
  senderPhone: json['sender_phone']! as String,
  waveReference: json['wave_reference'] as String?,
  paidOn: DateTime.parse(json['paid_on']! as String),
  status: PaymentRequestStatus.fromKey(json['status']! as String),
  rejectionReason: json['rejection_reason'] as String?,
  createdAt: DateTime.parse(json['created_at']! as String),
);

/// État d'abonnement (`GET /subscriptions/me`).
MySubscription subscriptionFromJson(Json json) {
  final latest = json['latest_request'];
  return MySubscription(
    plan: PlanId.fromKey(json['plan'] as String?),
    status: SubscriptionStatus.fromKey(json['status'] as String?),
    features: _features(json['features']),
    startsAt: _date(json['starts_at']),
    expiresAt: _date(json['expires_at']),
    paidUntil: _date(json['paid_until']),
    historyDays: json['history_days'] as int?,
    latestRequest: latest is Map<String, Object?>
        ? paymentRequestFromJson(latest)
        : null,
  );
}

/// Catalogue (`GET /subscriptions/plans`).
SubscriptionCatalog catalogFromJson(Json json) {
  final payment = json['payment']! as Json;
  return SubscriptionCatalog(
    plans: [
      for (final raw in json['plans']! as List<Object?>)
        if (raw is Map<String, Object?>)
          PlanOffer(
            plan: PlanId.fromKey(raw['plan'] as String?),
            name: raw['name']! as String,
            price: Decimal.fromInt(raw['price_fcfa']! as int),
            durationMonths: raw['duration_months'] as int? ?? 1,
            features: _features(raw['features']),
            highlights: [
              ...(raw['highlights'] as List<Object?>? ?? const [])
                  .whereType<String>(),
            ],
          ),
    ],
    payment: PaymentInstructions(
      available: payment['available'] == true,
      receiverPhone: payment['wave_receiver_phone'] as String?,
      receiverName: payment['wave_receiver_name'] as String?,
    ),
    freeHistoryDays: json['free_history_days'] as int? ?? 30,
  );
}
