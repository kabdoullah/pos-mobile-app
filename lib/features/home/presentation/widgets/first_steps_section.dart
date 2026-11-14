import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/router/main_shell.dart';
import '../../../../core/widgets/index.dart';
import '../../../cash_register/presentation/providers/cash_register_providers.dart';
import '../../../cash_register/presentation/widgets/open_cash_session_sheet.dart';
import '../../../inventory/presentation/providers/inventory_providers.dart';
import '../providers/home_providers.dart';

/// Avancement des « Premiers pas » : produit créé, caisse déjà ouverte,
/// vente faite. `null` tant qu'une des données n'est pas connue.
typedef FirstSteps = ({bool product, bool register, bool sale});

/// Lit l'avancement des premiers pas depuis les données existantes (rien
/// n'est enregistré à part).
FirstSteps? watchFirstSteps(WidgetRef ref) {
  final products = ref.watch(stockProductsProvider).value;
  final active = ref.watch(activeCashSessionProvider);
  final history = ref.watch(localCashSessionHistoryProvider).value;
  final hasSale = ref.watch(hasAnySaleProvider).value;
  if (products == null || !active.hasValue || history == null) return null;
  if (hasSale == null) return null;
  // Une vente suppose un produit et une caisse ouverte : après une
  // reconnexion, les sessions passées ne sont pas rechargées sur le
  // téléphone, mais les ventes le sont.
  return (
    product: products.isNotEmpty || hasSale,
    register: active.value != null || history.isNotEmpty || hasSale,
    sale: hasSale,
  );
}

/// « Premiers pas » de l'accueil : produit, caisse, première vente. Chaque
/// étape à faire mène à son action ; la section disparaît après la première
/// vente (toutes les étapes faites).
class FirstStepsSection extends ConsumerWidget {
  /// Crée la section.
  const FirstStepsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final steps = watchFirstSteps(ref);
    // Masquée par l'utilisateur, ou pas encore lue (pas d'apparition fugace).
    final hidden = ref.watch(firstStepsHiddenProvider).value ?? true;
    if (hidden ||
        steps == null ||
        (steps.product && steps.register && steps.sale)) {
      return const SizedBox.shrink();
    }
    final colors = AppColors.of(context);
    final done = [steps.product, steps.register, steps.sale];
    final doneCount = done.where((d) => d).length;
    // Étape en cours : la première pas encore faite.
    final current = done.indexOf(false);

    final rows = [
      (
        title: 'Ajouter un premier produit',
        detail: 'Nom et prix suffisent',
        action: () => context.push(Routes.productNew),
      ),
      (
        title: 'Ouvrir la caisse',
        detail: 'Avec votre fond de caisse',
        action: () => showOpenCashSessionSheet(context),
      ),
      (
        title: 'Faire une première vente',
        detail: 'Même une vente d’essai',
        action: () => StatefulNavigationShell.of(
          context,
        ).goBranch(ShellBranch.sale.index),
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        OverlineHeader('Premiers pas', trailing: '$doneCount sur 3'),
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            0,
            AppSpacing.md,
            AppSpacing.sm,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(
              value: doneCount / 3,
              minHeight: 4,
              color: colors.action,
              backgroundColor: colors.border,
            ),
          ),
        ),
        FlatList(
          children: [
            for (final (i, row) in rows.indexed)
              _StepRow(
                number: i + 1,
                title: row.title,
                detail: row.detail,
                isDone: done[i],
                isCurrent: i == current,
                onTap: done[i] ? null : row.action,
              ),
          ],
        ),
        // Masquable dès qu'une étape est faite ; le tutoriel reste dans les
        // Paramètres.
        if (doneCount > 0)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
            // Bouton puis indice : passent à la ligne sur petit écran.
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                TextButton(
                  onPressed: () =>
                      ref.read(firstStepsHiddenProvider.notifier).hide(),
                  child: const Text('Masquer les premiers pas'),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm + 2,
                  ),
                  child: Text(
                    'Revoir le tutoriel depuis Paramètres',
                    style: AppTypography.meta.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _StepRow extends StatelessWidget {
  const _StepRow({
    required this.number,
    required this.title,
    required this.detail,
    required this.isDone,
    required this.isCurrent,
    required this.onTap,
  });

  final int number;
  final String title;
  final String detail;
  final bool isDone;
  final bool isCurrent;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Semantics(
      button: onTap != null,
      label: isDone ? '$title, fait' : '$title, étape $number sur 3',
      excludeSemantics: true,
      child: InkWell(
        onTap: onTap,
        child: Stack(
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 60),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                child: Row(
                  children: [
                    if (!isDone) ...[
                      DecoratedBox(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isCurrent
                                ? colors.action
                                : colors.borderStrong,
                            width: isCurrent ? 2 : 1,
                          ),
                        ),
                        child: SizedBox.square(
                          dimension: 28,
                          child: Center(
                            child: Text(
                              '$number',
                              style: AppTypography.meta.copyWith(
                                fontWeight: FontWeight.w600,
                                color: colors.textPrimary,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm + 4),
                    ],
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: AppTypography.bodyStrong.copyWith(
                              color: isDone ? colors.textSecondary : null,
                            ),
                          ),
                          if (!isDone)
                            Text(
                              detail,
                              style: AppTypography.bodySmall.copyWith(
                                color: colors.textSecondary,
                              ),
                            ),
                        ],
                      ),
                    ),
                    if (isDone)
                      const StatusIndicator(
                        label: 'Fait',
                        tone: StatusTone.success,
                      ),
                  ],
                ),
              ),
            ),
            if (isCurrent)
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                child: SizedBox(
                  width: 3,
                  child: ColoredBox(color: colors.action),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
