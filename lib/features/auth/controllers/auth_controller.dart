import 'dart:async';
import 'dart:math';
import 'package:get/get.dart';
import '../../../base/base_controller.dart';
import '../services/auth_service.dart';
import '../../../util/snackbar.dart';

/// Authentication controller with random state via Timer
class AuthController extends BaseController {
  static const tag = 'AuthController';
  
  @override
  String get controllerName => tag;
  
  final AuthService _authService;
  
  final emailController = RxString('');
  final passwordController = RxString('');
  final isLoading = RxBool(false);
  final randomState = RxInt(0);
  
  Timer? _stateTimer;
  final _random = Random();
  bool _isDisposed = false;

  AuthController({AuthService? authService})
      : _authService = authService ?? Get.find<AuthService>();

  @override
  void onInit() {
    super.onInit();
    _startRandomStateTimer();
  }

  @override
  void onReady() {
    super.onReady();
    print('[AuthController] Ready to handle authentication');
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
    _stateTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      // Exit early if controller is being disposed or closed
      if (_isDisposed || isClosed) {
        timer.cancel();
        return;
      }
      
      try {
        randomState.value = _random.nextInt(100);
        print('[AuthController] Random state updated: ${randomState.value}');
      } catch (e) {
        print('[AuthController] Error updating random state: $e');
        timer.cancel();
      }
    });
  }

  /// Handle login
  Future<void> login() async {
    if (emailController.value.isEmpty || passwordController.value.isEmpty) {
      AppSnackBar.error('Please enter email and password', title: 'Error');
      return;
    }

    isLoading.value = true;
    
    final success = await _authService.login(
      emailController.value,
      passwordController.value,
    );

    isLoading.value = false;

    if (success) {
      // Don't navigate in test mode
      if (!Get.testMode) {
        // Add small delay to ensure overlay context is available before navigation
        await Future.delayed(const Duration(milliseconds: 100));
        if (Get.currentRoute == '/login' && Get.overlayContext != null) {
          Get.offAllNamed('/home');
        }
      }
    } else {
      AppSnackBar.error('Login failed', title: 'Error');
    }
  }

  /// Handle logout
  Future<void> logout() async {
    await _authService.logout();
    // Don't navigate in test mode
    if (!Get.testMode) {
      // Add small delay to ensure clean navigation
      await Future.delayed(const Duration(milliseconds: 100));
      if (Get.currentRoute != '/login' && Get.overlayContext != null) {
        Get.offAllNamed('/login');
      }
    }
  }
}
