import 'package:get/get.dart';
import '../controllers/auth_controller.dart';

/// Auth feature binding
class AuthBinding extends Bindings {
  @override
  void dependencies() {
    print('[AuthBinding] Setting up auth dependencies');
    
    // Register AuthController with fenix: true for auto-recovery
    // Skip registration if already prepared to avoid "already registered" error
    if (!Get.isRegistered<AuthController>()) {
      Get.lazyPut<AuthController>(
        () => AuthController(),
        fenix: true,
      );
    } else {
      print('[AuthBinding] AuthController already registered, skipping');
    }
  }
}
