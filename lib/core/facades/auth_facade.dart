import 'package:get/get.dart';
import '../services/auth_service.dart';

class Auth {
  Auth._();

  static AuthService get _service => Get.find<AuthService>();

  static bool get isLoggedIn => _service.isLoggedIn;

  static Future<bool> login(String email, String password) {
    return _service.login(email, password);
  }

  static Future<void> logout() {
    return _service.logout();
  }

  static Future<bool> restore() {
    return _service.restoreSession();
  }
}
