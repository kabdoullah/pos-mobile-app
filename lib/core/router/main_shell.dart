import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_typography.dart';

/// Onglets de la [MainShell], dans l'ordre des branches de la
/// [StatefulShellRoute] (`app_router.dart`) et des destinations ci-dessous —
/// à garder synchronisés. Utiliser `ShellBranch.x.index` avec `goBranch`.
enum ShellBranch {
  /// Accueil (dashboard).
  home,

  /// Vendre (caisse).
  sale,

  /// Vue d'ensemble du stock.
  inventory,

  /// Ventes (historique).
  salesHistory,

  /// Paramètres.
  settings,
}

/// Coquille principale : Scaffold + [_AppBottomNav] pilotés par
/// [StatefulNavigationShell].
///
/// Chaque onglet correspond à une branche de la [StatefulShellRoute] déclarée
/// dans `app_router.dart` — l'état de navigation (index actif, pile de chaque
/// branche) est géré nativement par go_router, plus besoin de provider dédié.
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
      bottomNavigationBar: _AppBottomNav(
        selectedIndex: navigationShell.currentIndex,
        // `initialLocation: true` quand on retape l'onglet déjà actif :
        // réinitialise la branche à sa route de départ.
        onSelected: (index) => navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        ),
      ),
    );
  }
}

/// Destinations, dans l'ordre de [ShellBranch].
const _destinations = <(IconData, IconData, String)>[
  (Icons.home_outlined, Icons.home, 'Accueil'),
  (Icons.point_of_sale_outlined, Icons.point_of_sale, 'Vendre'),
  (Icons.inventory_2_outlined, Icons.inventory_2, 'Stock'),
  (Icons.receipt_long_outlined, Icons.receipt_long, 'Historique'),
  (Icons.settings_outlined, Icons.settings, 'Paramètres'),
];

/// Barre de navigation v2 (remplace `NavigationBar`) : plate, 64 dp, filet
/// en haut, libellés toujours visibles ; l'onglet actif est marqué par un
/// trait `action` de 2 dp au-dessus de lui (pas d'indicateur en pilule).
class _AppBottomNav extends StatelessWidget {
  const _AppBottomNav({required this.selectedIndex, required this.onSelected});

  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(top: BorderSide(color: colors.border)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            children: [
              for (final (index, (icon, selectedIcon, label))
                  in _destinations.indexed)
                Expanded(
                  child: _NavItem(
                    icon: index == selectedIndex ? selectedIcon : icon,
                    label: label,
                    selected: index == selectedIndex,
                    onTap: () => onSelected(index),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final color = selected ? colors.textPrimary : colors.textSecondary;
    return Semantics(
      button: true,
      selected: selected,
      label: label,
      excludeSemantics: true,
      child: InkWell(
        onTap: onTap,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 24, color: color),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.labelSmall.copyWith(
                    color: color,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              ],
            ),
            if (selected)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: FractionallySizedBox(
                  widthFactor: 0.44,
                  child: Container(height: 2, color: colors.action),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
