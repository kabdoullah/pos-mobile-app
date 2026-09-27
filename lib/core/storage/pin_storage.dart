import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../config.dart';

/// Clés de stockage des données du PIN.
abstract class _PinStorageKeys {
  /// Hash du PIN (format `pbkdf2_sha256$<iterations>$<hex>`).
  static const String pinHash = 'pin_hash';

  /// Sel utilisé pour le hachage du PIN (hex).
  static const String pinSalt = 'pin_salt';

  /// Nombre de tentatives de PIN échouées.
  static const String pinAttempts = 'pin_attempts';

  /// Horodatage de fin du blocage du PIN (ISO 8601).
  static const String pinLockoutUntil = 'pin_lockout_until';
}

/// Enregistre et vérifie un PIN haché localement, avec protection par blocage.
class PinStorage {
  /// Crée une instance PinStorage.
  PinStorage({
    FlutterSecureStorage? secureStorage,
    Duration lockoutDuration = const Duration(minutes: 5),
  }) : _storage = secureStorage ?? const FlutterSecureStorage(),
       _lockoutDuration = lockoutDuration;

  /// Backend de stockage sécurisé sous-jacent.
  final FlutterSecureStorage _storage;

  /// Durée du blocage du PIN après le nombre maximal de tentatives.
  final Duration _lockoutDuration;

  /// Nombre maximal de tentatives de PIN avant blocage.
  static int get maxAttempts => AppConfig.maxPinAttempts;

  /// Nombre d'itérations PBKDF2. Réglé pour une dérivation assez lente sur une
  /// vérification ponctuelle.
  static const int _pbkdf2Iterations = 150000;

  /// Préfixe qui marque le format de hash actuel. Les anciens hash SHA-256 ne
  /// l'ont pas.
  static const String _hashPrefix = 'pbkdf2_sha256';

  /// Enregistre le PIN sous forme de hash PBKDF2-HMAC-SHA256 salé.
  Future<void> savePinHash(String pin) async {
    // Génère un sel aléatoire cryptographique (64 caractères hex = 32 octets).
    final salt = _generateRandomHex(32);
    final hash = _hashPin(pin, salt);

    await Future.wait([
      _storage.write(key: _PinStorageKeys.pinHash, value: hash),
      _storage.write(key: _PinStorageKeys.pinSalt, value: salt),
      _storage.write(key: _PinStorageKeys.pinAttempts, value: '0'),
      _storage.delete(key: _PinStorageKeys.pinLockoutUntil),
    ]);
  }

  /// Vérifie un PIN par rapport au hash enregistré.
  /// Retourne true s'il est correct (le compteur d'échecs repart alors de
  /// zéro). En cas d'échec, incrémente les tentatives et déclenche le blocage
  /// dès que [maxAttempts] échecs consécutifs sont atteints (le 5e échec bloque
  /// avec la valeur par défaut).
  /// Lève [PinLockedException] si le PIN est actuellement bloqué.
  Future<bool> verifyPin(String pin) async {
    // Vérifier d'abord le blocage.
    final until = await lockedUntil();
    if (until != null) {
      throw PinLockedException(lockedUntil: until);
    }

    final storedHash = await _storage.read(key: _PinStorageKeys.pinHash);
    final storedSalt = await _storage.read(key: _PinStorageKeys.pinSalt);

    if (storedHash == null || storedSalt == null) {
      return false;
    }

    // Hash à l'ancien format — rejeté sans compter de tentative ; l'utilisateur
    // doit recréer son PIN (géré par hasPinConfigured au moment du routage).
    if (!storedHash.startsWith('$_hashPrefix\$')) {
      return false;
    }

    final computedHash = _hashPin(pin, storedSalt);
    final isCorrect = _constantTimeEquals(computedHash, storedHash);

    if (isCorrect) {
      // Les échecs ne se cumulent pas d'une session à l'autre.
      if (await getPinAttempts() > 0) await resetAttempts();
    } else {
      // Incrémente les tentatives.
      final attempts = await getPinAttempts();
      final newAttempts = attempts + 1;

      if (newAttempts >= maxAttempts) {
        // Blocage.
        final lockoutUntil = DateTime.now()
            .add(_lockoutDuration)
            .toIso8601String();
        await _storage.write(
          key: _PinStorageKeys.pinLockoutUntil,
          value: lockoutUntil,
        );
      }

      await _storage.write(
        key: _PinStorageKeys.pinAttempts,
        value: newAttempts.toString(),
      );
    }

    return isCorrect;
  }

  /// Vérifie si un PIN a été configuré.
  ///
  /// Un hash à l'ancien format (non sécurisé) est considéré comme absent et
  /// effacé, ce qui oblige l'utilisateur à recréer son PIN.
  Future<bool> hasPinConfigured() async {
    final hash = await _storage.read(key: _PinStorageKeys.pinHash);
    if (hash == null) return false;
    if (!hash.startsWith('$_hashPrefix\$')) {
      // Ancien hash SHA-256 — incompatible, on le supprime.
      await clearPin();
      return false;
    }
    return true;
  }

  /// Récupère le nombre actuel de tentatives de PIN échouées.
  Future<int> getPinAttempts() async {
    final attempts = await _storage.read(key: _PinStorageKeys.pinAttempts);
    if (attempts == null || attempts.isEmpty) return 0;
    return int.tryParse(attempts) ?? 0;
  }

  /// Remet à zéro le compteur de tentatives de PIN et lève le blocage.
  Future<void> resetAttempts() async {
    await Future.wait([
      _storage.write(key: _PinStorageKeys.pinAttempts, value: '0'),
      _storage.delete(key: _PinStorageKeys.pinLockoutUntil),
    ]);
  }

  /// Efface toutes les données liées au PIN.
  Future<void> clearPin() async {
    await Future.wait([
      _storage.delete(key: _PinStorageKeys.pinHash),
      _storage.delete(key: _PinStorageKeys.pinSalt),
      _storage.delete(key: _PinStorageKeys.pinAttempts),
      _storage.delete(key: _PinStorageKeys.pinLockoutUntil),
    ]);
  }

  /// Fin du blocage en cours, ou null si le PIN n'est pas bloqué.
  ///
  /// Un blocage expiré ou un horodatage mal formé est effacé au passage, avec
  /// le compteur d'échecs : l'utilisateur retrouve toutes ses tentatives.
  Future<DateTime?> lockedUntil() async {
    final lockoutStr = await _storage.read(
      key: _PinStorageKeys.pinLockoutUntil,
    );
    if (lockoutStr == null) return null;

    final until = DateTime.tryParse(lockoutStr);
    if (until == null || DateTime.now().isAfter(until)) {
      await resetAttempts();
      return null;
    }
    return until;
  }

  /// Hache un PIN avec le sel donné en PBKDF2-HMAC-SHA256.
  ///
  /// Retourne une chaîne auto-descriptive `pbkdf2_sha256$<iterations>$<hex>`
  /// pour que le format puisse être détecté et migré plus tard.
  String _hashPin(String pin, String salt) {
    final derived = _pbkdf2(
      password: utf8.encode(pin),
      salt: _hexDecode(salt),
      iterations: _pbkdf2Iterations,
      keyLength: 32,
    );
    final hex = derived.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
    return '$_hashPrefix\$$_pbkdf2Iterations\$$hex';
  }

  /// PBKDF2-HMAC-SHA256 (RFC 8018) sur la primitive HMAC éprouvée de `crypto`.
  List<int> _pbkdf2({
    required List<int> password,
    required List<int> salt,
    required int iterations,
    required int keyLength,
  }) {
    final hmac = Hmac(sha256, password);
    const hLen = 32;
    final blockCount = (keyLength / hLen).ceil();
    final output = <int>[];

    for (var i = 1; i <= blockCount; i++) {
      // INT(i) : index du bloc en entier big-endian sur 4 octets.
      final indexBytes = [
        (i >> 24) & 0xff,
        (i >> 16) & 0xff,
        (i >> 8) & 0xff,
        i & 0xff,
      ];
      var u = hmac.convert([...salt, ...indexBytes]).bytes;
      final block = List<int>.of(u);
      for (var j = 1; j < iterations; j++) {
        u = hmac.convert(u).bytes;
        for (var k = 0; k < hLen; k++) {
          block[k] ^= u[k];
        }
      }
      output.addAll(block);
    }

    return output.sublist(0, keyLength);
  }

  /// Décode une chaîne hex en octets.
  List<int> _hexDecode(String hex) {
    final bytes = <int>[];
    for (var i = 0; i < hex.length; i += 2) {
      bytes.add(int.parse(hex.substring(i, i + 2), radix: 16));
    }
    return bytes;
  }

  /// Égalité de chaînes à temps constant — empêche les attaques temporelles sur
  /// les hash de PIN.
  bool _constantTimeEquals(String a, String b) {
    if (a.length != b.length) return false;
    var result = 0;
    for (var i = 0; i < a.length; i++) {
      result |= a.codeUnitAt(i) ^ b.codeUnitAt(i);
    }
    return result == 0;
  }

  /// Génère une chaîne hex aléatoire cryptographique de longueur [bytes].
  String _generateRandomHex(int bytes) {
    final rng = Random.secure();
    final random = List<int>.generate(bytes, (_) => rng.nextInt(256));
    return random.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  }
}

/// Levée quand la vérification du PIN est bloquée après trop de tentatives
/// échouées.
class PinLockedException implements Exception {
  /// Crée une PinLockedException.
  PinLockedException({required this.lockedUntil});

  /// Fin du blocage.
  final DateTime lockedUntil;

  @override
  String toString() => 'PIN verrouillé jusqu\'à $lockedUntil.';
}
