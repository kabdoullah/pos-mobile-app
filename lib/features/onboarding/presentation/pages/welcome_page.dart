import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/widgets/index.dart';
import '../../../auth/providers/auth_di_providers.dart';
import '../../../auth/providers/store_provider.dart';
import '../providers/welcome_provider.dart';

/// « Boutik est prête » : montré une fois, juste après le PIN d'une
/// inscription. Propose le tutoriel en 4 écrans ou l'accès direct à
/// l'accueil.
class WelcomePage extends ConsumerStatefulWidget {
  /// Crée la page d'accueil post-inscription.
  const WelcomePage({super.key});

  @override
  ConsumerState<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends ConsumerState<WelcomePage> {
  bool _leaving = false;

  /// Marque l'accueil comme vu (il ne revient plus), puis [then].
  Future<void> _leave(void Function() then) async {
    if (_leaving) return;
    setState(() => _leaving = true);
    // Repository lu une fois : l'appel ne dépend pas de la vie du provider.
    final repository = ref.read(authRepositoryProvider);
    await repository.completeWelcome();
    ref.invalidate(welcomePendingProvider);
    if (mounted) then();
  }

  /// Tutoriel à la place de cette page : il finit sur l'accueil.
  void _discover() => unawaited(_leave(() => context.go(Routes.tutorial)));

  void _skip() => unawaited(
    _leave(() {
      if (context.canPop()) {
        context.pop();
      } else {
        context.go(Routes.home);
      }
    }),
  );

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final storeName = ref.watch(storeConfigProvider).value?.name.trim();
    final title = storeName == null || storeName.isEmpty
        ? 'Votre boutique est prête'
        : '$storeName est prête';

    return PopScope(
      // Retour système = « Passer » : l'accueil ne doit pas revenir.
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _skip();
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          StrokeIcon(
                            DesignIcon.sell,
                            size: 32,
                            color: colors.textSecondary,
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          Semantics(
                            header: true,
                            child: Text(
                              title,
                              style: AppTypography.figureHero.copyWith(
                                fontFeatures: const [],
                              ),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            'Découvrez l’essentiel de Ma Caisse en 4 écrans, '
                            'moins d’une minute.',
                            style: AppTypography.body.copyWith(
                              color: colors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                PrimaryButton(
                  label: 'Découvrir',
                  onPressed: _leaving ? null : _discover,
                ),
                const SizedBox(height: AppSpacing.xs),
                TextButton(
                  onPressed: _leaving ? null : _skip,
                  child: const Text('Passer, aller à l’accueil'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
