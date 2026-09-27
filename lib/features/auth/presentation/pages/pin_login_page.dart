import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/sync/sync_providers.dart';
import '../../../../core/widgets/index.dart';
import '../../domain/entities/pin_failure.dart';
import '../../providers/store_provider.dart';
import '../providers/auth_providers.dart';
import '../widgets/auth_layout.dart';
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

  Future<void> _confirmSwitchAccount() async {
    final pending = await _pendingSalesCount();
    if (!mounted) return;
    final confirmed = await showConfirmDialog(
      context,
      title: 'Changer de compte ?',
      message: [
        'Vous devrez vous reconnecter avec les identifiants du nouveau '
            'compte. Le PIN de cet appareil sera supprimé.',
        // Si un autre compte se connecte, la synchro efface les données
        // locales de l'ancien compte (y compris les ventes non envoyées).
        if (pending == 1)
          '1 vente pas encore synchronisée : déverrouillez et synchronisez '
              'd\'abord, sinon elle sera effacée si un autre compte se '
              'connecte.',
        if (pending > 1)
          '$pending ventes pas encore synchronisées : déverrouillez et '
              'synchronisez d\'abord, sinon elles seront effacées si un autre '
              'compte se connecte.',
      ].join('\n\n'),
      confirmLabel: 'Changer de compte',
      isDangerous: pending > 0,
    );
    // Le routeur ouvre la connexion dès que l'état passe à Unauthenticated.
    if (confirmed && mounted) {
      await ref.read(authProvider.notifier).logout();
    }
  }

  /// Ventes pas encore envoyées au serveur. Lu à la demande : l'écran PIN
  /// n'a pas à ouvrir la base locale pour rien.
  Future<int> _pendingSalesCount() async {
    // Garde le provider (auto-dispose) en vie le temps de la lecture.
    final sub = ref.listenManual(pendingSyncCountProvider, (_, _) {});
    try {
      return await ref.read(pendingSyncCountProvider.future);
    } on Object {
      return 0;
    } finally {
      sub.close();
    }
  }

  static String _greeting() =>
      DateTime.now().hour < 18 ? 'Bonjour 👋' : 'Bonsoir 👋';

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
              child: PinDots(filledCount: _pin.length),
            ),
            const SizedBox(height: AppSpacing.sm),
            PinMessage(
              title: title,
              detail: detail,
              isError: isLocked || authValue.hasError,
            ),
            const Spacer(),
            PinNumpad(
              onDigit: _onDigit,
              onBackspace: _onBackspace,
              enabled: !isLoading && !isLocked,
            ),
            const SizedBox(height: AppSpacing.xs),
            TextButton(
              onPressed: isLoading ? null : _confirmSwitchAccount,
              style: TextButton.styleFrom(foregroundColor: cs.onSurfaceVariant),
              child: const Text('Changer de compte'),
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
        ),
      ),
    );
  }
}
