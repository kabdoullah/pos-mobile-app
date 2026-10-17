import 'dart:async';

import 'package:clock/clock.dart';
import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/config.dart';
import 'auth_providers.dart';

part 'session_lock_provider.g.dart';

/// Verrouille la session après `AppConfig.sessionLockMinutes` minutes sans
/// interaction : repasse en `AuthPinRequired` via [Auth.lock], le routeur
/// ouvre alors l'écran PIN.
///
/// L'activité est signalée par [recordActivity] (chaque toucher, voir
/// `PosMobileApp`). Le temps passé en arrière-plan compte : au retour, l'écart
/// à la dernière activité est comparé à l'horloge, les timers n'étant pas
/// fiables quand l'app est suspendue.
@Riverpod(keepAlive: true)
class SessionLock extends _$SessionLock with WidgetsBindingObserver {
  static const _timeout = Duration(minutes: AppConfig.sessionLockMinutes);

  DateTime _lastActivity = clock.now();
  Timer? _timer;

  @override
  void build() {
    WidgetsBinding.instance.addObserver(this);
    ref.listen<AsyncValue<AuthStatus>>(authProvider, (_, next) {
      if (next.value is AuthAuthenticated) {
        // Déjà armé (ex. AsyncLoading qui conserve la valeur) : on garde
        // l'échéance en cours.
        if (_timer == null) recordActivity();
      } else {
        _cancel();
      }
    }, fireImmediately: true);
    ref.onDispose(() {
      WidgetsBinding.instance.removeObserver(this);
      _cancel();
    });
  }

  bool get _isAuthenticated =>
      ref.read(authProvider).value is AuthAuthenticated;

  /// Signale une interaction de l'utilisateur : repousse le verrouillage.
  /// Sans effet hors de `Authenticated`.
  void recordActivity() {
    if (!_isAuthenticated) return;
    _lastActivity = clock.now();
    _arm(_timeout);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed || !_isAuthenticated) return;
    final remaining = _timeout - clock.now().difference(_lastActivity);
    if (remaining <= Duration.zero) {
      _lock();
    } else {
      _arm(remaining);
    }
  }

  void _arm(Duration delay) {
    _timer?.cancel();
    _timer = Timer(delay, _lock);
  }

  void _cancel() {
    _timer?.cancel();
    _timer = null;
  }

  void _lock() {
    _cancel();
    ref.read(authProvider.notifier).lock();
  }
}
