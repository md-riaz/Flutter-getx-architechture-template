import 'package:get/get.dart';
import '../controllers/home_controller.dart';

/// Home feature binding
class HomeBinding extends Bindings {
  @override
  void dependencies() {
    print('[HomeBinding] Setting up home dependencies');
    
    // Register HomeController - factory will be cleared on logout
    Get.lazyPut<HomeController>(
      () => HomeController(),
    );
  }
}
