import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:logger/logger.dart';

import '../../../../core/network/api_exception.dart';
import '../../../../core/network/error_mapper.dart';
import '../../../../core/network/network_providers.dart';
import '../../../../core/sync/sync_orchestrator.dart';
import '../../domain/entities/pin_failure.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../../auth/providers/auth_di_providers.dart';
import '../../providers/store_provider.dart';
import '../../providers/seller_profile_provider.dart';

part 'auth_providers.g.dart';

/// Statut d'authentification — position de l'utilisateur dans le parcours
/// d'auth.
///
/// Cycle de vie : `Unauthenticated` → (après connexion) →
/// `StoreSetupRequired`/`PinSetupRequired`/`PinRequired` → `Authenticated`.
/// Ou : n'importe quel état + expiration du token → `Unauthenticated`.
sealed class AuthStatus {
  /// Constructeur.
  const AuthStatus();
}

/// Aucun token valide dans le secure storage. L'utilisateur doit se connecter
/// ou s'inscrire.
class AuthUnauthenticated extends AuthStatus {
  /// Constructeur.
  const AuthUnauthenticated({this.sessionExpired = false});

  /// True si la session a expiré (rafraîchissement du token refusé) : l'écran
  /// de connexion l'explique. Le PIN local est conservé.
  final bool sessionExpired;
}

/// Token valide + utilisateur authentifié, mais boutique pas encore configurée
/// (inscription faite sur cet appareil, y compris après une fermeture de l'app
/// pendant cette étape).
/// Après la configuration de la boutique → `PinSetupRequired`.
class AuthStoreSetupRequired extends AuthStatus {
  /// Constructeur.
  const AuthStoreSetupRequired({this.isRevisit = false});

  /// True si l'utilisateur revient depuis l'étape PIN : la boutique est déjà
  /// enregistrée, le formulaire est pré-rempli.
  final bool isRevisit;
}

/// Token valide + utilisateur authentifié, mais PIN pas encore créé sur cet
/// appareil (première connexion uniquement).
/// Après la création du PIN → `Authenticated`.
class AuthPinSetupRequired extends AuthStatus {
  /// Constructeur.
  const AuthPinSetupRequired({this.canReturnToStoreSetup = false});

  /// True dans le parcours d'inscription : l'utilisateur peut revenir à
  /// l'étape boutique (voir [Auth.returnToStoreSetup]).
  final bool canReturnToStoreSetup;
}

/// Token valide + utilisateur authentifié, PIN présent localement mais pas
/// encore vérifié dans cette session.
/// L'utilisateur doit déverrouiller par vérification du PIN → `Authenticated`.
class AuthPinRequired extends AuthStatus {
  /// Constructeur.
  const AuthPinRequired();
}

/// Token valide + utilisateur authentifié + PIN vérifié dans cette session.
/// L'utilisateur a accès à toute l'app.
class AuthAuthenticated extends AuthStatus {
  /// Crée un statut authentifié.
  const AuthAuthenticated(this.user);

  /// L'utilisateur authentifié (extrait des claims JWT).
  final User user;
}

/// Échec de connexion : numéro ou mot de passe refusé par le serveur.
///
/// Typé pour que l'écran de connexion rattache l'erreur au champ mot de passe.
class InvalidCredentials implements Exception {
  /// Constructeur.
  const InvalidCredentials();

  @override
  String toString() => 'Téléphone ou mot de passe incorrect.';
}

/// Gère l'état et les actions d'authentification (connexion, inscription,
/// création/vérification du PIN, déconnexion).
///
/// L'état est un `AsyncValue<AuthStatus>` :
/// - `AsyncLoading` : opération en cours (init, connexion, inscription,
///   vérification du PIN, etc.)
/// - `AsyncData(status)` : opération réussie, l'utilisateur est dans `status`
/// - `AsyncError(exception)` : opération échouée. L'erreur est un message en
///   français, ou un type dédié ([InvalidCredentials], [PinFailure]) que
///   l'écran présente lui-même.
///
/// Initialisation : au lancement de l'app, `build()` vérifie les tokens et la
/// config du PIN dans le secure storage, puis route en conséquence.
/// L'expiration du token est gérée via le flux [authExpiredControllerProvider]
/// — quand le serveur invalide le token, ce notifier passe à `Unauthenticated`,
/// le routeur détecte le changement et redirige vers la connexion.
@riverpod
class Auth extends _$Auth {
  static final _logger = Logger();

  @override
  Future<AuthStatus> build() async {
    _logger.i('[Auth.build] Initializing auth state');

    // Écoute les événements d'expiration du token émis par l'intercepteur de
    // rafraîchissement Dio.
    // Quand l'intercepteur détecte un 401 + un rafraîchissement échoué, il émet
    // sur ce flux.
    // ignore: close_sinks — cycle de vie géré par authExpiredControllerProvider
    final expiredController = ref.read(authExpiredControllerProvider);
    final sub = expiredController.stream.listen((_) {
      if (state.value is AuthUnauthenticated) return;
      _logger.w('[Auth] Token expired detected, resetting to Unauthenticated');
      state = const AsyncData(AuthUnauthenticated(sessionExpired: true));
    });
    ref.onDispose(sub.cancel);

    // Init asynchrone (directe — pas besoin d'astuce fire-and-forget dans un
    // AsyncNotifier).
    return _resolveInitialStatus();
  }

  /// Vérifie les tokens enregistrés et la config du PIN pour déterminer l'état
  /// initial au lancement.
  Future<AuthStatus> _resolveInitialStatus() async {
    try {
      final repo = ref.read(authRepositoryProvider);
      final user = await repo.getCurrentUser();

      if (user == null) {
        _logger.i(
          '[Auth._resolveInitialStatus] No stored token, returning Unauthenticated',
        );
        return const AuthUnauthenticated();
      }

      final status = await _nextStepAfterSignIn(repo);
      _logger.i('[Auth._resolveInitialStatus] Token found, returning $status');
      return status;
    } catch (e) {
      _logger.e(
        '[Auth._resolveInitialStatus] Init failed: $e, returning Unauthenticated',
      );
      return const AuthUnauthenticated();
    }
  }

  /// Étape suivante d'un compte connecté : boutique à configurer (inscription
  /// inachevée sur cet appareil), sinon création ou saisie du PIN.
  Future<AuthStatus> _nextStepAfterSignIn(AuthRepository repo) async {
    if (await repo.isStoreSetupPending()) return const AuthStoreSetupRequired();
    return await repo.hasPinSetup()
        ? const AuthPinRequired()
        : const AuthPinSetupRequired();
  }

  /// Authentifie l'utilisateur par numéro de téléphone + mot de passe.
  ///
  /// Appelle l'endpoint de connexion du backend, enregistre les tokens JWT dans
  /// le secure storage.
  /// Puis : boutique à configurer si l'inscription est restée inachevée sur cet
  /// appareil, sinon PinRequired (PIN présent) ou PinSetupRequired.
  /// Les erreurs sont capturées automatiquement dans `AsyncError` via
  /// [AsyncValue.guard].
  Future<void> login(String phoneNumber, String password) async {
    _logger.i('[Auth.login] Starting for $phoneNumber');
    state = const AsyncLoading<AuthStatus>();

    state = await AsyncValue.guard(() async {
      try {
        final repo = ref.read(authRepositoryProvider);
        await repo.login(phoneNumber: phoneNumber, password: password);
        _logger.i('[Auth.login] Backend login succeeded');
        await _resetStoreCache();

        final status = await _nextStepAfterSignIn(repo);
        _logger.i('[Auth.login] Transitioning to $status');
        return status;
      } on UnauthorizedException {
        _logger.e('[Auth.login] Failed: invalid credentials');
        throw const InvalidCredentials();
      } catch (e) {
        final msg = errorToFrench(e);
        _logger.e('[Auth.login] Failed: $msg');
        throw msg;
      }
    });
  }

  /// Crée un compte utilisateur (téléphone + mot de passe, email optionnel).
  ///
  /// Crée le compte sur le backend, enregistre les tokens dans le secure
  /// storage.
  /// Passe à `StoreSetupRequired` (l'utilisateur doit configurer le nom,
  /// l'adresse et le statut TVA de la boutique).
  /// Après la configuration de la boutique → `PinSetupRequired`.
  Future<void> register(
    String phoneNumber,
    String password, {
    String? email,
  }) async {
    _logger.i('[Auth.register] Starting for $phoneNumber');
    state = const AsyncLoading<AuthStatus>();

    state = await AsyncValue.guard(() async {
      try {
        final repo = ref.read(authRepositoryProvider);
        await repo.register(
          phoneNumber: phoneNumber,
          password: password,
          email: email,
        );
        _logger.i('[Auth.register] Backend registration succeeded');
        await _resetStoreCache();
        return const AuthStoreSetupRequired();
      } catch (e) {
        final msg = errorToFrench(e);
        _logger.e('[Auth.register] Failed: $msg');
        throw msg;
      }
    });
  }

  /// Vérifie le PIN à 4 chiffres de l'utilisateur pour déverrouiller la session
  /// du jour.
  ///
  /// Compare le PIN au hash PBKDF2-HMAC-SHA256 du secure storage local.
  /// En cas de succès : récupère l'utilisateur courant depuis le token →
  /// `Authenticated`.
  /// En cas d'échec : `AsyncError` avec un [PinFailure] — [WrongPin] (avec les
  /// tentatives restantes) tant que moins de `AppConfig.maxPinAttempts` échecs
  /// consécutifs, puis [PinLocked] : l'échec qui atteint ce nombre bloque le
  /// PIN pendant `AppConfig.pinLockoutMinutes` minutes.
  Future<void> verifyPin(String pin) async {
    _logger.i('[Auth.verifyPin] Attempt with PIN length=${pin.length}');
    state = const AsyncLoading<AuthStatus>();

    state = await AsyncValue.guard(() async {
      try {
        final repo = ref.read(authRepositoryProvider);
        await repo.verifyPin(pin);

        _logger.i('[Auth.verifyPin] PIN verified, fetching user');
        final user = await repo.getCurrentUser();
        if (user != null) {
          _logger.i(
            '[Auth.verifyPin] User found, transitioning to Authenticated',
          );
          return AuthAuthenticated(user);
        } else {
          _logger.w(
            '[Auth.verifyPin] User not found despite valid PIN, returning Unauthenticated',
          );
          return const AuthUnauthenticated();
        }
      } on PinFailure catch (e) {
        _logger.w('[Auth.verifyPin] Rejected: $e');
        rethrow;
      } catch (e) {
        final msg = errorToFrench(e);
        _logger.e('[Auth.verifyPin] Failed: $msg');
        throw msg;
      }
    });

    // Déclenche la synchro quand l'utilisateur devient pleinement authentifié.
    if (state is AsyncData<AuthStatus>) {
      final status = (state as AsyncData<AuthStatus>).value;
      if (status is AuthAuthenticated) {
        _logger.i('[Auth.verifyPin] Triggering sync');
        unawaited(ref.read(syncOrchestratorProvider.notifier).syncNow());
      }
    }
  }

  /// Fin du blocage du PIN en cours, ou null — pour afficher le compte à
  /// rebours dès l'ouverture de l'écran PIN.
  Future<DateTime?> pinLockedUntil() =>
      ref.read(authRepositoryProvider).pinLockedUntil();

  /// La boutique vient d'être enregistrée (depuis store_setup_page.dart).
  /// Rafraîchit le JWT pour que le nouvel access token porte le store_id,
  /// marque la configuration comme terminée, puis passe à la création du PIN.
  Future<void> proceedToPinSetup() async {
    _logger.i('[Auth.proceedToPinSetup] Refreshing token with store_id');
    try {
      await ref.read(authRepositoryProvider).refreshTokens();
    } catch (e) {
      _logger.w(
        '[Auth.proceedToPinSetup] Token refresh failed (non-fatal): $e',
      );
    }
    await ref.read(authRepositoryProvider).completeStoreSetup();
    _logger.i('[Auth.proceedToPinSetup] Transitioning to PinSetupRequired');
    state = const AsyncData(AuthPinSetupRequired(canReturnToStoreSetup: true));
  }

  /// Retour de l'étape PIN à l'étape boutique, pendant l'inscription
  /// uniquement. Sans effet hors de ce cas (le compte est déjà créé : aucun
  /// retour vers l'étape « Compte »).
  void returnToStoreSetup() {
    final current = state.value;
    if (current is AuthPinSetupRequired && current.canReturnToStoreSetup) {
      state = const AsyncData(AuthStoreSetupRequired(isRevisit: true));
    }
  }

  /// Crée un nouveau PIN à 4 chiffres (après la première connexion).
  ///
  /// Enregistre le hash et le sel du PIN dans le secure storage local.
  /// Remet à zéro le compteur de tentatives de PIN.
  /// Puis passe à `Authenticated`.
  Future<void> setupPin(String pin) async {
    _logger.i('[Auth.setupPin] Setting PIN with length=${pin.length}');
    state = const AsyncLoading<AuthStatus>();

    state = await AsyncValue.guard(() async {
      try {
        final repo = ref.read(authRepositoryProvider);
        // Remet aussi à zéro les tentatives et le blocage.
        await repo.setupPin(pin);
        _logger.i('[Auth.setupPin] PIN saved, fetching user');

        final user = await repo.getCurrentUser();
        if (user != null) {
          _logger.i(
            '[Auth.setupPin] User found, transitioning to Authenticated',
          );
          return AuthAuthenticated(user);
        } else {
          _logger.w(
            '[Auth.setupPin] User not found despite valid token, returning Unauthenticated',
          );
          return const AuthUnauthenticated();
        }
      } catch (e) {
        final msg = errorToFrench(e);
        _logger.e('[Auth.setupPin] Failed: $msg');
        throw msg;
      }
    });

    // Déclenche la synchro quand l'utilisateur devient pleinement authentifié.
    if (state is AsyncData<AuthStatus>) {
      final status = (state as AsyncData<AuthStatus>).value;
      if (status is AuthAuthenticated) {
        _logger.i('[Auth.setupPin] Triggering sync');
        unawaited(ref.read(syncOrchestratorProvider.notifier).syncNow());
      }
    }
  }

  /// Déconnecte l'utilisateur courant.
  ///
  /// Efface les tokens du secure storage et le PIN du stockage local.
  /// Passe toujours à `Unauthenticated`, même si l'effacement échoue.
  Future<void> logout() async {
    _logger.i('[Auth.logout] Logging out');
    try {
      final repo = ref.read(authRepositoryProvider);
      await repo.logout();
      await _resetStoreCache();
      _logger.i('[Auth.logout] Storage cleared');
    } finally {
      state = const AsyncData(AuthUnauthenticated());
    }
  }

  /// Efface la boutique en cache du compte précédent, pour qu'un autre compte
  /// sur cet appareil ne l'affiche ni ne l'imprime jamais (nom, NCC, TVA,
  /// pied de reçu). La lecture suivante recharge la boutique du compte connecté.
  Future<void> _resetStoreCache() async {
    await ref.read(storeRepositoryProvider).clearLocal();
    ref.invalidate(storeConfigProvider);
    // Le nom du vendeur appartient au compte : même traitement.
    await ref.read(profileRepositoryProvider).clearLocal();
    ref.invalidate(sellerProfileProvider);
  }

  /// Efface tout état d'erreur en revenant à Unauthenticated.
  /// Appelé par les pages de connexion/inscription à l'affichage pour éviter
  /// des erreurs obsolètes.
  void clearError() {
    if (state is AsyncError) {
      state = const AsyncData(AuthUnauthenticated());
    }
  }
}
