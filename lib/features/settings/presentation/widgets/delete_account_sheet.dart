import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/network/error_mapper.dart';
import '../../../../core/widgets/index.dart';
import '../../../auth/presentation/providers/auth_providers.dart';

/// Ouvre la feuille de confirmation par mot de passe de la suppression du
/// compte (ADR-0011).
Future<void> showDeleteAccountSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => const DeleteAccountSheet(),
  );
}

/// Saisie du mot de passe puis suppression définitive du compte. En cas de
/// succès, l'état d'auth passe à `Unauthenticated` et le routeur ramène à la
/// connexion ; en cas d'échec, l'erreur s'affiche et rien n'est effacé.
class DeleteAccountSheet extends ConsumerStatefulWidget {
  /// Crée la feuille.
  const DeleteAccountSheet({super.key});

  @override
  ConsumerState<DeleteAccountSheet> createState() => _DeleteAccountSheetState();
}

class _DeleteAccountSheetState extends ConsumerState<DeleteAccountSheet> {
  final _controller = TextEditingController();
  bool _deleting = false;
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _delete() async {
    final password = _controller.text;
    if (password.isEmpty || _deleting) return;
    setState(() {
      _deleting = true;
      _error = null;
    });
    try {
      // Auth est surveillé par le routeur et la page Réglages : il survit à
      // la fermeture de cette feuille pendant l'appel.
      await ref.read(authProvider.notifier).deleteAccount(password);
      // Le routeur ramène à la connexion ; la feuille ne doit pas rester
      // au-dessus si elle n'a pas déjà été retirée.
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        setState(() {
          _deleting = false;
          _error = errorToFrench(e);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final error = _error;

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            0,
            AppSpacing.md,
            AppSpacing.md,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Supprimer mon compte',
                style: AppTypography.titleLarge,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Saisissez votre mot de passe pour confirmer. Cette action est '
                'définitive.',
                style: AppTypography.bodySmall.copyWith(
                  color: cs.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                label: 'Mot de passe',
                controller: _controller,
                obscureText: true,
                errorText: error,
                prefixIcon: Icons.lock_outlined,
                textInputAction: TextInputAction.done,
                autofillHints: const [AutofillHints.password],
                onChanged: (_) => setState(() => _error = null),
                onSubmitted: (_) => _delete(),
              ),
              const SizedBox(height: AppSpacing.md),
              ValueListenableBuilder(
                valueListenable: _controller,
                builder: (context, value, _) => FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: cs.error,
                    foregroundColor: cs.onError,
                    minimumSize: const Size.fromHeight(48),
                  ),
                  onPressed: value.text.isEmpty || _deleting ? null : _delete,
                  child: _deleting
                      ? SizedBox.square(
                          dimension: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: cs.onError,
                          ),
                        )
                      : const Text('Supprimer définitivement'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
