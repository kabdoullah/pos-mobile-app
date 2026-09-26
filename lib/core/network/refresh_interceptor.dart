import 'dart:async';

import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

import 'api_exception.dart';
import 'token_storage.dart';

/// Gère les réponses 401 en rafraîchissant le token puis en rejouant la
/// requête.
/// Empêche les rafraîchissements concurrents grâce à un verrou basé sur un
/// Completer.
class RefreshInterceptor extends Interceptor {
  /// Crée un RefreshInterceptor.
  RefreshInterceptor({
    required this.tokenStorage,
    required this.refreshCall,
    required this.onAuthExpired,
    required this.dio,
  });

  /// Gère la persistance sécurisée des tokens.
  final TokenStorage tokenStorage;

  /// Fonction appelant POST /api/v1/auth/refresh avec le refresh token.
  /// Retourne la nouvelle paire (accessToken, refreshToken).
  final Future<({String accessToken, String refreshToken})> Function(
    String refreshToken,
  )
  refreshCall;

  /// Appelée quand le rafraîchissement échoue (token expiré). Déclenche la
  /// redirection de déconnexion.
  final void Function() onAuthExpired;

  /// Instance Dio pour rejouer la requête d'origine après rafraîchissement du
  /// token.
  final Dio dio;

  static final _logger = Logger();

  /// Garantit une seule tentative de rafraîchissement à la fois.
  bool _isRefreshing = false;

  /// Completer pour ceux qui attendent la tentative de rafraîchissement en
  /// cours.
  Completer<bool>? _refreshCompleter;

  static const _publicPaths = {
    '/api/v1/auth/register',
    '/api/v1/auth/login',
    '/api/v1/auth/forgot-password',
    '/api/v1/auth/reset-password',
    '/health',
  };

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode != 401) {
      handler.next(err);
      return;
    }

    // Ne pas rafraîchir les tokens pour les endpoints publics.
    if (_isPublicPath(err.requestOptions.path)) {
      handler.next(err);
      return;
    }

    // Si un rafraîchissement est déjà en cours, attendre son résultat.
    if (_isRefreshing) {
      final success = await _refreshCompleter!.future;
      if (success) {
        handler.resolve(await dio.fetch(err.requestOptions));
      } else {
        handler.next(err);
      }
      return;
    }

    // Début du rafraîchissement.
    _isRefreshing = true;
    _refreshCompleter = Completer<bool>();

    try {
      final refreshToken = await tokenStorage.getRefreshToken();
      if (refreshToken == null) {
        throw UnauthorizedException(
          code: 'NO_REFRESH_TOKEN',
          detail: 'Session expirée. Veuillez vous reconnecter.',
        );
      }

      final result = await refreshCall(refreshToken);

      await tokenStorage.saveTokens(
        accessToken: result.accessToken,
        refreshToken: result.refreshToken,
      );

      _refreshCompleter!.complete(true);
      // Rejoue la requête d'origine avec le nouveau token.
      // La requête repasse par onRequest(), qui ajoute le nouveau token aux
      // en-têtes.
      handler.resolve(await dio.fetch(err.requestOptions));
    } catch (e) {
      _logger.e('Token refresh failed: $e');
      _refreshCompleter!.complete(false);
      onAuthExpired();

      handler.next(
        DioException(
          requestOptions: err.requestOptions,
          error: e,
          type: DioExceptionType.unknown,
        ),
      );
    } finally {
      _isRefreshing = false;
      _refreshCompleter = null;
    }
  }

  bool _isPublicPath(String path) => _publicPaths.contains(path);
}
