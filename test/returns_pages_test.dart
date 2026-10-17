import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mobile/app/theme/app_theme.dart';
import 'package:mobile/core/providers/connectivity_provider.dart';
import 'package:mobile/features/auth/presentation/providers/auth_providers.dart';
import 'package:mobile/features/returns/domain/entities/returnable_line.dart';
import 'package:mobile/features/returns/domain/entities/sale_return.dart';
import 'package:mobile/features/returns/domain/repositories/returns_repository.dart';
import 'package:mobile/features/returns/presentation/pages/sale_return_page.dart';
import 'package:mobile/features/returns/presentation/widgets/sale_returns_section.dart';
import 'package:mobile/features/returns/providers/returns_di_providers.dart';
import 'package:mobile/features/sales/domain/entities/sale.dart';

/// Évite l'initialisation de la vraie authentification.
class _NoAuth extends Auth {
  @override
  Future<AuthStatus> build() async => const AuthUnauthenticated();
}

/// Repository en mémoire : la persistance drift est couverte par
/// `returns_repository_test.dart` (drift laisse des timers en test de widget).
class _FakeReturns implements ReturnsRepository {
  _FakeReturns({required this.lines, this.returns = const []});

  final List<ReturnableLine> lines;
  final List<SaleReturn> returns;
  final created = <SaleReturn>[];

  @override
  Stream<List<ReturnableLine>> watchReturnableLines(Sale sale) =>
      Stream.value(lines);

  @override
  Stream<List<SaleReturn>> watchReturnsForSale(String saleId) =>
      Stream.value(returns);

  @override
  Future<SaleReturn> createReturn({
    required String id,
    required String saleId,
    required ReturnReason reason,
    String? note,
    required RefundMethod refundMethod,
    required List<NewReturnLine> lines,
  }) async {
    final saleReturn = SaleReturn(
      id: id,
      saleId: saleId,
      returnNumber: 0,
      reason: reason,
      note: note,
      refundMethod: refundMethod,
      refundAmount: lines.fold(Decimal.zero, (s, l) => s + l.refundAmount),
      createdAt: DateTime(2026, 10, 2, 15),
      syncStatus: ReturnSyncStatus.pending,
      lines: [
        for (final l in lines)
          SaleReturnLine(
            id: 'line-${l.saleItemId}',
            saleItemId: l.saleItemId,
            productId: l.productId,
            quantity: l.quantity,
            condition: l.condition,
            restocked: l.condition.restocks,
            refundAmount: l.refundAmount,
          ),
      ],
    );
    created.add(saleReturn);
    return saleReturn;
  }
}

void main() {
  setUpAll(() => initializeDateFormatting('fr_FR'));

  Sale sale({int receipt = 7}) => Sale(
    id: 'sale-1',
    receiptNumber: receipt,
    totalAmount: Decimal.fromInt(2000),
    vatAmount: Decimal.zero,
    paymentMethod: PaymentMethod.mixed,
    createdAt: DateTime(2026, 10, 1, 9),
    discountAmount: Decimal.zero,
  );

  ReturnableLine coca({int returned = 0}) => ReturnableLine(
    saleItemId: 'coca',
    productId: 'p1',
    productName: 'Coca 33cl',
    unitPrice: Decimal.fromInt(1000),
    discountAmount: Decimal.zero,
    soldQuantity: 2,
    returnedQuantity: returned,
    paidAmount: Decimal.fromInt(2000),
  );

  SaleReturn existing({
    ReturnSyncStatus status = ReturnSyncStatus.synced,
    String? code,
  }) => SaleReturn(
    id: 'r1',
    saleId: 'sale-1',
    returnNumber: 3,
    reason: ReturnReason.defective,
    refundMethod: RefundMethod.cash,
    refundAmount: Decimal.fromInt(2000),
    createdAt: DateTime(2026, 10, 2),
    syncStatus: status,
    rejectionCode: code,
    lines: [
      SaleReturnLine(
        id: 'ri',
        saleItemId: 'coca',
        productId: 'p1',
        quantity: 2,
        condition: ItemCondition.resellable,
        restocked: true,
        refundAmount: Decimal.fromInt(2000),
      ),
    ],
  );

  Future<void> pump(
    WidgetTester tester,
    Widget child,
    _FakeReturns repository, {
    ThemeData? theme,
    double height = 640,
  }) async {
    tester.view.physicalSize = Size(360, height);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authProvider.overrideWith(_NoAuth.new),
          returnsRepositoryProvider.overrideWithValue(repository),
          isOnlineProvider.overrideWith((ref) => Stream.value(false)),
        ],
        child: MaterialApp(
          theme: theme ?? AppTheme.light(),
          home: Scaffold(body: child),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  group('section Retours du détail de vente', () {
    testWidgets('action proposée tant qu’il reste un article', (tester) async {
      await pump(
        tester,
        SaleReturnsSection(sale: sale()),
        _FakeReturns(lines: [coca()]),
      );
      expect(find.text('Retourner des articles'), findsOneWidget);
    });

    testWidgets('plus d’action quand tout est retourné', (tester) async {
      await pump(
        tester,
        SaleReturnsSection(sale: sale()),
        _FakeReturns(lines: [coca(returned: 2)], returns: [existing()]),
      );
      expect(find.text('Retourner des articles'), findsNothing);
      expect(find.text('Retour #3'), findsOneWidget);
      expect(find.text('2 × Coca 33cl · remis en stock'), findsOneWidget);
      expect(find.text('Synchronisé'), findsOneWidget);
    });

    testWidgets('vente non synchronisée : retour indisponible', (tester) async {
      await pump(
        tester,
        SaleReturnsSection(sale: sale(receipt: 0)),
        _FakeReturns(lines: [coca()]),
      );
      expect(find.text('Retourner des articles'), findsNothing);
      expect(
        find.text('Retour possible après synchronisation de la vente.'),
        findsOneWidget,
      );
    });

    testWidgets('retour refusé par le serveur signalé', (tester) async {
      await pump(
        tester,
        SaleReturnsSection(sale: sale()),
        _FakeReturns(
          // Un retour refusé ne compte plus dans les quantités rendues.
          lines: [coca()],
          returns: [
            existing(
              status: ReturnSyncStatus.rejected,
              code: 'quantity_exceeded',
            ),
          ],
        ),
      );
      expect(
        find.text('Ces articles ont déjà été retournés sur un autre appareil.'),
        findsOneWidget,
      );
      expect(find.text('Retourner des articles'), findsOneWidget);
    });
  });

  group('écran de retour', () {
    for (final (name, theme) in [
      ('clair', AppTheme.light()),
      ('sombre', AppTheme.dark()),
    ]) {
      testWidgets('parcours complet, thème $name', (tester) async {
        final repository = _FakeReturns(lines: [coca()]);
        await pump(
          tester,
          SaleReturnPage(sale: sale()),
          repository,
          theme: theme,
        );
        expect(tester.takeException(), isNull);
        expect(find.text('Choisissez au moins un article'), findsOneWidget);

        await tester.tap(find.byTooltip('Augmenter'));
        await tester.pumpAndSettle();
        expect(find.text('Sera remis en stock'), findsOneWidget);
        expect(find.text('Choisissez le motif'), findsOneWidget);

        await tester.scrollUntilVisible(find.text('Produit défectueux'), 100);
        await tester.tap(find.text('Produit défectueux'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Continuer'));
        await tester.pumpAndSettle();

        // Récapitulatif : enregistrement impossible sans attester le
        // remboursement.
        expect(find.text('Confirmer le retour'), findsOneWidget);
        expect(find.text('1 remis en stock'), findsOneWidget);
        await tester.tap(find.text('Enregistrer le retour'));
        await tester.pumpAndSettle();
        expect(find.text('Confirmer le retour'), findsOneWidget);
        expect(repository.created, isEmpty);

        await tester.tap(find.byType(Checkbox));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Enregistrer le retour'));
        await tester.pumpAndSettle();

        expect(find.text('Retour enregistré'), findsWidgets);
        // Actions fixées en bas, toujours visibles.
        expect(find.text('Imprimer le reçu de retour'), findsOneWidget);
        expect(find.text('Terminer'), findsOneWidget);
        await tester.drag(find.byType(ListView), const Offset(0, -300));
        await tester.pumpAndSettle();
        expect(find.text('Enregistré · en attente de synchro'), findsOneWidget);
        expect(tester.takeException(), isNull);
        final saved = repository.created.single;
        expect(saved.refundAmount, Decimal.fromInt(1000));
        expect(saved.refundMethod, RefundMethod.cash);
        expect(saved.reason, ReturnReason.defective);
        expect(saved.lines.single.quantity, 1);
        expect(saved.lines.single.condition, ItemCondition.resellable);
      });
    }

    testWidgets('quantité bornée à la quantité retournable', (tester) async {
      await pump(
        tester,
        SaleReturnPage(sale: sale()),
        _FakeReturns(lines: [coca(returned: 1)]),
      );
      await tester.tap(find.byTooltip('Augmenter'));
      await tester.pumpAndSettle();
      final increase = tester.widget<IconButton>(
        find.ancestor(
          of: find.byTooltip('Augmenter'),
          matching: find.byType(IconButton),
        ),
      );
      expect(increase.onPressed, isNull);
    });

    testWidgets('motif « Autre » : commentaire exigé près du champ', (
      tester,
    ) async {
      // Écran haut : motif et champ visibles sans défilement.
      await pump(
        tester,
        SaleReturnPage(sale: sale()),
        _FakeReturns(lines: [coca()]),
        height: 1400,
      );
      await tester.tap(find.byTooltip('Augmenter'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Autre'));
      await tester.pumpAndSettle();

      expect(find.text('Commentaire obligatoire'), findsOneWidget);

      await tester.enterText(find.byType(TextField), 'Taille trop petite');
      await tester.pumpAndSettle();
      expect(find.text('Commentaire obligatoire'), findsNothing);
    });

    testWidgets('vente mixte : moyen de remboursement à choisir', (
      tester,
    ) async {
      await pump(
        tester,
        SaleReturnPage(sale: sale()),
        _FakeReturns(lines: [coca()]),
      );
      await tester.scrollUntilVisible(
        find.textContaining('Vente payée en mixte'),
        100,
      );
      expect(find.textContaining('Vente payée en mixte'), findsOneWidget);
      final cash = tester.widget<ChoiceChip>(
        find.widgetWithText(ChoiceChip, 'Espèces'),
      );
      expect(cash.selected, isTrue);
    });

    testWidgets('plus rien à retourner : écran explicite', (tester) async {
      await pump(
        tester,
        SaleReturnPage(sale: sale()),
        _FakeReturns(lines: [coca(returned: 2)]),
      );
      expect(find.text('Tout a déjà été retourné'), findsOneWidget);
    });
  });
}
