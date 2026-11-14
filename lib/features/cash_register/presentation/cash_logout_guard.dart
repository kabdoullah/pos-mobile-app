import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/cash_register_di_providers.dart';

/// Raison d'un refus de déconnexion, avec ce qu'en dit le dialogue et
/// l'action utile qu'il propose.
enum CashLogoutBlock {
  /// Une session de caisse est ouverte.
  openSession(
    title: 'Clôturez d’abord la caisse',
    message:
        'Vous ne pouvez pas vous déconnecter tant que la caisse est ouverte.',
    actionLabel: 'Clôturer la caisse',
  ),

  /// Une clôture refusée par le serveur attend un commentaire.
  closeAwaitingNote(
    title: 'Clôture à compléter',
    message:
        'Une clôture de caisse attend un commentaire : complétez-la avant de '
        'vous déconnecter.',
    actionLabel: 'Voir la caisse',
  ),

  /// Des opérations de caisse attendent la synchro.
  pendingOperations(
    title: 'Déconnexion impossible pour l’instant',
    message:
        'Des opérations de caisse ne sont pas encore synchronisées. '
        'Connectez-vous à internet, puis réessayez.',
    actionLabel: 'Synchroniser maintenant',
  );

  const CashLogoutBlock({
    required this.title,
    required this.message,
    required this.actionLabel,
  });

  /// Titre du dialogue de refus.
  final String title;

  /// Règle expliquée en une phrase.
  final String message;

  /// Libellé de l'action qui lève le blocage.
  final String actionLabel;
}

/// Raison pour laquelle une déconnexion demandée par l'utilisateur est
/// refusée, null si elle est permise.
///
/// Une session ouverte ou une opération de caisse non envoyée serait perdue
/// au changement de compte (la synchro du compte suivant efface les données
/// locales) et la session resterait ouverte sur le serveur sans appareil pour
/// la clôturer. À appeler avant chaque déconnexion volontaire — pas dans
/// `Auth.logout()`, que les déconnexions forcées (jeton expiré, suppression
/// du compte) doivent toujours pouvoir appeler.
Future<CashLogoutBlock?> cashLogoutBlock(WidgetRef ref) async {
  final repository = ref.read(cashRegisterRepositoryProvider);
  if (await repository.getActiveSession() != null) {
    return CashLogoutBlock.openSession;
  }
  // La session reste ouverte côté serveur tant que la clôture n'est pas
  // renvoyée avec un commentaire ; son entrée de file est « rejected ».
  if (await repository.hasCloseAwaitingNote()) {
    return CashLogoutBlock.closeAwaitingNote;
  }
  if (await repository.hasPendingCashOperations()) {
    return CashLogoutBlock.pendingOperations;
  }
  return null;
}
