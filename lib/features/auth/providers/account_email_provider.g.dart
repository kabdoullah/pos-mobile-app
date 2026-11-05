// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_email_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Email du compte et son état de vérification, lus à jour sur le serveur.
///
/// autoDispose : relu à chaque ouverture des paramètres, pour refléter une
/// vérification faite entre-temps depuis le lien de l'email.

@ProviderFor(AccountEmailStatus)
final accountEmailStatusProvider = AccountEmailStatusProvider._();

/// Email du compte et son état de vérification, lus à jour sur le serveur.
///
/// autoDispose : relu à chaque ouverture des paramètres, pour refléter une
/// vérification faite entre-temps depuis le lien de l'email.
final class AccountEmailStatusProvider
    extends $AsyncNotifierProvider<AccountEmailStatus, AccountEmail> {
  /// Email du compte et son état de vérification, lus à jour sur le serveur.
  ///
  /// autoDispose : relu à chaque ouverture des paramètres, pour refléter une
  /// vérification faite entre-temps depuis le lien de l'email.
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
    r'40960ca5944c628816a46ddca047a0c3e72a4b5f';

/// Email du compte et son état de vérification, lus à jour sur le serveur.
///
/// autoDispose : relu à chaque ouverture des paramètres, pour refléter une
/// vérification faite entre-temps depuis le lien de l'email.

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
