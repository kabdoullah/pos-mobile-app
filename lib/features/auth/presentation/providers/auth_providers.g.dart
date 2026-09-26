// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Gère l'état et les actions d'authentification (connexion, inscription,
/// création/vérification du PIN, déconnexion).
///
/// L'état est un `AsyncValue<AuthStatus>` :
/// - `AsyncLoading` : opération en cours (init, connexion, inscription,
///   vérification du PIN, etc.)
/// - `AsyncData(status)` : opération réussie, l'utilisateur est dans `status`
/// - `AsyncError(exception)` : opération échouée, l'exception est un message
///   lisible par l'utilisateur (voir [_toUserFacingException])
///
/// Initialisation : au lancement de l'app, `build()` vérifie les tokens et la
/// config du PIN dans le secure storage, puis route en conséquence.
/// L'expiration du token est gérée via le flux [authExpiredControllerProvider]
/// — quand le serveur invalide le token, ce notifier passe à `Unauthenticated`,
/// le routeur détecte le changement et redirige vers la connexion.

@ProviderFor(Auth)
final authProvider = AuthProvider._();

/// Gère l'état et les actions d'authentification (connexion, inscription,
/// création/vérification du PIN, déconnexion).
///
/// L'état est un `AsyncValue<AuthStatus>` :
/// - `AsyncLoading` : opération en cours (init, connexion, inscription,
///   vérification du PIN, etc.)
/// - `AsyncData(status)` : opération réussie, l'utilisateur est dans `status`
/// - `AsyncError(exception)` : opération échouée, l'exception est un message
///   lisible par l'utilisateur (voir [_toUserFacingException])
///
/// Initialisation : au lancement de l'app, `build()` vérifie les tokens et la
/// config du PIN dans le secure storage, puis route en conséquence.
/// L'expiration du token est gérée via le flux [authExpiredControllerProvider]
/// — quand le serveur invalide le token, ce notifier passe à `Unauthenticated`,
/// le routeur détecte le changement et redirige vers la connexion.
final class AuthProvider extends $AsyncNotifierProvider<Auth, AuthStatus> {
  /// Gère l'état et les actions d'authentification (connexion, inscription,
  /// création/vérification du PIN, déconnexion).
  ///
  /// L'état est un `AsyncValue<AuthStatus>` :
  /// - `AsyncLoading` : opération en cours (init, connexion, inscription,
  ///   vérification du PIN, etc.)
  /// - `AsyncData(status)` : opération réussie, l'utilisateur est dans `status`
  /// - `AsyncError(exception)` : opération échouée, l'exception est un message
  ///   lisible par l'utilisateur (voir [_toUserFacingException])
  ///
  /// Initialisation : au lancement de l'app, `build()` vérifie les tokens et la
  /// config du PIN dans le secure storage, puis route en conséquence.
  /// L'expiration du token est gérée via le flux [authExpiredControllerProvider]
  /// — quand le serveur invalide le token, ce notifier passe à `Unauthenticated`,
  /// le routeur détecte le changement et redirige vers la connexion.
  AuthProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authHash();

  @$internal
  @override
  Auth create() => Auth();
}

String _$authHash() => r'8743a11b09f1ee1a7e92388345b4ae739fd7e7be';

/// Gère l'état et les actions d'authentification (connexion, inscription,
/// création/vérification du PIN, déconnexion).
///
/// L'état est un `AsyncValue<AuthStatus>` :
/// - `AsyncLoading` : opération en cours (init, connexion, inscription,
///   vérification du PIN, etc.)
/// - `AsyncData(status)` : opération réussie, l'utilisateur est dans `status`
/// - `AsyncError(exception)` : opération échouée, l'exception est un message
///   lisible par l'utilisateur (voir [_toUserFacingException])
///
/// Initialisation : au lancement de l'app, `build()` vérifie les tokens et la
/// config du PIN dans le secure storage, puis route en conséquence.
/// L'expiration du token est gérée via le flux [authExpiredControllerProvider]
/// — quand le serveur invalide le token, ce notifier passe à `Unauthenticated`,
/// le routeur détecte le changement et redirige vers la connexion.

abstract class _$Auth extends $AsyncNotifier<AuthStatus> {
  FutureOr<AuthStatus> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<AuthStatus>, AuthStatus>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<AuthStatus>, AuthStatus>,
              AsyncValue<AuthStatus>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
