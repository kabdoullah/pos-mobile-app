import 'package:dio/dio.dart';

import 'token_storage.dart';

/// Injecte le token Bearer dans les en-têtes des requêtes vers les endpoints
/// authentifiés.
class AuthInterceptor extends Interceptor {
  /// Crée un AuthInterceptor.
  AuthInterceptor({required this.tokenStorage});

  /// Gère la récupération sécurisée du token.
  final TokenStorage tokenStorage;

  static const _publicPaths = {
    '/api/v1/auth/register',
    '/api/v1/auth/login',
    '/api/v1/auth/forgot-password',
    '/api/v1/auth/reset-password',
    '/health',
  }; // Routes qui ne nécessitent pas d'authentification

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (_isPublicPath(options.path)) {
      handler.next(options);
      return;
    }

    final token = await tokenStorage.getAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }

  bool _isPublicPath(String path) => _publicPaths.contains(path);
}
