import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:mobile/core/router/app_router.dart';
import 'package:mobile/features/auth/domain/entities/user.dart';
import 'package:mobile/features/auth/presentation/providers/auth_providers.dart';

class _AuthenticatedAuth extends Auth {
  @override
  Future<AuthStatus> build() async =>
      const AuthAuthenticated(User(id: 'u1', phoneNumber: '+2250700000000'));
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // Pages plein écran empilées par-dessus la shell (détail de vente…).
  // Si l'une d'elles se résout à travers la StatefulShellRoute, un `push`
  // depuis une page déjà au-dessus de la shell reconstruit la shell et le Navigator plante (clés de page
  // dupliquées).
  const fullScreenPaths = [
    Routes.catalog,
    Routes.saleDetail,
    Routes.productNew,
    Routes.productImport,
    '/catalog/abc/edit',
    '/catalog/abc/movements',
    Routes.bluetoothSetup,
    Routes.barcodeScanner,
  ];

  test('les pages plein écran ne passent pas par la shell des onglets', () {
    final container = ProviderContainer(
      overrides: [authProvider.overrideWith(_AuthenticatedAuth.new)],
    );
    addTearDown(container.dispose);
    final router = container.read(appRouterProvider);

    for (final path in fullScreenPaths) {
      final matches = router.configuration.findMatch(Uri.parse(path));
      expect(matches.isNotEmpty, isTrue, reason: '$path doit exister');
      expect(
        matches.matches.whereType<ShellRouteMatch>(),
        isEmpty,
        reason: '$path ne doit pas être déclarée dans une branche de la shell',
      );
    }
  });

  test('les onglets restent dans la shell', () {
    final container = ProviderContainer(
      overrides: [authProvider.overrideWith(_AuthenticatedAuth.new)],
    );
    addTearDown(container.dispose);
    final router = container.read(appRouterProvider);

    for (final path in [
      Routes.home,
      Routes.newSale,
      Routes.inventory,
      Routes.salesHistory,
      Routes.settings,
    ]) {
      expect(
        router.configuration
            .findMatch(Uri.parse(path))
            .matches
            .whereType<ShellRouteMatch>(),
        isNotEmpty,
        reason: path,
      );
    }
  });
}
