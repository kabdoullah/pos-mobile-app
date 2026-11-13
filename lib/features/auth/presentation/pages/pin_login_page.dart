import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/index.dart';
import '../../domain/entities/pin_failure.dart';
import '../../providers/store_provider.dart';
import '../providers/auth_providers.dart';
import '../widgets/auth_layout.dart';
import '../widgets/forgot_pin_sheet.dart';
import '../widgets/pin_numpad.dart';

/// Écran de déverrouillage quotidien par PIN, pavé numérique personnalisé.
///
/// Optimisé pour aller vite à la caisse : la vérification part dès le 4e
/// chiffre. Affiche les tentatives restantes, prévient avant la dernière, puis
/// un compte à rebours pendant le blocage (`AppConfig.maxPinAttempts` échecs →
/// `AppConfig.pinLockoutMinutes` min, voir [Auth.verifyPin]).
class PinLoginPage extends ConsumerStatefulWidget {
  /// Crée une page de connexion par PIN.
  const PinLoginPage({super.key});

  @override
  ConsumerState<PinLoginPage> createState() => _PinLoginPageState();
}

class _PinLoginPageState extends ConsumerState<PinLoginPage>
    with SingleTickerProviderStateMixin {
  String _pin = '';

  /// Fin du blocage en cours ; null si le PIN n'est pas bloqué.
  DateTime? _lockedUntil;
  Timer? _lockoutTicker;

  late final AnimationController _shakeController = AnimationController(
    duration: const Duration(milliseconds: 420),
    vsync: this,
  );
  late final Animation<Offset> _shakeAnimation = TweenSequence<Offset>(
    [
      TweenSequenceItem(
        tween: Tween(begin: Offset.zero, end: const Offset(0.04, 0)),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween(begin: const Offset(0.04, 0), end: const Offset(-0.04, 0)),
        weight: 2,
      ),
      TweenSequenceItem(
        tween: Tween(begin: const Offset(-0.04, 0), end: const Offset(0.02, 0)),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween(begin: const Offset(0.02, 0), end: Offset.zero),
        weight: 1,
      ),
    ],
  ).animate(CurvedAnimation(parent: _shakeController, curve: Curves.easeInOut));

  @override
  void initState() {
    super.initState();
    unawaited(_restoreLockout());
  }

  /// Blocage toujours en cours (app relancée pendant le blocage) : le compte à
  /// rebours s'affiche sans attendre une nouvelle saisie. Sans gravité en cas
  /// d'échec : [Auth.verifyPin] revérifie le blocage à chaque saisie.
  Future<void> _restoreLockout() async {
    try {
      final until = await ref.read(authProvider.notifier).pinLockedUntil();
      if (mounted && until != null) _startLockout(until);
    } on Object {
      return;
    }
  }

  @override
  void dispose() {
    _lockoutTicker?.cancel();
    _shakeController.dispose();
    super.dispose();
  }

  void _startLockout(DateTime until) {
    _lockoutTicker?.cancel();
    setState(() => _lockedUntil = until);
    _lockoutTicker = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (DateTime.now().isAfter(until)) {
        timer.cancel();
        setState(() => _lockedUntil = null);
      } else {
        setState(() {});
      }
    });
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
    await ref.read(authProvider.notifier).verifyPin(_pin);
    // Succès : le routeur ouvre l'accueil. Échec : voir le listen de build().
  }

  static String _greeting() => DateTime.now().hour < 18 ? 'Bonjour' : 'Bonsoir';

  static String _formatRemaining(Duration d) {
    final minutes = d.inMinutes;
    final seconds = d.inSeconds % 60;
    return minutes > 0 ? '$minutes min $seconds s' : '$seconds s';
  }

  /// Message sous les points : vérification, tentatives restantes, blocage.
  (String?, String?) _message(AsyncValue<AuthStatus> authValue) {
    final lockedUntil = _lockedUntil;
    if (lockedUntil != null) {
      final remaining = lockedUntil.difference(DateTime.now());
      return (
        'PIN temporairement bloqué',
        'Réessayez dans ${_formatRemaining(remaining)}.',
      );
    }
    if (authValue.isLoading) return (null, 'Vérification…');
    return switch (authValue.error) {
      WrongPin(remainingAttempts: 1) => (
        'Dernière tentative',
        'Après cet essai, le PIN sera temporairement bloqué.',
      ),
      WrongPin(:final remainingAttempts) => (
        'PIN incorrect',
        'Il vous reste $remainingAttempts tentatives.',
      ),
      // Blocage terminé : on peut réessayer.
      PinLocked() => (null, null),
      null => (null, null),
      final Object e => ('Déverrouillage impossible', e.toString()),
    };
  }

  @override
  Widget build(BuildContext context) {
    final authValue = ref.watch(authProvider);
    final isLoading = authValue.isLoading;
    final cs = Theme.of(context).colorScheme;
    final storeName =
        ref.watch(storeConfigProvider).whenOrNull(data: (s) => s?.name) ??
        'Ma boutique';

    ref.listen(authProvider, (_, next) {
      final error = next.error;
      if (error == null) return;
      setState(() => _pin = '');
      unawaited(_shakeController.forward(from: 0));
      if (error is PinLocked) _startLockout(error.until);
    });

    final (title, detail) = _message(authValue);
    final isLocked = _lockedUntil != null;

    return AuthScaffold(
      scrollable: false,
      resizeToAvoidBottomInset: false,
      child: FillOrScroll(
        child: Column(
          children: [
            const Spacer(),
            Text(
              _greeting(),
              style: AppTypography.bodyMedium.copyWith(
                color: cs.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Semantics(
              header: true,
              child: Text(
                storeName,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.titleLarge.copyWith(color: cs.onSurface),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Entrez votre PIN',
              style: AppTypography.labelMedium.copyWith(color: cs.onSurface),
            ),
            const SizedBox(height: AppSpacing.md),
            SlideTransition(
              position: _shakeAnimation,
              child: PinDots(
                filledCount: _pin.length,
                isError:
                    isLocked || (authValue.hasError && !authValue.isLoading),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            PinMessage(
              title: title,
              detail: detail,
              // Pendant la vérification, l'erreur de l'essai précédent est
              // encore là : « Vérification… » reste en couleur neutre.
              isError: isLocked || (authValue.hasError && !authValue.isLoading),
            ),
            const Spacer(),
            PinNumpad(
              onDigit: _onDigit,
              onBackspace: _onBackspace,
              enabled: !isLoading && !isLocked,
            ),
            const SizedBox(height: AppSpacing.xs),
            // Toujours accessible, même pendant un blocage : le mot de passe
            // du compte remplace le PIN.
            TextButton(
              onPressed: isLoading ? null : () => showForgotPinSheet(context),
              child: const Text('Code PIN oublié ?'),
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
        ),
      ),
    );
  }
}
