import 'package:get/get.dart';
import '../data/dto/inventory_request.dart';
import '../data/models/inventory_item.dart';
import '../data/repositories/inventory_repository.dart';

class InventoryService extends GetxService {
  final InventoryRepository repo;

  InventoryService(this.repo);

  Future<List<InventoryItem>> getItemsForWarehouse(String warehouseId) {
    return repo.fetchItems(InventoryRequest(warehouseId: warehouseId));
  }
}
