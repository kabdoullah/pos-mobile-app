import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/config.dart';
import '../../../../core/widgets/index.dart';
import '../providers/update_required_provider.dart';

/// Recouvre toute l'app d'un dialogue non fermable quand une mise à jour est
/// obligatoire (voir [UpdateRequired]).
///
/// Placé dans `MaterialApp.builder`, au-dessus du routeur : il bloque tous
/// les écrans, connexion et PIN compris, sans toucher à la navigation.
class UpdateRequiredGate extends ConsumerWidget {
  /// Crée le garde autour de [child].
  const UpdateRequiredGate({required this.child, super.key});

  /// L'application.
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final required = ref.watch(updateRequiredProvider);
    if (!required) return child;
    final scrim = Theme.of(context).colorScheme.scrim;
    return Stack(
      children: [
        // L'app reste dessous mais n'est plus accessible, ni au toucher ni
        // aux lecteurs d'écran.
        ExcludeSemantics(child: child),
        ModalBarrier(dismissible: false, color: scrim.withValues(alpha: 0.54)),
        const Center(child: _UpdateRequiredDialog()),
      ],
    );
  }
}

class _UpdateRequiredDialog extends StatelessWidget {
  const _UpdateRequiredDialog();

  /// Ouvre la fiche Play Store : l'app Play si présente (lien vérifié),
  /// sinon le navigateur. Pas de `market://` : certains Android (MIUI)
  /// proposent alors d'autres boutiques (GetApps…) où l'app n'est pas.
  Future<void> _openStore() async {
    final store = Uri.https('play.google.com', '/store/apps/details', {
      'id': AppConfig.playStoreAppId,
    });
    try {
      await launchUrl(store, mode: LaunchMode.externalApplication);
    } on Exception catch (_) {
      // Rien pour ouvrir le lien : le dialogue reste affiché.
    }
  }

  @override
  Widget build(BuildContext context) {
    // Une seule sortie : pas d'« Annuler », le dialogue reste affiché.
    return AppDialog(
      title: 'Mise à jour requise',
      message:
          'Cette version de Ma Caisse n’est plus prise en charge. Installez '
          'la nouvelle version pour continuer. Vos ventes et données sont '
          'conservées.',
      actions: [PrimaryButton(label: 'Mettre à jour', onPressed: _openStore)],
    );
  }
}
