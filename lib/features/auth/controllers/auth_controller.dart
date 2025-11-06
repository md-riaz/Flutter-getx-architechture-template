import 'dart:async';
import 'dart:math';
import 'package:get/get.dart';
import '../../../base/base_controller.dart';
import '../services/auth_service.dart';

/// Authentication controller with random state via Timer
class AuthController extends BaseController {
  static const tag = 'AuthController';
  
  final AuthService _authService = Get.find<AuthService>();
  
  final emailController = RxString('');
  final passwordController = RxString('');
  final isLoading = RxBool(false);
  final randomState = RxInt(0);
  
  Timer? _stateTimer;
  final _random = Random();

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
    _stateTimer?.cancel();
    super.onClose();
  }

  /// Start timer to update random state periodically
  void _startRandomStateTimer() {
    _stateTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      randomState.value = _random.nextInt(100);
      print('[AuthController] Random state updated: ${randomState.value}');
    });
  }

  /// Handle login
  Future<void> login() async {
    if (emailController.value.isEmpty || passwordController.value.isEmpty) {
      Get.snackbar('Error', 'Please enter email and password');
      return;
    }

    isLoading.value = true;
    
    final success = await _authService.login(
      emailController.value,
      passwordController.value,
    );

    isLoading.value = false;

    if (success) {
      Get.offAllNamed('/home');
    } else {
      Get.snackbar('Error', 'Login failed');
    }
  }
}
