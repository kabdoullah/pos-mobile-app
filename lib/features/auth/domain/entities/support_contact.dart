/// Coordonnées du support de la plateforme.
///
/// Les deux champs sont null quand le serveur ne les a pas configurés ou n'a
/// pas pu être joint : l'UI masque alors les boutons concernés.
class SupportContact {
  /// Crée les coordonnées du support.
  const SupportContact({this.contact, this.whatsApp});

  /// Email ou numéro de téléphone du support.
  final String? contact;

  /// Numéro WhatsApp du support (indicatif pays inclus).
  final String? whatsApp;
}
