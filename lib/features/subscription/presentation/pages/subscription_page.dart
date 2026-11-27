import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/widgets/index.dart';
import '../../domain/entities/subscription.dart';
import '../providers/subscription_providers.dart';

final _date = DateFormat('d MMMM yyyy', 'fr_FR');

/// Libellé et tonalité d'un statut d'abonnement.
(String, StatusTone) subscriptionStatusLabel(SubscriptionStatus status) =>
    switch (status) {
      SubscriptionStatus.free => ('Gratuit', StatusTone.neutral),
      SubscriptionStatus.pending => (
        'Paiement en vérification',
        StatusTone.warning,
      ),
      SubscriptionStatus.active => ('Actif', StatusTone.success),
      SubscriptionStatus.rejected => ('Demande refusée', StatusTone.error),
      SubscriptionStatus.expired => ('Expiré', StatusTone.neutral),
    };

/// « Mon abonnement » : formule actuelle et statut en tête (sans carte),
/// avertissement éventuel, puis les formules dans l'ordre. La formule
/// actuelle est cerclée de cacao ; la formule au-dessus porte le seul bouton
/// plein de l'écran (ADR-0017).
class SubscriptionPage extends ConsumerWidget {
  /// Crée la page.
  const SubscriptionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subscription =
        ref.watch(currentSubscriptionProvider).value ?? MySubscription.free;
    final catalog = ref.watch(subscriptionCatalogProvider);
    final canPay = catalog.value?.payment.available ?? false;

    Future<void> reload() async {
      ref.invalidate(subscriptionCatalogProvider);
      await ref.read(currentSubscriptionProvider.notifier).refresh();
    }

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Mon abonnement'),
      ),
      body: RefreshIndicator(
        onRefresh: reload,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            _CurrentPlanHeader(subscription: subscription),
            ..._notice(subscription, catalog.value),
            const SizedBox(height: AppSpacing.lg),
            const OverlineHeader('Formules'),
            const SizedBox(height: AppSpacing.sm),
            switch (catalog) {
              AsyncData(:final value) => Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (final offer in value.plans) ...[
                    _PlanCard(
                      offer: offer,
                      subscription: subscription,
                      canPay: canPay,
                    ),
                    const SizedBox(height: AppSpacing.md),
                  ],
                ],
              ),
              AsyncError(:final error) => _CatalogError(
                message: subscriptionErrorMessage(error),
                onRetry: () => ref.invalidate(subscriptionCatalogProvider),
              ),
              _ => const Padding(
                padding: EdgeInsets.all(AppSpacing.lg),
                child: Center(child: AppLoadingIndicator()),
              ),
            },
          ],
        ),
      ),
    );
  }

  /// Un seul avertissement à la fois : demande en cours, refus, ou paiement
  /// pas encore ouvert.
  List<Widget> _notice(
    MySubscription subscription,
    SubscriptionCatalog? catalog,
  ) {
    final request = subscription.latestRequest;
    final notice = switch (subscription.status) {
      _ when request != null && subscription.hasPendingRequest => _Notice(
        tone: StatusTone.warning,
        title: 'Paiement en vérification',
        message:
            'Nous vérifions votre transfert Wave de '
            '${formatFcfa(request.amount)}. La formule '
            '${request.plan.label} sera activée dès la vérification.',
      ),
      SubscriptionStatus.rejected when request != null => _Notice(
        tone: StatusTone.error,
        title: 'Demande refusée',
        message:
            '${request.rejectionReason ?? 'Paiement non retrouvé'}. '
            'Vous pouvez envoyer une nouvelle demande.',
      ),
      _ when catalog != null && !catalog.payment.available => const _Notice(
        tone: StatusTone.warning,
        title: 'Souscription bientôt disponible',
        message: 'Le paiement par Wave n’est pas encore ouvert.',
      ),
      _ => null,
    };
    return [
      if (notice != null) ...[const SizedBox(height: AppSpacing.md), notice],
    ];
  }
}

/// Formule actuelle posée sur le fond, sans carte : nom, statut, échéance.
class _CurrentPlanHeader extends StatelessWidget {
  const _CurrentPlanHeader({required this.subscription});

  final MySubscription subscription;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final (label, tone) = subscriptionStatusLabel(subscription.status);
    final expiresAt = subscription.expiresAt;
    final paidUntil = subscription.paidUntil;
    final meta = AppTypography.body.copyWith(color: colors.textSecondary);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Formule actuelle', style: meta),
        const SizedBox(height: AppSpacing.xs),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                subscription.plan.label,
                style: AppTypography.screenTitle,
              ),
            ),
            StatusIndicator(label: label, tone: tone),
          ],
        ),
        if (expiresAt != null) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(
            paidUntil != null && paidUntil.isAfter(expiresAt)
                ? 'Payé jusqu’au ${_date.format(paidUntil.toLocal())}'
                : 'Actif jusqu’au ${_date.format(expiresAt.toLocal())}',
            style: meta,
          ),
        ] else if (subscription.plan == PlanId.discovery) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Historique des ${subscription.historyDays ?? 30} derniers jours.',
            style: meta,
          ),
        ],
      ],
    );
  }
}

/// Bandeau d'avertissement : aplat « subtle » du statut, texte du statut.
class _Notice extends StatelessWidget {
  const _Notice({
    required this.tone,
    required this.title,
    required this.message,
  });

  final StatusTone tone;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final (background, foreground) = tone == StatusTone.error
        ? (colors.errorSubtle, colors.onErrorSubtle)
        : (colors.warningSubtle, colors.textPrimary);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSurface),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppTypography.bodyStrong.copyWith(color: foreground),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              message,
              style: AppTypography.body.copyWith(
                color: foreground,
                fontFeatures: AppTypography.tabularFigures,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureLine extends StatelessWidget {
  const _FeatureLine({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check,
            size: 18,
            color: colors.success,
            semanticLabel: 'Inclus',
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(child: Text(label, style: AppTypography.body)),
        ],
      ),
    );
  }
}

/// Une formule : nom, prix en chiffre, points forts, action.
///
/// La formule actuelle est cerclée de cacao. La formule juste au-dessus de
/// l'actuelle porte le bouton plein (« Passer à … ») ; les autres formules
/// payantes un bouton secondaire. Aucune action pendant une vérification ou
/// tant que le paiement n'est pas ouvert (le bandeau l'explique).
class _PlanCard extends StatelessWidget {
  const _PlanCard({
    required this.offer,
    required this.subscription,
    required this.canPay,
  });

  final PlanOffer offer;
  final MySubscription subscription;
  final bool canPay;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final isCurrent = offer.plan == subscription.plan;
    final isFree = offer.plan == PlanId.discovery;
    final isNextUp = offer.plan.index == subscription.plan.index + 1;
    final showAction = !isFree && canPay && !subscription.hasPendingRequest;
    final months = offer.durationMonths;

    void pay() => context.push(Routes.subscriptionPayment, extra: offer.plan);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSurface),
        border: Border.all(
          color: isCurrent ? colors.action : colors.border,
          width: isCurrent ? 2 : 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: Text(offer.name, style: AppTypography.heading)),
                if (isCurrent)
                  const StatusIndicator(
                    label: 'Votre formule',
                    tone: StatusTone.success,
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            if (isFree)
              const Text('Gratuit', style: AppTypography.figureSmall)
            else
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: formatFcfa(offer.price),
                      style: AppTypography.figureSmall,
                    ),
                    TextSpan(
                      text: months == 1 ? ' / mois' : ' / $months mois',
                      style: AppTypography.body.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                  ],
                ),
                style: const TextStyle(
                  fontFeatures: AppTypography.tabularFigures,
                ),
              ),
            const SizedBox(height: AppSpacing.sm),
            for (final line in offer.highlights) _FeatureLine(label: line),
            if (showAction) ...[
              const SizedBox(height: AppSpacing.md),
              if (isNextUp)
                PrimaryButton(label: 'Passer à ${offer.name}', onPressed: pay)
              else
                SecondaryButton(
                  label: isCurrent
                      ? 'Renouveler ${offer.name}'
                      : 'Choisir ${offer.name}',
                  onPressed: pay,
                ),
            ],
          ],
        ),
      ),
    );
  }
}

class _CatalogError extends StatelessWidget {
  const _CatalogError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          message,
          style: AppTypography.body.copyWith(
            color: AppColors.of(context).error,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        SecondaryButton(label: 'Réessayer', onPressed: onRetry),
      ],
    );
  }
}
