import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';

import 'package:mobile/app/theme/app_theme.dart';
import 'package:mobile/features/printing/domain/repositories/printer_repository.dart';
import 'package:mobile/features/printing/presentation/pages/bluetooth_setup_page.dart';
import 'package:mobile/features/printing/presentation/providers/printer_provider.dart';
import 'package:mobile/features/printing/providers/printing_di_providers.dart';

class _MockPrinterRepository extends Mock implements PrinterRepository {}

/// Imprimante simulée : [connect] réussit ou échoue selon [connectSucceeds].
class FakePrinter extends Printer {
  FakePrinter({required this.connectSucceeds});

  final bool connectSucceeds;

  @override
  PrinterState build() => const PrinterDisconnected();

  @override
  Future<void> connect(String mac, String name) async {
    state = connectSucceeds
        ? PrinterConnected(mac: mac, name: name)
        : PrinterError(message: 'injoignable', savedMac: mac);
  }
}

Future<void> pumpPage(
  WidgetTester tester, {
  required bool connectSucceeds,
  List<BluetoothInfo>? devices,
}) async {
  tester.view.physicalSize = const Size(360, 800);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  // Permission Bluetooth accordée (1 = granted).
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
  const permissions = MethodChannel('flutter.baseflow.com/permissions/methods');
  messenger.setMockMethodCallHandler(permissions, (call) async => 1);
  addTearDown(() => messenger.setMockMethodCallHandler(permissions, null));

  final repo = _MockPrinterRepository();
  when(repo.getPairedDevices).thenAnswer(
    (_) async =>
        devices ?? [BluetoothInfo(name: 'PT-210', macAdress: '00:11:22:33')],
  );

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        printerRepositoryProvider.overrideWithValue(repo),
        printerProvider.overrideWith(
          () => FakePrinter(connectSucceeds: connectSucceeds),
        ),
      ],
      child: MaterialApp(
        theme: AppTheme.light(),
        home: const BluetoothSetupPage(),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('connexion réussie : on reste, « Imprimer un test » proposé', (
    tester,
  ) async {
    await pumpPage(tester, connectSucceeds: true);
    expect(find.text('IMPRIMANTES APPAIRÉES AU TÉLÉPHONE'), findsOneWidget);
    expect(find.text('Appairée · non connectée'), findsOneWidget);

    await tester.tap(find.text('Connecter'));
    await tester.pumpAndSettle();
    expect(find.byType(BluetoothSetupPage), findsOneWidget);
    expect(find.text('Connectée'), findsOneWidget);
    expect(find.text('Imprimer un test'), findsOneWidget);
    expect(find.text('Oublier'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('connexion échouée : raison et « Réessayer » sur la ligne', (
    tester,
  ) async {
    await pumpPage(tester, connectSucceeds: false);
    await tester.tap(find.text('Connecter'));
    await tester.pumpAndSettle();
    expect(find.text('Connexion échouée'), findsOneWidget);
    expect(find.textContaining('allumée, chargée'), findsOneWidget);
    expect(find.text('Réessayer'), findsOneWidget);
  });

  testWidgets('aucune imprimante appairée : réglages Bluetooth proposés', (
    tester,
  ) async {
    await pumpPage(tester, connectSucceeds: true, devices: const []);
    expect(find.text('Aucune imprimante appairée'), findsOneWidget);
    expect(find.text('Ouvrir les réglages Bluetooth'), findsOneWidget);
    expect(find.text('Actualiser'), findsWidgets);
  });
}
