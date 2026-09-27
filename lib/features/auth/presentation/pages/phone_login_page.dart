import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/network/error_mapper.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/utils/phone_formatter.dart';
import '../../../../core/widgets/index.dart';
import '../../../auth/providers/auth_di_providers.dart';
import '../providers/auth_providers.dart';
import '../widgets/auth_layout.dart';

/// Écran de connexion par numéro de téléphone (authentification principale).
///
/// Sert aussi de point d'entrée pour la connexion sur un nouvel appareil et la
/// récupération de compte via le dialogue de mot de passe oublié. La suite du
/// parcours (boutique, PIN) est décidée par [Auth] et le routeur.
class PhoneLoginPage extends ConsumerStatefulWidget {
  /// Crée une page de connexion par téléphone.
  const PhoneLoginPage({super.key});

  @override
  ConsumerState<PhoneLoginPage> createState() => _PhoneLoginPageState();
}

class _PhoneLoginPageState extends ConsumerState<PhoneLoginPage> {
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  String? _phoneError;
  String? _passwordError;

  static final _logger = Logger();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) ref.read(authProvider.notifier).clearError();
    });
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool _validateForm() {
    final phone = _phoneController.text.trim();
    setState(() {
      _phoneError = phone.isEmpty
          ? 'Saisissez votre numéro de téléphone.'
          : !isValidLocalPhoneCi(phone)
          ? 'Numéro à 10 chiffres, ex. 07 00 00 00 00.'
          : null;
      _passwordError = _passwordController.text.isEmpty
          ? 'Saisissez votre mot de passe.'
          : null;
    });
    return _phoneError == null && _passwordError == null;
  }

  /// Une erreur de connexion n'a plus lieu d'être dès que l'utilisateur
  /// corrige sa saisie.
  void _onEdited() {
    if (_phoneError != null || _passwordError != null) {
      setState(() {
        _phoneError = null;
        _passwordError = null;
      });
    }
    ref.read(authProvider.notifier).clearError();
  }

  Future<void> _login() async {
    if (ref.read(authProvider).isLoading || !_validateForm()) return;
    FocusScope.of(context).unfocus();

    final e164 = toE164Ci(_phoneController.text.trim())!;
    _logger.i('[PhoneLogin] Login clicked: $e164');
    await ref.read(authProvider.notifier).login(e164, _passwordController.text);
  }

  void _showForgotPasswordDialog(BuildContext context) {
    final emailController = TextEditingController();

    unawaited(
      showDialog<void>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Mot de passe oublié'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Saisissez l\'email de récupération renseigné à l\'inscription. '
                'Sans email, contactez le support.',
              ),
              const SizedBox(height: AppSpacing.md),
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: 'Adresse email de récupération',
                  hintText: 'votre@email.com',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () async {
                final email = emailController.text.trim();
                if (email.isEmpty) return;
                Navigator.of(dialogContext).pop();
                try {
                  await ref
                      .read(authRepositoryProvider)
                      .sendPasswordReset(email);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Email envoyé. Vérifiez votre boîte mail.',
                        ),
                        duration: Duration(seconds: 4),
                      ),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    final cs = Theme.of(context).colorScheme;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          errorToFrench(e),
                          style: TextStyle(color: cs.onError),
                        ),
                        backgroundColor: cs.error,
                      ),
                    );
                  }
                }
              },
              child: const Text('Envoyer'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final authValue = ref.watch(authProvider);
    final isLoading = authValue.isLoading;
    final error = authValue.error;
    // Identifiants refusés : affiché sous le mot de passe, pas en bandeau.
    final credentialsError = error is InvalidCredentials
        ? error.toString()
        : null;
    final status = authValue.value;
    final sessionExpired =
        !authValue.hasError &&
        status is AuthUnauthenticated &&
        status.sessionExpired;

    return AuthScaffold(
      child: AutofillGroup(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: AppSpacing.xl),
            Center(
              child: ExcludeSemantics(
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: cs.primaryContainer,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                  ),
                  child: Icon(
                    Icons.storefront_rounded,
                    size: 32,
                    color: cs.onPrimaryContainer,
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            const AuthHeader(
              title: 'Bienvenue 👋',
              subtitle: 'Gérez votre boutique simplement.',
              centered: true,
            ),
            const SizedBox(height: AppSpacing.lg),
            AnimatedSize(
              duration: const Duration(milliseconds: 200),
              child: switch ((sessionExpired, error, credentialsError)) {
                (true, _, _) => const Padding(
                  padding: EdgeInsets.only(bottom: AppSpacing.lg),
                  child: AuthBanner(
                    title: 'Votre session a expiré',
                    message: 'Reconnectez-vous pour continuer.',
                    tone: AuthBannerTone.warning,
                  ),
                ),
                (_, final Object e, null) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                  child: AuthBanner(
                    title: 'Connexion impossible',
                    message: e.toString(),
                  ),
                ),
                _ => const SizedBox(width: double.infinity),
              },
            ),
            AppTextField(
              label: 'Téléphone',
              hint: '07 00 00 00 00',
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              inputFormatters: const [SpacedPhoneFormatter()],
              errorText: _phoneError,
              prefixIcon: Icons.phone_outlined,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.telephoneNumber],
              onChanged: (_) => _onEdited(),
            ),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              label: 'Mot de passe',
              controller: _passwordController,
              obscureText: true,
              errorText: _passwordError ?? credentialsError,
              prefixIcon: Icons.lock_outlined,
              textInputAction: TextInputAction.done,
              autofillHints: const [AutofillHints.password],
              onChanged: (_) => _onEdited(),
              onSubmitted: (_) => _login(),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: isLoading
                    ? null
                    : () => _showForgotPasswordDialog(context),
                child: const Text('Mot de passe oublié ?'),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            PrimaryButton(
              label: 'Se connecter',
              loadingLabel: 'Connexion…',
              onPressed: _login,
              isLoading: isLoading,
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(
              'Pas encore de compte ?',
              textAlign: TextAlign.center,
              style: AppTypography.bodyMedium.copyWith(
                color: cs.onSurfaceVariant,
              ),
            ),
            Center(
              child: TextButton(
                onPressed: isLoading ? null : () => context.go(Routes.register),
                child: const Text('Créer un compte'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
