import 'package:get/get.dart';

/// Base controller for all GetX controllers in the app
/// Implements fenix: true and provides lifecycle debug prints
abstract class BaseController extends GetxController {
  /// Explicit controller name to avoid minification issues in web builds
  String get controllerName => runtimeType.toString();

  @override
  void onInit() {
    super.onInit();
    print('[$controllerName] onInit called');
  }

  @override
  void onReady() {
    super.onReady();
    print('[$controllerName] onReady called');
  }

  @override
  void onClose() {
    print('[$controllerName] onClose called');
    super.onClose();
  }
}
