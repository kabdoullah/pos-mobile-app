import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/error_mapper.dart';
import '../../../auth/domain/entities/account_email.dart';
import '../../../auth/providers/account_email_provider.dart';
import 'settings_section.dart';

/// Email du compte et son état de vérification. Non vérifié : un appui renvoie
/// le lien (sans adresse vérifiée, le mot de passe oublié ne peut pas être
/// réinitialisé).
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

    return switch (status) {
      AsyncData(value: AccountEmail(email: null)) => const SettingsTile(
        icon: Icons.email_outlined,
        title: 'Adresse email',
        subtitle: Text('Aucun email sur ce compte'),
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
          style: TextStyle(color: cs.error),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        busy: _sending,
        onTap: () => _resend(email),
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
    if (!mounted) return;
    setState(() => _sending = false);
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
}
