import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Service to manage theme state (light/dark mode)
class ThemeService extends GetxService {
  final _isDarkMode = RxBool(false);

  bool get isDarkMode => _isDarkMode.value;
  ThemeMode get themeMode => _isDarkMode.value ? ThemeMode.dark : ThemeMode.light;

  @override
  void onInit() {
    super.onInit();
    print('[ThemeService] onInit called');
    // Initialize with system theme
    _isDarkMode.value = Get.isDarkMode;
  }

  /// Toggle between light and dark theme
  void toggleTheme() {
    _isDarkMode.value = !_isDarkMode.value;
    Get.changeThemeMode(themeMode);
    print('[ThemeService] Theme toggled to: ${_isDarkMode.value ? "Dark" : "Light"}');
  }

  /// Set theme explicitly
  void setTheme(bool isDark) {
    _isDarkMode.value = isDark;
    Get.changeThemeMode(themeMode);
    print('[ThemeService] Theme set to: ${isDark ? "Dark" : "Light"}');
  }

  /// Set to light theme
  void setLightTheme() {
    setTheme(false);
  }

  /// Set to dark theme
  void setDarkTheme() {
    setTheme(true);
  }
}
