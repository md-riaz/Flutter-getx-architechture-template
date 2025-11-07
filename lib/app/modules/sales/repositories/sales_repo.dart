import 'package:get/get.dart';
import '../../../core/services/json_db_service.dart';
import '../../../data/models/sale.dart';

/// Sales repository
class SalesRepo {
  final JsonDbService _db;
  static const String _fileName = 'sales';

  SalesRepo(this._db);

  /// Get all sales with optional filters
  Future<List<Sale>> list({
    String? query,
    String? customerId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final raw = await _db.readList(_fileName);
    var items = raw.map((e) => Sale.fromJson(Map<String, dynamic>.from(e))).toList();

    // Apply customer filter
    if (customerId != null && customerId.trim().isNotEmpty) {
      items = items.where((s) => s.customerId == customerId).toList();
    }

    // Apply date range filter
    if (startDate != null) {
      items = items.where((s) => s.date.isAfter(startDate.subtract(const Duration(days: 1)))).toList();
    }
    if (endDate != null) {
      items = items.where((s) => s.date.isBefore(endDate.add(const Duration(days: 1)))).toList();
    }

    // Apply search filter
    if (query != null && query.trim().isNotEmpty) {
      final q = query.toLowerCase();
      items = items.where((s) => s.invoiceNo.toLowerCase().contains(q)).toList();
    }

    items.sort((a, b) => b.date.compareTo(a.date)); // Newest first
    return items;
  }

  /// Get sale by ID
  Future<Sale?> getById(String id) async {
    final items = await list();
    try {
      return items.firstWhere((s) => s.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Create new sale
  Future<void> create(Sale sale) async {
    final rows = await _db.readList(_fileName);
    rows.add(sale.toJson());
    await _db.writeList(_fileName, rows);
  }

  /// Create sale and update product units status
  Future<void> createWithUnits(Sale sale, List<String> imeiList) async {
    // Save sale
    await create(sale);

    // Update product units to sold
    final productUnits = await _db.readList('product_units');
    for (var i = 0; i < productUnits.length; i++) {
      if (imeiList.contains(productUnits[i]['imei'])) {
        productUnits[i]['status'] = 'sold';
        productUnits[i]['saleId'] = sale.id;
      }
    }
    await _db.writeList('product_units', productUnits);
  }

  /// Get sales statistics
  Future<Map<String, dynamic>> getStatistics() async {
    final items = await list();
    if (items.isEmpty) {
      return {
        'total_sales': 0,
        'total_revenue': 0.0,
        'total_tax': 0.0,
        'avg_sale': 0.0,
      };
    }

    final totalRevenue = items.fold<double>(0, (sum, sale) => sum + sale.total);
    final totalTax = items.fold<double>(
      0,
      (sum, sale) => sum + sale.cgst + sale.sgst + sale.igst,
    );

    return {
      'total_sales': items.length,
      'total_revenue': totalRevenue,
      'total_tax': totalTax,
      'avg_sale': totalRevenue / items.length,
    };
  }
}
