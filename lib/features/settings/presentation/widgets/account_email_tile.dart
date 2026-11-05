import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    final cs = Theme.of(context).colorScheme;
    final status = ref.watch(accountEmailStatusProvider);
    final warning = TextStyle(color: cs.error);

    return switch (status) {
      AsyncData(value: AccountEmail(email: null)) => SettingsTile(
        icon: Icons.email_outlined,
        title: 'Adresse email',
        subtitle: Text(
          'Aucun email — touchez pour en ajouter un',
          style: warning,
        ),
        showChevron: true,
        onTap: () => showAccountEmailSheet(context),
      ),
      AsyncData(value: AccountEmail(:final email?, isVerified: true)) =>
        SettingsTile(
          icon: Icons.mark_email_read_outlined,
          title: 'Adresse email',
          subtitle: Text(
            '$email · Confirmée',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      AsyncData(value: AccountEmail(:final email?)) => SettingsTile(
        icon: Icons.mark_email_unread_outlined,
        title: 'Adresse email',
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
        icon: Icons.email_outlined,
        title: 'Adresse email',
        subtitle: const Text('Indisponible — touchez pour réessayer'),
        onTap: () => ref.invalidate(accountEmailStatusProvider),
      ),
      _ => const SettingsTile(
        icon: Icons.email_outlined,
        title: 'Adresse email',
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
