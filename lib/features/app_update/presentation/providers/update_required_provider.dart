import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/app_update_repository.dart';
import '../../providers/app_update_di_providers.dart';

part 'update_required_provider.g.dart';

/// Vrai quand l'app doit être mise à jour avant toute utilisation.
///
/// Vérifié au lancement puis à chaque retour au premier plan : d'abord sur
/// le minimum mémorisé (le blocage tient hors ligne), puis sur celui du
/// serveur. Se débloque seul une fois l'app mise à jour (build installé ≥
/// minimum) ou si le serveur abaisse le minimum.
@Riverpod(keepAlive: true)
class UpdateRequired extends _$UpdateRequired with WidgetsBindingObserver {
  bool _checking = false;

  @override
  bool build() {
    WidgetsBinding.instance.addObserver(this);
    ref.onDispose(() => WidgetsBinding.instance.removeObserver(this));
    unawaited(check());
    return false;
  }

  /// Relance la vérification (sans effet si une est déjà en cours).
  Future<void> check() async {
    if (_checking) return;
    _checking = true;
    try {
      final repository = ref.read(appUpdateRepositoryProvider);
      final installed = await repository.installedBuild();
      final cached = await repository.cachedMinBuild();
      if (!ref.mounted) return;
      state = isUpdateRequired(installedBuild: installed, minBuild: cached);

      final fresh = await repository.fetchMinBuild();
      if (!ref.mounted || fresh == null) return;
      state = isUpdateRequired(installedBuild: installed, minBuild: fresh);
    } finally {
      _checking = false;
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) unawaited(check());
  }
}
