import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:showcaseview/showcaseview.dart';

import '../../../../core/responsive/responsive.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/index.dart';
import '../../../auth/providers/store_provider.dart';
import '../../../sales/domain/entities/sale.dart';
import '../providers/home_providers.dart';
import '../providers/home_showcase_provider.dart';

/// Premium financial dashboard with asymmetric layout and refined aesthetics.
///
/// Runs a one-time contextual spotlight tour (via `showcaseview`) on first
/// visit, once the daily summary has finished loading — see [_tryStartShowcase].
class HomePage extends ConsumerStatefulWidget {
  /// Creates a [HomePage].
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final _summaryCardKey = GlobalKey();
  final _newSaleButtonKey = GlobalKey();
  final _quickActionsKey = GlobalKey();
  bool _showcaseStarted = false;

  @override
  void initState() {
    super.initState();
    ShowcaseView.register(
      enableAutoScroll: true,
      onFinish: _markShowcaseSeen,
      onDismiss: (_) => _markShowcaseSeen(),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) => _tryStartShowcase());
  }

  @override
  void dispose() {
    ShowcaseView.get().unregister();
    super.dispose();
  }

  void _markShowcaseSeen() =>
      ref.read(homeShowcaseSeenProvider.notifier).markSeen();

  /// Starts the tour once both the "already seen" flag and the daily
  /// summary have settled — starting earlier risks spotlighting a button
  /// whose position is about to shift once [dailySummaryProvider] resolves
  /// (the loading indicator is much shorter than the summary card).
  void _tryStartShowcase() {
    if (_showcaseStarted || !mounted) return;
    if (ref.read(homeShowcaseSeenProvider) != false) return;
    if (ref.read(dailySummaryProvider).isLoading) return;
    _showcaseStarted = true;
    ShowcaseView.get().startShowCase([
      _summaryCardKey,
      _newSaleButtonKey,
      _quickActionsKey,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final dailySummaryAsync = ref.watch(dailySummaryProvider);
    final storeAsync = ref.watch(storeConfigProvider);
    ref.listen<AsyncValue<DailySummary>>(dailySummaryProvider, (_, next) {
      if (!next.isLoading) _tryStartShowcase();
    });
    ref.listen<bool?>(homeShowcaseSeenProvider, (_, next) {
      if (next != null) _tryStartShowcase();
    });

    final cs = Theme.of(context).colorScheme;
    final storeName =
        storeAsync.whenOrNull(data: (s) => s?.name) ?? 'Ma boutique';
    final dateLabel = DateFormat('EEEE d MMMM', 'fr_FR').format(DateTime.now());
    final hPad = responsiveValue(
      context,
      small: AppSpacing.md,
      medium: AppSpacing.lg,
    );

    return AppScaffold(
      title: storeName,
      actions: [
        IconButton(
          icon: const Icon(Icons.settings_outlined),
          onPressed: () => StatefulNavigationShell.of(context).goBranch(3),
          tooltip: 'Paramètres',
        ),
      ],
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: store name + date
            Padding(
              padding: EdgeInsets.fromLTRB(
                hPad,
                AppSpacing.lg,
                hPad,
                AppSpacing.xl,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dateLabel,
                    style: AppTypography.bodySmall.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            // Daily summary card
            Padding(
              padding: EdgeInsets.symmetric(horizontal: hPad),
              child: _homeShowcase(
                key: _summaryCardKey,
                cs: cs,
                title: 'Résumé du jour',
                description:
                    'Suivez votre chiffre d\'affaires : total, espèces et '
                    'mobile money.',
                targetBorderRadius: BorderRadius.circular(AppSpacing.radiusXl),
                child: dailySummaryAsync.when(
                  loading: () => const AppLoadingIndicator(),
                  error: (_, _) => _SummaryCard(
                    summary: DailySummary.empty,
                    hasError: true,
                    onRetry: () => ref.invalidate(dailySummaryProvider),
                  ),
                  data: (summary) => _SummaryCard(summary: summary),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: hPad),
              child: _homeShowcase(
                key: _newSaleButtonKey,
                cs: cs,
                title: 'Nouvelle vente',
                description: 'Démarrez une nouvelle vente en un tap.',
                child: SizedBox(
                  width: double.infinity,
                  height: AppSpacing.buttonHeight,
                  child: FilledButton.icon(
                    onPressed: () => context.push(Routes.newSale),
                    icon: const Icon(Icons.point_of_sale, size: 22),
                    label: const Text('NOUVELLE VENTE'),
                    style: FilledButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppSpacing.radiusMd,
                        ),
                      ),
                      textStyle: AppTypography.labelLarge.copyWith(
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            _homeShowcase(
              key: _quickActionsKey,
              cs: cs,
              title: 'Accès rapide',
              description:
                  'Catalogue, historique des ventes ou ajout d\'un produit — '
                  'tout est ici.',
              child: const _QuickActionsSection(),
            ),
            const SizedBox(height: AppSpacing.xl),

            const _RecentActivitySection(),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }
}

/// Wraps [child] in a [Showcase] styled with the Cacao & Or palette instead
/// of the package's default black/white tooltip.
Showcase _homeShowcase({
  required GlobalKey key,
  required String title,
  required String description,
  required Widget child,
  required ColorScheme cs,
  BorderRadius? targetBorderRadius,
}) {
  return Showcase(
    key: key,
    title: title,
    description: description,
    titleTextStyle: AppTypography.titleMedium.copyWith(color: cs.onPrimary),
    descTextStyle: AppTypography.bodyMedium.copyWith(
      color: cs.onPrimary.withValues(alpha: 0.9),
    ),
    tooltipBackgroundColor: cs.primary,
    tooltipBorderRadius: BorderRadius.circular(AppSpacing.radiusLg),
    targetBorderRadius:
        targetBorderRadius ?? BorderRadius.circular(AppSpacing.radiusMd),
    overlayColor: cs.scrim,
    child: child,
  );
}

/// Quick access section for frequent POS operations.
class _QuickActionsSection extends StatelessWidget {
  const _QuickActionsSection();

  @override
  Widget build(BuildContext context) {
    final hPad = responsiveValue(
      context,
      small: AppSpacing.md,
      medium: AppSpacing.lg,
    );
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: hPad),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Accès rapide',
            style: AppTypography.labelMedium.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          // ✨ IntrinsicHeight + stretch — toutes les cartes à la même hauteur
          // quelle que soit la longueur du label (ex: "Nouveau produit" sur 2 lignes)
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: _QuickActionCard(
                    icon: Icons.shopping_bag_outlined,
                    label: 'Catalogue',
                    onTap: () =>
                        StatefulNavigationShell.of(context).goBranch(1),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: _QuickActionCard(
                    icon: Icons.history_outlined,
                    label: 'Historique',
                    onTap: () =>
                        StatefulNavigationShell.of(context).goBranch(2),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: _QuickActionCard(
                    icon: Icons.add_box_outlined,
                    label: 'Nouveau produit',
                    onTap: () => context.push(Routes.productNew),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Tappable quick-action card with icon and label.
class _QuickActionCard extends StatelessWidget {
  const _QuickActionCard({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return AppCard(
      onTap: onTap,
      padding: AppSpacing.md,
      child: Column(
        // ✨ mainAxisAlignment center — contenu centré quand la carte s'étire
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: cs.primaryContainer,
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            child: Icon(icon, color: cs.onPrimaryContainer, size: 22),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            label,
            textAlign: TextAlign.center,
            style: AppTypography.labelSmall.copyWith(
              color: cs.onSurface,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

/// Premium summary card with gradient background.
class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.summary,
    this.hasError = false,
    this.onRetry,
  });

  final DailySummary summary;

  /// When true, shows a subtle error indicator at the bottom of the card.
  final bool hasError;

  /// Optional retry callback shown when [hasError] is true.
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(
      context,
    ).textTheme; // ✨ un seul lookup pour l'error block
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            cs.primary.withValues(alpha: 0.95),
            cs.primary.withValues(alpha: 0.85),
          ],
        ),
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        boxShadow: [
          BoxShadow(
            color: cs.primary.withValues(alpha: 0.2),
            blurRadius: 30,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Stack(
        children: [
          // ✨ filigrane décoratif — profondeur visuelle sans nuire au contraste
          Positioned(
            top: -24,
            right: -24,
            child: Icon(
              Icons.payments_outlined,
              size: 160,
              color: cs.onPrimary.withValues(alpha: 0.08),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total du jour',
                  style: AppTypography.labelMedium.copyWith(
                    color: cs.onPrimary.withValues(alpha: 0.8),
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                // ✨ FittedBox — les gros montants (7+ chiffres) rétrécissent
                // au lieu de wrapper ou déborder de la carte
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: AmountDisplay(
                    amount: summary.totalAmount,
                    size: AmountSize.hero,
                    color: cs.onPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                Row(
                  children: [
                    _SummaryMetric(
                      label: 'Nombre',
                      child: Text(
                        '${summary.saleCount}',
                        style: AppTypography.bodyLarge.copyWith(
                          color: cs.onPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    _SummaryMetric(
                      label: 'Espèces',
                      dotColor: cs.secondary,
                      child: AmountDisplay(
                        amount: summary.cashTotal,
                        size: AmountSize.medium,
                        color: cs.onPrimary,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    _SummaryMetric(
                      label: 'Mobile',
                      dotColor: cs.tertiary,
                      child: AmountDisplay(
                        amount: summary.mobileMoneyTotal,
                        size: AmountSize.medium,
                        color: cs.onPrimary,
                      ),
                    ),
                  ],
                ),
                if (hasError) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    children: [
                      Icon(
                        Icons.warning_outlined,
                        color: cs.onPrimary.withValues(alpha: 0.7),
                        size: 14,
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        'Données non disponibles',
                        style: tt.labelSmall?.copyWith(
                          color: cs.onPrimary.withValues(alpha: 0.7),
                        ),
                      ),
                      if (onRetry != null) ...[
                        const SizedBox(width: AppSpacing.sm),
                        // ✨ TextButton : ripple + zone tactile 48px + Semantics natifs
                        TextButton(
                          onPressed: onRetry,
                          style: TextButton.styleFrom(
                            foregroundColor: cs.onPrimary,
                            padding: EdgeInsets.zero,
                            minimumSize: const Size(48, 32),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            textStyle: tt.labelSmall?.copyWith(
                              decoration: TextDecoration.underline,
                              decorationColor: cs.onPrimary,
                            ),
                          ),
                          child: const Text('Réessayer'),
                        ),
                      ],
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Labeled metric in the summary card.
class _SummaryMetric extends StatelessWidget {
  const _SummaryMetric({
    required this.label,
    required this.child,
    this.dotColor,
  });

  final String label;
  final Widget child;

  /// Optional color dot preceding the label — distinguishes payment breakdowns.
  final Color? dotColor;

  @override
  Widget build(BuildContext context) {
    // ✨ extrait pour éviter Theme.of(context) multi-ligne verbeux
    final cs = Theme.of(context).colorScheme;
    return Expanded(
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (dotColor != null) ...[
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: dotColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
              ],
              Text(
                label,
                style: AppTypography.captionText.copyWith(
                  color: cs.onPrimary.withValues(alpha: 0.7),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          // ✨ FittedBox — rétrécit au lieu de wrapper/déborder sur les
          // grands montants (colonne étroite à 3 partout)
          FittedBox(fit: BoxFit.scaleDown, child: child),
        ],
      ),
    );
  }
}

/// "Activité récente" — mini-list of today's latest sales, linking to the
/// full history. Hidden entirely when there is nothing to show yet.
class _RecentActivitySection extends ConsumerWidget {
  const _RecentActivitySection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recentSalesAsync = ref.watch(recentSalesProvider);
    final hPad = responsiveValue(
      context,
      small: AppSpacing.md,
      medium: AppSpacing.lg,
    );

    return recentSalesAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
      data: (sales) {
        if (sales.isEmpty) return const SizedBox.shrink();

        final cs = Theme.of(context).colorScheme;
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: hPad),
          child: Container(
            decoration: BoxDecoration(
              color: cs.surfaceContainerLow,
              borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
              border: Border.all(
                color: cs.outlineVariant.withValues(alpha: 0.4),
              ),
            ),
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Activité récente',
                      style: AppTypography.labelMedium.copyWith(
                        color: cs.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextButton(
                      onPressed: () =>
                          StatefulNavigationShell.of(context).goBranch(2),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(48, 32),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text('Voir tout'),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                for (final sale in sales) _RecentActivityRow(sale: sale),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// A single recent-sale row, tappable to open the sale's detail.
class _RecentActivityRow extends StatelessWidget {
  const _RecentActivityRow({required this.sale});

  final Sale sale;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final receiptLabel = sale.receiptNumber > 0
        ? 'Vente #${sale.receiptNumber}'
        : 'Vente provisoire';

    return InkWell(
      onTap: () => context.push(Routes.saleDetail, extra: sale),
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: cs.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.shopping_cart_outlined,
                color: cs.onPrimaryContainer,
                size: 20,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    receiptLabel,
                    style: AppTypography.labelSmall.copyWith(
                      color: cs.onSurface,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    _relativeTimeLabel(sale.createdAt),
                    style: AppTypography.captionText.copyWith(
                      color: cs.onSurfaceVariant.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
            AmountDisplay(amount: sale.totalAmount, size: AmountSize.small),
          ],
        ),
      ),
    );
  }
}

/// Formats a timestamp as a short French relative-time label.
String _relativeTimeLabel(DateTime dateTime) {
  final diff = DateTime.now().difference(dateTime);
  if (diff.inMinutes < 1) return 'À l\'instant';
  if (diff.inMinutes < 60) return 'Il y a ${diff.inMinutes} min';
  if (diff.inHours < 24) return 'Il y a ${diff.inHours} h';
  return 'Il y a ${diff.inDays} j';
}
