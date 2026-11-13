import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/index.dart';
import '../providers/auth_providers.dart';

/// Ouvre « Code PIN oublié » : le mot de passe du compte, vérifié en ligne,
/// permet de choisir un nouveau PIN.
Future<void> showForgotPinSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (_) => const ForgotPinSheet(),
  );
}

/// Feuille « Code PIN oublié ». Après vérification du mot de passe, l'app
/// passe d'elle-même à la création d'un nouveau PIN (redirection d'auth) ; le
/// panier et les données de la boutique sont conservés.
class ForgotPinSheet extends ConsumerStatefulWidget {
  /// Crée la feuille.
  const ForgotPinSheet({super.key});

  @override
  ConsumerState<ForgotPinSheet> createState() => _ForgotPinSheetState();
}

class _ForgotPinSheetState extends ConsumerState<ForgotPinSheet> {
  final _controller = TextEditingController();
  String? _error;
  bool _isLoading = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final password = _controller.text;
    if (password.isEmpty) {
      setState(() => _error = 'Saisissez votre mot de passe.');
      return;
    }
    setState(() {
      _error = null;
      _isLoading = true;
    });
    try {
      await ref.read(authProvider.notifier).recoverPin(password);
      // La redirection vers la création du PIN retire l'écran PIN et cette
      // feuille avec lui ; on ne ferme que si elle est encore là.
      if (mounted) Navigator.of(context).pop();
    } on InvalidCredentials {
      if (mounted) setState(() => _error = 'Mot de passe incorrect.');
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.lg,
          AppSpacing.md,
          AppSpacing.md + MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Code PIN oublié', style: AppTypography.sectionTitle),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Saisissez le mot de passe de votre compte, puis choisissez un '
              'nouveau code PIN. Votre panier et vos données sont conservés. '
              'Une connexion internet est nécessaire.',
              style: AppTypography.body.copyWith(color: colors.textSecondary),
            ),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              label: 'Mot de passe',
              controller: _controller,
              obscureText: true,
              autofocus: true,
              errorText: _error,
              autofillHints: const [AutofillHints.password],
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _isLoading ? null : _submit(),
              onChanged: (_) {
                if (_error != null) setState(() => _error = null);
              },
            ),
            const SizedBox(height: AppSpacing.md),
            PrimaryButton(
              label: 'Vérifier et choisir un nouveau PIN',
              isLoading: _isLoading,
              loadingLabel: 'Vérification…',
              onPressed: _isLoading ? null : _submit,
            ),
            const SizedBox(height: AppSpacing.xs),
            TextButton(
              onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
              child: const Text('Annuler'),
            ),
          ],
        ),
      ),
    );
  }
}
