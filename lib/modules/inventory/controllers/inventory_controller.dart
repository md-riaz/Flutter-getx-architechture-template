import 'package:get/get.dart';

import '../data/models/inventory_item.dart';
import '../services/inventory_service.dart';

class InventoryController extends GetxController {
  static const String sessionTag = 'session';

  final InventoryService service;

  InventoryController(this.service);

  final items = <InventoryItem>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadItems();
  }

  Future<void> loadItems() async {
    isLoading.value = true;
    try {
      final data = await service.getItemsForWarehouse('default-warehouse');
      items.assignAll(data);
    } finally {
      isLoading.value = false;
    }
  }
}
