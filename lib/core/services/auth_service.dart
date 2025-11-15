import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import '../data/models/user_model.dart';
import '../data/repositories/auth_repository.dart';
import './session_manager.dart';
import '../routes/app_routes.dart';

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
      
      return true;
    } catch (e) {
      print('Login error: $e');
      return false;
    } finally {
      _isLoading.value = false;
    }
  }

  /// Logout and cleanup session
  void logout() {
    print("AuthService: Logout initiated.");

    // Call the logout API in background (don't await)
    if (_currentUser.value?.token != null) {
      _authRepository.logout(_currentUser.value!.token).catchError((e) {
        print('Logout API error: $e');
      });
    }

    // Schedule the deletion to happen after the current frame.
    // This ensures the navigation has started and the old view is being disposed,
    // preventing it from trying to access a deleted controller.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print("AuthService: Frame complete. Deleting all session dependencies.");
      _sessionManager.clearSession();
    });

    // Clear user state immediately
    _currentUser.value = null;

    // Navigate away immediately. This is the most important step.
    // Get.offAllNamed will pop the current view and start the transition.
    Get.offAllNamed(Routes.login);
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
