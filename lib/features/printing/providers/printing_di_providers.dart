import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/printer_service.dart';
import '../data/saved_printer_storage.dart';
import '../domain/repositories/printer_repository.dart';
import '../domain/repositories/saved_printer_repository.dart';

part 'printing_di_providers.g.dart';

/// Fournit une implémentation unique de [PrinterRepository].
///
/// Retourne l'interface abstraite ; les consommateurs ne doivent pas dépendre
/// de l'implémentation concrète [PrinterService].
@riverpod
PrinterRepository printerRepository(Ref ref) => const PrinterService();

/// Fournit le stockage de l'imprimante mémorisée.
@riverpod
SavedPrinterRepository savedPrinterRepository(Ref ref) => SavedPrinterStorage();
