import 'package:get/get.dart';
import '../controllers/login_controller.dart';

/// Route-level bindings for Login screen
class LoginBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(() => LoginController());
  }
}
