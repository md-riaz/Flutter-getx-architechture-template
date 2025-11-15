import 'package:get/get.dart';
import '../services/theme_service.dart';

class ThemeBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<ThemeService>()) {
      Get.put<ThemeService>(ThemeService(), permanent: true);
    }
  }
}
