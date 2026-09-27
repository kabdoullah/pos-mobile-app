import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/responsive/responsive.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/router/main_shell.dart';
import '../../../../core/widgets/index.dart';
import '../../../auth/providers/store_provider.dart';
import '../providers/home_providers.dart';
import '../widgets/low_stock_section.dart';
import '../widgets/recent_sales_section.dart';
import '../widgets/today_summary.dart';

/// Accueil : répond à « comment va mon activité aujourd'hui ? » — chiffres du
/// jour, alertes de stock, dernières ventes et raccourcis.
class HomePage extends ConsumerWidget {
  /// Crée l'accueil.
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final storeName = ref.watch(storeConfigProvider).value?.name;
    final dateLabel = DateFormat(
      'EEEE d MMMM',
      'fr_FR',
    ).format(ref.watch(todayProvider));
    final hPad = responsiveValue(
      context,
      small: AppSpacing.md,
      medium: AppSpacing.lg,
    );

    void goTo(ShellBranch branch) =>
        StatefulNavigationShell.of(context).goBranch(branch.index);

    return AppScaffold(
      title: storeName == null || storeName.isEmpty ? 'Accueil' : storeName,
      actions: const [
        Padding(
          padding: EdgeInsets.only(right: AppSpacing.md),
          child: OfflineStatusIndicator(),
        ),
      ],
      body: ListView(
        padding: EdgeInsets.fromLTRB(hPad, AppSpacing.sm, hPad, AppSpacing.xl),
        children: [
          const Text('Bonjour', style: AppTypography.titleLarge),
          Text(
            // « samedi 27 septembre » → « Samedi 27 septembre »
            toBeginningOfSentenceCase(dateLabel, 'fr_FR'),
            style: AppTypography.bodyMedium.copyWith(
              color: cs.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          const TodaySummary(),
          const SizedBox(height: AppSpacing.md),
          _QuickActions(
            onNewSale: () => goTo(ShellBranch.sale),
            onNewProduct: () => context.push(Routes.productNew),
            onStock: () => goTo(ShellBranch.inventory),
          ),
          const SizedBox(height: AppSpacing.lg),
          LowStockSection(onSeeStock: () => goTo(ShellBranch.inventory)),
          const SizedBox(height: AppSpacing.md),
          RecentSalesSection(
            onSeeAll: () => goTo(ShellBranch.salesHistory),
            onNewSale: () => goTo(ShellBranch.sale),
          ),
        ],
      ),
    );
  }
}

/// Raccourcis : la vente en action principale, le reste en secondaire.
class _QuickActions extends StatelessWidget {
  const _QuickActions({
    required this.onNewSale,
    required this.onNewProduct,
    required this.onStock,
  });

  final VoidCallback onNewSale;
  final VoidCallback onNewProduct;
  final VoidCallback onStock;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PrimaryButton(
          label: 'Nouvelle vente',
          icon: Icons.point_of_sale,
          onPressed: onNewSale,
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Expanded(
              child: _SecondaryAction(
                icon: Icons.add_box_outlined,
                label: 'Produit',
                onPressed: onNewProduct,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _SecondaryAction(
                icon: Icons.inventory_2_outlined,
                label: 'Stock',
                onPressed: onStock,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SecondaryAction extends StatelessWidget {
  const _SecondaryAction({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(AppSpacing.buttonHeightSm),
      ),
    );
  }
}
