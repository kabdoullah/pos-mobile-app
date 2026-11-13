import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/index.dart';
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

    final colors = AppColors.of(context);
    final email = account.email;
    final bodyStyle = AppTypography.body.copyWith(fontSize: 15, height: 1.4);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const OverlineHeader('Compte'),
        Semantics(
          container: true,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: colors.surface,
              border: Border(
                top: BorderSide(color: colors.border),
                bottom: BorderSide(color: colors.border),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.sm,
                AppSpacing.xs,
                AppSpacing.xs,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: email == null
                            ? Text(
                                'Ajoutez un e-mail pour récupérer votre '
                                'compte en cas d’oubli du mot de passe.',
                                style: bodyStyle,
                              )
                            : Text.rich(
                                TextSpan(
                                  children: [
                                    const TextSpan(
                                      text:
                                          'Confirmez votre e-mail : ouvrez '
                                          'le lien envoyé à ',
                                    ),
                                    TextSpan(
                                      text: email,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const TextSpan(text: '.'),
                                  ],
                                ),
                                style: bodyStyle,
                              ),
                      ),
                      if (_sending)
                        const Padding(
                          padding: EdgeInsets.all(AppSpacing.md),
                          child: SizedBox.square(
                            dimension: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        )
                      else
                        TextButton(
                          onPressed: email == null
                              ? () => showAccountEmailSheet(context)
                              : () => _resend(email),
                          child: Text(email == null ? 'Ajouter' : 'Renvoyer'),
                        ),
                    ],
                  ),
                  Wrap(
                    spacing: AppSpacing.sm,
                    children: [
                      TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: colors.textSecondary,
                          padding: EdgeInsets.zero,
                        ),
                        onPressed: () =>
                            ref.read(emailReminderProvider.notifier).snooze(),
                        child: const Text('Plus tard'),
                      ),
                      if (email != null)
                        TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: colors.textSecondary,
                          ),
                          onPressed: () => showAccountEmailSheet(
                            context,
                            currentEmail: email,
                          ),
                          child: const Text('Corriger l’adresse'),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _resend(String email) async {
    setState(() => _sending = true);
    await resendEmailVerification(context, ref, email);
    if (mounted) setState(() => _sending = false);
  }
}
