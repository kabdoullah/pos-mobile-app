import 'dart:io';

import '../entities/store.dart';

/// Interface du repository boutique. Implémenté dans la couche `data`.
///
/// La configuration boutique est mise en cache sur l'appareil (affichée hors
/// ligne et imprimée sur les reçus) ; le backend reste la source de vérité.
abstract class StoreRepository {
  /// Boutique du compte connecté : cache local, sinon `GET /stores/me` (puis
  /// mise en cache). `null` si aucune boutique n'est disponible.
  Future<Store?> getStore();

  /// Enregistre la boutique en local puis la synchronise avec le backend.
  /// Lève une exception si la synchronisation échoue.
  Future<void> saveStore(Store store);

  /// Efface le cache local — à appeler quand le compte connecté change, pour
  /// ne jamais afficher ni imprimer la boutique d'un autre compte.
  Future<void> clearLocal();

  /// Envoie un nouveau logo (en ligne) ; renvoie la boutique mise à jour.
  Future<Store> uploadLogo(File image);

  /// Retire le logo (en ligne) ; renvoie la boutique mise à jour.
  Future<Store> deleteLogo(Store current);

  /// Octets du logo à la [version] donnée (cache disque, sinon serveur) ;
  /// null si indisponible. Utilisé à l'impression, donc lu hors ligne.
  Future<List<int>?> logoBytes(String version);
}
