import 'package:get/get.dart';
import '../../../../core/services/json_db_service.dart';
import '../../../../data/models/vendor.dart';

/// Vendor repository
/// Handles CRUD operations for vendors using JSON database
class VendorRepo {
  final JsonDbService _db;
  static const String _fileName = 'vendors';

  VendorRepo(this._db);

  /// Get all vendors with optional search query
  Future<List<Vendor>> list({String? query}) async {
    final raw = await _db.readList(_fileName);
    var items = raw
        .map((e) => Vendor.fromJson(Map<String, dynamic>.from(e)))
        .toList();

    // Apply search filter
    if (query != null && query.trim().isNotEmpty) {
      final q = query.toLowerCase();
      items = items.where((v) {
        return v.name.toLowerCase().contains(q) ||
            (v.gst?.toLowerCase().contains(q) ?? false) ||
            (v.phone?.toLowerCase().contains(q) ?? false) ||
            (v.email?.toLowerCase().contains(q) ?? false);
      }).toList();
    }

    // Sort by name
    items.sort((a, b) => a.name.compareTo(b.name));
    return items;
  }

  /// Get vendor by ID
  Future<Vendor?> getById(String id) async {
    final items = await list();
    try {
      return items.firstWhere((v) => v.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Create or update vendor
  Future<void> upsert(Vendor vendor) async {
    final rows = await _db.readList(_fileName);
    final idx = rows.indexWhere((e) => e['id'] == vendor.id);
    
    if (idx == -1) {
      // Create new
      rows.add(vendor.toJson());
    } else {
      // Update existing
      rows[idx] = vendor.toJson();
    }
    
    await _db.writeList(_fileName, rows);
  }

  /// Delete vendor by ID
  Future<void> remove(String id) async {
    final rows = await _db.readList(_fileName);
    rows.removeWhere((e) => e['id'] == id);
    await _db.writeList(_fileName, rows);
  }
}
