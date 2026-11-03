import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
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

  /// Ouvre la fiche Play Store : l'app Play si présente, sinon le navigateur.
  Future<void> _openStore() async {
    const id = AppConfig.playStoreAppId;
    final market = Uri.parse('market://details?id=$id');
    final web = Uri.https('play.google.com', '/store/apps/details', {'id': id});
    try {
      if (await launchUrl(market, mode: LaunchMode.externalApplication)) {
        return;
      }
    } on Exception catch (_) {
      // Pas d'app Play Store : repli sur le navigateur.
    }
    try {
      await launchUrl(web, mode: LaunchMode.externalApplication);
    } on Exception catch (_) {
      // Rien pour ouvrir le lien : le dialogue reste affiché.
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return AlertDialog(
      icon: Icon(Icons.system_update_outlined, size: 48, color: cs.primary),
      title: Text(
        'Mise à jour requise',
        style: AppTypography.titleLarge.copyWith(color: cs.onSurface),
        textAlign: TextAlign.center,
      ),
      content: Text(
        'Une nouvelle version de l’application est disponible. Mettez-la à '
        'jour pour continuer à l’utiliser. Vos ventes et données sont '
        'conservées.',
        style: AppTypography.bodyLarge.copyWith(color: cs.onSurface),
        textAlign: TextAlign.center,
      ),
      actionsPadding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        0,
        AppSpacing.lg,
        AppSpacing.lg,
      ),
      actions: [PrimaryButton(label: 'Mettre à jour', onPressed: _openStore)],
    );
  }
}
