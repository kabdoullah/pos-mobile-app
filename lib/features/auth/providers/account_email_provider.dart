import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/entities/account_email.dart';
import 'auth_di_providers.dart';

part 'account_email_provider.g.dart';

/// Email du compte et son état de vérification, lus à jour sur le serveur.
///
/// autoDispose : relu à chaque ouverture des paramètres, pour refléter une
/// vérification faite entre-temps depuis le lien de l'email.
@riverpod
class AccountEmailStatus extends _$AccountEmailStatus {
  @override
  Future<AccountEmail> build() =>
      ref.read(profileRepositoryProvider).getAccountEmail();

  /// Renvoie le lien de vérification. L'erreur réseau remonte à l'UI.
  Future<void> resendVerification() =>
      ref.read(profileRepositoryProvider).resendEmailVerification();
}
