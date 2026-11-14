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
/// sans tout ressaisir. Une fois la demande acceptée, affiche « Vérifiez vos
/// e-mails » (réponse neutre) avec le recours au support.
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
  bool _sent = false;

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
    try {
      await ref.read(authRepositoryProvider).sendPasswordReset(_email);
      if (!mounted) return;
      setState(() {
        _sending = false;
        _sent = true;
      });
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
    final hasSupport = support?.contact != null || support?.whatsApp != null;

    if (_sent) {
      return AppDialog(
        title: 'Vérifiez vos e-mails',
        message:
            'Si cette adresse est confirmée, un e-mail vous a été envoyé. '
            'Le lien est valable 1 heure.',
        body: [
          if (hasSupport) ...[
            Text(
              'Pas d’e-mail confirmé sur votre compte ?',
              style: AppTypography.body.copyWith(color: cs.onSurface),
            ),
            SupportContactButtons(
              contact: support?.contact,
              whatsApp: support?.whatsApp,
            ),
          ],
        ],
        actions: [
          AppDialogTextAction(
            label: 'Fermer',
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      );
    }

    return PopScope(
      // Pas de fermeture pendant l'envoi : le résultat serait perdu.
      canPop: !_sending,
      child: AppDialog(
        title: 'Mot de passe oublié',
        message:
            'Saisissez l’e-mail de récupération de votre compte. Nous y '
            'enverrons un lien pour choisir un nouveau mot de passe.',
        body: [
          AppTextField(
            label: 'E-mail',
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
          if (error != null)
            Text(
              error,
              style: AppTypography.bodySmall.copyWith(color: cs.error),
            ),
          // Sans e-mail, l'envoi est impossible : le support reste joignable
          // dès cette étape.
          if (hasSupport)
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Pas d’e-mail sur votre compte ? Contactez le support.',
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
        actions: [
          PrimaryButton(
            label: 'Envoyer le lien',
            loadingLabel: 'Envoi…',
            isLoading: _sending,
            onPressed: _send,
          ),
          AppDialogTextAction(
            label: 'Annuler',
            onPressed: _sending ? null : () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}
