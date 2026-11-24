/// Liens WhatsApp (`wa.me`) : vers un numéro, ou sans numéro pour laisser
/// WhatsApp proposer ses contacts.
library;

/// Lien WhatsApp (`wa.me`) vers [contact] s'il s'agit d'un numéro de téléphone,
/// null sinon (email, valeur sans chiffres). WhatsApp attend l'indicatif pays
/// sans « + » ni « 00 » : `+225 07 00 00 00 00` → `wa.me/2250700000000`.
///
/// [text] pré-remplit le message.
Uri? whatsAppUri(String contact, {String? text}) {
  if (contact.contains('@')) return null;
  var digits = contact.replaceAll(RegExp(r'\D'), '');
  if (digits.startsWith('00')) digits = digits.substring(2);
  if (digits.length < 8) return null;
  return _waMe(digits, text);
}

/// Lien WhatsApp sans destinataire : WhatsApp propose de choisir le contact,
/// message pré-rempli avec [text].
Uri whatsAppShareUri(String text) => _waMe('', text);

// Encodage explicite (%20) : `Uri.https` coderait les espaces en « + », que
// WhatsApp peut afficher tels quels.
Uri _waMe(String digits, String? text) => Uri.parse(
  'https://wa.me/$digits'
  '${text == null ? '' : '?text=${Uri.encodeComponent(text)}'}',
);
