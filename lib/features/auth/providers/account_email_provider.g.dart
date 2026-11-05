// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_email_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Email du compte et son état de vérification, lus à jour sur le serveur.
///
/// autoDispose : relu à chaque ouverture des paramètres ou de l'accueil, pour
/// refléter une vérification faite entre-temps depuis le lien de l'email.

@ProviderFor(AccountEmailStatus)
final accountEmailStatusProvider = AccountEmailStatusProvider._();

/// Email du compte et son état de vérification, lus à jour sur le serveur.
///
/// autoDispose : relu à chaque ouverture des paramètres ou de l'accueil, pour
/// refléter une vérification faite entre-temps depuis le lien de l'email.
final class AccountEmailStatusProvider
    extends $AsyncNotifierProvider<AccountEmailStatus, AccountEmail> {
  /// Email du compte et son état de vérification, lus à jour sur le serveur.
  ///
  /// autoDispose : relu à chaque ouverture des paramètres ou de l'accueil, pour
  /// refléter une vérification faite entre-temps depuis le lien de l'email.
  AccountEmailStatusProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'accountEmailStatusProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$accountEmailStatusHash();

  @$internal
  @override
  AccountEmailStatus create() => AccountEmailStatus();
}

String _$accountEmailStatusHash() =>
    r'e37a68bdac04c479ba06faf10e0e9dc37f365070';

/// Email du compte et son état de vérification, lus à jour sur le serveur.
///
/// autoDispose : relu à chaque ouverture des paramètres ou de l'accueil, pour
/// refléter une vérification faite entre-temps depuis le lien de l'email.

abstract class _$AccountEmailStatus extends $AsyncNotifier<AccountEmail> {
  FutureOr<AccountEmail> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<AccountEmail>, AccountEmail>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<AccountEmail>, AccountEmail>,
              AsyncValue<AccountEmail>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Email à compléter affiché en rappel sur l'accueil, ou null s'il n'y a
/// rien à signaler (email confirmé, rappel masqué, ou état inconnu hors
/// ligne).

@ProviderFor(EmailReminder)
final emailReminderProvider = EmailReminderProvider._();

/// Email à compléter affiché en rappel sur l'accueil, ou null s'il n'y a
/// rien à signaler (email confirmé, rappel masqué, ou état inconnu hors
/// ligne).
final class EmailReminderProvider
    extends $AsyncNotifierProvider<EmailReminder, AccountEmail?> {
  /// Email à compléter affiché en rappel sur l'accueil, ou null s'il n'y a
  /// rien à signaler (email confirmé, rappel masqué, ou état inconnu hors
  /// ligne).
  EmailReminderProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'emailReminderProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$emailReminderHash();

  @$internal
  @override
  EmailReminder create() => EmailReminder();
}

String _$emailReminderHash() => r'1be29318fc80bce19e555b777e6fece806b44814';

/// Email à compléter affiché en rappel sur l'accueil, ou null s'il n'y a
/// rien à signaler (email confirmé, rappel masqué, ou état inconnu hors
/// ligne).

abstract class _$EmailReminder extends $AsyncNotifier<AccountEmail?> {
  FutureOr<AccountEmail?> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<AccountEmail?>, AccountEmail?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<AccountEmail?>, AccountEmail?>,
              AsyncValue<AccountEmail?>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
