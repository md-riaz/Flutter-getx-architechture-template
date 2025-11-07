import 'package:get/get.dart';
import '../../../core/services/json_db_service.dart';
import '../controllers/purchases_controller.dart';
import '../repositories/purchases_repo.dart';

/// Purchases binding
class PurchasesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PurchasesRepo(Get.find<JsonDbService>()));
    Get.put(PurchasesController(Get.find()));
  }
}
