import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

import 'package:mobile/app/theme/app_theme.dart';
import 'package:mobile/core/router/app_router.dart';
import 'package:mobile/core/widgets/index.dart';
import 'package:mobile/features/catalog/data/repositories/barcode_reference_repository_impl.dart';
import 'package:mobile/features/catalog/domain/entities/product.dart';
import 'package:mobile/features/catalog/domain/repositories/barcode_reference_repository.dart';
import 'package:mobile/features/catalog/domain/repositories/catalog_repository.dart';
import 'package:mobile/features/catalog/presentation/pages/product_form_page.dart';
import 'package:mobile/features/catalog/providers/catalog_di_providers.dart';

class _MockCatalog extends Mock implements CatalogRepository {}

/// Écran de scan simulé : renvoie [code] dès son affichage.
class _FakeScanner extends StatefulWidget {
  const _FakeScanner({required this.code});

  final String code;

  @override
  State<_FakeScanner> createState() => _FakeScannerState();
}

class _FakeScannerState extends State<_FakeScanner> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => context.pop(widget.code),
    );
  }

  @override
  Widget build(BuildContext context) => const SizedBox();
}

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
      'échec synchrone de lecture : réessaie aussi au scan suivant',
      () async {
        var attempts = 0;
        final repo = BarcodeReferenceRepositoryImpl(
          loadJson: () {
            attempts++;
            if (attempts == 1) throw StateError('asset absent');
            return Future.value(jsonEncode(_reference));
          },
        );
        await expectLater(
          repo.suggestName('6181100099126'),
          throwsA(isA<StateError>()),
        );
        expect(
          await repo.suggestName('6181100099126'),
          'EAU MINERALE CELESTE 0.5L',
        );
      },
    );

    test(
      'l\'asset embarqué est lisible et sans code à usage interne',
      () async {
        final file = File(BarcodeReferenceRepositoryImpl.assetPath);
        final decoded =
            jsonDecode(file.readAsStringSync()) as Map<String, Object?>;
        expect(decoded.length, greaterThan(5000));
        expect(decoded.values, everyElement(isA<String>()));
        // Ni GTIN-14 (cartons), ni codes GS1 attribués par chaque magasin.
        bool restricted(String k) {
          if (k.length == 8) return k.startsWith('0') || k.startsWith('2');
          final padded = k.padLeft(13, '0');
          return padded.startsWith('2') ||
              padded.startsWith('02') ||
              padded.startsWith('04');
        }

        expect(decoded.keys.where((k) => k.length > 13), isEmpty);
        expect(decoded.keys.where(restricted), isEmpty);
        final repo = BarcodeReferenceRepositoryImpl(
          loadJson: () async => file.readAsStringSync(),
        );
        expect(await repo.suggestName('6181100099126'), isNotNull);
      },
    );
  });

  group('ProductFormPage', () {
    Future<void> pumpForm(
      WidgetTester tester, {
      String? initialBarcode,
      String? productId,
      BarcodeReferenceRepository? reference,
      List<String> scans = const [],
      bool settle = true,
    }) async {
      final catalog = _MockCatalog();
      when(catalog.watchCategories).thenAnswer((_) => Stream.value(const []));
      when(() => catalog.getProduct(any())).thenAnswer(
        (_) async => Product(
          id: 'p1',
          name: 'Coca',
          sellingPrice: Decimal.fromInt(500),
          updatedAt: DateTime(2026),
        ),
      );
      final pendingScans = [...scans];
      final router = GoRouter(
        initialLocation: '/form',
        routes: [
          GoRoute(
            path: '/form',
            builder: (_, _) => ProductFormPage(
              productId: productId,
              initialBarcode: initialBarcode,
            ),
          ),
          GoRoute(
            path: Routes.barcodeScanner,
            builder: (_, _) => _FakeScanner(code: pendingScans.removeAt(0)),
          ),
        ],
      );
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            catalogRepositoryProvider.overrideWithValue(catalog),
            barcodeReferenceRepositoryProvider.overrideWithValue(
              reference ?? _repo(),
            ),
          ],
          child: MaterialApp.router(
            theme: AppTheme.light(),
            routerConfig: router,
          ),
        ),
      );
      if (settle) await tester.pumpAndSettle();
    }

    Finder field(String label) => find.descendant(
      of: find.widgetWithText(AppTextField, label),
      matching: find.byType(TextField),
    );

    String text(WidgetTester tester, String label) =>
        tester.widget<TextField>(field(label)).controller!.text;

    String nameText(WidgetTester tester) => text(tester, 'Nom du produit');

    final hint = find.textContaining('Nom suggéré');

    Future<void> scan(WidgetTester tester) async {
      final button = find.text('Scanner');
      await tester.ensureVisible(button);
      await tester.tap(button);
      await tester.pumpAndSettle();
    }

    testWidgets('pré-remplit le nom d\'un code-barres connu', (tester) async {
      await pumpForm(tester, initialBarcode: '6181100099126');

      expect(nameText(tester), 'EAU MINERALE CELESTE 0.5L');
      expect(hint, findsOneWidget);
    });

    testWidgets('l\'indication disparaît dès que le nom est retouché', (
      tester,
    ) async {
      await pumpForm(tester, initialBarcode: '6181100099126');

      await tester.enterText(field('Nom du produit'), 'Eau Céleste 50cl');
      await tester.pump();

      expect(hint, findsNothing);
    });

    testWidgets('code inconnu : nom vide, pas d\'indication', (tester) async {
      await pumpForm(tester, initialBarcode: '3000000000005');

      expect(nameText(tester), isEmpty);
      expect(hint, findsNothing);
    });

    testWidgets('un nom tapé pendant la recherche est conservé', (
      tester,
    ) async {
      final json = Completer<String>();
      await pumpForm(
        tester,
        initialBarcode: '6181100099126',
        reference: BarcodeReferenceRepositoryImpl(loadJson: () => json.future),
      );

      await tester.enterText(field('Nom du produit'), 'Mon eau');
      json.complete(jsonEncode(_reference));
      await tester.pumpAndSettle();

      expect(nameText(tester), 'Mon eau');
      expect(hint, findsNothing);
    });

    testWidgets('un nouveau scan remplace le nom suggéré, ou l\'efface', (
      tester,
    ) async {
      await pumpForm(
        tester,
        scans: ['6181100099126', '036000291452', '3000000000005'],
      );

      await scan(tester);
      expect(nameText(tester), 'EAU MINERALE CELESTE 0.5L');

      await scan(tester);
      expect(text(tester, 'Code-barres'), '036000291452');
      expect(nameText(tester), 'MOUCHOIRS 12X');
      expect(hint, findsOneWidget);

      await scan(tester);
      expect(nameText(tester), isEmpty);
      expect(hint, findsNothing);
    });

    testWidgets('un nouveau scan ne remplace jamais un nom saisi', (
      tester,
    ) async {
      await pumpForm(tester, scans: ['6181100099126']);

      await tester.enterText(field('Nom du produit'), 'Eau du coin');
      await scan(tester);

      expect(nameText(tester), 'Eau du coin');
      expect(hint, findsNothing);
    });

    testWidgets('modifier le code-barres retire le nom suggéré', (
      tester,
    ) async {
      await pumpForm(tester, initialBarcode: '6181100099126');

      await tester.enterText(field('Code-barres'), '618110009912');
      await tester.pump();

      expect(nameText(tester), isEmpty);
      expect(hint, findsNothing);
    });

    testWidgets('en modification, un scan ne suggère rien', (tester) async {
      await pumpForm(tester, productId: 'p1', scans: ['6181100099126']);
      expect(nameText(tester), 'Coca');

      await tester.enterText(field('Nom du produit'), '');
      await scan(tester);

      expect(text(tester, 'Code-barres'), '6181100099126');
      expect(nameText(tester), isEmpty);
      expect(hint, findsNothing);
    });

    testWidgets('référentiel illisible : saisie manuelle, sans plantage', (
      tester,
    ) async {
      await pumpForm(
        tester,
        initialBarcode: '6181100099126',
        reference: BarcodeReferenceRepositoryImpl(
          loadJson: () async => throw const FormatException('corrompu'),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(nameText(tester), isEmpty);
      expect(hint, findsNothing);
    });

    testWidgets('page fermée avant la fin de la recherche : sans erreur', (
      tester,
    ) async {
      final json = Completer<String>();
      await pumpForm(
        tester,
        initialBarcode: '6181100099126',
        reference: BarcodeReferenceRepositoryImpl(loadJson: () => json.future),
        settle: false,
      );

      await tester.pumpWidget(const SizedBox());
      json.complete(jsonEncode(_reference));
      await tester.pump();

      expect(tester.takeException(), isNull);
    });
  });
}
