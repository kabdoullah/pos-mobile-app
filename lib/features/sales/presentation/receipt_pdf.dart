import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../domain/entities/sale.dart';
import 'providers/sales_providers.dart';

/// Télécharge le reçu PDF d'une vente synchronisée et ouvre le partage système.
///
/// Nécessite le réseau et un numéro de reçu serveur : l'appelant ne le propose
/// que si `sale.receiptNumber > 0`. Les erreurs remontent à l'appelant.
Future<void> shareSaleReceiptPdf(WidgetRef ref, Sale sale) async {
  final bytes = await ref.read(downloadSaleReceiptPdfProvider(sale.id).future);
  final dir = await getTemporaryDirectory();
  final file = File('${dir.path}/recu_${sale.receiptNumber}.pdf');
  await file.writeAsBytes(bytes);

  await SharePlus.instance.share(
    ShareParams(
      files: [XFile(file.path, mimeType: 'application/pdf')],
      subject: 'Reçu de vente',
    ),
  );
}
