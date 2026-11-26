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

/// « Mon abonnement » : formule actuelle, statut, échéance, fonctionnalités
/// incluses et formules disponibles (ADR-0017).
class SubscriptionPage extends ConsumerWidget {
  /// Crée la page.
  const SubscriptionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subscription =
        ref.watch(currentSubscriptionProvider).value ?? MySubscription.free;
    final catalog = ref.watch(subscriptionCatalogProvider);

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
            _CurrentPlanCard(subscription: subscription),
            const SizedBox(height: AppSpacing.lg),
            const OverlineHeader('Formules'),
            const SizedBox(height: AppSpacing.sm),
            switch (catalog) {
              AsyncData(:final value) => _PlanList(
                catalog: value,
                subscription: subscription,
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
}

class _CurrentPlanCard extends StatelessWidget {
  const _CurrentPlanCard({required this.subscription});

  final MySubscription subscription;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final (label, tone) = subscriptionStatusLabel(subscription.status);
    final expiresAt = subscription.expiresAt;
    final paidUntil = subscription.paidUntil;
    final request = subscription.latestRequest;
    final meta = AppTypography.body.copyWith(color: colors.textSecondary);

    return AppCard(
      elevated: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Formule actuelle', style: meta),
          const SizedBox(height: AppSpacing.xs),
          Text(subscription.plan.label, style: AppTypography.screenTitle),
          const SizedBox(height: AppSpacing.sm),
          StatusIndicator(label: label, tone: tone),
          if (expiresAt != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Actif jusqu’au ${_date.format(expiresAt.toLocal())}',
              style: meta,
            ),
          ],
          if (paidUntil != null &&
              expiresAt != null &&
              paidUntil.isAfter(expiresAt)) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Déjà renouvelé jusqu’au ${_date.format(paidUntil.toLocal())}',
              style: meta,
            ),
          ],
          if (request != null && subscription.hasPendingRequest) ...[
            const SizedBox(height: AppSpacing.md),
            Text(
              'Nous vérifions votre paiement Wave de '
              '${formatFcfa(request.amount)}. La formule '
              '${request.plan.label} sera activée dès la vérification.',
              style: AppTypography.body,
            ),
          ],
          if (request != null &&
              subscription.status == SubscriptionStatus.rejected) ...[
            const SizedBox(height: AppSpacing.md),
            Text(
              'Motif : ${request.rejectionReason ?? '—'}. '
              'Vous pouvez envoyer une nouvelle demande.',
              style: AppTypography.body.copyWith(color: colors.error),
            ),
          ],
          const SizedBox(height: AppSpacing.md),
          if (subscription.features.isEmpty)
            Text(
              'Ventes, catalogue, stock, caisse et historique des '
              '${subscription.historyDays ?? 30} derniers jours.',
              style: meta,
            )
          else
            for (final feature in subscription.features)
              _FeatureLine(label: feature.label),
        ],
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

class _PlanList extends StatelessWidget {
  const _PlanList({required this.catalog, required this.subscription});

  final SubscriptionCatalog catalog;
  final MySubscription subscription;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (!catalog.payment.available)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: Text(
              'La souscription par Wave ouvre bientôt.',
              style: AppTypography.body.copyWith(
                color: AppColors.of(context).warning,
              ),
            ),
          ),
        for (final offer in catalog.plans) ...[
          _PlanCard(
            offer: offer,
            subscription: subscription,
            canPay: catalog.payment.available,
          ),
          const SizedBox(height: AppSpacing.md),
        ],
      ],
    );
  }
}

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
    final isCurrent = offer.plan == subscription.plan;
    final isFree = offer.plan == PlanId.discovery;
    final pending = subscription.hasPendingRequest;
    final actionLabel = isCurrent
        ? 'Renouveler ${offer.name}'
        : 'Choisir ${offer.name}';

    return AppCard(
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
          Text(
            isFree ? 'Gratuit' : '${formatFcfa(offer.price)} / mois',
            style: AppTypography.bodyStrong,
          ),
          const SizedBox(height: AppSpacing.sm),
          for (final line in offer.highlights) _FeatureLine(label: line),
          if (!isFree) ...[
            const SizedBox(height: AppSpacing.md),
            SecondaryButton(
              label: pending ? 'Demande en cours de vérification' : actionLabel,
              onPressed: pending || !canPay
                  ? null
                  : () => context.push(
                      Routes.subscriptionPayment,
                      extra: offer.plan,
                    ),
            ),
          ],
        ],
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
