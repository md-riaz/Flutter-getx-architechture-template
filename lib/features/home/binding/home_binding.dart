import 'package:get/get.dart';
import '../controllers/home_controller.dart';

/// Home feature binding
class HomeBinding extends Bindings {
  @override
  void dependencies() {
    print('[HomeBinding] Setting up home dependencies');
    
    // Register HomeController with fenix: true for auto-recovery
    Get.lazyPut<HomeController>(
      () => HomeController(),
      fenix: true,
    );
  }
}
