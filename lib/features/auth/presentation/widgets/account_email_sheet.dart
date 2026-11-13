import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/network/error_mapper.dart';
import '../../../../core/utils/email_validator.dart';
import '../../../../core/widgets/index.dart';
import '../../providers/account_email_provider.dart';

/// Ouvre la feuille d'ajout (compte sans email) ou de correction (email pas
/// encore confirmé) de l'adresse email du compte.
Future<void> showAccountEmailSheet(
  BuildContext context, {
  String? currentEmail,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (_) => AccountEmailSheet(currentEmail: currentEmail),
  );
}

/// Renvoie le lien de vérification à [email] et affiche le résultat en
/// snackbar (envoyé, trop de demandes, hors ligne…).
Future<void> resendEmailVerification(
  BuildContext context,
  WidgetRef ref,
  String email,
) async {
  final messenger = ScaffoldMessenger.of(context);
  final cs = Theme.of(context).colorScheme;
  String message;
  var isError = false;
  try {
    await ref.read(accountEmailStatusProvider.notifier).resendVerification();
    message = 'Lien envoyé à $email. Ouvrez-le pour confirmer votre adresse.';
  } catch (e) {
    message = errorToFrench(e);
    isError = true;
  }
  _showResult(messenger, cs, message, isError: isError);
}

void _showResult(
  ScaffoldMessengerState messenger,
  ColorScheme cs,
  String message, {
  bool isError = false,
}) {
  messenger
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: isError ? cs.error : null,
        duration: const Duration(seconds: 5),
      ),
    );
}

/// Saisie de l'email du compte, confirmée par le mot de passe. Envoie ensuite
/// le lien de vérification à la nouvelle adresse.
class AccountEmailSheet extends ConsumerStatefulWidget {
  /// Crée la feuille ; [currentEmail] pré-remplit la correction.
  const AccountEmailSheet({this.currentEmail, super.key});

  /// Email actuel non confirmé, ou null pour un ajout.
  final String? currentEmail;

  @override
  ConsumerState<AccountEmailSheet> createState() => _AccountEmailSheetState();
}

class _AccountEmailSheetState extends ConsumerState<AccountEmailSheet> {
  late final _emailController = TextEditingController(
    text: widget.currentEmail ?? '',
  );
  final _passwordController = TextEditingController();
  bool _saving = false;
  bool _submitted = false;
  String? _error;

  String get _email => _emailController.text.trim();

  String? get _emailError {
    if (!_submitted || isValidEmail(_email)) return null;
    return _email.isEmpty
        ? 'Saisissez votre adresse email.'
        : 'Adresse email invalide.';
  }

  String? get _passwordError => _submitted && _passwordController.text.isEmpty
      ? 'Saisissez votre mot de passe.'
      : null;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() {
      _submitted = true;
      _error = null;
    });
    if (_emailError != null || _passwordError != null) return;
    setState(() => _saving = true);
    final messenger = ScaffoldMessenger.of(context);
    final cs = Theme.of(context).colorScheme;
    final email = _email;
    try {
      await ref
          .read(accountEmailStatusProvider.notifier)
          .updateEmail(email: email, password: _passwordController.text);
      if (!mounted) return;
      Navigator.of(context).pop();
      _showResult(
        messenger,
        cs,
        'Lien envoyé à ${email.toLowerCase()}. Ouvrez-le pour confirmer '
        'votre adresse.',
      );
    } catch (e) {
      if (mounted) {
        setState(() {
          _saving = false;
          _error = errorToFrench(e);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final error = _error;
    final isCorrection = widget.currentEmail != null;

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.lg,
            AppSpacing.md,
            AppSpacing.md,
          ),
          child: AutofillGroup(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  isCorrection ? 'Corriger mon email' : 'Ajouter un email',
                  style: AppTypography.titleLarge,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'En cas d’oubli, le lien pour choisir un nouveau mot de '
                  'passe est envoyé à cette adresse, une fois confirmée.',
                  style: AppTypography.bodySmall.copyWith(
                    color: cs.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                AppTextField(
                  label: 'Email',
                  hint: 'votre@email.com',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  errorText: _emailError,
                  prefixIcon: Icons.email_outlined,
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.email],
                  autofocus: true,
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: AppSpacing.md),
                AppTextField(
                  label: 'Mot de passe actuel',
                  controller: _passwordController,
                  obscureText: true,
                  errorText: _passwordError,
                  prefixIcon: Icons.lock_outlined,
                  textInputAction: TextInputAction.done,
                  autofillHints: const [AutofillHints.password],
                  onChanged: (_) => setState(() {}),
                  onSubmitted: (_) => _save(),
                ),
                if (error != null) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    error,
                    style: AppTypography.bodySmall.copyWith(color: cs.error),
                  ),
                ],
                const SizedBox(height: AppSpacing.md),
                PrimaryButton(
                  label: 'Enregistrer et envoyer le lien',
                  loadingLabel: 'Envoi…',
                  isLoading: _saving,
                  onPressed: _saving ? null : _save,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
