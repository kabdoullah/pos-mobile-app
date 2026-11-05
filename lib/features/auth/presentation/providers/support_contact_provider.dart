import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/support_contact.dart';
import '../../providers/auth_di_providers.dart';

part 'support_contact_provider.g.dart';

/// Coordonnées du support, lues sur le serveur à l'ouverture des écrans d'aide
/// (mot de passe oublié, lien de réinitialisation invalide).
///
/// autoDispose : relu à chaque ouverture, une config changée côté serveur est
/// visible sans redémarrer l'app.
@riverpod
Future<SupportContact> supportContact(Ref ref) =>
    ref.read(authRepositoryProvider).getSupportContact();
