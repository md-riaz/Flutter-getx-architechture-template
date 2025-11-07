import 'package:get/get.dart';
import '../../../core/services/json_db_service.dart';
import '../controllers/reports_controller.dart';
import '../repositories/reports_repo.dart';

/// Reports binding
class ReportsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ReportsRepo(Get.find<JsonDbService>()));
    Get.put(ReportsController(Get.find()));
  }
}
