import 'package:get/get.dart';
import '../features/auth/controllers/auth_controller.dart';

/// Auth feature binding
class AuthBinding extends Bindings {
  @override
  void dependencies() {
    print('[AuthBinding] Setting up auth dependencies');
    
    // Register AuthController with fenix: true for auto-recovery
    Get.lazyPut<AuthController>(
      () => AuthController(),
      fenix: true,
      tag: AuthController.tag,
    );
  }
}
