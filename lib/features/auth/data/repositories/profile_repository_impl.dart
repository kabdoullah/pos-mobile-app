import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/network/api_exception.dart';
import '../../domain/entities/account_email.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/auth_models.dart';

/// Clés du cache du profil dans flutter_secure_storage.
abstract class _ProfileKeys {
  static const String displayName = 'profile_display_name';

  /// Marque que le profil a été chargé (un nom null est aussi une réponse).
  static const String loaded = 'profile_loaded';

  /// Rappel « email » de l'accueil masqué jusqu'à cette date (ISO 8601).
  /// Pas sensible : SharedPreferences.
  static const String emailReminderSnoozedUntil =
      'email_reminder_snoozed_until';

  /// Comptes (ids) qui ont masqué les « Premiers pas » de l'accueil. Lié au
  /// compte, donc conservé au changement de compte : un autre compte ne
  /// l'hérite pas, le même le retrouve en se reconnectant. Pas sensible :
  /// SharedPreferences.
  static const String firstStepsHiddenUsers = 'first_steps_hidden_users';
}

/// Implémentation de [ProfileRepository] : cache secure storage devant l'API
/// `/users/me`.
class ProfileRepositoryImpl implements ProfileRepository {
  /// Crée un ProfileRepositoryImpl.
  ProfileRepositoryImpl({
    required this.remoteDataSource,
    FlutterSecureStorage? storage,
    SharedPreferencesAsync? prefs,
    Future<String?> Function()? currentUserId,
  }) : _storage = storage ?? const FlutterSecureStorage(),
       _prefs = prefs ?? SharedPreferencesAsync(),
       _currentUserId = currentUserId ?? (() async => null);

  /// Data source distante (API `/users/me`).
  final AuthRemoteDataSource remoteDataSource;
  final FlutterSecureStorage _storage;
  final SharedPreferencesAsync _prefs;

  /// Id du compte connecté (jeton), pour les préférences liées au compte.
  final Future<String?> Function() _currentUserId;

  @override
  Future<String?> getDisplayName() async {
    if (await _storage.read(key: _ProfileKeys.loaded) == 'true') {
      return _storage.read(key: _ProfileKeys.displayName);
    }
    try {
      final me = await remoteDataSource.getMe();
      await _writeLocal(me.displayName);
      return me.displayName;
    } on Exception {
      // Hors ligne au premier lancement : pas de nom, on réessaiera.
      return null;
    }
  }

  @override
  Future<String?> updateDisplayName(String? displayName) async {
    final trimmed = displayName?.trim();
    final me = await remoteDataSource.updateMe(
      UserMeUpdateDto(
        displayName: trimmed == null || trimmed.isEmpty ? null : trimmed,
      ),
    );
    await _writeLocal(me.displayName);
    return me.displayName;
  }

  @override
  Future<AccountEmail> getAccountEmail() async {
    try {
      return _toAccountEmail(await remoteDataSource.getMe());
    } on DioException catch (e) {
      throw parseException(e);
    }
  }

  @override
  Future<AccountEmail> updateEmail({
    required String email,
    required String password,
  }) async {
    try {
      final me = await remoteDataSource.updateEmail(
        UpdateEmailRequestDto(email: email.trim(), password: password),
      );
      return _toAccountEmail(me);
    } on DioException catch (e) {
      throw parseException(e);
    }
  }

  @override
  Future<DateTime?> emailReminderSnoozedUntil() async {
    final raw = await _prefs.getString(_ProfileKeys.emailReminderSnoozedUntil);
    return raw == null ? null : DateTime.tryParse(raw);
  }

  @override
  Future<void> snoozeEmailReminder(DateTime until) => _prefs.setString(
    _ProfileKeys.emailReminderSnoozedUntil,
    until.toIso8601String(),
  );

  @override
  Future<bool> firstStepsHidden() async {
    final userId = await _currentUserId();
    if (userId == null) return false;
    final users = await _prefs.getStringList(
      _ProfileKeys.firstStepsHiddenUsers,
    );
    return users?.contains(userId) ?? false;
  }

  @override
  Future<void> hideFirstSteps() async {
    final userId = await _currentUserId();
    if (userId == null) return;
    final users =
        await _prefs.getStringList(_ProfileKeys.firstStepsHiddenUsers) ??
        const <String>[];
    if (users.contains(userId)) return;
    await _prefs.setStringList(_ProfileKeys.firstStepsHiddenUsers, [
      ...users,
      userId,
    ]);
  }

  AccountEmail _toAccountEmail(UserMeDto me) =>
      AccountEmail(email: me.email, isVerified: me.emailVerifiedAt != null);

  @override
  Future<void> resendEmailVerification() async {
    try {
      await remoteDataSource.resendVerification();
    } on DioException catch (e) {
      throw parseException(e);
    }
  }

  @override
  Future<void> clearLocal() async {
    await _storage.delete(key: _ProfileKeys.displayName);
    await _storage.delete(key: _ProfileKeys.loaded);
    await _prefs.remove(_ProfileKeys.emailReminderSnoozedUntil);
  }

  Future<void> _writeLocal(String? displayName) async {
    await _storage.write(key: _ProfileKeys.displayName, value: displayName);
    await _storage.write(key: _ProfileKeys.loaded, value: 'true');
  }
}
