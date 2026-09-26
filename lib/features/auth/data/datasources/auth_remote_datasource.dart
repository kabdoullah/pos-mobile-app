import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/auth_models.dart';

part 'auth_remote_datasource.g.dart';

/// Data source distante pour l'authentification via l'API HTTP.
@RestApi()
abstract class AuthRemoteDataSource {
  /// Crée une instance AuthRemoteDataSource.
  factory AuthRemoteDataSource(Dio dio, {String baseUrl}) =
      _AuthRemoteDataSource;

  /// Crée un compte utilisateur.
  /// Endpoint : POST /api/v1/auth/register
  @POST('/api/v1/auth/register')
  Future<RegisterResponseDto> register(@Body() RegisterRequestDto request);

  /// Connexion par téléphone et mot de passe.
  /// Endpoint : POST /api/v1/auth/login
  @POST('/api/v1/auth/login')
  Future<TokenResponseDto> login(@Body() LoginRequestDto request);

  /// Demande un email de réinitialisation du mot de passe.
  /// Endpoint : POST /api/v1/auth/forgot-password
  @POST('/api/v1/auth/forgot-password')
  Future<void> forgotPassword(@Body() ForgotPasswordRequestDto request);

  /// Confirme la réinitialisation du mot de passe.
  /// Endpoint : POST /api/v1/auth/reset-password
  @POST('/api/v1/auth/reset-password')
  Future<void> resetPassword(@Body() ResetPasswordRequestDto request);

  /// Rafraîchit l'access token à l'aide du refresh token.
  /// Endpoint : POST /api/v1/auth/refresh
  @POST('/api/v1/auth/refresh')
  Future<TokenResponseDto> refresh(@Body() RefreshRequestDto request);
}
