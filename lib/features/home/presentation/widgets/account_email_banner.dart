import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/index.dart';
import '../../../auth/domain/entities/account_email.dart';
import '../../../auth/presentation/widgets/account_email_sheet.dart';
import '../../../auth/providers/account_email_provider.dart';

/// Rappel discret sur l'accueil : sans email confirmé, le mot de passe
/// oublié ne peut pas être réinitialisé. « Plus tard » le masque 7 jours.
/// Rien n'est affiché hors ligne ni une fois l'email confirmé.
class AccountEmailBanner extends ConsumerStatefulWidget {
  /// Crée le rappel.
  const AccountEmailBanner({super.key});

  @override
  ConsumerState<AccountEmailBanner> createState() => _AccountEmailBannerState();
}

class _AccountEmailBannerState extends ConsumerState<AccountEmailBanner> {
  late final AppLifecycleListener _lifecycle;
  bool _sending = false;

  @override
  void initState() {
    super.initState();
    // Retour depuis l'app mail après avoir ouvert le lien : relire l'état
    // pour retirer le rappel sans attendre le prochain lancement.
    _lifecycle = AppLifecycleListener(
      onResume: () {
        if (ref.read(emailReminderProvider).value != null) {
          ref.invalidate(accountEmailStatusProvider);
        }
      },
    );
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final account = ref.watch(emailReminderProvider).value;
    if (account == null) return const SizedBox.shrink();

    final cs = Theme.of(context).colorScheme;
    final email = account.email;
    final (title, message, actionLabel) = switch (account) {
      AccountEmail(email: null) => (
        'Ajoutez un email',
        'Sans email, vous ne pourrez pas récupérer votre mot de passe en '
            'cas d’oubli.',
        'Ajouter',
      ),
      AccountEmail(:final email?) => (
        'Confirmez votre email',
        'Ouvrez le lien envoyé à $email pour pouvoir récupérer votre mot de '
            'passe en cas d’oubli.',
        'Renvoyer le lien',
      ),
    };

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.mark_email_unread_outlined, color: cs.primary),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: AppTypography.titleMedium),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        message,
                        style: AppTypography.bodySmall.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              alignment: WrapAlignment.end,
              spacing: AppSpacing.sm,
              children: [
                TextButton(
                  onPressed: () =>
                      ref.read(emailReminderProvider.notifier).snooze(),
                  child: const Text('Plus tard'),
                ),
                if (email != null)
                  TextButton(
                    onPressed: () =>
                        showAccountEmailSheet(context, currentEmail: email),
                    child: const Text('Corriger'),
                  ),
                FilledButton.tonal(
                  onPressed: _sending
                      ? null
                      : email == null
                      ? () => showAccountEmailSheet(context)
                      : () => _resend(email),
                  child: Text(actionLabel),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _resend(String email) async {
    setState(() => _sending = true);
    await resendEmailVerification(context, ref, email);
    if (mounted) setState(() => _sending = false);
  }
}
