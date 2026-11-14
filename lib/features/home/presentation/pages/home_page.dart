import 'dart:async';

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/router/main_shell.dart';
import '../../../../core/sync/sync_orchestrator.dart';
import '../../../../core/sync/sync_providers.dart';
import '../../../../core/widgets/index.dart';
import '../../../auth/providers/store_provider.dart';
import '../../../cash_register/domain/entities/cash_session.dart';
import '../../../cash_register/presentation/providers/cash_register_providers.dart';
import '../../../cash_register/presentation/pages/open_cash_session_page.dart';
import '../../../onboarding/presentation/providers/welcome_provider.dart';
import '../providers/home_providers.dart';
import '../widgets/account_email_banner.dart';
import '../widgets/first_steps_section.dart';
import '../widgets/low_stock_section.dart';
import '../widgets/recent_sales_section.dart';
import '../widgets/today_summary.dart';

/// Accueil : un seul bloc mis en avant, l'état de la caisse et les espèces du
/// tiroir ; puis les chiffres du jour, les alertes de stock et les dernières
/// ventes, en listes plates. L'action du bas suit l'état de la caisse :
/// « Nouvelle vente » ou « Ouvrir la caisse ».
class HomePage extends ConsumerWidget {
  /// Crée l'accueil.
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Juste après l'inscription : « boutique prête » puis tutoriel, une fois
    // (WelcomePage efface le drapeau avant de se fermer).
    ref.listen(welcomePendingProvider, (previous, next) {
      if (next.value == true && previous?.value != true) {
        unawaited(context.push(Routes.welcome));
      }
    });
    final colors = AppColors.of(context);
    final storeName = ref.watch(storeConfigProvider).value?.name;
    final dateLabel = DateFormat(
      'EEEE d MMMM',
      'fr_FR',
    ).format(ref.watch(todayProvider));
    final session = ref.watch(activeCashSessionProvider);
    final isLoading = !session.hasValue && !session.hasError;
    final isClosed = session.hasValue && session.value == null;
    final steps = watchFirstSteps(ref);

    void goTo(ShellBranch branch) =>
        StatefulNavigationShell.of(context).goBranch(branch.index);

    return Scaffold(
      appBar: AppBar(
        titleSpacing: AppSpacing.md,
        title: Text(
          storeName == null || storeName.isEmpty ? 'Accueil' : storeName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: AppSpacing.md),
            child: OfflineStatusIndicator(),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _SyncFailedAlert(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(bottom: AppSpacing.lg),
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.md,
                    AppSpacing.xs,
                    AppSpacing.md,
                    AppSpacing.sm + AppSpacing.xs,
                  ),
                  child: Text(
                    toBeginningOfSentenceCase(dateLabel, 'fr_FR'),
                    style: AppTypography.body.copyWith(
                      fontSize: 15,
                      color: colors.textSecondary,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
                  child: _CashBox(),
                ),
                if (session.value != null)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.md,
                      AppSpacing.sm + AppSpacing.xs,
                      AppSpacing.md,
                      0,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: SecondaryButton(
                            label: 'Nouveau produit',
                            onPressed: () => context.push(Routes.productNew),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: SecondaryButton(
                            label: 'Voir le stock',
                            onPressed: () => goTo(ShellBranch.inventory),
                          ),
                        ),
                      ],
                    ),
                  ),
                const FirstStepsSection(),
                const TodaySummary(),
                const AccountEmailBanner(),
                LowStockSection(onSeeStock: () => goTo(ShellBranch.inventory)),
                RecentSalesSection(
                  onSeeAll: () => goTo(ShellBranch.salesHistory),
                ),
              ],
            ),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              color: colors.surface,
              border: Border(top: BorderSide(color: colors.border)),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm + AppSpacing.xs,
              ),
              // L'action du bas suit la prochaine étape : premier produit,
              // ouverture de la caisse, puis la vente.
              child: steps != null && !steps.product
                  ? PrimaryButton(
                      label: 'Ajouter mon premier produit',
                      height: AppSpacing.buttonHeight,
                      onPressed: () => context.push(Routes.productNew),
                    )
                  : isClosed
                  ? PrimaryButton(
                      label: 'Ouvrir la caisse',
                      height: AppSpacing.buttonHeight,
                      onPressed: () => showOpenCashSession(context),
                    )
                  : PrimaryButton(
                      label: 'Nouvelle vente',
                      height: AppSpacing.buttonHeight,
                      onPressed: isLoading
                          ? null
                          : () => goTo(ShellBranch.sale),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Bloc mis en avant : caisse ouverte (espèces dans le tiroir, entrée /
/// sortie, clôture) ou fermée (consigne et dernière clôture).
class _CashBox extends ConsumerWidget {
  const _CashBox();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = AppColors.of(context);
    final meta = AppTypography.bodySmall.copyWith(
      color: colors.textSecondary,
      fontFeatures: AppTypography.tabularFigures,
    );
    final session = ref.watch(activeCashSessionProvider);
    final open = session.value;

    final Widget content;
    if (!session.hasValue && !session.hasError) {
      content = const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SkeletonBox(width: 120, height: 16),
          SizedBox(height: AppSpacing.sm),
          SkeletonBox(width: 200, height: 32),
        ],
      );
    } else if (session.hasError) {
      content = const StatusIndicator(
        label: 'Caisse indisponible',
        tone: StatusTone.error,
      );
    } else if (open == null) {
      content = _ClosedContent(meta: meta);
    } else {
      content = _OpenContent(session: open, meta: meta);
    }

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border.all(color: colors.border),
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: content,
      ),
    );
  }
}

class _OpenContent extends ConsumerWidget {
  const _OpenContent({required this.session, required this.meta});

  final CashSession session;
  final TextStyle meta;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(cashSummaryProvider(session.id));
    final values = summary.value;
    final expected = values?.expectedAmount;
    final mobile = values?.mobileMoneySales ?? Decimal.zero;
    final noActivity =
        values != null &&
        values.cashSalesCount == 0 &&
        mobile == Decimal.zero &&
        values.cashIn == Decimal.zero &&
        values.cashOut == Decimal.zero;
    final since = DateFormat.Hm('fr_FR').format(session.openedAt.toLocal());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            const Expanded(
              child: StatusIndicator(
                label: 'Caisse ouverte',
                tone: StatusTone.success,
              ),
            ),
            Text('depuis $since', style: meta),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Text('Espèces dans le tiroir', style: meta),
        if (expected != null)
          Text(
            formatFcfa(expected),
            style: AppTypography.figureHero.copyWith(
              color: expected < Decimal.zero
                  ? AppColors.of(context).error
                  : null,
            ),
          )
        else if (summary.hasError)
          Text('Solde indisponible', style: meta)
        else
          const Padding(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.xs),
            child: SkeletonBox(width: 180, height: 32),
          ),
        if (mobile > Decimal.zero)
          Text('Mobile money, hors tiroir · ${formatFcfa(mobile)}', style: meta)
        else if (noActivity)
          Text('Fond de caisse du matin', style: meta),
        const SizedBox(height: AppSpacing.sm + AppSpacing.xs),
        Row(
          children: [
            Expanded(
              child: SecondaryButton(
                label: 'Entrée / sortie',
                onPressed: () => context.push(Routes.cashRegister),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: SecondaryButton(
                label: 'Clôturer',
                onPressed: () => context.push(Routes.cashClose),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ClosedContent extends ConsumerWidget {
  const _ClosedContent({required this.meta});

  final TextStyle meta;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(localCashSessionHistoryProvider).value;
    final last = lastClosedSession(history);
    final counted = last?.countedAmount;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const StatusIndicator(label: 'Caisse fermée', tone: StatusTone.warning),
        const SizedBox(height: AppSpacing.sm),
        const Text(
          'Comptez les espèces du tiroir, puis ouvrez la caisse pour '
          'commencer à vendre.',
          style: AppTypography.body,
        ),
        if (last != null) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Dernière clôture : ${closureLabel(last.closedAt!)}'
            '${counted == null ? '' : ' · ${formatFcfa(counted)}'}',
            style: meta,
          ),
          // Caisse fermée : seul accès à l'historique des sessions (détail,
          // comptages, écarts).
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: () => context.push(Routes.cashHistory),
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: const Size(0, AppSpacing.minTapTarget),
              ),
              child: const Text('Voir les sessions de caisse'),
            ),
          ),
        ],
      ],
    );
  }
}

/// « aujourd'hui à 19:30 », « hier à 19:30 » ou « le 3 novembre à 19:30 ».
String closureLabel(DateTime closedAt, {DateTime? now}) {
  final local = closedAt.toLocal();
  final today = now ?? DateTime.now();
  final day = DateTime(local.year, local.month, local.day);
  final days = DateTime(
    today.year,
    today.month,
    today.day,
  ).difference(day).inDays;
  final time = DateFormat.Hm('fr_FR').format(local);
  return switch (days) {
    0 => 'aujourd’hui à $time',
    1 => 'hier à $time',
    _ => 'le ${DateFormat('d MMMM', 'fr_FR').format(local)} à $time',
  };
}

/// Message bloquant (seul aplat de couleur) : des envois ont échoué ; ils
/// sont gardés sur le téléphone.
class _SyncFailedAlert extends ConsumerWidget {
  const _SyncFailedAlert();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(syncOrchestratorProvider);
    final pending = ref.watch(pendingSyncCountProvider).value ?? 0;
    if (status is! SyncStatusError || pending == 0) {
      return const SizedBox.shrink();
    }
    final colors = AppColors.of(context);
    final style = AppTypography.body.copyWith(
      fontSize: 15,
      height: 1.4,
      color: colors.onErrorSubtle,
    );
    return ColoredBox(
      color: colors.errorSubtle,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.xs + 2,
          AppSpacing.xs + 2,
          AppSpacing.xs + 2,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: pending == 1
                          ? '1 envoi en échec. '
                          : '$pending envois en échec. ',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const TextSpan(text: 'Ils sont gardés sur ce téléphone.'),
                  ],
                ),
                style: style,
              ),
            ),
            TextButton(
              onPressed: () => unawaited(
                ref.read(syncOrchestratorProvider.notifier).syncNow(),
              ),
              style: TextButton.styleFrom(
                foregroundColor: colors.onErrorSubtle,
                textStyle: AppTypography.labelLarge.copyWith(
                  decoration: TextDecoration.underline,
                ),
              ),
              child: const Text('Réessayer'),
            ),
          ],
        ),
      ),
    );
  }
}
