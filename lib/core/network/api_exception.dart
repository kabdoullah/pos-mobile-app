import 'package:dio/dio.dart';

/// Exception de base pour toutes les erreurs réseau.
sealed class NetworkException implements Exception {
  /// Crée une NetworkException avec un message destiné à l'utilisateur.
  NetworkException(this.message);

  /// Message destiné à l'utilisateur, en français.
  final String message;
}

/// Pas de connexion, délai dépassé ou réseau injoignable.
/// Le message destiné à l'utilisateur est en français.
class ConnectionException extends NetworkException {
  /// Crée une ConnectionException.
  ConnectionException()
    : super('Pas de connexion. Vos données sont sauvegardées localement.');
}

/// L'API a renvoyé un 4xx ou 5xx avec un corps d'erreur structuré.
/// Fournit un code d'erreur lisible par la machine, un message utilisateur et
/// un champ optionnel.
class ApiException extends NetworkException {
  /// Crée une ApiException.
  ApiException({
    required this.statusCode,
    required this.code,
    required String detail,
    this.field,
  }) : super(detail);

  /// Code de statut HTTP (400–599).
  final int statusCode;

  /// Code d'erreur lisible par la machine (ex. 'INVALID_EMAIL').
  final String code;

  /// Nom du champ concerné en cas d'erreur de validation (optionnel).
  final String? field;
}

/// 401 Unauthorized — token invalide ou expiré, rafraîchissement échoué.
/// Étend ApiException pour conserver le statut HTTP et le code d'erreur.
class UnauthorizedException extends ApiException {
  /// Crée une UnauthorizedException.
  UnauthorizedException({
    required super.code,
    required super.detail,
    super.field,
  }) : super(statusCode: 401);
}

/// 409 Conflict — conflit de synchro ou violation de contrainte d'unicité.
/// Étend ApiException pour conserver le statut HTTP et le code d'erreur.
class ConflictException extends ApiException {
  /// Crée une ConflictException.
  ConflictException({required super.code, required super.detail, super.field})
    : super(statusCode: 409);
}

/// Convertit une DioException en NetworkException propre au projet.
NetworkException parseException(DioException e) {
  // Erreurs réseau (aucune réponse reçue).
  if (e.type == DioExceptionType.connectionTimeout ||
      e.type == DioExceptionType.receiveTimeout ||
      e.type == DioExceptionType.connectionError ||
      e.response == null) {
    return ConnectionException();
  }

  final statusCode = e.response!.statusCode ?? 500;
  final (code: code, detail: detail, field: field) = _parseBody(
    e.response!.data as Map<String, dynamic>?,
  );

  // Codes de statut spécifiques.
  if (statusCode == 401) {
    return UnauthorizedException(code: code, detail: detail, field: field);
  }
  if (statusCode == 409) {
    return ConflictException(code: code, detail: detail, field: field);
  }

  // 4xx/5xx génériques.
  return ApiException(
    statusCode: statusCode,
    code: code,
    detail: detail,
    field: field,
  );
}

({String code, String detail, String? field}) _parseBody(
  Map<String, dynamic>? data,
) {
  if (data == null) {
    return (code: 'UNKNOWN', detail: 'Erreur serveur.', field: null);
  }

  final code = (data['code'] as String?) ?? 'UNKNOWN';
  final detail = (data['detail'] as String?) ?? 'Erreur serveur.';
  final field = data['field'] as String?;

  return (code: code, detail: detail, field: field);
}
