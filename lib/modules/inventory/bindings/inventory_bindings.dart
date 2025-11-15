import 'package:get/get.dart';
import '../../../core/services/api_client.dart';
import '../controllers/inventory_controller.dart';
import '../data/repositories/inventory_repository.dart';
import '../services/inventory_service.dart';

class InventoryBindings extends Bindings {
  static const String sessionTag = 'session';

  @override
  void dependencies() {
    Get.lazyPut<InventoryRepository>(
      () => InventoryRepository(Get.find<ApiClient>()),
      tag: sessionTag,
    );
    Get.lazyPut<InventoryService>(
      () => InventoryService(Get.find<InventoryRepository>(tag: sessionTag)),
      tag: sessionTag,
    );
    Get.lazyPut<InventoryController>(
      () => InventoryController(Get.find<InventoryService>(tag: sessionTag)),
      tag: sessionTag,
    );
  }
}
