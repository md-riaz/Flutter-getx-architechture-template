import 'package:get/get.dart';
import '../../../../core/services/json_db_service.dart';
import '../controllers/customer_controller.dart';
import '../repositories/customer_repo.dart';

/// Customer binding
class CustomerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CustomerRepo(Get.find<JsonDbService>()));
    Get.put(CustomerController(Get.find()));
  }
}
