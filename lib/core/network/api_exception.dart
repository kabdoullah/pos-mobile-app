import 'package:dio/dio.dart';

/// Exception de base pour toutes les erreurs réseau.
sealed class NetworkException implements Exception {
  /// Crée une NetworkException avec un message destiné à l'utilisateur.
  NetworkException(this.message);

  /// Message destiné à l'utilisateur, en français.
  final String message;
}

/// Aucune réponse du serveur : réseau injoignable ou délai dépassé.
/// Le message destiné à l'utilisateur est en français.
class ConnectionException extends NetworkException {
  /// Réseau injoignable (pas d'internet, DNS, connexion refusée).
  ConnectionException() : super(offlineMessage);

  /// Délai dépassé : en pratique, le serveur (Render, offre gratuite) sort de
  /// veille et met près d'une minute à répondre.
  ConnectionException.timeout() : super(timeoutMessage);

  /// Message affiché quand le réseau est injoignable.
  static const offlineMessage =
      'Pas de connexion internet. Vérifiez votre réseau puis réessayez.';

  /// Message affiché quand le serveur ne répond pas à temps.
  static const timeoutMessage =
      'Le serveur démarre, cela peut prendre une minute. '
      'Réessayez dans quelques secondes.';
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

/// 403 STORE_SUSPENDED — la plateforme a suspendu la boutique. Temporaire :
/// rien de ce qui attend l'envoi ne doit être abandonné.
class StoreSuspendedException extends ApiException {
  /// Crée une StoreSuspendedException.
  StoreSuspendedException({required super.detail, this.supportContact})
    : super(statusCode: 403, code: errorCode);

  /// Code d'erreur renvoyé par l'API.
  static const errorCode = 'STORE_SUSPENDED';

  /// Contact du support à afficher (téléphone ou email), null s'il n'est pas
  /// configuré côté serveur.
  final String? supportContact;
}

/// La suspension portée par [error] (réponse HTTP, exception déjà convertie ou
/// enveloppée par un intercepteur), ou null s'il s'agit d'une autre erreur.
StoreSuspendedException? storeSuspensionOf(Object error) {
  if (error is StoreSuspendedException) return error;
  if (error is! DioException) return null;
  final wrapped = error.error;
  if (wrapped is StoreSuspendedException) return wrapped;
  final response = error.response;
  if (response?.statusCode != 403 || response?.data is! Map<String, dynamic>) {
    return null;
  }
  final parsed = parseException(error);
  return parsed is StoreSuspendedException ? parsed : null;
}

/// Convertit une DioException en NetworkException propre au projet.
NetworkException parseException(DioException e) {
  // Erreurs réseau (aucune réponse reçue).
  if (e.type == DioExceptionType.connectionTimeout ||
      e.type == DioExceptionType.sendTimeout ||
      e.type == DioExceptionType.receiveTimeout) {
    return ConnectionException.timeout();
  }
  if (e.type == DioExceptionType.connectionError || e.response == null) {
    return ConnectionException();
  }

  final statusCode = e.response!.statusCode ?? 500;
  final (
    code: code,
    detail: detail,
    field: field,
    supportContact: supportContact,
  ) = _parseBody(
    e.response!.data as Map<String, dynamic>?,
  );

  // Codes de statut spécifiques.
  if (statusCode == 403 && code == StoreSuspendedException.errorCode) {
    return StoreSuspendedException(
      detail: detail,
      supportContact: supportContact,
    );
  }
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

({String code, String detail, String? field, String? supportContact})
_parseBody(Map<String, dynamic>? data) {
  if (data == null) {
    return (
      code: 'UNKNOWN',
      detail: 'Erreur serveur.',
      field: null,
      supportContact: null,
    );
  }

  final code = (data['code'] as String?) ?? 'UNKNOWN';
  final detail = (data['detail'] as String?) ?? 'Erreur serveur.';
  final field = data['field'] as String?;
  final details = data['details'];
  final contact = details is Map<String, dynamic>
      ? (details['support_contact'] as String?)?.trim()
      : null;

  return (
    code: code,
    detail: detail,
    field: field,
    supportContact: contact == null || contact.isEmpty ? null : contact,
  );
}
