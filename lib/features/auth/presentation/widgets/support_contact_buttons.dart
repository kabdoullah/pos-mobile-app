import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/index.dart';

/// Lien WhatsApp (`wa.me`) vers [contact] s'il s'agit d'un numéro de téléphone,
/// null sinon (email, valeur sans chiffres). WhatsApp attend l'indicatif pays
/// sans « + » ni « 00 » : `+225 07 00 00 00 00` → `wa.me/2250700000000`.
Uri? whatsAppUri(String contact) {
  if (contact.contains('@')) return null;
  var digits = contact.replaceAll(RegExp(r'\D'), '');
  if (digits.startsWith('00')) digits = digits.substring(2);
  if (digits.length < 8) return null;
  return Uri.https('wa.me', '/$digits');
}

/// Boutons de contact du support : email (ou appel si le contact est un
/// numéro) et WhatsApp. Rien n'est affiché pour une coordonnée absente.
///
/// [compact] : deux petits boutons côte à côte (dialogues), sinon des boutons
/// pleine largeur (écrans).
class SupportContactButtons extends StatelessWidget {
  /// Crée les boutons pour [contact] (email ou numéro) et [whatsApp].
  const SupportContactButtons({
    required this.contact,
    required this.whatsApp,
    this.compact = false,
    super.key,
  });

  /// Email ou numéro du support, null s'il n'est pas configuré.
  final String? contact;

  /// Numéro WhatsApp dédié ; à défaut, [contact] s'il s'agit d'un numéro.
  final String? whatsApp;

  /// Deux petits boutons côte à côte au lieu de boutons pleine largeur.
  final bool compact;

  static bool _isEmail(String contact) => contact.contains('@');

  Future<void> _open(BuildContext context, Uri uri) async {
    final messenger = ScaffoldMessenger.maybeOf(context);
    var opened = false;
    try {
      opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
    } on Exception catch (_) {
      // Aucune app ne sait ouvrir ce lien : message ci-dessous.
    }
    if (!opened) {
      messenger
        ?..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(content: Text('Impossible d’ouvrir le contact.')),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final contact = this.contact;
    final whatsAppLink = whatsAppUri(whatsApp ?? contact ?? '');
    final contactUri = contact == null
        ? null
        : _isEmail(contact)
        ? Uri(scheme: 'mailto', path: contact)
        : Uri(scheme: 'tel', path: contact.replaceAll(' ', ''));
    final contactIcon = contact != null && _isEmail(contact)
        ? Icons.mail_outline
        : Icons.call_outlined;

    if (compact) {
      return Wrap(
        spacing: AppSpacing.sm,
        runSpacing: AppSpacing.xs,
        children: [
          if (whatsAppLink != null)
            OutlinedButton.icon(
              onPressed: () => _open(context, whatsAppLink),
              icon: const Icon(Icons.chat_outlined, size: 18),
              label: const Text('WhatsApp'),
            ),
          if (contactUri != null)
            OutlinedButton.icon(
              onPressed: () => _open(context, contactUri),
              icon: Icon(contactIcon, size: 18),
              label: Text(_isEmail(contact!) ? 'Email' : 'Appeler'),
            ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (contactUri != null) ...[
          SecondaryButton(
            label: contact!,
            icon: contactIcon,
            onPressed: () => _open(context, contactUri),
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
        if (whatsAppLink != null) ...[
          SecondaryButton(
            label: 'WhatsApp',
            icon: Icons.chat_outlined,
            onPressed: () => _open(context, whatsAppLink),
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
      ],
    );
  }
}
