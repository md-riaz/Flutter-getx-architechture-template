import 'package:get/get.dart';
import '../../../core/services/json_db_service.dart';
import '../controllers/stock_controller.dart';
import '../repositories/stock_repo.dart';

/// Stock binding
class StockBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => StockRepo(Get.find<JsonDbService>()));
    Get.put(StockController(Get.find()));
  }
}
