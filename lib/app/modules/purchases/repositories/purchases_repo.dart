import 'package:get/get.dart';
import '../../../core/services/json_db_service.dart';
import '../../../data/models/purchase.dart';
import '../../../data/models/product_unit.dart';

/// Purchases repository
class PurchasesRepo {
  final JsonDbService _db;
  static const String _purchasesFile = 'purchases';
  static const String _productUnitsFile = 'product_units';

  PurchasesRepo(this._db);

  /// Get all purchases with optional filters
  Future<List<Purchase>> list({
    String? query,
    String? vendorId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final raw = await _db.readList(_purchasesFile);
    var items = raw
        .map((e) => Purchase.fromJson(Map<String, dynamic>.from(e)))
        .toList();

    // Apply vendor filter
    if (vendorId != null && vendorId.trim().isNotEmpty) {
      items = items.where((p) => p.vendorId == vendorId).toList();
    }

    // Apply date range filter
    if (startDate != null) {
      items = items
          .where((p) =>
              p.date.isAfter(startDate.subtract(const Duration(days: 1))))
          .toList();
    }
    if (endDate != null) {
      items = items
          .where((p) => p.date.isBefore(endDate.add(const Duration(days: 1))))
          .toList();
    }

    // Apply search filter
    if (query != null && query.trim().isNotEmpty) {
      final q = query.toLowerCase();
      items = items.where((p) {
        return p.vendorInvoiceNo.toLowerCase().contains(q) ||
            (p.notes?.toLowerCase().contains(q) ?? false);
      }).toList();
    }

    items.sort((a, b) => b.date.compareTo(a.date)); // Newest first
    return items;
  }

  /// Get purchase by ID
  Future<Purchase?> getById(String id) async {
    final items = await list();
    try {
      return items.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Create new purchase and add product units to stock
  Future<void> create(Purchase purchase, List<ProductUnit> units) async {
    // Save purchase
    final purchases = await _db.readList(_purchasesFile);
    purchases.add(purchase.toJson());
    await _db.writeList(_purchasesFile, purchases);

    // Add product units to stock
    final productUnits = await _db.readList(_productUnitsFile);
    for (var unit in units) {
      productUnits.add(unit.toJson());
    }
    await _db.writeList(_productUnitsFile, productUnits);
  }

  /// Get purchase statistics
  Future<Map<String, dynamic>> getStatistics() async {
    final items = await list();
    if (items.isEmpty) {
      return {
        'total_purchases': 0,
        'total_amount': 0.0,
        'avg_purchase': 0.0,
        'total_items': 0,
      };
    }

    final totalAmount = items.fold<double>(0, (sum, p) => sum + p.total);

    // Count total items from all purchases
    final productUnits = await _db.readList(_productUnitsFile);
    final purchaseIds = items.map((p) => p.id).toSet();
    final totalItems = productUnits
        .where((u) => purchaseIds.contains(u['purchaseId']))
        .length;

    return {
      'total_purchases': items.length,
      'total_amount': totalAmount,
      'avg_purchase': totalAmount / items.length,
      'total_items': totalItems,
    };
  }
}
