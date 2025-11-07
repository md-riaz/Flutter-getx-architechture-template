import 'package:get/get.dart';
import '../../../../core/services/json_db_service.dart';
import '../../../../data/models/brand.dart';

/// Brand repository
class BrandRepo {
  final JsonDbService _db;
  static const String _fileName = 'brands';

  BrandRepo(this._db);

  /// Get all brands with optional search
  Future<List<Brand>> list({String? query}) async {
    final raw = await _db.readList(_fileName);
    var items = raw
        .map((e) => Brand.fromJson(Map<String, dynamic>.from(e)))
        .toList();

    if (query != null && query.trim().isNotEmpty) {
      final q = query.toLowerCase();
      items = items.where((b) => b.name.toLowerCase().contains(q)).toList();
    }

    items.sort((a, b) => a.name.compareTo(b.name));
    return items;
  }

  /// Get brand by ID
  Future<Brand?> getById(String id) async {
    final items = await list();
    try {
      return items.firstWhere((b) => b.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Create or update brand
  Future<void> upsert(Brand brand) async {
    final rows = await _db.readList(_fileName);
    final idx = rows.indexWhere((e) => e['id'] == brand.id);
    
    if (idx == -1) {
      rows.add(brand.toJson());
    } else {
      rows[idx] = brand.toJson();
    }
    
    await _db.writeList(_fileName, rows);
  }

  /// Delete brand
  Future<void> remove(String id) async {
    final rows = await _db.readList(_fileName);
    rows.removeWhere((e) => e['id'] == id);
    await _db.writeList(_fileName, rows);
  }
}
