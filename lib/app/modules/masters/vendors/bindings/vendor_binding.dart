import 'package:get/get.dart';
import '../../../../core/services/json_db_service.dart';
import '../controllers/vendor_controller.dart';
import '../repositories/vendor_repo.dart';

/// Vendor binding
/// Manages dependency injection for vendor module
class VendorBinding extends Bindings {
  @override
  void dependencies() {
    // Repository
    Get.lazyPut(() => VendorRepo(Get.find<JsonDbService>()));
    
    // Controller
    Get.put(VendorController(Get.find()));
  }
}
