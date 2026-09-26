/// Retire les caractères de contrôle ASCII et les espaces en début/fin d'un
/// code-barres brut (gère GS1 FNC1 et artefacts similaires des scanners).
/// Retourne null si le résultat est vide, si l'entrée est null, ou si le
/// résultat ne respecte pas le format validé côté serveur (alphanumérique, 6 à
/// 50 caractères).
String? normalizeBarcode(String? raw) {
  if (raw == null) return null;
  final cleaned = raw.trim().replaceAll(RegExp(r'[\x00-\x1F\x7F]'), '');
  if (cleaned.isEmpty) return null;
  // Le serveur refuse les codes-barres qui ne correspondent pas à
  // ^[A-Za-z0-9]{6,50}$.
  // On les écarte silencieusement pour éviter des échecs d'envoi (422) qui
  // boucleraient sans fin.
  if (!RegExp(r'^[A-Za-z0-9]{6,50}$').hasMatch(cleaned)) return null;
  return cleaned;
}
