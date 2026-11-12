import 'dart:async';
import 'dart:io';
import 'dart:math' as math;

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mobile/app/theme/app_colors.dart';
import 'package:mobile/app/theme/app_theme.dart';
import 'package:mobile/core/providers/connectivity_provider.dart';
import 'package:mobile/core/router/app_router.dart';
import 'package:mobile/core/sync/sync_orchestrator.dart';
import 'package:mobile/core/sync/sync_providers.dart';
import 'package:mobile/core/widgets/index.dart';
import 'package:mobile/features/auth/presentation/providers/auth_providers.dart';
import 'package:mobile/features/cash_register/domain/entities/cash_movement.dart';
import 'package:mobile/features/cash_register/domain/entities/cash_session.dart';
import 'package:mobile/features/cash_register/domain/entities/cash_session_detail.dart';
import 'package:mobile/features/cash_register/domain/entities/cash_summary.dart';
import 'package:mobile/features/cash_register/domain/repositories/cash_register_repository.dart';
import 'package:mobile/features/cash_register/presentation/pages/cash_register_page.dart';
import 'package:mobile/features/cash_register/presentation/providers/cash_register_providers.dart';
import 'package:mobile/features/cash_register/presentation/pages/cash_session_detail_page.dart';
import 'package:mobile/features/cash_register/presentation/pages/cash_session_history_page.dart';
import 'package:mobile/features/cash_register/presentation/pages/close_cash_session_page.dart';
import 'package:mobile/features/cash_register/presentation/widgets/cash_movement_tile.dart';
import 'package:mobile/features/cash_register/presentation/widgets/discrepancy_badge.dart';
import 'package:mobile/features/cash_register/providers/cash_register_di_providers.dart';
import 'package:mobile/features/home/presentation/pages/home_page.dart';
import 'package:mobile/features/home/presentation/providers/home_providers.dart';
import 'package:mocktail/mocktail.dart';

class _MockCashRegister extends Mock implements CashRegisterRepository {}

class _NoAuth extends Auth {
  @override
  Future<AuthStatus> build() async => const AuthUnauthenticated();
}

/// Synchro figée (pas de timers ni d'appels réseau).
class _IdleSync extends SyncOrchestrator {
  @override
  SyncStatus build() => const SyncStatusIdle();

  @override
  Future<void> syncNow({bool forceFullPull = false}) async {}
}

Decimal d(String value) => Decimal.parse(value);

CashSession openSession() => CashSession(
  id: 's1',
  deviceId: 'device-1',
  status: CashSessionStatus.open,
  openingAmount: d('10000'),
  openedAt: DateTime.utc(2026, 11, 10, 8),
  syncStatus: CashSyncStatus.synced,
  serverRecalculated: false,
);

CashSession closedSession({
  CashSyncStatus syncStatus = CashSyncStatus.synced,
  bool serverRecalculated = false,
  String? rejectionCode,
}) => openSession().copyWith(
  status: CashSessionStatus.closed,
  syncStatus: syncStatus,
  serverRecalculated: serverRecalculated,
  expectedAmount: d('50000'),
  clientExpectedAmount: d('48000'),
  countedAmount: d('49000'),
  discrepancyAmount: d('-1000'),
  closingNote: 'Monnaie rendue en trop',
  closedAt: DateTime.utc(2026, 11, 10, 19),
  rejectionCode: rejectionCode,
);

CashSummary summary({
  String expected = '47500',
  String rejectedCashRefunds = '0',
}) => CashSummary(
  openingAmount: d('10000'),
  cashSales: d('40000'),
  cashSalesCount: 6,
  mobileMoneySales: d('15000'),
  cashIn: d('5000'),
  cashOut: d('6000'),
  cashRefunds: d('1500'),
  rejectedCashRefunds: d(rejectedCashRefunds),
  expectedAmount: d(expected),
);

CashMovement movement(
  int i, {
  CashSyncStatus syncStatus = CashSyncStatus.synced,
}) => CashMovement(
  id: 'm$i',
  sessionId: 's1',
  type: i.isEven ? CashMovementType.cashIn : CashMovementType.cashOut,
  reason: i.isEven ? CashMovementReason.topUp : CashMovementReason.expense,
  amount: d('${1000 + i}'),
  createdAt: DateTime.utc(2026, 11, 10, 9, i),
  syncStatus: syncStatus,
  rejectionCode: syncStatus == CashSyncStatus.rejected
      ? 'INSUFFICIENT_CASH'
      : null,
);

/// Ratio de contraste WCAG entre deux couleurs opaques.
double contrast(Color a, Color b) {
  final la = a.computeLuminance();
  final lb = b.computeLuminance();
  return (math.max(la, lb) + 0.05) / (math.min(la, lb) + 0.05);
}

void main() {
  late _MockCashRegister repo;

  setUpAll(() async {
    await initializeDateFormatting('fr_FR');
    registerFallbackValue(Decimal.zero);
  });

  setUp(() {
    repo = _MockCashRegister();
    when(() => repo.watchLocalHistory()).thenAnswer((_) => Stream.value([]));
  });

  List<Override> overrides({bool online = true}) => [
    cashRegisterRepositoryProvider.overrideWithValue(repo),
    authProvider.overrideWith(_NoAuth.new),
    syncOrchestratorProvider.overrideWith(_IdleSync.new),
    isOnlineProvider.overrideWith((ref) => Stream.value(online)),
    pendingSyncCountProvider.overrideWith((ref) => Stream.value(0)),
  ];

  /// Monte [initial] dans un routeur où les pages de caisse sont réelles.
  Future<GoRouter> pumpCash(
    WidgetTester tester,
    String initial, {
    bool online = true,
    ThemeData? theme,
    Size size = const Size(400, 2400),
  }) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final router = GoRouter(
      initialLocation: initial,
      routes: [
        GoRoute(
          path: Routes.cashRegister,
          builder: (_, _) => const CashRegisterPage(),
        ),
        GoRoute(
          path: Routes.cashClose,
          builder: (_, _) => const CloseCashSessionPage(),
        ),
        GoRoute(
          path: Routes.cashHistory,
          builder: (_, _) => const CashSessionHistoryPage(),
        ),
        GoRoute(
          path: Routes.cashSessionDetail,
          builder: (_, state) =>
              CashSessionDetailPage(sessionId: state.pathParameters['id']!),
        ),
      ],
    );
    addTearDown(router.dispose);
    await tester.pumpWidget(
      ProviderScope(
        overrides: overrides(online: online),
        retry: (_, _) => null,
        child: MaterialApp.router(
          theme: theme ?? AppTheme.light(),
          routerConfig: router,
        ),
      ),
    );
    await tester.pumpAndSettle();
    return router;
  }

  void stubActive(CashSession? session, CashSummary? s) {
    when(
      () => repo.watchActiveSession(),
    ).thenAnswer((_) => Stream.value(session));
    when(() => repo.getActiveSession()).thenAnswer((_) async => session);
    if (session != null && s != null) {
      when(
        () => repo.watchSummary(session.id),
      ).thenAnswer((_) => Stream.value(s));
    }
  }

  testWidgets('closed state shows open button', (tester) async {
    stubActive(null, null);
    when(() => repo.watchLocalHistory()).thenAnswer(
      (_) => Stream.value([
        closedSession(
          syncStatus: CashSyncStatus.rejected,
          rejectionCode: CashRegisterException.closingNoteRequired,
        ),
      ]),
    );
    await pumpCash(tester, Routes.cashRegister);

    expect(find.text('Caisse fermée'), findsOneWidget);
    // La clôture refusée reste visible depuis la caisse fermée.
    expect(
      find.text('Dernière clôture refusée par le serveur'),
      findsOneWidget,
    );
    await tester.tap(find.widgetWithText(PrimaryButton, 'Ouvrir la caisse'));
    await tester.pumpAndSettle();
    expect(find.text('Fond de caisse'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('active page shows expected balance and recent movements', (
    tester,
  ) async {
    stubActive(openSession(), summary());
    when(() => repo.watchMovements('s1')).thenAnswer(
      (_) => Stream.value([
        movement(1, syncStatus: CashSyncStatus.rejected),
        for (var i = 2; i <= 12; i++) movement(i),
      ]),
    );
    await pumpCash(tester, Routes.cashRegister);

    expect(
      find.bySemanticsLabel(
        'Solde théorique du tiroir : ${formatFcfa(d('47500'))}',
      ),
      findsOneWidget,
    );
    for (final label in [
      'Fond de caisse',
      'Ventes en espèces (6)',
      'Entrées',
      'Sorties',
      'Remboursements espèces',
    ]) {
      expect(find.text(label), findsOneWidget, reason: label);
    }
    expect(find.text('Entrée'), findsOneWidget);
    expect(find.text('Sortie'), findsOneWidget);
    expect(find.text('Clôturer la caisse'), findsOneWidget);
    // Les 10 derniers mouvements seulement.
    expect(find.byType(CashMovementTile), findsNWidgets(10));
    expect(
      find.textContaining('Refusé par le serveur'),
      findsOneWidget,
      reason: 'un mouvement refusé est marqué',
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('movement sheet refuses a withdrawal above the drawer', (
    tester,
  ) async {
    stubActive(openSession(), summary());
    when(
      () => repo.watchMovements('s1'),
    ).thenAnswer((_) => Stream.value(const []));
    await pumpCash(tester, Routes.cashRegister);

    await tester.tap(find.widgetWithText(SecondaryButton, 'Sortie'));
    await tester.pumpAndSettle();
    expect(find.text("Mouvement d'espèces"), findsOneWidget);

    await tester.enterText(find.byType(TextField).first, '60000');
    await tester.pump();
    expect(
      find.text('Le tiroir ne contient que ${formatFcfa(d('47500'))}.'),
      findsOneWidget,
    );
    final button = tester.widget<PrimaryButton>(
      find.widgetWithText(PrimaryButton, 'Retirer ${formatFcfa(d('60000'))}'),
    );
    expect(button.onPressed, isNull);

    // Une entrée n'est pas plafonnée par le tiroir.
    await tester.tap(find.text('Entrée').last);
    await tester.pump();
    expect(find.textContaining('Le tiroir ne contient que'), findsNothing);
    expect(
      find.widgetWithText(PrimaryButton, 'Ajouter ${formatFcfa(d('60000'))}'),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('open sheet suggests the last counted amount', (tester) async {
    stubActive(null, null);
    when(
      () => repo.watchLocalHistory(),
    ).thenAnswer((_) => Stream.value([closedSession()]));
    await pumpCash(tester, Routes.cashRegister);

    await tester.tap(find.widgetWithText(PrimaryButton, 'Ouvrir la caisse'));
    await tester.pumpAndSettle();
    await tester.tap(find.textContaining(': ${formatAmount(d('49000'))}'));
    await tester.pump();
    expect(
      find.widgetWithText(
        PrimaryButton,
        'Ouvrir avec ${formatFcfa(d('49000'))}',
      ),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('close page shows surplus/deficit/balanced and requires note '
      'on gap', (tester) async {
    stubActive(openSession(), summary(expected: '10000'));
    final closed = closedSession(syncStatus: CashSyncStatus.pending);
    when(
      () => repo.closeSession(
        sessionId: any(named: 'sessionId'),
        countedAmount: any(named: 'countedAmount'),
        note: any(named: 'note'),
      ),
    ).thenAnswer((_) async => closed);
    when(
      () => repo.watchLocalHistory(),
    ).thenAnswer((_) => Stream.value([closed]));
    when(
      () => repo.watchSummary('s1'),
    ).thenAnswer((_) => Stream.value(summary(expected: '10000')));
    when(
      () => repo.watchMovements('s1'),
    ).thenAnswer((_) => Stream.value(const []));
    when(() => repo.fetchRemoteDetail('s1')).thenThrow(Exception('offline'));
    final router = await pumpCash(tester, Routes.cashClose);

    final field = find.byType(TextField).first;
    await tester.enterText(field, '10000');
    await tester.pump();
    expect(find.text('Caisse équilibrée'), findsOneWidget);
    expect(find.text('Commentaire (facultatif)'), findsOneWidget);

    await tester.enterText(field, '12000');
    await tester.pump();
    expect(
      find.bySemanticsLabel('Excédent de ${formatFcfa(d('2000'))}'),
      findsOneWidget,
    );
    expect(find.text("Expliquez l'écart (obligatoire)"), findsOneWidget);

    await tester.enterText(field, '9000');
    await tester.pump();
    expect(
      find.bySemanticsLabel('Déficit de ${formatFcfa(d('1000'))}'),
      findsOneWidget,
    );

    // Écart sans commentaire : refusé avant même la confirmation.
    await tester.tap(find.widgetWithText(PrimaryButton, 'Clôturer la caisse'));
    await tester.pumpAndSettle();
    expect(find.text("Expliquez l'écart avant de clôturer."), findsOneWidget);
    expect(find.byType(AlertDialog), findsNothing);

    await tester.enterText(find.byType(TextField).last, 'Pièce perdue');
    await tester.tap(find.widgetWithText(PrimaryButton, 'Clôturer la caisse'));
    await tester.pumpAndSettle();
    // Le dialogue récapitule chaque terme, le montant compté et l'écart.
    final dialog = find.byType(AlertDialog);
    for (final line in [
      'Fond de caisse : ${formatFcfa(d('10000'))}',
      'Ventes espèces : ${formatFcfa(d('40000'))}',
      'Entrées : ${formatFcfa(d('5000'))}',
      'Sorties : ${formatFcfa(d('6000'))}',
      'Remboursements : ${formatFcfa(d('1500'))}',
      'Solde théorique : ${formatFcfa(d('10000'))}',
      'Montant compté : ${formatFcfa(d('9000'))}',
      'Écart : Déficit de ${formatFcfa(d('1000'))}',
    ]) {
      expect(
        find.descendant(of: dialog, matching: find.textContaining(line)),
        findsOneWidget,
        reason: line,
      );
    }
    await tester.tap(find.text('Clôturer'));
    await tester.pumpAndSettle();

    verify(
      () => repo.closeSession(
        sessionId: 's1',
        countedAmount: d('9000'),
        note: 'Pièce perdue',
      ),
    ).called(1);
    expect(
      router.routerDelegate.currentConfiguration.uri.path,
      '/cash/sessions/s1',
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('close page accepts negative expected balance', (tester) async {
    stubActive(openSession(), summary(expected: '-2000'));
    when(
      () => repo.closeSession(
        sessionId: any(named: 'sessionId'),
        countedAmount: any(named: 'countedAmount'),
        note: any(named: 'note'),
      ),
    ).thenAnswer((_) async => closedSession());
    await pumpCash(tester, Routes.cashClose);

    expect(
      find.bySemanticsLabel('Solde théorique : ${formatFcfa(d('-2000'))}'),
      findsOneWidget,
    );
    await tester.enterText(find.byType(TextField).first, '0');
    await tester.pump();
    expect(
      find.bySemanticsLabel('Excédent de ${formatFcfa(d('2000'))}'),
      findsOneWidget,
    );

    await tester.enterText(find.byType(TextField).last, 'Solde négatif');
    await tester.tap(find.widgetWithText(PrimaryButton, 'Clôturer la caisse'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Clôturer'));
    await tester.pumpAndSettle();

    verify(
      () => repo.closeSession(
        sessionId: 's1',
        countedAmount: Decimal.zero,
        note: 'Solde négatif',
      ),
    ).called(1);
  });

  group('détail', () {
    CashSessionDetail serverDetail() => CashSessionDetail(
      session: closedSession(serverRecalculated: true),
      summary: CashServerSummary(
        openingAmount: d('10000'),
        cashSales: d('42000'),
        cashSalesCount: 7,
        mobileMoneySales: d('0'),
        cashIn: d('5000'),
        cashOut: d('6000'),
        cashRefunds: d('1000'),
        expectedAmount: d('50000'),
        lateImpact: d('1500'),
        serverRecalculated: true,
      ),
      movements: [movement(2)],
    );

    void stubLocal(CashSession session, {String rejected = '0'}) {
      when(
        () => repo.watchLocalHistory(),
      ).thenAnswer((_) => Stream.value([session]));
      when(
        () => repo.watchSummary('s1'),
      ).thenAnswer((_) => Stream.value(summary(rejectedCashRefunds: rejected)));
      when(
        () => repo.watchMovements('s1'),
      ).thenAnswer((_) => Stream.value([movement(4)]));
    }

    testWidgets('detail shows server-recalculated and late-impact banners', (
      tester,
    ) async {
      stubLocal(closedSession(serverRecalculated: true), rejected: '2500');
      when(
        () => repo.fetchRemoteDetail('s1'),
      ).thenAnswer((_) async => serverDetail());
      await pumpCash(tester, '/cash/sessions/s1');

      expect(
        find.text(
          'Montant recalculé par le serveur : ${formatFcfa(d('50000'))} '
          '(affiché : ${formatFcfa(d('48000'))})',
        ),
        findsOneWidget,
      );
      expect(
        find.text(
          'Opérations arrivées après clôture : +${formatFcfa(d('1500'))}',
        ),
        findsOneWidget,
      );
      expect(
        find.text(
          'Retour refusé : ${formatFcfa(d('2500'))} rendus non comptés',
        ),
        findsOneWidget,
      );
      // Chiffres du serveur, solde figé à la clôture.
      expect(find.text('Ventes en espèces (7)'), findsOneWidget);
      expect(
        find.bySemanticsLabel(
          'Solde théorique à la clôture : ${formatFcfa(d('50000'))}',
        ),
        findsOneWidget,
      );
      expect(find.text('Déficit de ${formatFcfa(d('1000'))}'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('detail offline shows local figures without error', (
      tester,
    ) async {
      stubLocal(closedSession());
      await pumpCash(tester, '/cash/sessions/s1', online: false);

      verifyNever(() => repo.fetchRemoteDetail(any()));
      expect(find.text('Ventes en espèces (6)'), findsOneWidget);
      expect(find.textContaining('Opérations arrivées'), findsNothing);
      expect(find.text('Session indisponible'), findsNothing);
      expect(tester.takeException(), isNull);
    });

    testWidgets('detail resubmits a close rejected for a missing note', (
      tester,
    ) async {
      stubLocal(
        closedSession(
          syncStatus: CashSyncStatus.rejected,
          rejectionCode: CashRegisterException.closingNoteRequired,
        ),
      );
      when(
        () => repo.resubmitCloseWithNote(any(), any()),
      ).thenAnswer((_) async {});
      when(
        () => repo.fetchRemoteDetail('s1'),
      ).thenAnswer((_) async => serverDetail());
      await pumpCash(tester, '/cash/sessions/s1');

      expect(
        find.text('Le serveur exige un commentaire pour cet écart'),
        findsOneWidget,
      );
      // Clôture non acceptée : le serveur n'est même pas interrogé.
      verifyNever(() => repo.fetchRemoteDetail(any()));
      expect(find.textContaining('Opérations arrivées'), findsNothing);

      await tester.tap(find.text('Renvoyer la clôture'));
      await tester.pump();
      expect(find.text("Expliquez l'écart avant de renvoyer."), findsOneWidget);
      verifyNever(() => repo.resubmitCloseWithNote(any(), any()));

      await tester.enterText(
        find.widgetWithText(AppTextField, 'Commentaire (obligatoire)'),
        'Vente oubliée',
      );
      await tester.tap(find.text('Renvoyer la clôture'));
      await tester.pumpAndSettle();
      verify(() => repo.resubmitCloseWithNote('s1', 'Vente oubliée')).called(1);
    });

    testWidgets('detail shows other rejection codes read-only', (tester) async {
      stubLocal(
        closedSession(
          syncStatus: CashSyncStatus.rejected,
          rejectionCode: 'CASH_SESSION_CLOSED',
        ),
      );
      await pumpCash(tester, '/cash/sessions/s1', online: false);

      expect(find.text('Refusé par le serveur'), findsOneWidget);
      expect(find.text('Cette caisse est déjà clôturée.'), findsOneWidget);
      expect(find.text('Renvoyer la clôture'), findsNothing);
    });
  });

  testWidgets('history offline lists local sessions with a banner', (
    tester,
  ) async {
    when(
      () => repo.watchLocalHistory(),
    ).thenAnswer((_) => Stream.value([closedSession()]));
    await pumpCash(tester, Routes.cashHistory, online: false);

    expect(
      find.text('Hors ligne : sessions de ce téléphone uniquement'),
      findsOneWidget,
    );
    expect(
      find.bySemanticsLabel(RegExp('Déficit de ${formatFcfa(d('1000'))}')),
      findsOneWidget,
    );
    verifyNever(() => repo.fetchRemoteHistory(cursor: any(named: 'cursor')));
  });

  test('history ignores a page that arrives after a refresh', () async {
    final pending = Completer<CashSessionPage>();
    var firstPageCalls = 0;
    when(() => repo.fetchRemoteHistory()).thenAnswer((_) async {
      firstPageCalls++;
      return CashSessionPage(
        items: [closedSession().copyWith(id: 'p$firstPageCalls')],
        nextCursor: 'c2',
        hasMore: true,
      );
    });
    when(
      () => repo.fetchRemoteHistory(cursor: 'c2'),
    ).thenAnswer((_) => pending.future);
    final container = ProviderContainer(
      overrides: [cashRegisterRepositoryProvider.overrideWithValue(repo)],
      retry: (_, _) => null,
    );
    addTearDown(container.dispose);
    final sub = container.listen(cashSessionHistoryProvider, (_, _) {});
    addTearDown(sub.close);
    await container.read(cashSessionHistoryProvider.future);

    final notifier = container.read(cashSessionHistoryProvider.notifier);
    final loading = notifier.loadMore();
    await notifier.refresh();
    pending.complete(
      CashSessionPage(
        items: [openSession().copyWith(id: 'old')],
        hasMore: false,
      ),
    );
    await loading;

    // La page de l'ancienne liste n'est pas collée à la liste rechargée.
    expect(container.read(cashSessionHistoryProvider).value!.map((s) => s.id), [
      'p2',
    ]);
    expect(notifier.hasMore, isTrue);
  });

  testWidgets('history online pages through server sessions', (tester) async {
    when(() => repo.fetchRemoteHistory()).thenAnswer(
      (_) async => CashSessionPage(
        items: [closedSession()],
        nextCursor: 'c2',
        hasMore: true,
      ),
    );
    when(() => repo.fetchRemoteHistory(cursor: 'c2')).thenAnswer(
      (_) async => CashSessionPage(
        items: [openSession().copyWith(id: 's2')],
        hasMore: false,
      ),
    );
    await pumpCash(tester, Routes.cashHistory);

    expect(find.textContaining('Hors ligne'), findsNothing);
    await tester.tap(find.text('Voir les sessions plus anciennes'));
    await tester.pumpAndSettle();
    expect(find.text('En cours'), findsOneWidget);
    expect(find.text('Voir les sessions plus anciennes'), findsNothing);
  });

  Future<void> pumpHome(WidgetTester tester) async {
    tester.view.physicalSize = const Size(400, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final router = GoRouter(
      initialLocation: Routes.home,
      routes: [
        GoRoute(path: Routes.home, builder: (_, _) => const HomePage()),
        GoRoute(
          path: Routes.cashRegister,
          builder: (_, _) => const Text('page caisse'),
        ),
      ],
    );
    addTearDown(router.dispose);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          ...overrides(),
          dailySummaryProvider.overrideWith(
            (ref) => Stream.value((
              saleCount: 0,
              totalAmount: Decimal.zero,
              cashTotal: Decimal.zero,
              mobileMoneyTotal: Decimal.zero,
              refundTotal: Decimal.zero,
            )),
          ),
          homeLowStockProvider.overrideWith((ref) => Stream.value(const [])),
        ],
        retry: (_, _) => null,
        child: MaterialApp.router(
          theme: AppTheme.light(),
          routerConfig: router,
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('home card shows an unavailable balance on summary error', (
    tester,
  ) async {
    stubActive(openSession(), null);
    when(
      () => repo.watchSummary('s1'),
    ).thenAnswer((_) => Stream.error(StateError('drift')));
    await pumpHome(tester);

    expect(
      find.bySemanticsLabel('Caisse ouverte, solde indisponible'),
      findsOneWidget,
    );
    expect(find.byType(SkeletonBox), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('home card navigates to /cash', (tester) async {
    stubActive(openSession(), summary());
    await pumpHome(tester);

    final card = find.bySemanticsLabel(
      'Caisse ouverte, espèces dans le tiroir ${formatFcfa(d('47500'))}',
    );
    expect(card, findsOneWidget);
    // Action de tap exposée aux lecteurs d'écran (TalkBack, VoiceOver).
    expect(
      tester.getSemantics(card),
      matchesSemantics(
        label:
            'Caisse ouverte, espèces dans le tiroir ${formatFcfa(d('47500'))}',
        isButton: true,
        hasTapAction: true,
      ),
    );
    await tester.tap(card);
    await tester.pumpAndSettle();
    expect(find.text('page caisse'), findsOneWidget);
  });

  group('dark mode renders without hard-coded colors', () {
    for (final (name, theme) in [
      ('clair', AppTheme.light()),
      ('sombre', AppTheme.dark()),
    ]) {
      testWidgets('écart et solde négatif lisibles (≥ 4.5:1), thème $name', (
        tester,
      ) async {
        stubActive(openSession(), summary(expected: '-2000'));
        await pumpCash(tester, Routes.cashClose, theme: theme);

        final cs = theme.colorScheme;
        // Solde négatif affiché tel quel, en couleur d'erreur du thème.
        final hero = tester.widget<Text>(find.text(formatFcfa(d('-2000'))));
        expect(hero.style!.color, cs.error);
        expect(contrast(cs.error, cs.surface), greaterThanOrEqualTo(4.5));

        // Excédent : paire d'avertissement du thème.
        await tester.enterText(find.byType(TextField).first, '0');
        await tester.pump();
        final surplus = tester.widget<Text>(find.text('Excédent'));
        expect(surplus.style!.color, cs.onTertiaryContainer);
        // Les trois états lisibles sur leur fond.
        final semantic = theme.extension<AppSemanticColors>()!;
        for (final (fg, bg) in [
          (semantic.success, semantic.successContainer),
          (cs.onTertiaryContainer, cs.tertiaryContainer),
          (cs.onErrorContainer, cs.errorContainer),
        ]) {
          expect(contrast(fg, bg), greaterThanOrEqualTo(4.5));
        }
        expect(tester.takeException(), isNull);
      });
    }

    test('aucune couleur codée en dur dans les écrans de caisse', () {
      final files = Directory('lib/features/cash_register/presentation')
          .listSync(recursive: true)
          .whereType<File>()
          .where(
            (f) => f.path.endsWith('.dart') && !f.path.endsWith('.g.dart'),
          );
      expect(files, isNotEmpty);
      for (final file in files) {
        final source = file.readAsStringSync();
        expect(
          source.contains('Color(0x'),
          isFalse,
          reason: '${file.path} : couleur codée en dur',
        );
        final namedColors =
            RegExp(
                r'Colors\.(\w+)',
              ).allMatches(source).map((m) => m.group(1)).toSet()
              ..remove('transparent');
        expect(namedColors, isEmpty, reason: file.path);
      }
    });
  });

  testWidgets('discrepancy badge labels', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(
          body: Column(
            children: [
              DiscrepancyBadge(discrepancy: Decimal.zero),
              DiscrepancyBadge(discrepancy: d('500')),
              DiscrepancyBadge(discrepancy: d('-500')),
            ],
          ),
        ),
      ),
    );
    expect(find.text('Caisse équilibrée'), findsOneWidget);
    expect(find.text('Excédent de ${formatFcfa(d('500'))}'), findsOneWidget);
    expect(find.text('Déficit de ${formatFcfa(d('500'))}'), findsOneWidget);
  });
}
