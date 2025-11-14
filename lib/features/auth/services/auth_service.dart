import 'package:get/get.dart';
import '../../../domain/auth/entities/user.dart';
import '../../../domain/auth/usecases/get_current_user_use_case.dart';
import '../../../domain/auth/usecases/login_use_case.dart';
import '../../../domain/auth/usecases/logout_use_case.dart';

class AuthService extends GetxService {
  final LoginUseCase _loginUseCase;
  final LogoutUseCase _logoutUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final _currentUser = Rxn<User>();

  AuthService({
    required LoginUseCase loginUseCase,
    required LogoutUseCase logoutUseCase,
    required GetCurrentUserUseCase getCurrentUserUseCase,
  })  : _loginUseCase = loginUseCase,
        _logoutUseCase = logoutUseCase,
        _getCurrentUserUseCase = getCurrentUserUseCase;

  User? get currentUser => _currentUser.value;
  bool get isAuthenticated => _currentUser.value != null;

  @override
  void onInit() {
    super.onInit();
    _currentUser.value = _getCurrentUserUseCase();
  }

  Future<User> login(String email, String password) async {
    final user = await _loginUseCase(
      LoginParams(email: email, password: password),
    );
    _currentUser.value = user;
    return user;
  }

  Future<void> logout() async {
    await _logoutUseCase();
    _currentUser.value = null;
  }

  void updateCachedUser(User? user) {
    _currentUser.value = user;
  }
}
