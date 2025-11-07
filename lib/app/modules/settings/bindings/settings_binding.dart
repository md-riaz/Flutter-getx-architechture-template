import 'package:get/get.dart';
import '../controllers/settings_controller.dart';

/// Settings binding
class SettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SettingsController());
  }
}
