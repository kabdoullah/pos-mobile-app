import 'package:flutter_riverpod/misc.dart';
import 'package:mobile/features/subscription/domain/entities/entitlements.dart';
import 'package:mobile/features/subscription/domain/entities/subscription.dart';
import 'package:mobile/features/subscription/presentation/providers/subscription_providers.dart';

/// Toutes les fonctionnalités payantes ouvertes (formule Business sans
/// échéance) : pour les tests d'écrans antérieurs aux abonnements (ADR-0017).
final Override allFeaturesOverride = entitlementsProvider.overrideWithValue(
  Entitlements.of(
    const MySubscription(
      plan: PlanId.business,
      status: SubscriptionStatus.active,
      features: {...PlanFeature.values},
    ),
    DateTime(2026),
  ),
);
