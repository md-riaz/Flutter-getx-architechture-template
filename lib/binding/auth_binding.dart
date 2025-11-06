import 'package:get/get.dart';
import '../features/auth/controllers/auth_controller.dart';

/// Auth feature binding
class AuthBinding extends Bindings {
  @override
  void dependencies() {
    print('[AuthBinding] Setting up auth dependencies');
    
    // Only register if not already registered to avoid double initialization
    if (!Get.isRegistered<AuthController>()) {
      // Register AuthController with fenix: true for auto-recovery
      Get.lazyPut<AuthController>(
        () => AuthController(),
        fenix: true,
      );
    } else {
      print('[AuthBinding] AuthController already registered, skipping');
    }
  }
}
