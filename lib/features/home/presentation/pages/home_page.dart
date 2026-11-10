import 'package:decimal/decimal.dart';
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
import '../../../cash_register/presentation/providers/cash_register_providers.dart';
import '../providers/home_providers.dart';
import '../widgets/account_email_banner.dart';
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
          // Le nom de la boutique est dans l'AppBar : salutation et date
          // tiennent sur une ligne discrète, le chiffre d'affaires reste
          // l'information principale.
          Text(
            'Bonjour · ${toBeginningOfSentenceCase(dateLabel, 'fr_FR')}',
            style: AppTypography.bodyMedium.copyWith(
              color: cs.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          const AccountEmailBanner(),
          const TodaySummary(),
          const SizedBox(height: AppSpacing.md),
          _CashCard(onTap: () => context.push(Routes.cashRegister)),
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

/// Carte « Caisse » : solde théorique de la caisse ouverte, ou « Caisse
/// fermée · Ouvrir ». Un tap ouvre l'écran de la caisse.
class _CashCard extends ConsumerWidget {
  const _CashCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final muted = AppTypography.bodySmall.copyWith(color: cs.onSurfaceVariant);
    final session = ref.watch(activeCashSessionProvider);
    final sessionId = session.value?.id;
    final expected = sessionId == null
        ? null
        : ref.watch(cashSummaryProvider(sessionId)).value?.expectedAmount;

    final Widget trailing;
    final String subtitle;
    final String semanticsLabel;
    if (session.isLoading && !session.hasValue) {
      subtitle = 'Solde théorique';
      trailing = const SkeletonBox(width: 96, height: 20);
      semanticsLabel = 'Caisse, chargement';
    } else if (sessionId == null) {
      subtitle = session.hasError ? 'Caisse indisponible' : 'Caisse fermée';
      trailing = const SizedBox.shrink();
      semanticsLabel = '$subtitle. Ouvrir la caisse';
    } else {
      subtitle = 'Solde théorique';
      trailing = expected == null
          ? const SkeletonBox(width: 96, height: 20)
          : AmountDisplay(
              amount: expected,
              color: expected < Decimal.zero ? cs.error : null,
            );
      semanticsLabel = expected == null
          ? 'Caisse ouverte'
          : 'Caisse ouverte, solde théorique ${formatFcfa(expected)}';
    }

    // excludeSemantics retire l'action de l'InkWell : on la redonne ici,
    // sinon les lecteurs d'écran annoncent un bouton inactif.
    return Semantics(
      button: true,
      label: semanticsLabel,
      onTap: onTap,
      excludeSemantics: true,
      child: AppCard(
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minHeight: AppSpacing.buttonHeightSm,
          ),
          child: Row(
            children: [
              Icon(Icons.point_of_sale_outlined, color: cs.primary),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Caisse', style: AppTypography.titleMedium),
                    Text(
                      sessionId == null ? '$subtitle · Ouvrir' : subtitle,
                      style: muted,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              trailing,
              Icon(Icons.chevron_right, color: cs.onSurfaceVariant),
            ],
          ),
        ),
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
