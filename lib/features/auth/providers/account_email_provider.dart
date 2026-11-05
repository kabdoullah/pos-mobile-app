import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/entities/account_email.dart';
import 'auth_di_providers.dart';

part 'account_email_provider.g.dart';

/// Durée pendant laquelle « Plus tard » masque le rappel de l'accueil.
const emailReminderSnoozeDuration = Duration(days: 7);

/// Email du compte et son état de vérification, lus à jour sur le serveur.
///
/// autoDispose : relu à chaque ouverture des paramètres ou de l'accueil, pour
/// refléter une vérification faite entre-temps depuis le lien de l'email.
@riverpod
class AccountEmailStatus extends _$AccountEmailStatus {
  @override
  Future<AccountEmail> build() =>
      ref.read(profileRepositoryProvider).getAccountEmail();

  /// Renvoie le lien de vérification. L'erreur réseau remonte à l'UI.
  Future<void> resendVerification() =>
      ref.read(profileRepositoryProvider).resendEmailVerification();

  /// Ajoute ou corrige l'email puis envoie le lien. L'erreur remonte à l'UI.
  Future<void> updateEmail({
    required String email,
    required String password,
  }) async {
    final account = await ref
        .read(profileRepositoryProvider)
        .updateEmail(email: email, password: password);
    state = AsyncData(account);
  }
}

/// Email à compléter affiché en rappel sur l'accueil, ou null s'il n'y a
/// rien à signaler (email confirmé, rappel masqué, ou état inconnu hors
/// ligne).
@riverpod
class EmailReminder extends _$EmailReminder {
  @override
  Future<AccountEmail?> build() async {
    final account = await ref.watch(accountEmailStatusProvider.future);
    if (account.isVerified) return null;
    final snoozedUntil = await ref
        .read(profileRepositoryProvider)
        .emailReminderSnoozedUntil();
    if (snoozedUntil != null && DateTime.now().isBefore(snoozedUntil)) {
      return null;
    }
    return account;
  }

  /// « Plus tard » : masque le rappel pendant [emailReminderSnoozeDuration].
  Future<void> snooze() async {
    state = const AsyncData(null);
    await ref
        .read(profileRepositoryProvider)
        .snoozeEmailReminder(DateTime.now().add(emailReminderSnoozeDuration));
  }
}
