import 'api_exception.dart';

const _detailMap = <String, String>{
  // Authentification
  'This phone number is already registered.': 'Ce numéro est déjà enregistré.',
  'Phone number does not exist (check the number of digits and prefix).':
      "Ce numéro n'existe pas, vérifiez-le.",
  'Phone number does not exist (unknown country code).':
      "Ce numéro n'existe pas, vérifiez-le.",
  'Phone number must be a mobile number.':
      'Saisissez un numéro mobile (01, 05 ou 07).',
  'This email is already registered.': 'Cet email est déjà enregistré.',
  'Invalid phone number or password.': 'Numéro ou mot de passe incorrect.',
  'Invalid email or password.': 'Email ou mot de passe incorrect.',
  'Account is disabled.': 'Le compte est désactivé.',
  'Invalid password.': 'Mot de passe incorrect.',
  'Invalid or expired refresh token.':
      'Session expirée, veuillez vous reconnecter',
  'User not found or disabled.': 'Utilisateur introuvable ou désactivé',
  'Invalid or expired token.': 'Lien invalide ou expiré',
  'Not authenticated': 'Authentification requise',
  'Invalid credentials': 'Session expirée, veuillez vous reconnecter',
  // Rate limiting (429)
  'Too many requests. Try again later.':
      'Trop de tentatives. Réessayez dans quelques minutes.',
  // Catalogue
  'Product not found.': 'Produit introuvable',
  'A product with this barcode already exists.':
      'Un produit avec ce code-barres existe déjà',
  // Ventes
  'Sale not found.': 'Vente introuvable',
  // Boutiques
  'Store not found.': 'Boutique introuvable',
  'Store is suspended.': 'Votre boutique est suspendue.',
  'A store already exists for this user.':
      'Une boutique existe déjà pour cet utilisateur',
  // Synchro
  'since must be timezone-aware': 'Paramètre de date invalide',
};

/// Convertit n'importe quelle exception en message utilisateur en français.
String errorToFrench(Object e) {
  if (e is ApiException) {
    return _detailMap[e.message] ?? 'Une erreur est survenue.';
  }
  if (e is ConnectionException) {
    return e.message; // already French
  }
  return 'Une erreur est survenue.';
}
