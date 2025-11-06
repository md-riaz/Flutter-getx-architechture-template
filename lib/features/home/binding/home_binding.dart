import 'package:get/get.dart';
import '../controllers/home_controller.dart';

/// Home feature binding
class HomeBinding extends Bindings {
  @override
  void dependencies() {
    print('[HomeBinding] Setting up home dependencies');
    
    // Register HomeController with fenix: true for auto-recovery
    // Skip registration if already prepared to avoid "already registered" error
    if (!Get.isRegistered<HomeController>()) {
      Get.lazyPut<HomeController>(
        () => HomeController(),
        fenix: true,
      );
    } else {
      print('[HomeBinding] HomeController already registered, skipping');
    }
  }
}
