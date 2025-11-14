import 'package:get/get.dart';
import '../../../base/base_controller.dart';
import '../../../domain/auth/entities/user.dart';
import '../../../domain/auth/usecases/get_current_user_use_case.dart';
import '../../../domain/auth/usecases/login_use_case.dart';
import '../../../domain/auth/usecases/logout_use_case.dart';
import '../services/auth_service.dart';

class AuthController extends BaseController {
  static const tag = 'AuthController';

  @override
  String get controllerName => tag;

  final LoginUseCase _loginUseCase;
  final LogoutUseCase _logoutUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final AuthService _authService;

  final email = ''.obs;
  final password = ''.obs;
  final isLoading = false.obs;
  final errorMessage = RxnString();
  final user = Rxn<User>();

  AuthController({
    required LoginUseCase loginUseCase,
    required LogoutUseCase logoutUseCase,
    required GetCurrentUserUseCase getCurrentUserUseCase,
    required AuthService authService,
  })  : _loginUseCase = loginUseCase,
        _logoutUseCase = logoutUseCase,
        _getCurrentUserUseCase = getCurrentUserUseCase,
        _authService = authService;

  @override
  void onInit() {
    super.onInit();
    user.value = _getCurrentUserUseCase();
  }

  Future<bool> login() async {
    if (email.value.isEmpty || password.value.isEmpty) {
      errorMessage.value = 'Please enter email and password';
      return false;
    }

    isLoading.value = true;
    errorMessage.value = null;

    try {
      final sanitizedEmail = email.value.trim().toLowerCase();
      final sanitizedPassword = password.value.trim();

      final result = await _loginUseCase(
        LoginParams(email: sanitizedEmail, password: sanitizedPassword),
      );
      user.value = result;
      _authService.updateCachedUser(result);
      return true;
    } on LoginValidationException catch (error) {
      errorMessage.value = error.message;
      return false;
    } catch (error) {
      errorMessage.value = 'Login failed. Please try again.';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> logout() async {
    try {
      await _logoutUseCase();
      _authService.updateCachedUser(null);
      user.value = null;
      return true;
    } catch (_) {
      errorMessage.value = 'Logout failed. Please try again.';
      return false;
    }
  }
}
