import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/index.dart';
import '../providers/auth_providers.dart';
import '../../providers/store_provider.dart';
import '../widgets/pin_numpad.dart';

/// Écran de connexion quotidienne par PIN avec pavé numérique personnalisé.
///
/// Remplace le clavier système par un pavé 3×4 et des points indicateurs. Gère
/// le blocage après 5 tentatives ; animation de secousse sur un PIN erroné.
class PinLoginPage extends ConsumerStatefulWidget {
  /// Crée une page de connexion par PIN.
  const PinLoginPage({super.key});

  @override
  ConsumerState<PinLoginPage> createState() => _PinLoginPageState();
}

class _PinLoginPageState extends ConsumerState<PinLoginPage>
    with SingleTickerProviderStateMixin {
  String _pin = '';
  late AnimationController _shakeController;
  late Animation<Offset> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 420),
      vsync: this,
    );
    _shakeAnimation =
        TweenSequence<Offset>([
          TweenSequenceItem(
            tween: Tween(begin: Offset.zero, end: const Offset(0.04, 0)),
            weight: 1,
          ),
          TweenSequenceItem(
            tween: Tween(
              begin: const Offset(0.04, 0),
              end: const Offset(-0.04, 0),
            ),
            weight: 2,
          ),
          TweenSequenceItem(
            tween: Tween(
              begin: const Offset(-0.04, 0),
              end: const Offset(0.02, 0),
            ),
            weight: 1,
          ),
          TweenSequenceItem(
            tween: Tween(begin: const Offset(0.02, 0), end: Offset.zero),
            weight: 1,
          ),
        ]).animate(
          CurvedAnimation(parent: _shakeController, curve: Curves.easeInOut),
        );
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  void _onDigit(String digit) {
    if (_pin.length >= 4) return;
    setState(() => _pin += digit);
    if (_pin.length == 4) unawaited(_verifyPin());
  }

  void _onBackspace() {
    if (_pin.isEmpty) return;
    setState(() => _pin = _pin.substring(0, _pin.length - 1));
  }

  Future<void> _verifyPin() async {
    try {
      await ref.read(authProvider.notifier).verifyPin(_pin);
      // Le routeur redirige automatiquement sur l'état AuthAuthenticated
    } catch (_) {
      // Erreur affichée via authValue.asError
    }
  }

  Future<void> _onForgotPin() async {
    await ref.read(authProvider.notifier).logout();
    if (mounted) context.go(Routes.emailLogin);
  }

  static String _timeGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Bonjour,';
    if (hour < 18) return 'Bon après-midi,';
    return 'Bonsoir,';
  }

  @override
  Widget build(BuildContext context) {
    final authValue = ref.watch(authProvider);
    final systemError = authValue.asError?.error.toString();
    final isLoading = authValue.isLoading;
    final cs = Theme.of(context).colorScheme;
    final storeName =
        ref.watch(storeConfigProvider).whenOrNull(data: (s) => s?.name) ??
        'Ma boutique';

    ref.listen(authProvider, (_, next) {
      if (next.hasError) {
        setState(() => _pin = '');
        unawaited(_shakeController.forward(from: 0));
      }
    });

    final isDark = Theme.of(context).brightness == Brightness.dark;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: FillOrScroll(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Column(
                children: [
                  const Spacer(),
                  // Icône de cadenas dans un conteneur aux couleurs de la marque
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: cs.primaryContainer,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                    ),
                    child: Icon(
                      Icons.lock_rounded,
                      size: 36,
                      color: cs.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    '${_timeGreeting()} $storeName',
                    style: AppTypography.bodyMedium.copyWith(
                      color: cs.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Entrez votre PIN',
                    style: AppTypography.titleLarge.copyWith(
                      color: cs.onSurface,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  // Points indicateurs — secousse sur un PIN erroné
                  SlideTransition(
                    position: _shakeAnimation,
                    child: PinDots(filledCount: _pin.length),
                  ),
                  // Emplacement de l'erreur — hauteur fixe pour éviter un saut de
                  // mise en page
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: systemError != null
                        ? Padding(
                            key: ValueKey(systemError),
                            padding: const EdgeInsets.only(top: AppSpacing.sm),
                            child: Semantics(
                              liveRegion: true,
                              child: Text(
                                systemError,
                                style: AppTypography.errorText.copyWith(
                                  color: cs.error,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )
                        : const SizedBox(height: AppSpacing.md + AppSpacing.sm),
                  ),
                  const Spacer(),
                  // Pavé numérique personnalisé — pas de clavier système
                  if (isLoading)
                    const SizedBox(
                      height: 290,
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else
                    PinNumpad(
                      onDigit: _onDigit,
                      onBackspace: _onBackspace,
                      enabled: !isLoading,
                    ),
                  const SizedBox(height: AppSpacing.sm),
                  TextButton(
                    onPressed: _onForgotPin,
                    child: const Text("J'ai oublié mon PIN"),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
