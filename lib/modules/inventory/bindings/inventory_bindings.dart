import 'package:get/get.dart';

import '../../../core/services/api_client.dart';
import '../../../core/services/session_manager.dart';
import '../controllers/inventory_controller.dart';
import '../data/repositories/inventory_repository.dart';
import '../services/inventory_service.dart';

class InventoryBindings extends Bindings {
  static const String sessionTag = SessionManager.sessionTag;

  @override
  void dependencies() {
    Get.put<InventoryRepository>(
      InventoryRepository(Get.find<ApiClient>()),
      tag: sessionTag,
    );
    Get.put<InventoryService>(
      InventoryService(Get.find<InventoryRepository>(tag: sessionTag)),
      tag: sessionTag,
    );
    Get.put<InventoryController>(
      InventoryController(Get.find<InventoryService>(tag: sessionTag)),
      tag: sessionTag,
    );

    // Register cleanup so SessionManager can properly dispose these on logout
    final sessionManager = Get.find<SessionManager>();
    sessionManager.registerCleanup(() {
      Get.delete<InventoryController>(tag: sessionTag, force: true);
      Get.delete<InventoryService>(tag: sessionTag, force: true);
      Get.delete<InventoryRepository>(tag: sessionTag, force: true);
    });
  }
}
