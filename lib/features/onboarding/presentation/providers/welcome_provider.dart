import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../auth/providers/auth_di_providers.dart';

part 'welcome_provider.g.dart';

/// True si le compte connecté vient de s'inscrire et n'a pas encore vu
/// l'accueil « boutique prête ». Lu par l'Accueil, qui ouvre alors
/// `WelcomePage` une fois.
@riverpod
Future<bool> welcomePending(Ref ref) =>
    ref.watch(authRepositoryProvider).isWelcomePending();
