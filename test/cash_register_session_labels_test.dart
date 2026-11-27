import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mobile/core/widgets/amount_display.dart';
import 'package:mobile/features/cash_register/presentation/cash_session_labels.dart';

void main() {
  setUpAll(() => initializeDateFormatting('fr_FR'));

  final today = DateTime(2026, 11, 26);

  group('sessionOpenedSinceLabel', () {
    test('le jour même : l’heure seule', () {
      expect(
        sessionOpenedSinceLabel(DateTime(2026, 11, 26, 8, 5), today),
        'depuis 08:05',
      );
    });

    test('la veille : « hier » devant l’heure', () {
      expect(
        sessionOpenedSinceLabel(DateTime(2026, 11, 25, 14, 29), today),
        'depuis hier 14:29',
      );
    });

    test('avant-hier et plus : la date', () {
      expect(
        sessionOpenedSinceLabel(DateTime(2026, 11, 23, 9), today),
        'depuis le 23 nov. 09:00',
      );
    });
  });

  test('isOpenedBeforeToday : vrai seulement avant minuit du jour', () {
    expect(isOpenedBeforeToday(DateTime(2026, 11, 25, 23, 59), today), isTrue);
    expect(isOpenedBeforeToday(DateTime(2026, 11, 26), today), isFalse);
  });

  test('formatAmount : séparateur de milliers visible (U+00A0)', () {
    expect(formatAmount(Decimal.parse('1500')), '1 500');
    expect(formatFcfa(Decimal.parse('1250000')), '1 250 000 FCFA');
  });
}
