import '../entities/account_email.dart';

/// Profil de l'utilisateur connecté : nom affiché « Vendeur : … » sur les
/// reçus (ADR-0008), mis en cache pour imprimer hors ligne, et état de
/// vérification de l'email.
abstract interface class ProfileRepository {
  /// Nom du vendeur (cache local, sinon serveur) ; null s'il n'est pas défini
  /// ou inconnu hors ligne.
  Future<String?> getDisplayName();

  /// Enregistre le nom (null ou vide = retiré). Nécessite le réseau.
  Future<String?> updateDisplayName(String? displayName);

  /// Email du compte et son état de vérification, toujours lus sur le serveur
  /// (pas de cache : l'état change hors de l'app). Nécessite le réseau.
  Future<AccountEmail> getAccountEmail();

  /// Renvoie le lien de vérification de l'email. Nécessite le réseau.
  Future<void> resendEmailVerification();

  /// Ajoute un email au compte, ou corrige un email non vérifié, puis envoie
  /// le lien de vérification. Le mot de passe est revérifié. Nécessite le
  /// réseau.
  Future<AccountEmail> updateEmail({
    required String email,
    required String password,
  });

  /// Date jusqu'à laquelle le rappel « email » de l'accueil est masqué, ou
  /// null s'il ne l'est pas (préférence de l'appareil).
  Future<DateTime?> emailReminderSnoozedUntil();

  /// Masque le rappel « email » de l'accueil jusqu'à [until].
  Future<void> snoozeEmailReminder(DateTime until);

  /// True si le compte connecté a masqué les « Premiers pas » de l'accueil
  /// sur cet appareil (gardé s'il se reconnecte, jamais hérité par un autre
  /// compte).
  Future<bool> firstStepsHidden();

  /// Masque les « Premiers pas » de l'accueil pour le compte connecté.
  Future<void> hideFirstSteps();

  /// Vide le cache local (changement de compte).
  Future<void> clearLocal();
}
