import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:logger/logger.dart';

import '../../../../core/config.dart';
import '../../../../core/network/api_exception.dart';
import '../../../../core/network/error_mapper.dart';
import '../../../../core/network/network_providers.dart';
import '../../../../core/sync/sync_orchestrator.dart';
import '../../domain/entities/user.dart';
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
  const AuthUnauthenticated();
}

/// Token valide + utilisateur authentifié, mais boutique pas encore configurée
/// (première inscription uniquement).
/// Après la configuration de la boutique → `PinSetupRequired`.
class AuthStoreSetupRequired extends AuthStatus {
  /// Constructeur.
  const AuthStoreSetupRequired();
}

/// Token valide + utilisateur authentifié, mais PIN pas encore créé sur cet
/// appareil (première connexion uniquement).
/// Après la création du PIN → `Authenticated`.
class AuthPinSetupRequired extends AuthStatus {
  /// Constructeur.
  const AuthPinSetupRequired();
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
      _logger.w('[Auth] Token expired detected, resetting to Unauthenticated');
      state = const AsyncData(AuthUnauthenticated());
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

      final hasPinSetup = await repo.hasPinSetup();
      final status = hasPinSetup
          ? const AuthPinRequired()
          : const AuthPinSetupRequired();
      _logger.i(
        '[Auth._resolveInitialStatus] Token found, PIN configured=$hasPinSetup, returning $status',
      );
      return status;
    } catch (e) {
      _logger.e(
        '[Auth._resolveInitialStatus] Init failed: $e, returning Unauthenticated',
      );
      return const AuthUnauthenticated();
    }
  }

  /// Authentifie l'utilisateur par numéro de téléphone + mot de passe.
  ///
  /// Appelle l'endpoint de connexion du backend, enregistre les tokens JWT dans
  /// le secure storage.
  /// Vérifie ensuite la config du PIN : si présent → PinRequired (vérifier le
  /// PIN existant), sinon → PinSetupRequired (créer un nouveau PIN).
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

        final hasPinSetup = await repo.hasPinSetup();
        final status = hasPinSetup
            ? const AuthPinRequired()
            : const AuthPinSetupRequired();
        _logger.i(
          '[Auth.login] PIN configured=$hasPinSetup, transitioning to $status',
        );
        return status;
      } catch (e) {
        final msg = _toUserFacingException(e);
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
        final msg = _toUserFacingException(e);
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
  /// En cas de PIN erroné : lève « PIN incorrect ».
  /// À la 4e tentative échouée : blocage automatique local pendant 5 minutes.
  Future<void> verifyPin(String pin) async {
    _logger.i('[Auth.verifyPin] Attempt with PIN length=${pin.length}');
    state = const AsyncLoading<AuthStatus>();

    state = await AsyncValue.guard(() async {
      try {
        final repo = ref.read(authRepositoryProvider);
        final isCorrect = await repo.verifyPin(pin);

        if (!isCorrect) {
          final attempts = await repo.getPinAttempts();
          final remaining = AppConfig.maxPinAttempts - attempts;
          if (remaining <= 0) {
            throw 'PIN incorrect. Compte verrouillé pour ${AppConfig.pinLockoutMinutes} min.';
          }
          final s = remaining > 1 ? 's' : '';
          throw 'PIN incorrect. $remaining tentative$s restante$s.';
        }

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
      } catch (e) {
        if (e is Exception && e.toString().contains('PIN verrouillé')) {
          // PinLockedException venant du repo — on garde le message exact
          _logger.e('[Auth.verifyPin] PIN locked: $e');
          rethrow;
        }
        final msg = _toUserFacingException(e);
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

  /// L'utilisateur a dépassé la configuration de la boutique (depuis
  /// store_setup_page.dart).
  /// Rafraîchit le JWT pour que le nouvel access token porte le store_id, puis
  /// passe à l'écran de création du PIN.
  Future<void> proceedToPinSetup() async {
    _logger.i('[Auth.proceedToPinSetup] Refreshing token with store_id');
    try {
      await ref.read(authRepositoryProvider).refreshTokens();
    } catch (e) {
      _logger.w(
        '[Auth.proceedToPinSetup] Token refresh failed (non-fatal): $e',
      );
    }
    _logger.i('[Auth.proceedToPinSetup] Transitioning to PinSetupRequired');
    state = const AsyncData(AuthPinSetupRequired());
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
        await repo.setupPin(pin);
        await repo.resetPinAttempts();
        _logger.i(
          '[Auth.setupPin] PIN saved, resetting attempts, fetching user',
        );

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
        final msg = _toUserFacingException(e);
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

  /// Convertit les exceptions en messages clairs en français.
  /// Utilisé dans [AsyncValue.guard] pour stocker des erreurs parlantes.
  String _toUserFacingException(Object e) {
    if (e is! NetworkException) {
      final msg = e.toString();
      if (msg.startsWith('PIN incorrect') || msg.contains('verrouillé')) {
        return msg;
      }
    }
    return errorToFrench(e);
  }
}
