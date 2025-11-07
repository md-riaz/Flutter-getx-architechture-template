import 'package:get/get.dart';
import '../../../core/services/json_db_service.dart';
import '../../../data/models/purchase.dart';
import '../../../data/models/sale.dart';
import '../../../data/models/product_unit.dart';

/// Reports repository - provides data for various reports
class ReportsRepo {
  final JsonDbService _db;

  ReportsRepo(this._db);

  /// Get purchase report data
  Future<Map<String, dynamic>> getPurchaseReport({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final purchasesRaw = await _db.readList('purchases');
    var purchases = purchasesRaw
        .map((e) => Purchase.fromJson(Map<String, dynamic>.from(e)))
        .toList();

    // Apply date filter
    if (startDate != null) {
      purchases = purchases
          .where((p) =>
              p.date.isAfter(startDate.subtract(const Duration(days: 1))))
          .toList();
    }
    if (endDate != null) {
      purchases = purchases
          .where((p) => p.date.isBefore(endDate.add(const Duration(days: 1))))
          .toList();
    }

    final totalPurchases = purchases.length;
    final totalAmount = purchases.fold<double>(0, (sum, p) => sum + p.total);

    // Get items count
    final productUnits = await _db.readList('product_units');
    final purchaseIds = purchases.map((p) => p.id).toSet();
    final itemsCount = productUnits
        .where((u) => purchaseIds.contains(u['purchaseId']))
        .length;

    return {
      'total_purchases': totalPurchases,
      'total_amount': totalAmount,
      'total_items': itemsCount,
      'avg_purchase': totalPurchases > 0 ? totalAmount / totalPurchases : 0.0,
      'purchases': purchases,
    };
  }

  /// Get sales report data
  Future<Map<String, dynamic>> getSalesReport({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final salesRaw = await _db.readList('sales');
    var sales = salesRaw
        .map((e) => Sale.fromJson(Map<String, dynamic>.from(e)))
        .toList();

    // Apply date filter
    if (startDate != null) {
      sales = sales
          .where(
              (s) => s.date.isAfter(startDate.subtract(const Duration(days: 1))))
          .toList();
    }
    if (endDate != null) {
      sales = sales
          .where((s) => s.date.isBefore(endDate.add(const Duration(days: 1))))
          .toList();
    }

    final totalSales = sales.length;
    final totalRevenue = sales.fold<double>(0, (sum, s) => sum + s.total);
    final totalTax = sales.fold<double>(
      0,
      (sum, s) => sum + s.cgst + s.sgst + s.igst,
    );
    final taxableAmount = sales.fold<double>(0, (sum, s) => sum + s.taxable);

    return {
      'total_sales': totalSales,
      'total_revenue': totalRevenue,
      'total_tax': totalTax,
      'taxable_amount': taxableAmount,
      'avg_sale': totalSales > 0 ? totalRevenue / totalSales : 0.0,
      'sales': sales,
    };
  }

  /// Get stock report data
  Future<Map<String, dynamic>> getStockReport() async {
    final unitsRaw = await _db.readList('product_units');
    final units = unitsRaw
        .map((e) => ProductUnit.fromJson(Map<String, dynamic>.from(e)))
        .toList();

    final totalItems = units.length;
    final inStock =
        units.where((u) => u.status == ProductStatus.in_stock).length;
    final sold = units.where((u) => u.status == ProductStatus.sold).length;
    final returned =
        units.where((u) => u.status == ProductStatus.returned).length;

    final stockValue = units
        .where((u) => u.status == ProductStatus.in_stock)
        .fold<double>(0, (sum, u) => sum + u.purchasePrice);

    final potentialRevenue = units
        .where((u) => u.status == ProductStatus.in_stock)
        .fold<double>(0, (sum, u) => sum + u.sellPrice);

    return {
      'total_items': totalItems,
      'in_stock': inStock,
      'sold': sold,
      'returned': returned,
      'stock_value': stockValue,
      'potential_revenue': potentialRevenue,
      'units': units,
    };
  }

  /// Get GST report data
  Future<Map<String, dynamic>> getGSTReport({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final salesRaw = await _db.readList('sales');
    var sales = salesRaw
        .map((e) => Sale.fromJson(Map<String, dynamic>.from(e)))
        .toList();

    // Apply date filter
    if (startDate != null) {
      sales = sales
          .where(
              (s) => s.date.isAfter(startDate.subtract(const Duration(days: 1))))
          .toList();
    }
    if (endDate != null) {
      sales = sales
          .where((s) => s.date.isBefore(endDate.add(const Duration(days: 1))))
          .toList();
    }

    final totalCGST = sales.fold<double>(0, (sum, s) => sum + s.cgst);
    final totalSGST = sales.fold<double>(0, (sum, s) => sum + s.sgst);
    final totalIGST = sales.fold<double>(0, (sum, s) => sum + s.igst);
    final totalGST = totalCGST + totalSGST + totalIGST;
    final taxableAmount = sales.fold<double>(0, (sum, s) => sum + s.taxable);

    // Separate intra-state and inter-state
    final intraStateSales = sales.where((s) => s.cgst > 0 || s.sgst > 0).toList();
    final interStateSales = sales.where((s) => s.igst > 0).toList();

    return {
      'total_gst': totalGST,
      'total_cgst': totalCGST,
      'total_sgst': totalSGST,
      'total_igst': totalIGST,
      'taxable_amount': taxableAmount,
      'intra_state_count': intraStateSales.length,
      'inter_state_count': interStateSales.length,
      'sales': sales,
    };
  }
}
