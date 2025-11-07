import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_getx_architecture/app/core/services/tax_service.dart';

void main() {
  late TaxService taxService;

  setUp(() {
    taxService = TaxService();
  });

  group('TaxService', () {
    test('calculates intra-state GST correctly (CGST + SGST)', () {
      final result = taxService.calculate(
        taxable: 100000,
        taxRate: 18,
        intraState: true,
      );

      expect(result.taxable, 100000.0);
      expect(result.cgst, 9000.0); // 9% of 100000
      expect(result.sgst, 9000.0); // 9% of 100000
      expect(result.igst, 0.0);
      expect(result.total, 118000.0); // 100000 + 9000 + 9000
    });

    test('calculates inter-state GST correctly (IGST)', () {
      final result = taxService.calculate(
        taxable: 100000,
        taxRate: 18,
        intraState: false,
      );

      expect(result.taxable, 100000.0);
      expect(result.cgst, 0.0);
      expect(result.sgst, 0.0);
      expect(result.igst, 18000.0); // 18% of 100000
      expect(result.total, 118000.0); // 100000 + 18000
    });

    test('handles decimal values correctly', () {
      final result = taxService.calculate(
        taxable: 99999.99,
        taxRate: 12,
        intraState: true,
      );

      expect(result.taxable, 99999.99);
      expect(result.cgst, 6000.0); // 6% of 99999.99, rounded
      expect(result.sgst, 6000.0); // 6% of 99999.99, rounded
      expect(result.total, 111999.99);
    });

    test('calculates 5% GST correctly', () {
      final result = taxService.calculate(
        taxable: 50000,
        taxRate: TaxService.gstRate5,
        intraState: true,
      );

      expect(result.taxable, 50000.0);
      expect(result.cgst, 1250.0); // 2.5% of 50000
      expect(result.sgst, 1250.0); // 2.5% of 50000
      expect(result.total, 52500.0);
    });

    test('calculates 28% GST correctly', () {
      final result = taxService.calculate(
        taxable: 100000,
        taxRate: TaxService.gstRate28,
        intraState: false,
      );

      expect(result.taxable, 100000.0);
      expect(result.igst, 28000.0); // 28% of 100000
      expect(result.total, 128000.0);
    });

    test('handles zero taxable amount', () {
      final result = taxService.calculate(
        taxable: 0,
        taxRate: 18,
        intraState: true,
      );

      expect(result.taxable, 0.0);
      expect(result.cgst, 0.0);
      expect(result.sgst, 0.0);
      expect(result.total, 0.0);
    });
  });
}
