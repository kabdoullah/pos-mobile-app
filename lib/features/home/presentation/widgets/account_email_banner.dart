import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../auth/domain/entities/account_email.dart';
import '../../../auth/presentation/widgets/account_email_sheet.dart';
import '../../../auth/providers/account_email_provider.dart';

/// Rappel bien visible sur l'accueil : sans email confirmé, le mot de passe
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
    final (title, actionLabel, icon) = switch (account) {
      AccountEmail(email: null) => (
        'Ajoutez un email',
        'Ajouter mon email',
        Icons.alternate_email_rounded,
      ),
      AccountEmail(email: _?) => (
        'Confirmez votre email',
        'Renvoyer le lien',
        Icons.mark_email_unread_outlined,
      ),
    };
    final foreground = cs.onTertiaryContainer;
    final bodyStyle = AppTypography.bodyMedium.copyWith(color: foreground);

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Semantics(
        container: true,
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: cs.tertiaryContainer,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            border: Border.all(color: cs.tertiary, width: 1.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ExcludeSemantics(
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: cs.tertiary,
                      child: Icon(icon, color: cs.onTertiary, size: 22),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Semantics(
                          header: true,
                          child: Text(
                            title,
                            style: AppTypography.titleMedium.copyWith(
                              color: foreground,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        if (email == null)
                          Text(
                            'Sans email, vous ne pourrez pas récupérer votre '
                            'mot de passe en cas d’oubli.',
                            style: bodyStyle,
                          )
                        else
                          Text.rich(
                            TextSpan(
                              children: [
                                const TextSpan(
                                  text: 'Ouvrez le lien envoyé à ',
                                ),
                                TextSpan(
                                  text: email,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const TextSpan(
                                  text:
                                      ' pour pouvoir récupérer votre mot de '
                                      'passe en cas d’oubli.',
                                ),
                              ],
                            ),
                            style: bodyStyle,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              FilledButton.icon(
                onPressed: _sending
                    ? null
                    : email == null
                    ? () => showAccountEmailSheet(context)
                    : () => _resend(email),
                icon: _sending
                    ? const SizedBox.square(
                        dimension: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Icon(email == null ? Icons.add_rounded : Icons.send),
                label: Text(actionLabel),
              ),
              const SizedBox(height: AppSpacing.xs),
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                children: [
                  TextButton(
                    style: TextButton.styleFrom(foregroundColor: foreground),
                    onPressed: () =>
                        ref.read(emailReminderProvider.notifier).snooze(),
                    child: const Text('Plus tard'),
                  ),
                  if (email != null)
                    TextButton(
                      style: TextButton.styleFrom(foregroundColor: foreground),
                      onPressed: () =>
                          showAccountEmailSheet(context, currentEmail: email),
                      child: const Text('Corriger l’adresse'),
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
