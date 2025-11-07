import 'package:get/get.dart';
import '../../../core/services/json_db_service.dart';
import '../controllers/sales_controller.dart';
import '../repositories/sales_repo.dart';

/// Sales binding
class SalesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SalesRepo(Get.find<JsonDbService>()));
    Get.put(SalesController(Get.find()));
  }
}
