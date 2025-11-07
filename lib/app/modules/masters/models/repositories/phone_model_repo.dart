import 'package:get/get.dart';
import '../../../../core/services/json_db_service.dart';
import '../../../../data/models/phone_model.dart';

/// Phone model repository
class PhoneModelRepo {
  final JsonDbService _db;
  static const String _fileName = 'models';

  PhoneModelRepo(this._db);

  /// Get all phone models with optional search and brand filter
  Future<List<PhoneModel>> list({String? query, String? brandId}) async {
    final raw = await _db.readList(_fileName);
    var items = raw
        .map((e) => PhoneModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();

    // Apply brand filter
    if (brandId != null && brandId.trim().isNotEmpty) {
      items = items.where((m) => m.brandId == brandId).toList();
    }

    // Apply search filter
    if (query != null && query.trim().isNotEmpty) {
      final q = query.toLowerCase();
      items = items.where((m) => m.name.toLowerCase().contains(q)).toList();
    }

    items.sort((a, b) => a.name.compareTo(b.name));
    return items;
  }

  /// Get model by ID
  Future<PhoneModel?> getById(String id) async {
    final items = await list();
    try {
      return items.firstWhere((m) => m.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Create or update phone model
  Future<void> upsert(PhoneModel model) async {
    final rows = await _db.readList(_fileName);
    final idx = rows.indexWhere((e) => e['id'] == model.id);
    
    if (idx == -1) {
      rows.add(model.toJson());
    } else {
      rows[idx] = model.toJson();
    }
    
    await _db.writeList(_fileName, rows);
  }

  /// Delete phone model
  Future<void> remove(String id) async {
    final rows = await _db.readList(_fileName);
    rows.removeWhere((e) => e['id'] == id);
    await _db.writeList(_fileName, rows);
  }
}
