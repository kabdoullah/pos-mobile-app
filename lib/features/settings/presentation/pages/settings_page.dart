import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/theme_mode_provider.dart';
import '../../../../core/network/error_mapper.dart';
import '../../../../core/providers/connectivity_provider.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/sync/sync_orchestrator.dart';
import '../../../../core/sync/sync_providers.dart';
import '../../../../core/utils/phone_formatter.dart';
import '../../../../core/widgets/index.dart';
import '../../../auth/presentation/pages/store_setup_page.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../auth/providers/store_provider.dart';
import '../../../printing/presentation/providers/printer_provider.dart';
import '../../../sales/domain/entities/payment_method_label.dart';
import '../../../sales/providers/sales_di_providers.dart';
import '../../../auth/providers/seller_profile_provider.dart';
import '../widgets/receipt_settings_sheet.dart';
import '../widgets/seller_name_sheet.dart';
import '../widgets/settings_section.dart';

/// Paramètres, par sections : commerce, caisse, application, compte.
class SettingsPage extends ConsumerStatefulWidget {
  /// Crée la page des paramètres.
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  // Protection contre le double tap sur les actions asynchrones.
  bool _exporting = false;
  bool _syncing = false;

  void _showMessage(String message, {bool isError = false}) {
    final cs = Theme.of(context).colorScheme;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          backgroundColor: isError ? cs.error : null,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final store = ref.watch(storeConfigProvider).value;
    final auth = ref.watch(authProvider).value;
    final phone = auth is AuthAuthenticated ? auth.user.phoneNumber : null;
    final sellerName = ref.watch(sellerProfileProvider).value;
    final storeAddress = store?.address;
    final footer = store?.receiptFooterText;

    return AppScaffold(
      title: 'Paramètres',
      body: ListView(
        padding: const EdgeInsets.only(bottom: AppSpacing.xl),
        children: [
          SettingsSection(
            title: 'COMMERCE',
            children: [
              SettingsTile(
                icon: Icons.storefront_outlined,
                title: store == null ? 'Configurer ma boutique' : 'Mon magasin',
                subtitle: Text(
                  store == null
                      ? 'Nom et adresse du commerce'
                      : [
                          store.name,
                          if (storeAddress != null && storeAddress.isNotEmpty)
                            storeAddress,
                        ].join(' · '),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                showChevron: true,
                onTap: () => Navigator.of(context).push<void>(
                  MaterialPageRoute(
                    fullscreenDialog: true,
                    builder: (_) => const StoreSetupPage(isEditMode: true),
                  ),
                ),
              ),
              if (store != null)
                SettingsTile(
                  icon: Icons.receipt_long_outlined,
                  title: 'Reçus',
                  subtitle: Text(
                    footer == null || footer.isEmpty
                        ? 'Personnaliser le pied de page'
                        : footer,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  showChevron: true,
                  onTap: () => showReceiptSettingsSheet(context, store),
                ),
            ],
          ),
          SettingsSection(
            title: 'CAISSE',
            children: [
              SettingsTile(
                icon: Icons.print_outlined,
                title: 'Imprimante',
                subtitle: Text(_printerLabel(ref.watch(printerProvider))),
                showChevron: true,
                onTap: () => context.push(Routes.bluetoothSetup),
              ),
            ],
          ),
          SettingsSection(
            title: 'APPLICATION',
            children: [
              SettingsTile(
                icon: Icons.cloud_sync_outlined,
                title: 'Synchronisation',
                subtitle: Text(_syncLabel()),
                busy: _syncing,
                onTap: _syncNow,
                trailing: const Icon(Icons.refresh),
              ),
              SettingsTile(
                icon: Icons.palette_outlined,
                title: 'Apparence',
                trailing: SegmentedButton<ThemeMode>(
                  segments: const [
                    ButtonSegment(
                      value: ThemeMode.light,
                      icon: Icon(Icons.light_mode_outlined, size: 18),
                      tooltip: 'Clair',
                    ),
                    ButtonSegment(
                      value: ThemeMode.system,
                      icon: Icon(Icons.brightness_auto_outlined, size: 18),
                      tooltip: 'Système',
                    ),
                    ButtonSegment(
                      value: ThemeMode.dark,
                      icon: Icon(Icons.dark_mode_outlined, size: 18),
                      tooltip: 'Sombre',
                    ),
                  ],
                  selected: {ref.watch(themeModeProvider)},
                  onSelectionChanged: (modes) =>
                      ref.read(themeModeProvider.notifier).setMode(modes.first),
                  showSelectedIcon: false,
                  style: SegmentedButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                  ),
                ),
              ),
              SettingsTile(
                icon: Icons.file_download_outlined,
                title: 'Exporter les ventes',
                subtitle: const Text('Fichier CSV à partager'),
                busy: _exporting,
                onTap: _exportCsv,
              ),
              SettingsTile(
                icon: Icons.help_outline,
                title: 'Revoir le tutoriel',
                subtitle: const Text('Visite guidée de l’application'),
                showChevron: true,
                onTap: () => context.push(Routes.tutorial),
              ),
            ],
          ),
          SettingsSection(
            title: 'COMPTE',
            children: [
              if (phone != null)
                SettingsTile(
                  icon: Icons.person_outline,
                  title: 'Mon compte',
                  subtitle: Text(
                    [
                      formatPhoneCiDisplay(phone),
                      sellerName == null || sellerName.isEmpty
                          ? 'Nom du vendeur à définir'
                          : 'Vendeur : $sellerName',
                    ].join(' · '),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  showChevron: true,
                  onTap: () => showSellerNameSheet(context, sellerName),
                ),
              SettingsTile(
                icon: Icons.logout_outlined,
                title: 'Se déconnecter',
                destructive: true,
                onTap: _confirmLogout,
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _printerLabel(PrinterState state) => switch (state) {
    PrinterConnected(:final name) => 'Connectée : $name',
    PrinterConnecting() => 'Connexion…',
    PrinterDisconnected(savedName: final name?) => name,
    PrinterDisconnected() => 'Aucune imprimante configurée',
    PrinterError() => 'Erreur de connexion — touchez pour vérifier',
  };

  /// État de synchro en mots simples (jamais de jargon technique).
  String _syncLabel() {
    final isOnline = ref.watch(isOnlineProvider).value ?? true;
    final status = ref.watch(syncOrchestratorProvider);
    final pending = ref.watch(pendingSyncCountProvider).value ?? 0;
    if (!isOnline) return 'Hors ligne — reprise automatique';
    return switch (status) {
      SyncStatusSyncing() => 'Synchronisation…',
      SyncStatusError() => 'Échec — touchez pour réessayer',
      SyncStatusIdle() when pending > 0 =>
        pending == 1 ? '1 vente en attente' : '$pending ventes en attente',
      SyncStatusIdle(lastSyncAt: final at?) =>
        'Synchronisé à ${DateFormat.Hm('fr_FR').format(at)}',
      SyncStatusIdle() => 'Synchronisé',
    };
  }

  Future<void> _syncNow() async {
    if (!(ref.read(isOnlineProvider).value ?? false)) {
      _showMessage(
        'Hors ligne : la synchronisation reprendra au retour du réseau.',
      );
      return;
    }
    setState(() => _syncing = true);
    // syncNow() ne lève pas : le résultat se lit dans l'état de l'orchestrateur.
    await ref.read(syncOrchestratorProvider.notifier).syncNow();
    if (!mounted) return;
    setState(() => _syncing = false);
    switch (ref.read(syncOrchestratorProvider)) {
      case SyncStatusError():
        _showMessage(
          'La synchronisation a échoué. Réessayez dans un instant.',
          isError: true,
        );
      case SyncStatusSyncing():
        _showMessage('Synchronisation déjà en cours…');
      case SyncStatusIdle():
        _showMessage('Tout est synchronisé');
    }
  }

  Future<void> _confirmLogout() async {
    final pending = ref.read(pendingSyncCountProvider).value ?? 0;
    final confirmed = await showConfirmDialog(
      context,
      title: 'Se déconnecter ?',
      // Si un autre compte se connecte ensuite, la synchro efface les données
      // locales de l'ancien compte (y compris les ventes non envoyées).
      message: pending == 0
          ? 'Vous devrez saisir votre numéro et votre mot de passe pour vous '
                'reconnecter.'
          : pending == 1
          ? '1 vente pas encore synchronisée. Synchronisez avant de vous '
                'déconnecter : si un autre compte se connecte sur ce '
                'téléphone, elle sera effacée.'
          : '$pending ventes pas encore synchronisées. Synchronisez avant de '
                'vous déconnecter : si un autre compte se connecte sur ce '
                'téléphone, elles seront effacées.',
      confirmLabel: 'Se déconnecter',
      isDangerous: true,
    );
    if (confirmed && mounted) {
      unawaited(ref.read(authProvider.notifier).logout());
    }
  }

  Future<void> _exportCsv() async {
    setState(() => _exporting = true);
    try {
      final dir = await getTemporaryDirectory();
      final filename =
          'ventes_${DateFormat('yyyyMMdd').format(DateTime.now())}.csv';
      final file = File('${dir.path}/$filename');
      final sink = file.openWrite();

      sink.writeln('Date,Reçu N°,Total (FCFA),TVA (FCFA),Mode de paiement');

      // Pagination par tranches de 200 pour éviter de saturer la mémoire sur
      // les appareils d'entrée de gamme.
      const chunkSize = 200;
      String? cursor;
      while (true) {
        final chunk = await ref
            .read(salesRepositoryProvider)
            .getSales(limit: chunkSize, cursor: cursor);

        for (final sale in chunk) {
          sink.writeln(
            [
              sale.createdAt.toIso8601String(),
              sale.receiptNumber,
              sale.totalAmount,
              sale.vatAmount,
              sale.paymentMethod.label,
            ].join(','),
          );
        }

        if (chunk.length < chunkSize) break;
        cursor = chunk.last.createdAt.toIso8601String();
      }

      await sink.close();

      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(file.path, mimeType: 'text/csv')],
          subject: 'Export ventes POS',
        ),
      );
    } catch (e) {
      if (mounted) {
        _showMessage('Export impossible : ${errorToFrench(e)}', isError: true);
      }
    } finally {
      if (mounted) setState(() => _exporting = false);
    }
  }
}
