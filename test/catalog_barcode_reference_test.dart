import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:mobile/app/theme/app_theme.dart';
import 'package:mobile/features/catalog/data/repositories/barcode_reference_repository_impl.dart';
import 'package:mobile/features/catalog/domain/repositories/catalog_repository.dart';
import 'package:mobile/features/catalog/presentation/pages/product_form_page.dart';
import 'package:mobile/features/catalog/providers/catalog_di_providers.dart';

class _MockCatalog extends Mock implements CatalogRepository {}

const _reference = {
  '6181100099126': 'EAU MINERALE CELESTE 0.5L',
  // UPC-A enregistré sur 12 chiffres.
  '036000291452': 'MOUCHOIRS 12X',
  // UPC-A enregistré en EAN-13 (zéro de tête).
  '0012345678905': 'BISCUIT TEST',
};

BarcodeReferenceRepositoryImpl _repo({void Function()? onLoad}) {
  return BarcodeReferenceRepositoryImpl(
    loadJson: () async {
      onLoad?.call();
      return jsonEncode(_reference);
    },
  );
}

void main() {
  group('BarcodeReferenceRepositoryImpl', () {
    test('suggère le nom d\'un EAN-13 connu', () async {
      expect(
        await _repo().suggestName('6181100099126'),
        'EAU MINERALE CELESTE 0.5L',
      );
    });

    test('retrouve un UPC-A quelle que soit la forme lue', () async {
      final repo = _repo();
      expect(await repo.suggestName('0036000291452'), 'MOUCHOIRS 12X');
      expect(await repo.suggestName('012345678905'), 'BISCUIT TEST');
    });

    test('ignore les espaces et caractères de contrôle du scanner', () async {
      expect(
        await _repo().suggestName(' \x1D6181100099126 '),
        'EAU MINERALE CELESTE 0.5L',
      );
    });

    test('null pour un code inconnu', () async {
      expect(await _repo().suggestName('3000000000005'), isNull);
    });

    test('code invalide : null sans charger le référentiel', () async {
      var loads = 0;
      final repo = _repo(onLoad: () => loads++);
      expect(await repo.suggestName('660'), isNull);
      expect(loads, 0);
    });

    test('charge le référentiel une seule fois', () async {
      var loads = 0;
      final repo = _repo(onLoad: () => loads++);
      await Future.wait([
        repo.suggestName('6181100099126'),
        repo.suggestName('036000291452'),
      ]);
      await repo.suggestName('3000000000005');
      expect(loads, 1);
    });

    test('après un échec de lecture, réessaie au scan suivant', () async {
      var attempts = 0;
      final repo = BarcodeReferenceRepositoryImpl(
        loadJson: () async {
          attempts++;
          if (attempts == 1) throw const FormatException('corrompu');
          return jsonEncode(_reference);
        },
      );
      await expectLater(
        repo.suggestName('6181100099126'),
        throwsA(isA<FormatException>()),
      );
      expect(
        await repo.suggestName('6181100099126'),
        'EAU MINERALE CELESTE 0.5L',
      );
    });

    test(
      'l\'asset embarqué est lisible et sans code à usage interne',
      () async {
        final file = File(BarcodeReferenceRepositoryImpl.assetPath);
        final decoded =
            jsonDecode(file.readAsStringSync()) as Map<String, Object?>;
        expect(decoded.length, greaterThan(5000));
        expect(decoded.values, everyElement(isA<String>()));
        // Préfixe 2 : codes attribués par chaque magasin (GS1).
        expect(
          decoded.keys.where((k) => k.length == 13 && k.startsWith('2')),
          isEmpty,
        );
        final repo = BarcodeReferenceRepositoryImpl(
          loadJson: () async => file.readAsStringSync(),
        );
        expect(await repo.suggestName('6181100099126'), isNotNull);
      },
    );
  });

  group('ProductFormPage', () {
    Future<void> pumpForm(WidgetTester tester, String barcode) async {
      final catalog = _MockCatalog();
      when(catalog.watchCategories).thenAnswer((_) => Stream.value(const []));
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            catalogRepositoryProvider.overrideWithValue(catalog),
            barcodeReferenceRepositoryProvider.overrideWithValue(_repo()),
          ],
          child: MaterialApp(
            theme: AppTheme.light(),
            home: ProductFormPage(initialBarcode: barcode),
          ),
        ),
      );
      await tester.pumpAndSettle();
    }

    String nameText(WidgetTester tester) =>
        tester.widget<TextField>(find.byType(TextField).first).controller!.text;

    testWidgets('pré-remplit le nom d\'un code-barres connu', (tester) async {
      await pumpForm(tester, '6181100099126');

      expect(nameText(tester), 'EAU MINERALE CELESTE 0.5L');
      expect(find.textContaining('Nom suggéré'), findsOneWidget);
    });

    testWidgets('l\'indication disparaît dès que le nom est retouché', (
      tester,
    ) async {
      await pumpForm(tester, '6181100099126');

      await tester.enterText(find.byType(TextField).first, 'Eau Céleste 50cl');
      await tester.pump();

      expect(find.textContaining('Nom suggéré'), findsNothing);
    });

    testWidgets('code inconnu : nom vide, pas d\'indication', (tester) async {
      await pumpForm(tester, '3000000000005');

      expect(nameText(tester), isEmpty);
      expect(find.textContaining('Nom suggéré'), findsNothing);
    });
  });
}
