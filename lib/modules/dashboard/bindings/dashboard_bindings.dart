import 'package:get/get.dart';
import '../../inventory/bindings/inventory_bindings.dart';
import '../controllers/dashboard_controller.dart';

class DashboardBindings extends Bindings {
  @override
  void dependencies() {
    // For now, init inventory as part of the session/example.
    InventoryBindings().dependencies();
    Get.put(DashboardController());
  }
}
