import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Onglets de la [MainShell], dans l'ordre des branches de la
/// [StatefulShellRoute] (`app_router.dart`) et des destinations ci-dessous —
/// à garder synchronisés. Utiliser `ShellBranch.x.index` avec `goBranch`.
enum ShellBranch {
  /// Accueil (dashboard).
  home,

  /// Caisse (vente).
  sale,

  /// Vue d'ensemble du stock.
  inventory,

  /// Ventes (historique).
  salesHistory,

  /// Paramètres.
  settings,
}

/// Coquille principale : Scaffold + [NavigationBar] Material 3 pilotés par
/// [StatefulNavigationShell].
///
/// Chaque onglet correspond à une branche de la [StatefulShellRoute] déclarée
/// dans `app_router.dart` — l'état de navigation (index actif, pile de chaque
/// branche) est géré nativement par go_router, plus besoin de provider dédié.
/// Le style de la barre (couleurs, indicateur, typographie) vient du thème
/// Cacao & Or via `navigationBarTheme` (voir `core/theme/app_theme.dart`).
class MainShell extends StatelessWidget {
  /// Crée la coquille principale à partir de la shell de navigation active.
  const MainShell({required this.navigationShell, super.key});

  /// Shell fournie par [StatefulShellRoute.indexedStack], expose l'index
  /// courant et le changement de branche.
  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        // `initialLocation: true` quand on retape l'onglet déjà actif :
        // réinitialise la branche à sa route de départ.
        onDestinationSelected: (index) => navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        ),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Accueil',
          ),
          NavigationDestination(
            icon: Icon(Icons.point_of_sale_outlined),
            selectedIcon: Icon(Icons.point_of_sale),
            label: 'Caisse',
          ),
          NavigationDestination(
            icon: Icon(Icons.inventory_2_outlined),
            selectedIcon: Icon(Icons.inventory_2),
            label: 'Stock',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long),
            label: 'Historique',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Paramètres',
          ),
        ],
      ),
    );
  }
}
