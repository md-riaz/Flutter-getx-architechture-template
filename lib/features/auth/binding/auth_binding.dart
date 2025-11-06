import 'package:get/get.dart';
import '../controllers/auth_controller.dart';

/// Auth feature binding
class AuthBinding extends Bindings {
  @override
  void dependencies() {
    print('[AuthBinding] Setting up auth dependencies');
    
    // Register AuthController - factory will be cleared on logout
    Get.lazyPut<AuthController>(
      () => AuthController(),
    );
  }
}
