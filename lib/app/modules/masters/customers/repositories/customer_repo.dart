import 'package:get/get.dart';
import '../../../../core/services/json_db_service.dart';
import '../../../../data/models/customer.dart';

/// Customer repository
class CustomerRepo {
  final JsonDbService _db;
  static const String _fileName = 'customers';

  CustomerRepo(this._db);

  /// Get all customers with optional search
  Future<List<Customer>> list({String? query}) async {
    final raw = await _db.readList(_fileName);
    var items = raw
        .map((e) => Customer.fromJson(Map<String, dynamic>.from(e)))
        .toList();

    if (query != null && query.trim().isNotEmpty) {
      final q = query.toLowerCase();
      items = items.where((c) {
        return c.name.toLowerCase().contains(q) ||
            (c.phone?.toLowerCase().contains(q) ?? false) ||
            (c.email?.toLowerCase().contains(q) ?? false) ||
            (c.gst?.toLowerCase().contains(q) ?? false);
      }).toList();
    }

    items.sort((a, b) => a.name.compareTo(b.name));
    return items;
  }

  /// Get customer by ID
  Future<Customer?> getById(String id) async {
    final items = await list();
    try {
      return items.firstWhere((c) => c.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Create or update customer
  Future<void> upsert(Customer customer) async {
    final rows = await _db.readList(_fileName);
    final idx = rows.indexWhere((e) => e['id'] == customer.id);
    
    if (idx == -1) {
      rows.add(customer.toJson());
    } else {
      rows[idx] = customer.toJson();
    }
    
    await _db.writeList(_fileName, rows);
  }

  /// Delete customer
  Future<void> remove(String id) async {
    final rows = await _db.readList(_fileName);
    rows.removeWhere((e) => e['id'] == id);
    await _db.writeList(_fileName, rows);
  }
}
