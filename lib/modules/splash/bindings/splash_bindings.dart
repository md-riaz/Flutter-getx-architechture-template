import 'package:get/get.dart';
import '../controllers/splash_controller.dart';

/// Route-level bindings for Splash screen
class SplashBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SplashController>(() => SplashController());
  }
}
