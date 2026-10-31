import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/index.dart';
import '../providers/auth_providers.dart';
import '../widgets/auth_layout.dart';

/// Écran affiché quand la plateforme a suspendu la boutique.
///
/// L'app reste bloquée ici (même après un redémarrage hors ligne) jusqu'à ce
/// que « Réessayer » obtienne du serveur la confirmation de la réactivation :
/// le routeur quitte alors l'écran. Pas de déconnexion proposée : elle
/// risquerait d'effacer des ventes pas encore envoyées.
class StoreSuspendedPage extends ConsumerStatefulWidget {
  /// Crée l'écran de suspension.
  const StoreSuspendedPage({super.key});

  @override
  ConsumerState<StoreSuspendedPage> createState() => _StoreSuspendedPageState();
}

class _StoreSuspendedPageState extends ConsumerState<StoreSuspendedPage> {
  bool _checking = false;

  Future<void> _retry() async {
    setState(() => _checking = true);
    final message = await ref
        .read(authProvider.notifier)
        .retryAfterSuspension();
    if (!mounted) return;
    setState(() => _checking = false);
    if (message != null) _showMessage(message);
  }

  Future<void> _contact(String contact) async {
    final uri = _isEmail(contact)
        ? Uri(scheme: 'mailto', path: contact)
        : Uri(scheme: 'tel', path: contact.replaceAll(' ', ''));
    final opened = await launchUrl(uri);
    if (!opened && mounted) _showMessage('Impossible d’ouvrir le contact.');
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  static bool _isEmail(String contact) => contact.contains('@');

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final status = ref.watch(authProvider).value;
    final contact = status is AuthStoreSuspended ? status.supportContact : null;

    return AuthScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: AppSpacing.xl),
          Icon(Icons.store_outlined, size: 56, color: cs.error),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Boutique suspendue',
            style: AppTypography.titleLarge.copyWith(color: cs.onSurface),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            contact != null
                ? 'Votre boutique a été suspendue. Contactez le support '
                      'pour la réactiver.'
                : 'Votre boutique a été suspendue. Contactez le support '
                      'de l’application pour la réactiver.',
            style: AppTypography.bodyLarge.copyWith(color: cs.onSurface),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Les ventes et données enregistrées sur ce téléphone sont '
            'conservées : elles seront envoyées dès la réactivation.',
            style: AppTypography.bodyMedium.copyWith(
              color: cs.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.lg),
          if (contact != null) ...[
            SecondaryButton(
              label: contact,
              icon: _isEmail(contact)
                  ? Icons.mail_outline
                  : Icons.call_outlined,
              onPressed: () => _contact(contact),
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
          PrimaryButton(
            label: 'Réessayer',
            loadingLabel: 'Vérification…',
            isLoading: _checking,
            icon: Icons.refresh,
            onPressed: _checking ? null : _retry,
          ),
        ],
      ),
    );
  }
}
