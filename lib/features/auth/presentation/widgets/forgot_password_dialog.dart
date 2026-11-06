import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/network/api_exception.dart';
import '../../../../core/network/error_mapper.dart';
import '../../../../core/utils/email_validator.dart';
import '../../../../core/widgets/index.dart';
import '../../providers/auth_di_providers.dart';
import '../providers/support_contact_provider.dart';
import 'support_contact_buttons.dart';

/// Ouvre la demande de lien de réinitialisation du mot de passe.
Future<void> showForgotPasswordDialog(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (_) => const ForgotPasswordDialog(),
  );
}

/// Saisie de l'email de récupération puis envoi du lien de réinitialisation.
///
/// Reste ouverte pendant l'envoi (le serveur peut mettre près d'une minute à
/// sortir de veille) et affiche les erreurs sur place, pour corriger l'adresse
/// sans tout ressaisir. Ne se ferme qu'une fois la demande acceptée.
class ForgotPasswordDialog extends ConsumerStatefulWidget {
  /// Crée la boîte de dialogue.
  const ForgotPasswordDialog({super.key});

  @override
  ConsumerState<ForgotPasswordDialog> createState() =>
      _ForgotPasswordDialogState();
}

class _ForgotPasswordDialogState extends ConsumerState<ForgotPasswordDialog> {
  final _emailController = TextEditingController();
  bool _submitted = false;
  bool _sending = false;

  /// Refus du serveur portant sur l'adresse (affiché sous le champ).
  String? _serverEmailError;

  /// Autre échec (réseau, serveur), affiché sous le champ.
  String? _error;

  String get _email => _emailController.text.trim();

  String? get _emailError {
    if (_serverEmailError != null) return _serverEmailError;
    if (!_submitted || isValidEmail(_email)) return null;
    return _email.isEmpty
        ? 'Saisissez votre adresse email.'
        : 'Adresse email invalide.';
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _onEdited() => setState(() {
    _serverEmailError = null;
    _error = null;
  });

  Future<void> _send() async {
    if (_sending) return;
    setState(() => _submitted = true);
    if (_emailError != null) return;

    FocusScope.of(context).unfocus();
    setState(() => _sending = true);
    final messenger = ScaffoldMessenger.of(context);
    try {
      await ref.read(authRepositoryProvider).sendPasswordReset(_email);
      if (!mounted) return;
      Navigator.of(context).pop();
      messenger.showSnackBar(
        const SnackBar(
          content: Text(
            'Si cette adresse est confirmée, un email vous a été envoyé. '
            'Vérifiez votre boîte mail.',
          ),
          duration: Duration(seconds: 4),
        ),
      );
    } on Object catch (e) {
      if (!mounted) return;
      setState(() {
        _sending = false;
        if (e is ApiException && e.field == 'email') {
          _serverEmailError = errorToFrench(e);
        } else {
          _error = errorToFrench(e);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final error = _error;
    final support = ref.watch(supportContactProvider).value;
    return PopScope(
      // Pas de fermeture pendant l'envoi : le résultat serait perdu.
      canPop: !_sending,
      child: AlertDialog(
        title: const Text('Mot de passe oublié'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Saisissez l\'email de récupération renseigné à l\'inscription.',
            ),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              label: 'Adresse email de récupération',
              hint: 'votre@email.com',
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              errorText: _emailError,
              textInputAction: TextInputAction.send,
              autofillHints: const [AutofillHints.email],
              autofocus: true,
              onChanged: (_) => _onEdited(),
              onSubmitted: (_) => _send(),
            ),
            if (error != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                error,
                style: AppTypography.bodySmall.copyWith(color: cs.error),
              ),
            ],
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Pas d\'email, ou email jamais confirmé ? Contactez le '
                    'support.',
                    style: AppTypography.bodySmall.copyWith(
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                SupportContactButtons(
                  contact: support?.contact,
                  whatsApp: support?.whatsApp,
                  compact: true,
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: _sending ? null : () => Navigator.of(context).pop(),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: _sending ? null : _send,
            child: _sending
                ? const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox.square(
                        dimension: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      SizedBox(width: AppSpacing.sm),
                      Text('Envoi…'),
                    ],
                  )
                : const Text('Envoyer'),
          ),
        ],
      ),
    );
  }
}
