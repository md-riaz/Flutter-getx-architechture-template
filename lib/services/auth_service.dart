import 'package:get/get.dart';
import '../features/auth/models/user.dart';
import '../features/auth/repositories/auth_repository.dart';
import './feature_registry_service.dart';

/// Authentication service (permanent via bindings)
class AuthService extends GetxService {
  final AuthRepository _authRepository = AuthRepository();
  final _currentUser = Rxn<User>();

  User? get currentUser => _currentUser.value;
  bool get isAuthenticated => _currentUser.value != null;

  @override
  void onInit() {
    super.onInit();
    print('[AuthService] onInit called');
  }

  /// Login user
  Future<bool> login(String email, String password) async {
    try {
      print('[AuthService] Attempting login for: $email');
      
      // Validate credentials
      final isValid = await _authRepository.validate(email, password);
      if (!isValid) {
        print('[AuthService] Invalid credentials');
        return false;
      }

      // Login and get user
      final user = await _authRepository.login(email, password);
      _currentUser.value = user;
      
      // Create feature bindings on login
      final featureRegistry = Get.find<FeatureRegistryService>();
      featureRegistry.createFeatureBindings();
      
      print('[AuthService] Login successful for: ${user.email}');
      return true;
    } catch (e) {
      print('[AuthService] Login error: $e');
      return false;
    }
  }

  /// Logout user
  Future<void> logout() async {
    try {
      print('[AuthService] Logging out');
      
      // Delete feature bindings on logout
      final featureRegistry = Get.find<FeatureRegistryService>();
      featureRegistry.deleteFeatureBindings();
      
      await _authRepository.logout();
      _currentUser.value = null;
      
      print('[AuthService] Logout successful');
    } catch (e) {
      print('[AuthService] Logout error: $e');
    }
  }
}
