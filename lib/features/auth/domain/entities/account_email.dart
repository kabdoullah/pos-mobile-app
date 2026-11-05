/// Adresse email du compte connecté et son état de vérification.
///
/// Le lien de réinitialisation du mot de passe n'est envoyé qu'à une adresse
/// vérifiée.
class AccountEmail {
  /// Crée l'état de l'email du compte.
  const AccountEmail({required this.email, required this.isVerified});

  /// Adresse du compte ; null pour les anciens comptes créés sans email.
  final String? email;

  /// Vrai une fois le lien de vérification ouvert et confirmé.
  final bool isVerified;
}
