import 'package:get/get.dart';
import '../../inventory/controllers/inventory_controller.dart';

enum Feature { inventory }

class DashboardController extends GetxController {
  final availableFeatures = <Feature>[].obs;

  @override
  void onInit() {
    super.onInit();
    _detectFeatures();
  }

  void _detectFeatures() {
    if (Get.isRegistered<InventoryController>(tag: 'session')) {
      availableFeatures.add(Feature.inventory);
    }
  }
}
