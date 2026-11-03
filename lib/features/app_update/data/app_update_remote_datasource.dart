import 'package:dio/dio.dart';

import '../../../core/config.dart';

/// Lit le build minimal exigé dans la réponse de `GET /health`.
///
/// C'est aussi la première requête de l'app : sur Render (offre gratuite),
/// le serveur s'endort après 15 min sans trafic et met près d'une minute à
/// redémarrer. Lancée au démarrage, elle le réveille pendant la saisie du
/// numéro et du mot de passe. Dio nu (sans intercepteurs) : `/health` est
/// public.
class AppUpdateRemoteDataSource {
  /// Crée la source distante.
  AppUpdateRemoteDataSource({Dio? dio}) : _dio = dio;

  final Dio? _dio;

  /// Build minimal exigé, ou null (hors ligne, serveur indisponible, champ
  /// absent ou invalide).
  Future<int?> fetchMinBuild() async {
    final dio =
        _dio ??
        Dio(
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
      final response = await dio.get<Map<String, dynamic>>('/health');
      final value = response.data?['min_app_build'];
      return value is int && value >= 0 ? value : null;
    } on DioException catch (_) {
      return null;
    } finally {
      if (_dio == null) dio.close();
    }
  }
}
