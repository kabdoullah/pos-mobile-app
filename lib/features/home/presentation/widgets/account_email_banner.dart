import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../auth/domain/entities/account_email.dart';
import '../../../auth/presentation/widgets/account_email_sheet.dart';
import '../../../auth/providers/account_email_provider.dart';

/// Rappel sur l'accueil : sans email confirmé, le mot de passe
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
    final muted = AppTypography.bodyMedium.copyWith(
      color: cs.onSurfaceVariant,
      height: 1.4,
    );
    final (title, actionLabel) = switch (account) {
      AccountEmail(email: null) => (
        'Ajoutez un email de récupération',
        'Ajouter',
      ),
      AccountEmail(email: _?) => ('Confirmez votre email', 'Renvoyer le lien'),
    };

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Semantics(
        container: true,
        child: Container(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.md,
            AppSpacing.md,
            AppSpacing.xs,
          ),
          decoration: BoxDecoration(
            color: cs.surfaceContainerLow,
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            border: Border.all(color: cs.outlineVariant),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Semantics(
                header: true,
                child: Text(
                  title,
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              if (email == null)
                Text(
                  'Pour retrouver votre compte si vous oubliez le mot de '
                  'passe.',
                  style: muted,
                )
              else
                Text.rich(
                  TextSpan(
                    children: [
                      const TextSpan(text: 'Ouvrez le lien envoyé à '),
                      TextSpan(
                        text: email,
                        style: TextStyle(
                          color: cs.onSurface,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const TextSpan(
                        text: ' pour pouvoir retrouver votre compte.',
                      ),
                    ],
                  ),
                  style: muted,
                ),
              Wrap(
                children: [
                  TextButton(
                    onPressed: _sending
                        ? null
                        : email == null
                        ? () => showAccountEmailSheet(context)
                        : () => _resend(email),
                    child: _sending
                        ? const SizedBox.square(
                            dimension: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(actionLabel),
                  ),
                  if (email != null)
                    TextButton(
                      onPressed: () =>
                          showAccountEmailSheet(context, currentEmail: email),
                      child: const Text('Corriger l’adresse'),
                    ),
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: cs.onSurfaceVariant,
                    ),
                    onPressed: () =>
                        ref.read(emailReminderProvider.notifier).snooze(),
                    child: const Text('Plus tard'),
                  ),
                ],
              ),
            ],
          ),
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
