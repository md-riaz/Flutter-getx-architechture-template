import 'package:get/get.dart';
import '../features/home/controllers/home_controller.dart';

/// Home feature binding
class HomeBinding extends Bindings {
  @override
  void dependencies() {
    print('[HomeBinding] Setting up home dependencies');
    
    // Only register if not already registered to avoid double initialization
    if (!Get.isRegistered<HomeController>()) {
      // Register HomeController with fenix: true for auto-recovery
      Get.lazyPut<HomeController>(
        () => HomeController(),
        fenix: true,
      );
    } else {
      print('[HomeBinding] HomeController already registered, skipping');
    }
  }
}
