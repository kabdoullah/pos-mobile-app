import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/utils/phone_formatter.dart';
import '../../../../core/widgets/index.dart';
import '../providers/auth_providers.dart';
import '../widgets/auth_layout.dart';
import '../widgets/registration_stepper.dart';

/// Étape 1 de l'inscription : compte (téléphone + mot de passe, email
/// optionnel).
///
/// Le numéro de téléphone est l'identifiant principal. L'email est optionnel,
/// pour la récupération de compte. Une fois le compte créé, [Auth] passe à
/// l'étape boutique et le routeur suit.
class RegisterPage extends ConsumerStatefulWidget {
  /// Crée une page d'inscription.
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  /// Longueur minimale du mot de passe (règle du backend, ADR-0006).
  static const _minPasswordLength = 8;

  /// Passe à true au premier « Continuer » : les champs vides ou invalides
  /// s'affichent alors en erreur (pas avant, pour ne pas gronder pendant la
  /// saisie).
  bool _submitted = false;

  @override
  void initState() {
    super.initState();
    // Efface toute erreur d'auth obsolète d'une tentative de connexion
    // précédente.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) ref.read(authProvider.notifier).clearError();
    });
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String get _phone => _phoneController.text.trim();
  String get _email => _emailController.text.trim();
  String get _password => _passwordController.text;
  String get _confirm => _confirmPasswordController.text;

  bool get _phoneValid => isValidLocalPhoneCi(_phone);
  bool get _passwordValid => _password.length >= _minPasswordLength;
  bool get _passwordsMatch => _confirm.isNotEmpty && _confirm == _password;
  bool get _emailValid =>
      _email.isEmpty || RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(_email);

  String? get _phoneError {
    if (!_submitted || _phoneValid) return null;
    return _phone.isEmpty
        ? 'Saisissez votre numéro de téléphone.'
        : 'Numéro à 10 chiffres, ex. 07 00 00 00 00.';
  }

  String? get _emailError =>
      _submitted && !_emailValid ? 'Adresse email invalide.' : null;

  String? get _passwordError {
    if (!_submitted || _passwordValid) return null;
    return _password.isEmpty
        ? 'Choisissez un mot de passe.'
        : 'Au moins $_minPasswordLength caractères.';
  }

  /// Signalé dès que la confirmation est aussi longue que le mot de passe
  /// (avant, l'utilisateur est simplement en train de la saisir).
  String? get _confirmError {
    if (_passwordsMatch) return null;
    if (_confirm.isEmpty) {
      return _submitted ? 'Confirmez votre mot de passe.' : null;
    }
    return _submitted || _confirm.length >= _password.length
        ? 'Les mots de passe ne correspondent pas.'
        : null;
  }

  void _onEdited() {
    setState(() {});
    ref.read(authProvider.notifier).clearError();
  }

  Future<void> _register() async {
    if (ref.read(authProvider).isLoading) return;
    setState(() => _submitted = true);
    if (!_phoneValid || !_emailValid || !_passwordValid || !_passwordsMatch) {
      return;
    }
    FocusScope.of(context).unfocus();

    await ref
        .read(authProvider.notifier)
        .register(
          toE164Ci(_phone)!,
          _password,
          email: _email.isEmpty ? null : _email,
        );
    // Succès : le routeur passe à l'étape boutique.
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final authValue = ref.watch(authProvider);
    final isLoading = authValue.isLoading;
    final errorMessage = authValue.error?.toString();

    return PopScope(
      // Retour système : vers la connexion plutôt que quitter l'app.
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && !isLoading) context.go(Routes.emailLogin);
      },
      child: AuthScaffold(
        child: AutofillGroup(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const RegistrationStepper(currentStep: 1),
              const SizedBox(height: AppSpacing.lg),
              const AuthHeader(
                title: 'Créer votre compte',
                subtitle: 'Commençons par vos informations de connexion.',
              ),
              const SizedBox(height: AppSpacing.lg),
              AnimatedSize(
                duration: const Duration(milliseconds: 200),
                child: errorMessage != null
                    ? Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                        child: AuthBanner(
                          title: 'Inscription impossible',
                          message: errorMessage,
                        ),
                      )
                    : const SizedBox(width: double.infinity),
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
                helper: _phoneValid
                    ? const ValidationHint(label: 'Numéro valide', isMet: true)
                    : null,
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                label: 'Email (facultatif)',
                hint: 'Pour récupérer votre compte',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                errorText: _emailError,
                prefixIcon: Icons.email_outlined,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.email],
                onChanged: (_) => _onEdited(),
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                label: 'Mot de passe',
                controller: _passwordController,
                obscureText: true,
                errorText: _passwordError,
                prefixIcon: Icons.lock_outlined,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.newPassword],
                onChanged: (_) => _onEdited(),
                helper: ValidationHint(
                  label: 'Au moins $_minPasswordLength caractères',
                  isMet: _passwordValid,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                label: 'Confirmer le mot de passe',
                controller: _confirmPasswordController,
                obscureText: true,
                errorText: _confirmError,
                prefixIcon: Icons.lock_outlined,
                textInputAction: TextInputAction.done,
                autofillHints: const [AutofillHints.newPassword],
                onChanged: (_) => _onEdited(),
                onSubmitted: (_) => _register(),
                helper: _passwordsMatch
                    ? const ValidationHint(
                        label: 'Les mots de passe correspondent',
                        isMet: true,
                      )
                    : null,
              ),
              const SizedBox(height: AppSpacing.xl),
              PrimaryButton(
                label: 'Continuer',
                loadingLabel: 'Création du compte…',
                onPressed: _register,
                isLoading: isLoading,
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Vous avez déjà un compte ?',
                textAlign: TextAlign.center,
                style: AppTypography.bodyMedium.copyWith(
                  color: cs.onSurfaceVariant,
                ),
              ),
              Center(
                child: TextButton(
                  onPressed: isLoading
                      ? null
                      : () => context.go(Routes.emailLogin),
                  child: const Text('Se connecter'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
