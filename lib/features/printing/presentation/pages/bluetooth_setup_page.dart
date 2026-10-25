import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';

import '../../../../core/responsive/responsive.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/index.dart';
import '../../domain/repositories/printer_repository.dart';
import '../../providers/printing_di_providers.dart';
import '../providers/printer_provider.dart';

/// Page d'appairage et de connexion à une imprimante thermique Bluetooth.
///
/// La page explique que les imprimantes doivent d'abord être appairées dans les
/// paramètres système Android, puis liste les appareils appairés pour les
/// sélectionner et s'y connecter.
class BluetoothSetupPage extends ConsumerStatefulWidget {
  /// Crée une [BluetoothSetupPage].
  const BluetoothSetupPage({super.key});

  @override
  ConsumerState<BluetoothSetupPage> createState() => _BluetoothSetupPageState();
}

class _BluetoothSetupPageState extends ConsumerState<BluetoothSetupPage> {
  bool _hasPermission = false;
  bool _checkingPermission = true;
  List<BluetoothInfo> _pairedDevices = [];
  bool _isLoading = false;
  // ✨ track quel MAC est en cours de connexion — évite le spinner global sur tous les devices
  String? _connectingMac;
  bool _testing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkPermissions());
  }

  // BLUETOOTH_CONNECT n'existe que sur Android 12+ : sur iOS, permission_handler
  // la renvoie « refusée définitivement » sans jamais afficher la demande
  // système. iOS passe par l'autorisation CoreBluetooth.
  Permission get _bluetoothPermission =>
      Platform.isIOS ? Permission.bluetooth : Permission.bluetoothConnect;

  Future<void> _checkPermissions() async {
    final status = await _bluetoothPermission.status;
    final hasPermission = status.isGranted;

    if (mounted) {
      setState(() {
        _hasPermission = hasPermission;
        _checkingPermission = false;
      });
    }

    if (hasPermission) {
      await _loadDevices();
    }
  }

  Future<void> _requestPermission() async {
    final result = await _bluetoothPermission.request();
    if (result.isGranted) {
      if (mounted) setState(() => _hasPermission = true);
      await _loadDevices();
    } else if (result.isDenied) {
      if (mounted) setState(() => _checkingPermission = false);
    } else if (result.isPermanentlyDenied) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Permission refusée. Ouvre les paramètres de l\'app.',
            ),
            duration: Duration(seconds: 3),
          ),
        );
        await AppSettings.openAppSettings();
      }
    }
  }

  Future<void> _loadDevices() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);
    try {
      // Note : BluetoothInfo.macAdress contient une faute de frappe (un seul «
      // d ») dans print_bluetooth_thermal v1.2.x
      final devices = await ref
          .read(printerRepositoryProvider)
          .getPairedDevices();
      if (mounted) setState(() => _pairedDevices = devices);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Impossible de lister les imprimantes. Vérifiez que le '
              'Bluetooth est activé.',
            ),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _connectToDevice(BluetoothInfo device) async {
    if (ref.read(printerProvider) is PrinterConnecting) return;

    // ✨ mémoriser le MAC pour afficher le spinner uniquement sur cette carte
    setState(() => _connectingMac = device.macAdress);

    // Note : BluetoothInfo.macAdress (un seul « d »)
    await ref
        .read(printerProvider.notifier)
        .connect(device.macAdress, device.name);

    if (!mounted) return;
    setState(() => _connectingMac = null);

    final newState = ref.read(printerProvider);
    if (newState is PrinterConnected) {
      _onConnectSuccess();
    } else if (newState is PrinterError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Connexion impossible. Vérifiez que l’imprimante est allumée et '
            'à proximité.',
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  Future<void> _printTest() async {
    setState(() => _testing = true);
    final messenger = ScaffoldMessenger.of(context);
    final cs = Theme.of(context).colorScheme;
    try {
      await ref.read(printerProvider.notifier).printTest();
      messenger.showSnackBar(
        const SnackBar(content: Text('Ticket de test imprimé')),
      );
    } on PrintException catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text(e.userMessage), backgroundColor: cs.error),
      );
    } finally {
      if (mounted) setState(() => _testing = false);
    }
  }

  Future<void> _forget(String name) async {
    final confirmed = await showConfirmDialog(
      context,
      title: 'Oublier $name ?',
      message:
          'Vous devrez choisir à nouveau une imprimante pour imprimer vos '
          'reçus.',
      confirmLabel: 'Oublier',
      isDangerous: true,
    );
    if (!confirmed || !mounted) return;
    await ref.read(printerProvider.notifier).forget();
  }

  // Correctif n°2 : snackbar + retour au lieu du dialogue d'impression test
  // cassé
  void _onConnectSuccess() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Imprimante connectée'),
        duration: Duration(seconds: 2),
      ),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    // ✨ extraits une fois — pas de double lookup Theme.of(context) dans itemBuilder
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final savedName = switch (ref.watch(printerProvider)) {
      PrinterConnected(:final name) => name,
      PrinterDisconnected(:final savedName) => savedName,
      _ => null,
    };

    return AppScaffold(
      title: 'Configurer l\'imprimante',
      actions: [
        if (!_checkingPermission && _hasPermission)
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadDevices,
            tooltip: 'Actualiser',
          ),
      ],
      body: SingleChildScrollView(
        padding: EdgeInsets.all(
          responsiveValue(context, small: AppSpacing.md, medium: AppSpacing.lg),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (savedName != null) ...[
              _SavedPrinterCard(
                name: savedName,
                isTesting: _testing,
                onTest: _printTest,
                onForget: () => _forget(savedName),
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
            if (_checkingPermission) ...[
              const Center(child: AppLoadingIndicator()),
              const SizedBox(height: AppSpacing.lg),
              const Text(
                'Vérification des permissions...',
                textAlign: TextAlign.center,
              ),
            ] else if (!_hasPermission) ...[
              EmptyState(
                icon: Icons.bluetooth_disabled_outlined,
                title: 'Permission Bluetooth requise',
                message:
                    'L\'app doit accéder à Bluetooth pour découvrir les imprimantes.',
                actionLabel: 'Accorder la permission',
                onAction: _requestPermission,
              ),
            ] else if (_pairedDevices.isEmpty) ...[
              EmptyState(
                icon: Icons.print_outlined,
                title: 'Aucune imprimante trouvée',
                message: Platform.isIOS
                    ? 'Allumez votre imprimante Bluetooth et placez-la près '
                          'du téléphone.'
                    : 'Appairez d\'abord votre imprimante Bluetooth dans les '
                          'réglages Android.',
                actionLabel: 'Ouvrir les réglages Bluetooth',
                // Correctif n°3 : ouvre directement les paramètres Bluetooth
                // via app_settings
                onAction: () => AppSettings.openAppSettings(
                  type: AppSettingsType.bluetooth,
                ),
              ),
            ] else ...[
              // ✨ barre de progression lors d'un refresh (liste déjà visible)
              if (_isLoading) const LinearProgressIndicator(),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Appareils appairés (${_pairedDevices.length})',
                style: tt.titleSmall,
              ),
              const SizedBox(height: AppSpacing.md),
              // Une seule surface, une ligne par appareil.
              AppListGroup(
                dividerIndent: 56,
                children: [
                  for (final device in _pairedDevices)
                    Builder(
                      builder: (context) {
                        final printerState = ref.watch(printerProvider);
                        final isConnected =
                            printerState is PrinterConnected &&
                            printerState.mac == device.macAdress;
                        final isAnyConnecting =
                            printerState is PrinterConnecting;
                        // Indicateur uniquement sur la ligne de l'appareil
                        // en cours de connexion.
                        final isThisDeviceConnecting =
                            _connectingMac == device.macAdress;

                        return ListTile(
                          onTap: (isConnected || isAnyConnecting)
                              ? null
                              : () => _connectToDevice(device),
                          leading: Icon(
                            isConnected ? Icons.check_circle : Icons.bluetooth,
                            color: isConnected
                                ? cs.secondary
                                : cs.onSurfaceVariant,
                          ),
                          title: Text(device.name),
                          subtitle: Text(device.macAdress, style: tt.bodySmall),
                          trailing: isConnected
                              ? Text(
                                  'Connectée',
                                  style: tt.bodyMedium?.copyWith(
                                    color: cs.secondary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                )
                              : isThisDeviceConnecting
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : Icon(
                                  Icons.arrow_forward_ios,
                                  size: 16,
                                  color: cs.onSurfaceVariant,
                                ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md,
                            vertical: AppSpacing.xs,
                          ),
                        );
                      },
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Imprimante enregistrée : nom, ticket de test et oubli.
class _SavedPrinterCard extends StatelessWidget {
  const _SavedPrinterCard({
    required this.name,
    required this.isTesting,
    required this.onTest,
    required this.onForget,
  });

  final String name;
  final bool isTesting;
  final VoidCallback onTest;
  final VoidCallback onForget;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Imprimante enregistrée',
            style: AppTypography.labelMedium.copyWith(
              color: cs.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Row(
            children: [
              Icon(Icons.print_outlined, color: cs.primary),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.titleMedium,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: FilledButton.tonalIcon(
                  onPressed: isTesting ? null : onTest,
                  icon: isTesting
                      ? const SizedBox.square(
                          dimension: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.receipt_outlined),
                  label: const Text('Tester'),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: TextButton.icon(
                  onPressed: isTesting ? null : onForget,
                  icon: const Icon(Icons.link_off),
                  label: const Text('Oublier'),
                  style: TextButton.styleFrom(foregroundColor: cs.error),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
