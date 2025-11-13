import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// App-wide snackbar utilities, not tied to any controller.
/// Uses Get.rawSnackbar with instantInit:false so it waits for the
/// overlay to be ready and avoids "No Overlay widget" errors.
class AppSnackBar {
  AppSnackBar._();

  static void info(String message, {String? title, Duration duration = const Duration(seconds: 3)}) {
    _show(title: title, message: message, duration: duration);
  }

  static void success(String message, {String? title, Duration duration = const Duration(seconds: 3)}) {
    _show(
      title: title,
      message: message,
      duration: duration,
      backgroundColor: Colors.green.shade600,
      icon: const Icon(Icons.check_circle, color: Colors.white),
    );
  }

  static void error(String message, {String? title, Duration duration = const Duration(seconds: 3)}) {
    _show(
      title: title,
      message: message,
      duration: duration,
      backgroundColor: Colors.red.shade700,
      icon: const Icon(Icons.error_outline, color: Colors.white),
    );
  }

  static void _show({
    String? title,
    required String message,
    Duration duration = const Duration(seconds: 3),
    SnackPosition position = SnackPosition.BOTTOM,
    Color? backgroundColor,
    Widget? icon,
  }) {
    // Prefer the familiar Get.snackbar API; instantInit:false defers until overlay is ready.
    Get.snackbar(
      title ?? '',
      message,
      duration: duration,
      snackPosition: position,
      instantInit: false,
      backgroundColor: backgroundColor ?? Get.theme.snackBarTheme.backgroundColor ?? Colors.black87,
      icon: icon,
      margin: const EdgeInsets.all(12),
      borderRadius: 8,
      snackStyle: SnackStyle.FLOATING,
      colorText: Colors.white,
    );
  }
}
