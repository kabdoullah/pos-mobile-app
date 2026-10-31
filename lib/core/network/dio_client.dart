import 'dart:developer' as developer;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../config.dart';
import 'api_exception.dart';
import 'auth_interceptor.dart';
import 'refresh_interceptor.dart';
import 'store_suspended_interceptor.dart';
import 'token_storage.dart';

/// Construit et configure une instance Dio avec auth JWT, rafraîchissement et
/// gestion des erreurs.
Dio buildDio({
  required TokenStorage tokenStorage,
  required void Function() onAuthExpired,
  required void Function(String? supportContact) onStoreSuspended,
}) {
  // Dio dédié aux appels de rafraîchissement (sans intercepteurs pour éviter
  // les boucles infinies).
  final refreshDio = Dio(
    BaseOptions(
      baseUrl: AppConfig.apiUrl,
      connectTimeout: const Duration(
        seconds: AppConfig.httpConnectTimeoutSeconds,
      ),
      receiveTimeout: const Duration(
        seconds: AppConfig.httpReceiveTimeoutSeconds,
      ),
      contentType: 'application/json',
      validateStatus: null,
    ),
  );

  // Appel de rafraîchissement : POST /api/v1/auth/refresh
  Future<({String accessToken, String refreshToken})> refreshCall(
    String refreshToken,
  ) async {
    final response = await refreshDio.post<Map<String, dynamic>>(
      '/api/v1/auth/refresh',
      data: {'refresh_token': refreshToken},
    );

    if (response.statusCode != 200) {
      throw parseException(
        DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
        ),
      );
    }

    final data = response.data;
    if (data == null) {
      throw ApiException(
        statusCode: 500,
        code: 'INVALID_REFRESH_RESPONSE',
        detail: 'Réponse serveur invalide.',
      );
    }

    return (
      accessToken: data['access_token'] as String,
      refreshToken: data['refresh_token'] as String,
    );
  }

  // Instance Dio principale.
  final dio = Dio(
    BaseOptions(
      baseUrl: AppConfig.apiUrl,
      connectTimeout: const Duration(
        seconds: AppConfig.httpConnectTimeoutSeconds,
      ),
      receiveTimeout: const Duration(
        seconds: AppConfig.httpReceiveTimeoutSeconds,
      ),
      contentType: 'application/json',
      validateStatus: (status) =>
          status != null && status >= 200 && status < 300,
    ),
  );

  // Ajout des intercepteurs.
  dio.interceptors.add(AuthInterceptor(tokenStorage: tokenStorage));
  dio.interceptors.add(
    RefreshInterceptor(
      tokenStorage: tokenStorage,
      refreshCall: refreshCall,
      onAuthExpired: onAuthExpired,
      dio: dio,
    ),
  );
  // Après le rafraîchissement : voit aussi un refus de refresh pour
  // suspension, que RefreshInterceptor enveloppe sans expirer la session.
  dio.interceptors.add(
    StoreSuspendedInterceptor(onStoreSuspended: onStoreSuspended),
  );

  // Logs de débogage en dev.
  if (kDebugMode) {
    dio.interceptors.add(
      LogInterceptor(
        requestBody: false,
        responseBody: true,
        responseHeader: false,
        logPrint: (obj) {
          developer.log(obj.toString(), name: 'Dio');
        },
      ),
    );
  }

  return dio;
}

/// Réveille le serveur dès le lancement, sans attendre le résultat.
///
/// Sur Render (offre gratuite), le serveur s'endort après 15 min sans trafic
/// et met près d'une minute à redémarrer. Lancé au démarrage de l'app, ce
/// ping fait coïncider ce délai avec la saisie du numéro et du mot de passe :
/// la connexion trouve un serveur déjà réveillé. Échec ignoré (hors ligne,
/// serveur indisponible) : les vraies requêtes gèrent leurs erreurs.
Future<void> wakeUpServer() async {
  final dio = Dio(
    BaseOptions(
      baseUrl: AppConfig.apiUrl,
      connectTimeout: const Duration(
        seconds: AppConfig.httpConnectTimeoutSeconds,
      ),
      receiveTimeout: const Duration(
        seconds: AppConfig.httpReceiveTimeoutSeconds,
      ),
    ),
  );
  try {
    await dio.get<void>('/health');
  } on DioException catch (_) {
    // Ignoré volontairement, voir la doc ci-dessus.
  } finally {
    dio.close();
  }
}
