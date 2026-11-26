import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/subscription/data/subscription_mappers.dart';
import 'package:mobile/features/subscription/domain/entities/entitlements.dart';
import 'package:mobile/features/subscription/domain/entities/subscription.dart';

final _now = DateTime.utc(2026, 11, 26, 12);

MySubscription _starter({DateTime? expiresAt, DateTime? paidUntil}) =>
    MySubscription(
      plan: PlanId.starter,
      status: SubscriptionStatus.active,
      features: const {
        PlanFeature.returns,
        PlanFeature.cashMovements,
        PlanFeature.cashCount,
        PlanFeature.unlimitedHistory,
      },
      expiresAt: expiresAt ?? _now.add(const Duration(days: 10)),
      paidUntil: paidUntil,
    );

void main() {
  group('Entitlements', () {
    test('la formule gratuite limite l’historique et bloque le payant', () {
      final rights = Entitlements.of(MySubscription.free, _now);

      expect(rights.plan, PlanId.discovery);
      expect(rights.can(PlanFeature.returns), isFalse);
      expect(rights.can(PlanFeature.employees), isFalse);
      expect(rights.historyDays, 30);
    });

    test('Starter ouvre retours, caisse et historique, pas les employés', () {
      final rights = Entitlements.of(_starter(), _now);

      expect(rights.can(PlanFeature.returns), isTrue);
      expect(rights.can(PlanFeature.cashCount), isTrue);
      expect(rights.can(PlanFeature.employees), isFalse);
      expect(rights.historyStart(_now), isNull);
    });

    test('hors connexion, une période terminée ne donne plus de droits', () {
      final expired = _starter(
        expiresAt: _now.subtract(const Duration(minutes: 1)),
      );

      final rights = Entitlements.of(expired, _now);

      expect(rights.plan, PlanId.discovery);
      expect(rights.can(PlanFeature.returns), isFalse);
    });

    test('un renouvellement déjà payé prolonge les droits hors connexion', () {
      final renewed = _starter(
        expiresAt: _now.subtract(const Duration(days: 1)),
        paidUntil: _now.add(const Duration(days: 29)),
      );

      expect(Entitlements.of(renewed, _now).can(PlanFeature.returns), isTrue);
    });

    test('l’historique gratuit commence 29 jours avant aujourd’hui', () {
      final start = Entitlements.free.historyStart(DateTime(2026, 11, 30, 18));

      expect(start, DateTime(2026, 11, 1));
    });
  });

  group('mappers', () {
    test('lit /me, ignore les fonctionnalités inconnues', () {
      final subscription = subscriptionFromJson({
        'plan': 'business',
        'status': 'active',
        'starts_at': '2026-11-01T00:00:00Z',
        'expires_at': '2026-12-01T00:00:00Z',
        'paid_until': '2026-12-01T00:00:00Z',
        'features': ['employees', 'future_feature'],
        'history_days': null,
        'latest_request': {
          'id': 'r1',
          'plan': 'business',
          'amount_fcfa': 4000,
          'sender_phone': '+2250707070707',
          'wave_reference': 'T_1',
          'paid_on': '2026-11-01',
          'status': 'approved',
          'rejection_reason': null,
          'has_proof': false,
          'created_at': '2026-11-01T08:00:00Z',
          'reviewed_at': '2026-11-01T09:00:00Z',
        },
        'server_time': '2026-11-26T12:00:00Z',
      });

      expect(subscription.plan, PlanId.business);
      expect(subscription.features, {PlanFeature.employees});
      expect(subscription.historyDays, isNull);
      expect(subscription.latestRequest?.amount.toString(), '4000');
      expect(subscription.hasPendingRequest, isFalse);
    });

    test('lit /plans avec les instructions Wave', () {
      final catalog = catalogFromJson({
        'plans': [
          {
            'plan': 'discovery',
            'name': 'Découverte',
            'price_fcfa': 0,
            'duration_months': 1,
            'features': <String>[],
            'highlights': ['Ventes'],
          },
          {
            'plan': 'starter',
            'name': 'Starter',
            'price_fcfa': 2000,
            'duration_months': 1,
            'features': ['returns'],
            'highlights': ['Retours'],
          },
        ],
        'payment': {
          'available': true,
          'wave_receiver_phone': '+2250700000001',
          'wave_receiver_name': null,
        },
        'free_history_days': 30,
      });

      expect(catalog.cheapestWith(PlanFeature.returns)?.plan, PlanId.starter);
      expect(catalog.cheapestWith(PlanFeature.employees), isNull);
      expect(catalog.payment.receiverPhone, '+2250700000001');
      expect(catalog.offer(PlanId.starter)?.price.toString(), '2000');
    });
  });
}
