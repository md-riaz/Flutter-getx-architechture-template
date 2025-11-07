import 'package:get/get.dart';

/// Tax calculation result
class TaxCalculation {
  final double taxable;
  final double cgst;
  final double sgst;
  final double igst;
  final double total;

  const TaxCalculation({
    required this.taxable,
    required this.cgst,
    required this.sgst,
    required this.igst,
    required this.total,
  });

  @override
  String toString() {
    return 'TaxCalculation(taxable: $taxable, cgst: $cgst, sgst: $sgst, igst: $igst, total: $total)';
  }
}

/// Service for GST tax calculations
/// Handles CGST/SGST (intra-state) and IGST (inter-state)
class TaxService extends GetxService {
  /// Calculate tax breakdown
  /// taxable: base amount before tax
  /// taxRate: total tax rate as percentage (e.g., 18 for 18% GST)
  /// intraState: true for CGST+SGST, false for IGST
  TaxCalculation calculate({
    required double taxable,
    required double taxRate,
    required bool intraState,
  }) {
    double cgst = 0;
    double sgst = 0;
    double igst = 0;

    if (intraState) {
      // Intra-state: split between CGST and SGST
      final halfRate = taxRate / 2;
      cgst = (taxable * halfRate / 100);
      sgst = (taxable * halfRate / 100);
    } else {
      // Inter-state: IGST only
      igst = (taxable * taxRate / 100);
    }

    final total = taxable + cgst + sgst + igst;

    return TaxCalculation(
      taxable: _roundToTwoDecimals(taxable),
      cgst: _roundToTwoDecimals(cgst),
      sgst: _roundToTwoDecimals(sgst),
      igst: _roundToTwoDecimals(igst),
      total: _roundToTwoDecimals(total),
    );
  }

  /// Round to 2 decimal places for currency
  double _roundToTwoDecimals(double value) {
    return (value * 100).round() / 100;
  }

  /// Standard GST rates in India
  static const double gstRate5 = 5.0;
  static const double gstRate12 = 12.0;
  static const double gstRate18 = 18.0;
  static const double gstRate28 = 28.0;
}
