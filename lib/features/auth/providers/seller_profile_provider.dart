import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'auth_di_providers.dart';

part 'seller_profile_provider.g.dart';

/// Nom du vendeur imprimé « Vendeur : … » sur les reçus (ADR-0008).
///
/// keepAlive : lu à l'impression et modifié depuis une feuille qui ne
/// l'écoute pas (même raison que `StoreConfig`). Invalidé par `Auth` à chaque
/// changement de compte.
@Riverpod(keepAlive: true)
class SellerProfile extends _$SellerProfile {
  @override
  Future<String?> build() =>
      ref.read(profileRepositoryProvider).getDisplayName();

  /// Enregistre le nom (vide = retiré). L'erreur réseau remonte à l'UI.
  Future<void> save(String? displayName) async {
    final saved = await ref
        .read(profileRepositoryProvider)
        .updateDisplayName(displayName);
    state = AsyncData(saved);
  }
}
