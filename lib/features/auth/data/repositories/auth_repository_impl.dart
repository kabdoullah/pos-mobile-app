import 'package:dio/dio.dart';

import '../../../../core/network/api_exception.dart';
import '../../../../core/storage/pin_storage.dart';
import '../../../../core/storage/secure_token_storage.dart';
import '../../domain/entities/pin_failure.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/auth_models.dart';

/// Implémentation concrète de [AuthRepository].
class AuthRepositoryImpl implements AuthRepository {
  /// Crée un AuthRepositoryImpl.
  AuthRepositoryImpl({
    required this.dataSource,
    required this.tokenStorage,
    required this.pinStorage,
  });

  /// Data source distante.
  final AuthRemoteDataSource dataSource;

  /// Stockage sécurisé des tokens.
  final SecureTokenStorage tokenStorage;

  /// Stockage du PIN.
  final PinStorage pinStorage;

  @override
  Future<User> register({
    required String phoneNumber,
    required String password,
    String? email,
  }) async {
    try {
      final registerRes = await dataSource.register(
        RegisterRequestDto(
          phoneNumber: phoneNumber,
          password: password,
          email: email,
        ),
      );

      // Connexion automatique après l'inscription.
      final tokenRes = await dataSource.login(
        LoginRequestDto(phoneNumber: phoneNumber, password: password),
      );

      await tokenStorage.saveTokens(
        accessToken: tokenRes.accessToken,
        refreshToken: tokenRes.refreshToken,
      );
      await tokenStorage.savePhone(phoneNumber);

      final userId = await tokenStorage.getUserId() ?? registerRes.userId;
      // Persisté : si l'app est fermée avant la configuration de la boutique,
      // le prochain lancement y revient au lieu de passer au PIN.
      await tokenStorage.saveStoreSetupPending(userId);
      return User(
        id: userId,
        phoneNumber: phoneNumber,
        email: email,
        storeId: await tokenStorage.getStoreId(),
      );
    } on DioException catch (e) {
      throw _parseException(e);
    }
  }

  @override
  Future<User> login({
    required String phoneNumber,
    required String password,
  }) async {
    try {
      final tokenRes = await dataSource.login(
        LoginRequestDto(phoneNumber: phoneNumber, password: password),
      );

      await tokenStorage.saveTokens(
        accessToken: tokenRes.accessToken,
        refreshToken: tokenRes.refreshToken,
      );
      await tokenStorage.savePhone(phoneNumber);

      final userId = await tokenStorage.getUserId();
      if (userId == null) {
        throw Exception('Login failed: user ID missing from token');
      }
      return User(
        id: userId,
        phoneNumber: phoneNumber,
        storeId: await tokenStorage.getStoreId(),
      );
    } on DioException catch (e) {
      throw _parseException(e);
    }
  }

  @override
  Future<void> setupPin(String pin) async {
    await pinStorage.savePinHash(pin);
  }

  @override
  Future<void> verifyPin(String pin) async {
    final bool isCorrect;
    try {
      isCorrect = await pinStorage.verifyPin(pin);
    } on PinLockedException catch (e) {
      throw PinLocked(until: e.lockedUntil);
    }
    if (isCorrect) return;

    // Cet échec a pu déclencher le blocage.
    final until = await pinStorage.lockedUntil();
    if (until != null) throw PinLocked(until: until);
    final attempts = await pinStorage.getPinAttempts();
    throw WrongPin(remainingAttempts: PinStorage.maxAttempts - attempts);
  }

  @override
  Future<DateTime?> pinLockedUntil() => pinStorage.lockedUntil();

  @override
  Future<void> sendPasswordReset(String email) async {
    try {
      await dataSource.forgotPassword(ForgotPasswordRequestDto(email: email));
    } on DioException catch (e) {
      throw _parseException(e);
    }
  }

  @override
  Future<void> logout() async {
    await tokenStorage.clearTokens();
    await pinStorage.clearPin();
  }

  @override
  Future<User?> getCurrentUser() async {
    final userId = await tokenStorage.getUserId();
    if (userId == null) return null;

    return User(
      id: userId,
      phoneNumber: await tokenStorage.getPhone() ?? '',
      storeId: await tokenStorage.getStoreId(),
    );
  }

  @override
  Future<bool> hasPinSetup() => pinStorage.hasPinConfigured();

  @override
  Future<bool> isStoreSetupPending() async {
    final pendingUserId = await tokenStorage.getStoreSetupPendingUserId();
    if (pendingUserId == null) return false;
    return pendingUserId == await tokenStorage.getUserId();
  }

  @override
  Future<void> completeStoreSetup() => tokenStorage.clearStoreSetupPending();

  @override
  Future<void> refreshTokens() async {
    final refreshToken = await tokenStorage.getRefreshToken();
    if (refreshToken == null) return;
    try {
      final tokenRes = await dataSource.refresh(
        RefreshRequestDto(refreshToken: refreshToken),
      );
      await tokenStorage.saveTokens(
        accessToken: tokenRes.accessToken,
        refreshToken: tokenRes.refreshToken,
      );
    } on DioException catch (e) {
      throw _parseException(e);
    }
  }

  /// Convertit une [DioException] en [NetworkException].
  NetworkException _parseException(DioException e) {
    return parseException(e);
  }
}
