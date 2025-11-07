import 'package:get/get.dart';
import '../../../core/services/json_db_service.dart';
import '../../../data/models/product_unit.dart';

/// Stock repository
class StockRepo {
  final JsonDbService _db;
  static const String _fileName = 'product_units';

  StockRepo(this._db);

  /// Get all product units with optional filters
  Future<List<ProductUnit>> list({
    String? query,
    ProductStatus? status,
    String? brandId,
    String? modelId,
  }) async {
    final raw = await _db.readList(_fileName);
    var items = raw
        .map((e) => ProductUnit.fromJson(Map<String, dynamic>.from(e)))
        .toList();

    // Apply filters
    if (status != null) {
      items = items.where((u) => u.status == status).toList();
    }

    if (brandId != null && brandId.trim().isNotEmpty) {
      items = items.where((u) => u.brandId == brandId).toList();
    }

    if (modelId != null && modelId.trim().isNotEmpty) {
      items = items.where((u) => u.modelId == modelId).toList();
    }

    if (query != null && query.trim().isNotEmpty) {
      final q = query.toLowerCase();
      items = items.where((u) {
        return u.imei.toLowerCase().contains(q) ||
            (u.color?.toLowerCase().contains(q) ?? false);
      }).toList();
    }

    items.sort((a, b) => b.id.compareTo(a.id)); // Newest first
    return items;
  }

  /// Get unit by IMEI
  Future<ProductUnit?> getByImei(String imei) async {
    final items = await list();
    try {
      return items.firstWhere((u) => u.imei == imei);
    } catch (e) {
      return null;
    }
  }

  /// Add new product unit
  Future<void> add(ProductUnit unit) async {
    final rows = await _db.readList(_fileName);
    rows.add(unit.toJson());
    await _db.writeList(_fileName, rows);
  }

  /// Update product unit
  Future<void> update(ProductUnit unit) async {
    final rows = await _db.readList(_fileName);
    final idx = rows.indexWhere((e) => e['id'] == unit.id);
    if (idx != -1) {
      rows[idx] = unit.toJson();
      await _db.writeList(_fileName, rows);
    }
  }

  /// Get stock statistics
  Future<Map<String, int>> getStatistics() async {
    final items = await list();
    return {
      'total': items.length,
      'in_stock': items.where((u) => u.status == ProductStatus.inStock).length,
      'sold': items.where((u) => u.status == ProductStatus.sold).length,
      'returned': items.where((u) => u.status == ProductStatus.returned).length,
    };
  }
}
