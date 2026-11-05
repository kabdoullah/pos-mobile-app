/// Contrôle de forme d'une adresse email avant envoi au serveur.
///
/// Volontairement permissif (`x@y.z`) : le backend fait la validation
/// complète et ses refus restent traduits par `errorToFrench`.
bool isValidEmail(String email) => _emailPattern.hasMatch(email.trim());

final _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
