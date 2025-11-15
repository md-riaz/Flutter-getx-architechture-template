import 'package:get/get.dart';
import '../services/auth_service.dart';
import '../services/api_client.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(ApiClient(), permanent: true);
    Get.put(AuthService(), permanent: true);
  }
}
