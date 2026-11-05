import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../core/network/api_exception.dart';
import '../../../../core/network/error_mapper.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/widgets/index.dart';
import '../../providers/auth_di_providers.dart';
import '../providers/support_contact_provider.dart';
import '../widgets/auth_layout.dart';
import '../widgets/support_contact_buttons.dart';

/// Token du lien de réinitialisation : dans le fragment (`#token=…`, gardé
/// hors des logs serveur), ou dans la query pour les liens plus anciens.
String? resetTokenFrom(Uri uri) {
  final fromFragment = uri.fragment.isEmpty
      ? null
      : Uri.splitQueryString(uri.fragment)['token'];
  return fromFragment ?? uri.queryParameters['token'];
}

/// Choix d'un nouveau mot de passe, ouvert par le lien de l'email de
/// réinitialisation (Android App Link `/auth/reset-password?token=…`).
///
/// Accessible quel que soit l'état d'auth. Après succès, renvoie vers la
/// connexion : le routeur redirige ensuite selon l'état de la session.
class ResetPasswordPage extends ConsumerStatefulWidget {
  /// Crée la page avec le [token] lu dans le lien (null s'il manque).
  const ResetPasswordPage({required this.token, super.key});

  /// Token de réinitialisation reçu par email.
  final String? token;

  @override
  ConsumerState<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends ConsumerState<ResetPasswordPage> {
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  /// Même règle que le backend (`ResetPasswordRequest.new_password`).
  static const _minPasswordLength = 8;

  bool _submitted = false;
  bool _isLoading = false;
  String? _error;
  late bool _invalidLink = widget.token == null || widget.token!.isEmpty;

  @override
  void initState() {
    super.initState();
    // main() retient la 1re frame (FlutterNativeSplash.preserve) et seule
    // SplashPage la libère. Ouverte à froid par le lien de l'email, l'app
    // démarre directement ici : sans ce remove(), l'écran resterait noir.
    // Sans effet si le splash est déjà retiré.
    FlutterNativeSplash.remove();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String get _password => _passwordController.text;
  String get _confirm => _confirmPasswordController.text;

  bool get _passwordValid => _password.length >= _minPasswordLength;
  bool get _passwordsMatch => _confirm.isNotEmpty && _confirm == _password;

  String? get _passwordError {
    if (!_submitted || _passwordValid) return null;
    return _password.isEmpty
        ? 'Choisissez un mot de passe.'
        : 'Au moins $_minPasswordLength caractères.';
  }

  String? get _confirmError {
    if (_passwordsMatch) return null;
    if (_confirm.isEmpty) {
      return _submitted ? 'Confirmez votre mot de passe.' : null;
    }
    return _submitted || _confirm.length >= _password.length
        ? 'Les mots de passe ne correspondent pas.'
        : null;
  }

  void _onEdited() => setState(() => _error = null);

  Future<void> _submit() async {
    if (_isLoading) return;
    setState(() => _submitted = true);
    if (!_passwordValid || !_passwordsMatch) return;
    FocusScope.of(context).unfocus();

    setState(() => _isLoading = true);
    try {
      await ref
          .read(authRepositoryProvider)
          .resetPassword(token: widget.token!, newPassword: _password);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mot de passe modifié. Connectez-vous.'),
          duration: Duration(seconds: 4),
        ),
      );
      context.go(Routes.emailLogin);
    } on Object catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        // 422 sans champ : seul le token est refusé (invalide, expiré, utilisé).
        if (e is ApiException && e.statusCode == 422 && e.field == null) {
          _invalidLink = true;
        } else {
          _error = errorToFrench(e);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      header: const AuthBrandBand(),
      child: _invalidLink ? _buildInvalidLink(context) : _buildForm(context),
    );
  }

  Widget _buildInvalidLink(BuildContext context) {
    final support = ref.watch(supportContactProvider).value;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: AppSpacing.sm),
        const AuthHeader(
          title: 'Lien invalide ou expiré',
          subtitle:
              'Ce lien a déjà servi, a expiré (il est valable 1 heure) ou a '
              'été remplacé par un lien plus récent.',
        ),
        const SizedBox(height: AppSpacing.lg),
        const AuthBanner(
          title: 'Utilisez le dernier lien reçu',
          message:
              'Ou redemandez-en un : sur l\'écran de connexion, appuyez sur '
              '« Mot de passe oublié ? ». Sans accès à votre email, contactez '
              'le support.',
          tone: AuthBannerTone.warning,
        ),
        const SizedBox(height: AppSpacing.lg),
        SupportContactButtons(
          contact: support?.contact,
          whatsApp: support?.whatsApp,
        ),
        const SizedBox(height: AppSpacing.sm),
        PrimaryButton(
          label: 'Retour à la connexion',
          onPressed: () => context.go(Routes.emailLogin),
        ),
      ],
    );
  }

  Widget _buildForm(BuildContext context) {
    final error = _error;
    return AutofillGroup(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: AppSpacing.sm),
          const AuthHeader(
            title: 'Nouveau mot de passe',
            subtitle: 'Choisissez le mot de passe de votre compte.',
          ),
          const SizedBox(height: AppSpacing.lg),
          if (error != null)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.lg),
              child: AuthBanner(
                title: 'Modification impossible',
                message: error,
              ),
            ),
          AppTextField(
            label: 'Nouveau mot de passe',
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
            onSubmitted: (_) => _submit(),
            helper: _passwordsMatch
                ? const ValidationHint(
                    label: 'Les mots de passe correspondent',
                    isMet: true,
                  )
                : null,
          ),
          const SizedBox(height: AppSpacing.xl),
          PrimaryButton(
            label: 'Enregistrer',
            loadingLabel: 'Enregistrement…',
            onPressed: _submit,
            isLoading: _isLoading,
          ),
          const SizedBox(height: AppSpacing.md),
          Center(
            child: TextButton(
              onPressed: _isLoading
                  ? null
                  : () => context.go(Routes.emailLogin),
              child: const Text('Retour à la connexion'),
            ),
          ),
        ],
      ),
    );
  }
}
