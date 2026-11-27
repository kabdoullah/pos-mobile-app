import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/network/api_exception.dart';
import 'package:mobile/features/auth/domain/entities/user.dart';
import 'package:mobile/features/auth/presentation/providers/auth_providers.dart';
import 'package:mobile/features/subscription/data/subscription_repository_impl.dart';
import 'package:mobile/features/subscription/domain/entities/subscription.dart';
import 'package:mobile/features/subscription/domain/repositories/subscription_repository.dart';
import 'package:mobile/features/subscription/presentation/providers/subscription_providers.dart';
import 'package:mobile/features/subscription/providers/subscription_di_providers.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _MockDio extends Mock implements Dio {}

/// Préférences en mémoire.
class _MemoryPrefs extends Fake implements SharedPreferencesAsync {
  final values = <String, String>{};

  @override
  Future<String?> getString(String key) async => values[key];

  @override
  Future<void> setString(String key, String value) async => values[key] = value;

  @override
  Future<void> remove(String key) async => values.remove(key);
}

class _AuthenticatedAuth extends Auth {
  @override
  Future<AuthStatus> build() async =>
      const AuthAuthenticated(User(id: 'u1', phoneNumber: '+2250700000000'));
}

const _starterJson = <String, Object?>{
  'plan': 'starter',
  'status': 'active',
  'starts_at': '2026-11-20T00:00:00Z',
  'expires_at': '2099-12-20T00:00:00Z',
  'paid_until': '2099-12-20T00:00:00Z',
  'features': ['returns', 'cash_movements'],
  'history_days': null,
  'latest_request': null,
  'server_time': '2026-11-26T12:00:00Z',
};

Response<Map<String, Object?>> _ok(Map<String, Object?> data) =>
    Response(requestOptions: RequestOptions(), statusCode: 200, data: data);

DioException _offline() => DioException(
  requestOptions: RequestOptions(),
  type: DioExceptionType.connectionError,
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late _MockDio dio;
  late _MemoryPrefs prefs;
  late SubscriptionRepositoryImpl repository;

  setUpAll(() => registerFallbackValue(FormData()));

  setUp(() {
    dio = _MockDio();
    prefs = _MemoryPrefs();
    repository = SubscriptionRepositoryImpl(dio: () => dio, prefs: prefs);
  });

  void answerMe(Object Function() answer) {
    when(
      () => dio.get<Map<String, Object?>>('/api/v1/subscriptions/me'),
    ).thenAnswer((_) async {
      final value = answer();
      if (value is DioException) throw value;
      return value as Response<Map<String, Object?>>;
    });
  }

  group('SubscriptionRepositoryImpl', () {
    test('mémorise l’abonnement reçu et le relit hors connexion', () async {
      answerMe(() => _ok(_starterJson));

      await repository.fetchSubscription();
      final cached = await repository.cachedSubscription();

      expect(cached?.plan, PlanId.starter);
      expect(cached?.features, contains(PlanFeature.returns));
    });

    test('sans réseau : ConnectionException', () async {
      answerMe(_offline);

      await expectLater(
        repository.fetchSubscription(),
        throwsA(isA<ConnectionException>()),
      );
    });

    test('changement de compte : le cache est effacé', () async {
      answerMe(() => _ok(_starterJson));
      await repository.fetchSubscription();

      await repository.clearLocal();

      expect(await repository.cachedSubscription(), isNull);
    });

    test('envoie la demande avec le montant entier et la date', () async {
      when(
        () => dio.post<Map<String, Object?>>(
          '/api/v1/subscriptions/requests',
          data: any(named: 'data'),
        ),
      ).thenAnswer(
        (_) async => _ok({
          'id': 'r1',
          'plan': 'starter',
          'amount_fcfa': 2000,
          'sender_phone': '+2250707070707',
          'wave_reference': 'T_1',
          'paid_on': '2026-11-26',
          'status': 'pending',
          'rejection_reason': null,
          'has_proof': false,
          'created_at': '2026-11-26T10:00:00Z',
          'reviewed_at': null,
        }),
      );

      final request = await repository.submitPaymentRequest(
        PaymentRequestDraft(
          plan: PlanId.starter,
          amountFcfa: 2000,
          senderPhone: '+2250707070707',
          paidOn: DateTime(2026, 11, 26),
          waveReference: 'T_1',
        ),
      );

      final form =
          verify(
                () => dio.post<Map<String, Object?>>(
                  '/api/v1/subscriptions/requests',
                  data: captureAny(named: 'data'),
                ),
              ).captured.single
              as FormData;
      expect(Map.fromEntries(form.fields), {
        'plan': 'starter',
        'amount_fcfa': '2000',
        'sender_phone': '+2250707070707',
        'paid_on': '2026-11-26',
        'wave_reference': 'T_1',
      });
      expect(request.status, PaymentRequestStatus.pending);
    });
  });

  group('CurrentSubscription', () {
    Future<ProviderContainer> start(SubscriptionRepository repo) async {
      final container = ProviderContainer(
        overrides: [
          authProvider.overrideWith(_AuthenticatedAuth.new),
          subscriptionRepositoryProvider.overrideWithValue(repo),
        ],
      );
      addTearDown(container.dispose);
      await container.read(authProvider.future);
      await container.read(currentSubscriptionProvider.future);
      await pumpEventQueue();
      return container;
    }

    test('hors connexion, garde les droits mémorisés', () async {
      answerMe(() => _ok(_starterJson));
      await repository.fetchSubscription();
      answerMe(_offline);

      final container = await start(repository);

      final rights = container.read(entitlementsProvider);
      expect(rights.can(PlanFeature.returns), isTrue);
    });

    test('sans cache ni réseau : formule gratuite', () async {
      answerMe(_offline);

      final container = await start(repository);

      final rights = container.read(entitlementsProvider);
      expect(rights.plan, PlanId.discovery);
      expect(rights.can(PlanFeature.returns), isFalse);
    });

    test('la réponse du serveur remplace l’état mémorisé', () async {
      answerMe(() => _ok(_starterJson));

      final container = await start(repository);

      expect(container.read(entitlementsProvider).plan, PlanId.starter);
    });
  });
}
