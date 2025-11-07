import 'package:get/get.dart';
import '../../../../core/services/json_db_service.dart';
import '../controllers/phone_model_controller.dart';
import '../repositories/phone_model_repo.dart';

/// Phone model binding
class PhoneModelBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PhoneModelRepo(Get.find<JsonDbService>()));
    Get.put(PhoneModelController(Get.find()));
  }
}
