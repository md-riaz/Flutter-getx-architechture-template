import '../../../../core/services/api_client.dart';
import '../dto/inventory_request.dart';
import '../models/inventory_item.dart';

class InventoryRepository {
  final ApiClient api;

  InventoryRepository(this.api);

  Future<List<InventoryItem>> fetchItems(InventoryRequest req) async {
    final raw = await api.getInventoryItems(req.toJson());
    return raw.map((e) => InventoryItem.fromJson(e)).toList();
  }
}
