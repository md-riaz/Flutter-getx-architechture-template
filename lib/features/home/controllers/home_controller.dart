import 'package:get/get.dart';
import '../../../base/base_controller.dart';
import '../../../domain/auth/entities/user.dart';
import '../../../domain/auth/usecases/get_current_user_use_case.dart';
import '../../../domain/auth/usecases/logout_use_case.dart';
import '../../auth/services/auth_service.dart';

class HomeController extends BaseController {
  static const tag = 'HomeController';

  @override
  String get controllerName => tag;

  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final LogoutUseCase _logoutUseCase;
  final AuthService _authService;

  final user = Rxn<User>();
  final isProcessing = false.obs;
  final errorMessage = RxnString();

  HomeController({
    required GetCurrentUserUseCase getCurrentUserUseCase,
    required LogoutUseCase logoutUseCase,
    required AuthService authService,
  })  : _getCurrentUserUseCase = getCurrentUserUseCase,
        _logoutUseCase = logoutUseCase,
        _authService = authService;

  @override
  void onInit() {
    super.onInit();
    user.value = _getCurrentUserUseCase();
  }

  Future<bool> logout() async {
    isProcessing.value = true;
    errorMessage.value = null;
    try {
      await _logoutUseCase();
      _authService.updateCachedUser(null);
      user.value = null;
      return true;
    } catch (_) {
      errorMessage.value = 'Unable to logout. Please try again.';
      return false;
    } finally {
      isProcessing.value = false;
    }
  }
}
