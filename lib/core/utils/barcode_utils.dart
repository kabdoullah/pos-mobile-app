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

/// Formes sous lesquelles un code-barres déjà normalisé peut être enregistré.
///
/// Un UPC-A (12 chiffres) est aussi un EAN-13 précédé d'un zéro : selon le
/// scanner ou la saisie, le même article arrive sous l'une ou l'autre forme.
/// La forme reçue est toujours en tête.
List<String> barcodeLookupCandidates(String normalized) {
  final digitsOnly = RegExp(r'^\d+$').hasMatch(normalized);
  if (digitsOnly && normalized.length == 12) {
    return [normalized, '0$normalized'];
  }
  if (digitsOnly && normalized.length == 13 && normalized.startsWith('0')) {
    return [normalized, normalized.substring(1)];
  }
  return [normalized];
}
