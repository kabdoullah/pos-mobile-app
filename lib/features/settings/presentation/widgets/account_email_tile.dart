import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';

import '../../../auth/domain/entities/account_email.dart';
import '../../../auth/presentation/widgets/account_email_sheet.dart';
import '../../../auth/providers/account_email_provider.dart';
import 'settings_section.dart';

/// Email du compte et son état de vérification (sans adresse confirmée, le
/// mot de passe oublié ne peut pas être réinitialisé).
///
/// - Aucun email : un appui ouvre l'ajout.
/// - Non confirmé : un appui renvoie le lien, le crayon corrige l'adresse.
/// - Confirmé : affichage seul.
class AccountEmailTile extends ConsumerStatefulWidget {
  /// Crée la ligne « Adresse email ».
  const AccountEmailTile({super.key});

  @override
  ConsumerState<AccountEmailTile> createState() => _AccountEmailTileState();
}

class _AccountEmailTileState extends ConsumerState<AccountEmailTile> {
  bool _sending = false;

  @override
  Widget build(BuildContext context) {
    final status = ref.watch(accountEmailStatusProvider);
    final warning = TextStyle(color: AppColors.of(context).warning);

    return switch (status) {
      AsyncData(value: AccountEmail(email: null)) => SettingsTile(
        title: 'Adresse e-mail',
        subtitle: Text(
          'Aucun email — touchez pour en ajouter un',
          style: warning,
        ),
        showChevron: true,
        onTap: () => showAccountEmailSheet(context),
      ),
      AsyncData(value: AccountEmail(:final email?, isVerified: true)) =>
        SettingsTile(
          title: 'Adresse e-mail',
          subtitle: Text(
            '$email · Confirmée',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      AsyncData(value: AccountEmail(:final email?)) => SettingsTile(
        title: 'Adresse e-mail',
        subtitle: Text(
          '$email · Non confirmée — touchez pour renvoyer le lien',
          style: warning,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        busy: _sending,
        onTap: () => _resend(email),
        trailing: IconButton(
          icon: const Icon(Icons.edit_outlined),
          tooltip: 'Corriger l’adresse',
          onPressed: () => showAccountEmailSheet(context, currentEmail: email),
        ),
      ),
      AsyncError() => SettingsTile(
        title: 'Adresse e-mail',
        subtitle: const Text('Indisponible — touchez pour réessayer'),
        onTap: () => ref.invalidate(accountEmailStatusProvider),
      ),
      _ => const SettingsTile(
        title: 'Adresse e-mail',
        subtitle: Text('Chargement…'),
      ),
    };
  }

  Future<void> _resend(String email) async {
    if (_sending) return;
    setState(() => _sending = true);
    await resendEmailVerification(context, ref, email);
    if (mounted) setState(() => _sending = false);
  }
}
