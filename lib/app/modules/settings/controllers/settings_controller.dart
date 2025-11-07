import 'package:get/get.dart';

/// Settings controller
class SettingsController extends GetxController {
  final isDarkMode = false.obs;
  final notificationsEnabled = true.obs;

  void toggleDarkMode(bool value) {
    isDarkMode.value = value;
  }

  void toggleNotifications(bool value) {
    notificationsEnabled.value = value;
  }
}
