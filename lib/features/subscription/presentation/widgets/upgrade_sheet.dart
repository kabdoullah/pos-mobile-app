import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/widgets/index.dart';
import '../../domain/entities/subscription.dart';
import '../providers/subscription_providers.dart';

/// Vrai si [feature] est accessible ; sinon explique la formule nécessaire
/// et propose la page des abonnements (ADR-0017).
///
/// Point d'entrée unique des écrans : aucun widget ne compare lui-même des
/// formules ou des prix.
Future<bool> requireFeature(
  BuildContext context,
  WidgetRef ref,
  PlanFeature feature,
) async {
  if (ref.read(entitlementsProvider).can(feature)) return true;
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (_) => UpgradeSheet(feature: feature),
  );
  return false;
}

/// Feuille « Fonctionnalité réservée » : ce qui est bloqué, la formule qui
/// le débloque et son prix, et le chemin vers la souscription.
class UpgradeSheet extends ConsumerWidget {
  /// Crée la feuille pour [feature].
  const UpgradeSheet({required this.feature, super.key});

  /// Fonctionnalité demandée.
  final PlanFeature feature;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = AppColors.of(context);
    final offer = ref
        .watch(subscriptionCatalogProvider)
        .value
        ?.cheapestWith(feature);
    final planName = offer?.name ?? 'Starter';
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.lg,
          AppSpacing.md,
          AppSpacing.md,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(feature.label, style: AppTypography.sectionTitle),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Cette fonction fait partie de la formule $planName. '
              'Vos ventes et vos données restent accessibles.',
              style: AppTypography.body.copyWith(color: colors.textSecondary),
            ),
            if (offer != null) ...[
              const SizedBox(height: AppSpacing.md),
              Text(
                '${offer.name} : ${formatFcfa(offer.price)} par mois',
                style: AppTypography.bodyStrong,
              ),
            ],
            const SizedBox(height: AppSpacing.lg),
            PrimaryButton(
              label: 'Voir les formules',
              onPressed: () {
                Navigator.of(context).pop();
                unawaited(context.push(Routes.subscription));
              },
            ),
            const SizedBox(height: AppSpacing.sm),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Plus tard'),
            ),
          ],
        ),
      ),
    );
  }
}
