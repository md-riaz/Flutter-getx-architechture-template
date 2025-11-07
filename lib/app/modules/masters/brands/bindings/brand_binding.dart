import 'package:get/get.dart';
import '../../../../core/services/json_db_service.dart';
import '../controllers/brand_controller.dart';
import '../repositories/brand_repo.dart';

/// Brand binding
class BrandBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => BrandRepo(Get.find<JsonDbService>()));
    Get.put(BrandController(Get.find()));
  }
}
