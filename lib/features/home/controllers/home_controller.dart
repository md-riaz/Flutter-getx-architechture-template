import 'dart:async';
import 'dart:math';
import 'package:get/get.dart';
import '../../../base/base_controller.dart';
import '../../auth/services/auth_service.dart';

/// Home controller with random state via Timer
class HomeController extends BaseController {
  static const tag = 'HomeController';
  
  @override
  String get controllerName => tag;
  
  final AuthService _authService;
  
  final randomState = RxInt(0);
  final counter = RxInt(0);
  
  Timer? _stateTimer;
  final _random = Random();
  bool _isDisposed = false;

  HomeController({AuthService? authService})
      : _authService = authService ?? Get.find<AuthService>();

  @override
  void onInit() {
    super.onInit();
    _startRandomStateTimer();
  }

  @override
  void onReady() {
    super.onReady();
    print('[HomeController] Ready to display home screen');
  }

  @override
  void onClose() {
    _isDisposed = true;
    _stateTimer?.cancel();
    _stateTimer = null;
    super.onClose();
  }

  /// Start timer to update random state periodically
  void _startRandomStateTimer() {
    _stateTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      // Exit early if controller is being disposed or closed
      if (_isDisposed || isClosed) {
        timer.cancel();
        return;
      }
      
      try {
        randomState.value = _random.nextInt(100);
        print('[HomeController] Random state updated: ${randomState.value}');
      } catch (e) {
        print('[HomeController] Error updating random state: $e');
        timer.cancel();
      }
    });
  }

  /// Increment counter
  void incrementCounter() {
    counter.value++;
    print('[HomeController] Counter incremented: ${counter.value}');
  }

  /// Handle logout
  Future<void> logout() async {
    await _authService.logout();
    // Don't navigate in test mode
    if (!Get.testMode && Get.overlayContext != null) {
      Get.offAllNamed('/login');
    }
  }

  /// Get user email
  String getUserEmail() {
    return _authService.currentUser?.email ?? 'Unknown';
  }
}
