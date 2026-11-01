import 'package:dio/dio.dart';

import 'api_exception.dart';

/// Signale toute réponse « boutique suspendue » (403 STORE_SUSPENDED), d'où
/// qu'elle vienne (connexion, synchro, écran), pour que l'app bascule sur
/// l'écran de suspension dès le prochain contact avec le serveur.
///
/// L'erreur continue son chemin : l'appelant la gère comme avant.
class StoreSuspendedInterceptor extends Interceptor {
  /// Crée l'intercepteur.
  StoreSuspendedInterceptor({required this.onStoreSuspended});

  /// Appelée avec la suspension (contacts du support compris).
  final void Function(StoreSuspendedException suspension) onStoreSuspended;

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final suspension = storeSuspensionOf(err);
    if (suspension != null) onStoreSuspended(suspension);
    handler.next(err);
  }
}
