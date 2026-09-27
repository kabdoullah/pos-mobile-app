// ============================================================
// AVANT → APRÈS : RegisterPage
// Flutter 3.x+ | Material 3 | Dart 3+ | POS Mobile
// ============================================================
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/responsive/responsive.dart';
import '../../../../core/router/app_router.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/index.dart';
import '../../../../core/utils/phone_formatter.dart';
import '../providers/auth_providers.dart';
import '../widgets/registration_stepper.dart';

/// Page d'inscription (téléphone + mot de passe, email optionnel).
///
/// Le numéro de téléphone est l'identifiant principal. L'email est optionnel,
/// pour la récupération de compte. Crée le compte et enregistre les tokens JWT
/// de façon sécurisée.
class RegisterPage extends ConsumerStatefulWidget {
  /// Crée une page d'inscription.
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;
  late TextEditingController _phoneController;

  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;
  String? _phoneError;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _phoneController = TextEditingController();
    // Efface toute erreur d'auth obsolète d'une tentative de connexion
    // précédente.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) ref.read(authProvider.notifier).clearError();
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  bool _validateForm() {
    _emailError = null;
    _passwordError = null;
    _confirmPasswordError = null;
    _phoneError = null;

    final phone = _phoneController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;
    final email = _emailController.text.trim();

    bool isValid = true;

    // Phone validation (format local CI : 0XXXXXXXXX).
    if (phone.isEmpty) {
      _phoneError = 'Numéro requis';
      isValid = false;
    } else if (!isValidLocalPhoneCi(phone)) {
      _phoneError = 'Format invalide. Ex: 07 00 00 00 00';
      isValid = false;
    }

    // Validation du mot de passe.
    if (password.isEmpty) {
      _passwordError = 'Mot de passe requis';
      isValid = false;
    } else if (password.length < 8) {
      _passwordError = 'Au moins 8 caractères';
      isValid = false;
    }

    // Validation de la confirmation du mot de passe.
    if (confirmPassword.isEmpty) {
      _confirmPasswordError = 'Confirmation requise';
      isValid = false;
    } else if (password != confirmPassword) {
      _confirmPasswordError = 'Les mots de passe ne correspondent pas';
      isValid = false;
    }

    // Validation de l'email (optionnel — on ne vérifie le format que s'il est
    // renseigné).
    if (email.isNotEmpty && !_isValidEmail(email)) {
      _emailError = 'Email invalide';
      isValid = false;
    }

    setState(() {});
    return isValid;
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email);
  }

  Future<void> _register() async {
    if (!_validateForm()) return;

    final email = _emailController.text.trim();
    final e164 = toE164Ci(_phoneController.text.trim())!;
    try {
      final authNotifier = ref.read(authProvider.notifier);
      await authNotifier.register(
        e164,
        _passwordController.text,
        email: email.isEmpty ? null : email,
      );
      // La redirection du routeur gère automatiquement la navigation selon le
      // nouvel état d'auth.
    } catch (_) {
      // L'état d'erreur est déjà géré par l'affichage de l'état authProvider
      // ci-dessus.
    }
  }

  @override
  Widget build(BuildContext context) {
    // ✨ Accès centralisé à colorScheme — utilisé dans tout le build
    final cs = Theme.of(context).colorScheme;
    final authValue = ref.watch(authProvider);
    final isLoading = authValue.isLoading;
    final errorMessage = authValue.asError?.error.toString();

    final spacing = responsiveValue(
      context,
      small: AppSpacing.md,
      medium: AppSpacing.lg,
    );

    final isDark = Theme.of(context).brightness == Brightness.dark;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
      ),
      child: Scaffold(
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(
                  spacing,
                  spacing,
                  spacing,
                  AppSpacing.lg,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const RegistrationStepper(currentStep: 1),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      'Créer votre compte',
                      // ✨ onSurface explicite — lisible en clair comme en
                      // sombre
                      style: AppTypography.titleLarge.copyWith(
                        color: cs.onSurface,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'Renseignez vos informations pour ouvrir votre espace marchand.',
                      // ✨ colorScheme.onSurfaceVariant remplace
                      // AppColors.textSecondary — compatible mode sombre
                      style: AppTypography.bodyMedium.copyWith(
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(spacing, 0, spacing, spacing),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // ✨ AnimatedSwitcher — entrée/sortie fluides en 200 ms,
                      // sans saut de mise en page
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: errorMessage != null
                            ? Semantics(
                                // ✨ liveRegion — le lecteur d'écran annonce
                                // l'erreur immédiatement
                                liveRegion: true,
                                key: const ValueKey('error-banner'),
                                child: Container(
                                  margin: const EdgeInsets.only(
                                    bottom: AppSpacing.lg,
                                  ),
                                  padding: const EdgeInsets.all(AppSpacing.md),
                                  decoration: BoxDecoration(
                                    // ✨ errorContainer M3 — s'adapte au mode
                                    // sombre
                                    color: cs.errorContainer,
                                    border: Border.all(color: cs.error),
                                    borderRadius: BorderRadius.circular(
                                      AppSpacing
                                          .radiusMd, // ✨ token replaces hardcoded 8
                                    ),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // ✨ Icône — ne pas s'appuyer uniquement
                                      // sur la couleur (WCAG 1.4.1)
                                      Icon(
                                        Icons.error_outline,
                                        color: cs.onErrorContainer,
                                        size: 20,
                                      ),
                                      const SizedBox(width: AppSpacing.sm),
                                      Expanded(
                                        child: Text(
                                          errorMessage,
                                          // ✨ onErrorContainer — bon contraste
                                          // sur le fond d'erreur
                                          style: AppTypography.bodyMedium
                                              .copyWith(
                                                color: cs.onErrorContainer,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : const SizedBox.shrink(),
                      ),
                      AppTextField(
                        label: 'Téléphone',
                        hint: '07 00 00 00 00',
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        inputFormatters: const [SpacedPhoneFormatter()],
                        errorText: _phoneError,
                        prefixIcon: Icons.phone_outlined,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      AppTextField(
                        label: 'Mot de passe',
                        hint: 'Au moins 8 caractères',
                        controller: _passwordController,
                        obscureText: true,
                        errorText: _passwordError,
                        prefixIcon: Icons.lock_outlined,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      AppTextField(
                        label: 'Confirmer le mot de passe',
                        controller: _confirmPasswordController,
                        obscureText: true,
                        errorText: _confirmPasswordError,
                        prefixIcon: Icons.lock_outlined,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      AppTextField(
                        label: 'Email (optionnel)',
                        hint: 'Pour récupérer votre compte',
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        errorText: _emailError,
                        prefixIcon: Icons.email_outlined,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      PrimaryButton(
                        label: 'Créer mon compte',
                        onPressed: isLoading ? null : _register,
                        isLoading: isLoading,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Wrap(
                        alignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(
                            'Vous avez un compte ? ',
                            // ✨ onSurfaceVariant remplace la valeur implicite
                            // par défaut — compatible mode sombre explicitement
                            style: AppTypography.bodyMedium.copyWith(
                              color: cs.onSurfaceVariant,
                            ),
                          ),
                          TextButton(
                            onPressed: () => context.go(Routes.emailLogin),
                            child: const Text('Connectez-vous'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
