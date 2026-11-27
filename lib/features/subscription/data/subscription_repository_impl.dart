import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/network/api_exception.dart';
import '../domain/entities/subscription.dart';
import '../domain/repositories/subscription_repository.dart';
import 'subscription_mappers.dart';

/// Implémentation de [SubscriptionRepository] (ADR-0017).
///
/// Les réponses brutes de `/me` et `/plans` sont gardées telles quelles dans
/// les préférences : propres au compte, elles sont effacées par
/// [clearLocal] au changement de compte (`Auth._resetStoreCache`).
class SubscriptionRepositoryImpl implements SubscriptionRepository {
  /// Crée le repository. [dio] n'est lu qu'au premier appel réseau : vider
  /// le cache (changement de compte) ne dépend pas de la pile réseau.
  SubscriptionRepositoryImpl({
    required Dio Function() dio,
    SharedPreferencesAsync? prefs,
  }) : _dioOf = dio,
       _prefs = prefs ?? SharedPreferencesAsync();

  final Dio Function() _dioOf;

  Dio get _dio => _dioOf();
  final SharedPreferencesAsync _prefs;

  static const _base = '/api/v1/subscriptions';
  static const _subscriptionKey = 'subscription_me';
  static const _catalogKey = 'subscription_plans';

  Future<Json?> _readJson(String key) async {
    final raw = await _prefs.getString(key);
    if (raw == null) return null;
    try {
      return jsonDecode(raw) as Json;
    } on FormatException {
      return null;
    }
  }

  Future<Json> _get(String path) async {
    try {
      final response = await _dio.get<Json>(path);
      return response.data!;
    } on DioException catch (e) {
      throw parseException(e);
    }
  }

  @override
  Future<MySubscription?> cachedSubscription() async {
    final json = await _readJson(_subscriptionKey);
    return json == null ? null : subscriptionFromJson(json);
  }

  @override
  Future<MySubscription> fetchSubscription() async {
    final json = await _get('$_base/me');
    final subscription = subscriptionFromJson(json);
    await _prefs.setString(_subscriptionKey, jsonEncode(json));
    return subscription;
  }

  @override
  Future<SubscriptionCatalog?> cachedCatalog() async {
    final json = await _readJson(_catalogKey);
    return json == null ? null : catalogFromJson(json);
  }

  @override
  Future<SubscriptionCatalog> fetchCatalog() async {
    final json = await _get('$_base/plans');
    final catalog = catalogFromJson(json);
    await _prefs.setString(_catalogKey, jsonEncode(json));
    return catalog;
  }

  @override
  Future<PaymentRequest> submitPaymentRequest(PaymentRequestDraft draft) async {
    final proofPath = draft.proofPath;
    final form = FormData.fromMap({
      'plan': draft.plan.name,
      'amount_fcfa': draft.amountFcfa.toString(),
      'sender_phone': draft.senderPhone,
      'paid_on': DateFormat('yyyy-MM-dd').format(draft.paidOn),
      if (draft.waveReference != null) 'wave_reference': draft.waveReference,
      if (proofPath != null)
        'proof': await MultipartFile.fromFile(proofPath, filename: 'proof'),
    });
    try {
      final response = await _dio.post<Json>('$_base/requests', data: form);
      return paymentRequestFromJson(response.data!);
    } on DioException catch (e) {
      throw parseException(e);
    }
  }

  @override
  Future<void> clearLocal() async {
    await _prefs.remove(_subscriptionKey);
    await _prefs.remove(_catalogKey);
  }
}
