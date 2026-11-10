import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/cash_register_di_providers.dart';

/// Refus de déconnexion : une session de caisse est ouverte.
const cashLogoutOpenSessionMessage =
    'Clôturez la caisse avant de vous déconnecter.';

/// Refus de déconnexion : des opérations de caisse attendent la synchro.
const cashLogoutPendingMessage =
    'Des opérations de caisse ne sont pas encore synchronisées. Connectez-vous '
    'à internet et synchronisez avant de vous déconnecter.';

/// Raison pour laquelle une déconnexion demandée par l'utilisateur est
/// refusée, null si elle est permise.
///
/// Une session ouverte ou une opération de caisse non envoyée serait perdue
/// au changement de compte (la synchro du compte suivant efface les données
/// locales) et la session resterait ouverte sur le serveur sans appareil pour
/// la clôturer. À appeler avant chaque déconnexion volontaire — pas dans
/// `Auth.logout()`, que les déconnexions forcées (jeton expiré, suppression
/// du compte) doivent toujours pouvoir appeler.
Future<String?> cashLogoutBlockReason(WidgetRef ref) async {
  final repository = ref.read(cashRegisterRepositoryProvider);
  if (await repository.getActiveSession() != null) {
    return cashLogoutOpenSessionMessage;
  }
  if (await repository.hasPendingCashOperations()) {
    return cashLogoutPendingMessage;
  }
  return null;
}
