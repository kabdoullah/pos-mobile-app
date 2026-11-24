import 'package:flutter_test/flutter_test.dart';

import 'package:mobile/core/utils/whatsapp_link.dart';

void main() {
  group('whatsAppUri', () {
    test('numéro E.164 ou affiché : chiffres seuls, sans « + »', () {
      expect(
        whatsAppUri('+225 07 00 00 00 00').toString(),
        'https://wa.me/2250700000000',
      );
      expect(
        whatsAppUri('002250700000000').toString(),
        'https://wa.me/2250700000000',
      );
    });

    test('email ou valeur trop courte : null', () {
      expect(whatsAppUri('support@exemple.ci'), isNull);
      expect(whatsAppUri('support'), isNull);
      expect(whatsAppUri('12'), isNull);
    });

    test('texte : encodé dans le paramètre « text »', () {
      final uri = whatsAppUri(
        '+2250700000000',
        text: 'Total : 1 500 FCFA\nMerci',
      );
      expect(uri!.path, '/2250700000000');
      expect(uri.queryParameters['text'], 'Total : 1 500 FCFA\nMerci');
    });
  });

  test('whatsAppShareUri : sans numéro, WhatsApp propose ses contacts', () {
    final uri = whatsAppShareUri('Reçu *Boutique*');
    expect(uri.host, 'wa.me');
    expect(uri.path, '/');
    expect(uri.queryParameters['text'], 'Reçu *Boutique*');
  });
}
