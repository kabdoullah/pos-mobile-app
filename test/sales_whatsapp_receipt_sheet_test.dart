import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:mobile/app/theme/app_theme.dart';
import 'package:mobile/core/widgets/index.dart';
import 'package:mobile/features/auth/domain/entities/store.dart';
import 'package:mobile/features/auth/providers/seller_profile_provider.dart';
import 'package:mobile/features/auth/providers/store_provider.dart';
import 'package:mobile/features/sales/domain/entities/sale.dart';
import 'package:mobile/features/sales/presentation/widgets/whatsapp_receipt_sheet.dart';

class _Store extends StoreConfig {
  @override
  Future<Store?> build() async =>
      const Store(name: 'Boutique Awa', isSubjectToVat: false);
}

class _Seller extends SellerProfile {
  @override
  Future<String?> build() async => null;
}

final _sale = Sale(
  id: 'v1',
  receiptNumber: 0,
  totalAmount: Decimal.fromInt(1500),
  vatAmount: Decimal.zero,
  paymentMethod: PaymentMethod.cash,
  createdAt: DateTime(2026, 11, 24, 9, 5),
  discountAmount: Decimal.zero,
);

void main() {
  setUpAll(() => initializeDateFormatting('fr_FR'));

  /// Affiche la feuille ; renvoie les liens ouverts par le lanceur simulé.
  Future<List<Uri>> pumpSheet(
    WidgetTester tester, {
    bool launchSucceeds = true,
  }) async {
    final opened = <Uri>[];
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          storeConfigProvider.overrideWith(_Store.new),
          sellerProfileProvider.overrideWith(_Seller.new),
        ],
        child: MaterialApp(
          theme: AppTheme.light(),
          home: Scaffold(
            body: WhatsAppReceiptSheet(
              sale: _sale,
              launcher: (uri) async {
                opened.add(uri);
                return launchSucceeds;
              },
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    return opened;
  }

  Future<void> send(WidgetTester tester) async {
    await tester.tap(find.text('Ouvrir WhatsApp'));
    await tester.pumpAndSettle();
  }

  testWidgets('numéro saisi : WhatsApp ouvert sur ce numéro, reçu provisoire', (
    tester,
  ) async {
    final opened = await pumpSheet(tester);
    await tester.enterText(find.byType(AppTextField), '0700000000');
    await send(tester);

    expect(opened, hasLength(1));
    expect(opened.single.path, '/2250700000000');
    final text = opened.single.queryParameters['text']!;
    expect(text, startsWith('*Boutique Awa*'));
    expect(text, contains('Reçu provisoire'));
  });

  testWidgets('numéro vide : WhatsApp propose de choisir le contact', (
    tester,
  ) async {
    final opened = await pumpSheet(tester);
    await send(tester);

    expect(opened.single.path, '/');
    expect(opened.single.queryParameters['text'], contains('Boutique Awa'));
  });

  testWidgets('numéro invalide : erreur, WhatsApp pas ouvert', (tester) async {
    final opened = await pumpSheet(tester);
    // Ligne fixe : pas de WhatsApp.
    await tester.enterText(find.byType(AppTextField), '2720000000');
    await send(tester);

    expect(opened, isEmpty);
    expect(
      find.text('Numéro mobile invalide (ex. 07 00 00 00 00).'),
      findsOneWidget,
    );
  });

  testWidgets('WhatsApp absent : message, la feuille reste ouverte', (
    tester,
  ) async {
    await pumpSheet(tester, launchSucceeds: false);
    await send(tester);

    expect(
      find.text('Impossible d’ouvrir WhatsApp sur ce téléphone.'),
      findsOneWidget,
    );
    expect(find.text('Ouvrir WhatsApp'), findsOneWidget);
  });
}
