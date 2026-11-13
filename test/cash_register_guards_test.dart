import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mobile/app/theme/app_theme.dart';
import 'package:mobile/core/providers/connectivity_provider.dart';
import 'package:mobile/core/sync/sync_orchestrator.dart';
import 'package:mobile/core/sync/sync_providers.dart';
import 'package:mobile/features/auth/domain/entities/user.dart';
import 'package:mobile/features/auth/presentation/providers/auth_providers.dart';
import 'package:mobile/features/cash_register/domain/entities/cash_session.dart';
import 'package:mobile/features/cash_register/domain/repositories/cash_register_repository.dart';
import 'package:mobile/features/cash_register/presentation/providers/cash_register_providers.dart';
import 'package:mobile/features/cash_register/presentation/widgets/open_cash_session_sheet.dart';
import 'package:mobile/features/cash_register/providers/cash_register_di_providers.dart';
import 'package:mobile/features/catalog/domain/entities/product.dart';
import 'package:mobile/features/returns/domain/entities/returnable_line.dart';
import 'package:mobile/features/returns/domain/entities/sale_return.dart';
import 'package:mobile/features/returns/domain/usecases/create_sale_return_usecase.dart';
import 'package:mobile/features/returns/presentation/providers/returns_providers.dart';
import 'package:mobile/features/returns/providers/returns_di_providers.dart';
import 'package:mobile/features/sales/domain/entities/cart_item.dart';
import 'package:mobile/features/sales/domain/entities/sale.dart';
import 'package:mobile/features/sales/domain/usecases/create_sale_usecase.dart';
import 'package:mobile/features/sales/presentation/providers/cart_provider.dart';
import 'package:mobile/features/sales/presentation/providers/checkout_provider.dart';
import 'package:mobile/features/sales/presentation/providers/sales_providers.dart';
import 'package:mobile/features/sales/providers/sales_di_providers.dart';
import 'package:mobile/features/settings/presentation/pages/settings_page.dart';
import 'package:mocktail/mocktail.dart';

class _MockCashRegister extends Mock implements CashRegisterRepository {}

class _MockCreateSale extends Mock implements CreateSaleUseCase {}

class _MockCreateReturn extends Mock implements CreateSaleReturnUseCase {}

class _Authenticated extends Auth {
  @override
  Future<AuthStatus> build() async =>
      const AuthAuthenticated(User(id: 'u1', phoneNumber: '+2250700000000'));
}

/// Synchro figée (pas de timers ni d'appels réseau).
class _IdleSync extends SyncOrchestrator {
  @override
  SyncStatus build() => const SyncStatusIdle();
}

/// Compte les synchros demandées.
class _CountingSync extends SyncOrchestrator {
  int calls = 0;

  @override
  SyncStatus build() => const SyncStatusIdle();

  @override
  Future<void> syncNow({bool forceFullPull = false}) async => calls++;
}

Decimal d(String value) => Decimal.parse(value);

final _openSession = CashSession(
  id: 'session-1',
  deviceId: 'device-1',
  status: CashSessionStatus.open,
  openingAmount: d('10000'),
  openedAt: DateTime.utc(2026, 11, 10, 8),
  syncStatus: CashSyncStatus.synced,
  serverRecalculated: false,
);

final _coca = Product(
  id: 'p1',
  name: 'Coca-Cola 33cl',
  sellingPrice: d('1000'),
  updatedAt: DateTime(2026),
);

Sale _sale({PaymentMethod method = PaymentMethod.cash}) => Sale(
  id: 'sale-1',
  receiptNumber: 7,
  totalAmount: d('2000'),
  vatAmount: Decimal.zero,
  discountAmount: Decimal.zero,
  paymentMethod: method,
  createdAt: DateTime(2026),
);

final _line = ReturnableLine(
  saleItemId: 'coca',
  productId: 'p1',
  productName: 'Coca-Cola 33cl',
  unitPrice: d('1000'),
  discountAmount: Decimal.zero,
  soldQuantity: 2,
  returnedQuantity: 0,
  paidAmount: d('2000'),
);

SaleReturn _savedReturn(RefundMethod method) => SaleReturn(
  id: 'r1',
  saleId: 'sale-1',
  returnNumber: 0,
  reason: ReturnReason.defective,
  refundMethod: method,
  refundAmount: d('1000'),
  createdAt: DateTime(2026),
  syncStatus: ReturnSyncStatus.pending,
  lines: const [],
);

void main() {
  late _MockCashRegister cash;

  setUpAll(() {
    registerFallbackValue(PaymentMethod.cash);
    registerFallbackValue(RefundMethod.cash);
    registerFallbackValue(ReturnReason.defective);
    registerFallbackValue(Decimal.zero);
    registerFallbackValue(<CartItem>[]);
    registerFallbackValue(<ReturnSelection>[]);
    registerFallbackValue(_sale());
    return initializeDateFormatting('fr_FR');
  });

  setUp(() => cash = _MockCashRegister());

  group('encaissement', () {
    late _MockCreateSale useCase;
    late ProviderContainer container;

    When<Future<Sale>> whenCreateSale() => when(
      () => useCase(
        items: any(named: 'items'),
        discount: any(named: 'discount'),
        totalAmount: any(named: 'totalAmount'),
        vatAmount: any(named: 'vatAmount'),
        paymentMethod: any(named: 'paymentMethod'),
        cashAmount: any(named: 'cashAmount'),
        mobileMoneyAmount: any(named: 'mobileMoneyAmount'),
        cashSessionId: any(named: 'cashSessionId'),
      ),
    );

    setUp(() {
      useCase = _MockCreateSale();
      container = ProviderContainer(
        overrides: [
          createSaleUseCaseProvider.overrideWithValue(useCase),
          cashRegisterRepositoryProvider.overrideWithValue(cash),
          isOnlineProvider.overrideWith((ref) => Stream.value(false)),
        ],
      );
      addTearDown(container.dispose);
      container
        ..listen(cartProvider, (_, _) {})
        ..listen(checkoutProvider, (_, _) {});
      container.read(cartProvider.notifier).addItem(_coca, quantity: 2);
      container.read(checkoutProvider.notifier).setCashReceived(d('5000'));
    });

    test('submit without open session throws and keeps cart', () async {
      when(cash.getActiveSession).thenAnswer((_) async => null);

      await expectLater(
        container.read(saleSubmissionProvider.notifier).submit(),
        throwsA(
          isA<CashRegisterException>().having(
            (e) => e.code,
            'code',
            CashRegisterException.noOpenSession,
          ),
        ),
      );

      verifyNever(
        () => useCase(
          items: any(named: 'items'),
          discount: any(named: 'discount'),
          totalAmount: any(named: 'totalAmount'),
          vatAmount: any(named: 'vatAmount'),
          paymentMethod: any(named: 'paymentMethod'),
          cashAmount: any(named: 'cashAmount'),
          mobileMoneyAmount: any(named: 'mobileMoneyAmount'),
          cashSessionId: any(named: 'cashSessionId'),
        ),
      );
      expect(container.read(cartProvider).unitCount, 2);
      expect(container.read(checkoutProvider).cashReceived, d('5000'));
      expect(container.read(saleSubmissionProvider), isFalse);
    });

    test('submit with session attaches it', () async {
      when(cash.getActiveSession).thenAnswer((_) async => _openSession);
      whenCreateSale().thenAnswer((_) async => _sale());

      final completed = await container
          .read(saleSubmissionProvider.notifier)
          .submit();

      expect(completed?.sale.id, 'sale-1');
      verify(
        () => useCase(
          items: any(named: 'items'),
          discount: any(named: 'discount'),
          totalAmount: d('2000'),
          vatAmount: Decimal.zero,
          paymentMethod: PaymentMethod.cash,
          cashAmount: null,
          mobileMoneyAmount: null,
          cashSessionId: 'session-1',
        ),
      ).called(1);
      expect(container.read(cartProvider).isEmpty, isTrue);
    });
  });

  group('retour', () {
    late _MockCreateReturn useCase;
    late ProviderContainer container;

    When<Future<SaleReturn>> whenCreateReturn() => when(
      () => useCase(
        returnId: any(named: 'returnId'),
        sale: any(named: 'sale'),
        selections: any(named: 'selections'),
        reason: any(named: 'reason'),
        note: any(named: 'note'),
        refundMethod: any(named: 'refundMethod'),
        cashSessionId: any(named: 'cashSessionId'),
      ),
    );

    Future<SaleReturn> submit(RefundMethod method) => container
        .read(saleReturnSubmissionProvider.notifier)
        .submit(
          sale: _sale(),
          lines: [_line],
          draft: ReturnDraftState(
            returnId: 'r1',
            quantities: const {'coca': 1},
            reason: ReturnReason.defective,
            refundMethod: method,
          ),
        );

    setUp(() {
      useCase = _MockCreateReturn();
      container = ProviderContainer(
        overrides: [
          createSaleReturnUseCaseProvider.overrideWithValue(useCase),
          cashRegisterRepositoryProvider.overrideWithValue(cash),
          // Hors ligne : pas de synchro (pas de plugin de connectivité en test).
          isOnlineProvider.overrideWith((ref) => Stream.value(false)),
        ],
      );
      addTearDown(container.dispose);
      whenCreateReturn().thenAnswer(
        (inv) async =>
            _savedReturn(inv.namedArguments[#refundMethod] as RefundMethod),
      );
    });

    test('cash refund without session refused, wave refund allowed', () async {
      when(cash.getActiveSession).thenAnswer((_) async => null);

      await expectLater(
        submit(RefundMethod.cash),
        throwsA(
          isA<CashRegisterException>().having(
            (e) => e.code,
            'code',
            CashRegisterException.noOpenSession,
          ),
        ),
      );
      verifyNever(
        () => useCase(
          returnId: any(named: 'returnId'),
          sale: any(named: 'sale'),
          selections: any(named: 'selections'),
          reason: any(named: 'reason'),
          note: any(named: 'note'),
          refundMethod: any(named: 'refundMethod'),
          cashSessionId: any(named: 'cashSessionId'),
        ),
      );

      final saved = await submit(RefundMethod.wave);
      expect(saved.refundMethod, RefundMethod.wave);
      verify(
        () => useCase(
          returnId: 'r1',
          sale: any(named: 'sale'),
          selections: any(named: 'selections'),
          reason: ReturnReason.defective,
          note: any(named: 'note'),
          refundMethod: RefundMethod.wave,
          cashSessionId: null,
        ),
      ).called(1);
    });

    test('a saved return is synced right away when online', () async {
      when(cash.getActiveSession).thenAnswer((_) async => _openSession);
      final sync = _CountingSync();
      final online = ProviderContainer(
        overrides: [
          createSaleReturnUseCaseProvider.overrideWithValue(useCase),
          cashRegisterRepositoryProvider.overrideWithValue(cash),
          isOnlineProvider.overrideWith((ref) => Stream.value(true)),
          syncOrchestratorProvider.overrideWith(() => sync),
        ],
      );
      addTearDown(online.dispose);
      // Écouté comme dans l'app : un provider sans écouteur reste en pause.
      online.listen(isOnlineProvider, (_, _) {});
      await online.read(isOnlineProvider.future);

      await online
          .read(saleReturnSubmissionProvider.notifier)
          .submit(
            sale: _sale(),
            lines: [_line],
            draft: const ReturnDraftState(
              returnId: 'r1',
              quantities: {'coca': 1},
              reason: ReturnReason.defective,
              refundMethod: RefundMethod.cash,
            ),
          );

      expect(sync.calls, 1);
    });

    test('a refused return does not trigger a sync', () async {
      when(cash.getActiveSession).thenAnswer((_) async => null);
      final sync = _CountingSync();
      final online = ProviderContainer(
        overrides: [
          createSaleReturnUseCaseProvider.overrideWithValue(useCase),
          cashRegisterRepositoryProvider.overrideWithValue(cash),
          isOnlineProvider.overrideWith((ref) => Stream.value(true)),
          syncOrchestratorProvider.overrideWith(() => sync),
        ],
      );
      addTearDown(online.dispose);
      online.listen(isOnlineProvider, (_, _) {});
      await online.read(isOnlineProvider.future);

      await expectLater(
        online
            .read(saleReturnSubmissionProvider.notifier)
            .submit(
              sale: _sale(),
              lines: [_line],
              draft: const ReturnDraftState(
                returnId: 'r1',
                quantities: {'coca': 1},
                reason: ReturnReason.defective,
                refundMethod: RefundMethod.cash,
              ),
            ),
        throwsA(isA<CashRegisterException>()),
      );
      expect(sync.calls, 0);
    });

    test('cash refund with session attaches it', () async {
      when(cash.getActiveSession).thenAnswer((_) async => _openSession);

      await submit(RefundMethod.cash);

      verify(
        () => useCase(
          returnId: 'r1',
          sale: any(named: 'sale'),
          selections: any(named: 'selections'),
          reason: ReturnReason.defective,
          note: any(named: 'note'),
          refundMethod: RefundMethod.cash,
          cashSessionId: 'session-1',
        ),
      ).called(1);
    });
  });

  group('déconnexion', () {
    Future<void> pumpSettings(WidgetTester tester) async {
      tester.view.physicalSize = const Size(360, 640);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      FlutterSecureStorage.setMockInitialValues({});
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authProvider.overrideWith(_Authenticated.new),
            syncOrchestratorProvider.overrideWith(_IdleSync.new),
            isOnlineProvider.overrideWith((ref) => Stream.value(true)),
            pendingSyncCountProvider.overrideWith((ref) => Stream.value(0)),
            cashRegisterRepositoryProvider.overrideWithValue(cash),
          ],
          child: MaterialApp(
            theme: AppTheme.light(),
            home: const SettingsPage(),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(find.text('Se déconnecter'), 200);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Se déconnecter'));
      await tester.pumpAndSettle();
    }

    testWidgets('logout blocked while session open', (tester) async {
      when(cash.getActiveSession).thenAnswer((_) async => _openSession);

      await pumpSettings(tester);

      expect(
        find.text('Clôturez la caisse avant de vous déconnecter.'),
        findsOneWidget,
      );
      expect(find.text('Se déconnecter ?'), findsNothing);
      expect(tester.takeException(), isNull);
    });

    testWidgets('logout blocked while a close waits for a note', (
      tester,
    ) async {
      // Clôture refusée faute de commentaire : la session reste ouverte côté
      // serveur, son entrée de file est « rejected ».
      when(cash.getActiveSession).thenAnswer((_) async => null);
      when(cash.hasCloseAwaitingNote).thenAnswer((_) async => true);
      when(cash.hasPendingCashOperations).thenAnswer((_) async => false);

      await pumpSettings(tester);

      expect(
        find.text(
          'Une clôture de caisse attend un commentaire : complétez-la avant '
          'de vous déconnecter.',
        ),
        findsOneWidget,
      );
      expect(find.text('Se déconnecter ?'), findsNothing);
      expect(tester.takeException(), isNull);
    });

    testWidgets('logout blocked while a cash close is queued', (tester) async {
      // Session clôturée sur l'appareil, clôture pas encore envoyée.
      when(cash.getActiveSession).thenAnswer((_) async => null);
      when(cash.hasCloseAwaitingNote).thenAnswer((_) async => false);
      when(cash.hasPendingCashOperations).thenAnswer((_) async => true);

      await pumpSettings(tester);

      expect(
        find.text(
          'Des opérations de caisse ne sont pas encore synchronisées. '
          'Connectez-vous à internet et synchronisez avant de vous '
          'déconnecter.',
        ),
        findsOneWidget,
      );
      expect(find.text('Se déconnecter ?'), findsNothing);
      expect(tester.takeException(), isNull);
    });

    testWidgets('logout confirm shown without open session', (tester) async {
      when(cash.getActiveSession).thenAnswer((_) async => null);
      when(cash.hasCloseAwaitingNote).thenAnswer((_) async => false);
      when(cash.hasPendingCashOperations).thenAnswer((_) async => false);

      await pumpSettings(tester);

      expect(find.text('Se déconnecter ?'), findsOneWidget);
      expect(
        find.text('Clôturez la caisse avant de vous déconnecter.'),
        findsNothing,
      );
    });
  });

  group('ouverture de caisse', () {
    test('le contrôleur ouvre la session puis synchronise en ligne', () async {
      when(cash.getActiveSession).thenAnswer((_) async => null);
      when(
        () => cash.openSession(
          openingAmount: any(named: 'openingAmount'),
          note: any(named: 'note'),
        ),
      ).thenAnswer((_) async => _openSession);
      final sync = _CountingSync();
      final container = ProviderContainer(
        overrides: [
          cashRegisterRepositoryProvider.overrideWithValue(cash),
          isOnlineProvider.overrideWith((ref) => Stream.value(true)),
          syncOrchestratorProvider.overrideWith(() => sync),
        ],
      );
      addTearDown(container.dispose);
      // Écouté comme dans l'app : un provider sans écouteur reste en pause.
      container.listen(isOnlineProvider, (_, _) {});
      await container.read(isOnlineProvider.future);

      final session = await container
          .read(cashRegisterControllerProvider.notifier)
          .open(openingAmount: d('10000'), note: '  ');

      expect(session.id, 'session-1');
      verify(
        () => cash.openSession(openingAmount: d('10000'), note: null),
      ).called(1);
      expect(sync.calls, 1);
    });

    Future<Future<bool>> pumpSheet(
      WidgetTester tester, {
      bool dark = false,
    }) async {
      late Future<bool> result;
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            cashRegisterRepositoryProvider.overrideWithValue(cash),
            isOnlineProvider.overrideWith((ref) => Stream.value(false)),
          ],
          child: MaterialApp(
            theme: dark ? AppTheme.dark() : AppTheme.light(),
            home: Scaffold(
              body: Builder(
                builder: (context) => TextButton(
                  onPressed: () => result = showOpenCashSessionSheet(context),
                  child: const Text('ouvrir'),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('ouvrir'));
      await tester.pumpAndSettle();
      return result;
    }

    testWidgets('la feuille ouvre la caisse et se ferme', (tester) async {
      when(cash.getActiveSession).thenAnswer((_) async => null);
      when(
        () => cash.openSession(
          openingAmount: any(named: 'openingAmount'),
          note: any(named: 'note'),
        ),
      ).thenAnswer((_) async => _openSession);
      final result = await pumpSheet(tester);

      await tester.enterText(find.byType(TextField).first, '15000');
      await tester.tap(find.text('Ouvrir la caisse').last);
      await tester.pumpAndSettle();

      expect(await result, isTrue);
      expect(find.text('Fond de caisse'), findsNothing);
      verify(
        () => cash.openSession(openingAmount: d('15000'), note: null),
      ).called(1);
    });

    testWidgets('la feuille affiche le refus en français', (tester) async {
      when(cash.getActiveSession).thenAnswer((_) async => _openSession);
      await pumpSheet(tester);

      await tester.enterText(find.byType(TextField).first, '15000');
      await tester.tap(find.text('Ouvrir la caisse').last);
      await tester.pumpAndSettle();

      expect(
        find.text('Une caisse est déjà ouverte sur cet appareil.'),
        findsOneWidget,
      );
      verifyNever(
        () => cash.openSession(
          openingAmount: any(named: 'openingAmount'),
          note: any(named: 'note'),
        ),
      );
    });

    testWidgets('la feuille s’affiche en thème sombre', (tester) async {
      tester.view.physicalSize = const Size(360, 640);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await pumpSheet(tester, dark: true);

      expect(find.text('Fond de caisse'), findsOneWidget);
      expect(find.text('Ajouter un commentaire'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
