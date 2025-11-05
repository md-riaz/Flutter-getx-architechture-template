import 'package:get/get.dart';

/// Base controller for all GetX controllers in the app
/// Implements fenix: true and provides lifecycle debug prints
abstract class BaseController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    print('[${runtimeType}] onInit called');
  }

  @override
  void onReady() {
    super.onReady();
    print('[${runtimeType}] onReady called');
  }

  @override
  void onClose() {
    print('[${runtimeType}] onClose called');
    super.onClose();
  }
}
