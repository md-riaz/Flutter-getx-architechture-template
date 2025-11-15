import 'package:get/get.dart';
import '../data/models/user_model.dart';
import '../data/repositories/auth_repository.dart';
import './session_manager.dart';

class AuthService extends GetxService {
  final AuthRepository _authRepository;
  final SessionManager _sessionManager;

  final Rx<User?> _currentUser = Rx<User?>(null);
  final _isLoading = false.obs;

  AuthService(this._authRepository, this._sessionManager);

  bool get isLoggedIn => _currentUser.value != null;
  User? get currentUser => _currentUser.value;
  UserPermissions? get permissions => _currentUser.value?.permissions;
  bool get isLoading => _isLoading.value;

  /// Login with email and password
  Future<bool> login(String email, String password) async {
    try {
      _isLoading.value = true;
      final user = await _authRepository.login(email, password);
      _currentUser.value = user;
      
      // Initialize session-level bindings after successful login
      _sessionManager.initializeSession();
      
      return true;
    } catch (e) {
      print('Login error: $e');
      return false;
    } finally {
      _isLoading.value = false;
    }
  }

  /// Logout and cleanup session
  Future<void> logout() async {
    try {
      _isLoading.value = true;
      
      if (_currentUser.value?.token != null) {
        await _authRepository.logout(_currentUser.value!.token);
      }
      
      // Clear session-level bindings
      _sessionManager.clearSession();
      
      // Clear user state
      _currentUser.value = null;
    } catch (e) {
      print('Logout error: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  /// Validate current session
  Future<bool> validateSession() async {
    if (_currentUser.value?.token == null) return false;
    
    try {
      return await _authRepository.validateToken(_currentUser.value!.token);
    } catch (e) {
      print('Session validation error: $e');
      return false;
    }
  }

  /// Legacy method for backward compatibility
  Future<void> fakeLogin() async {
    await login('demo@example.com', 'password');
  }
}
