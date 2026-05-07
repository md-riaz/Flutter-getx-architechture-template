import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../data/models/user_model.dart';
import '../data/repositories/auth_repository.dart';
import '../interfaces/storage_interface.dart';
import '../routes/app_routes.dart';
import './session_manager.dart';

class AuthService extends GetxService {
  final AuthRepository _authRepository;
  final SessionManager _sessionManager;
  final IStorageService? _storageService;

  final Rx<User?> _currentUser = Rx<User?>(null);
  final _isLoading = false.obs;

  // Storage keys
  static const String _tokenKey = 'auth_token';
  static const String _userIdKey = 'auth_user_id';
  static const String _userEmailKey = 'auth_user_email';
  static const String _userNameKey = 'auth_user_name';

  /// [storageService] is optional: when omitted (e.g. in unit tests) token
  /// persistence is skipped without affecting other behaviour.
  AuthService(
    this._authRepository,
    this._sessionManager, [
    this._storageService,
  ]);

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

      // Persist the session token so it can be restored after an app restart
      await _persistSession(user);

      return true;
    } catch (e) {
      debugPrint('AuthService.login error: $e');
      return false;
    } finally {
      _isLoading.value = false;
    }
  }

  /// Attempt to restore a previously persisted session.
  ///
  /// Returns true if a valid stored token was found and the session was
  /// restored. Returns false if there is no token or the token is invalid.
  Future<bool> restoreSession() async {
    if (_storageService == null) return false;

    final token = await _storageService!.getString(_tokenKey);
    if (token == null || token.isEmpty) return false;

    try {
      final isValid = await _authRepository.validateToken(token);
      if (!isValid) {
        await _clearPersistedSession();
        return false;
      }

      // Re-hydrate the in-memory user from stored profile data
      final id = await _storageService!.getString(_userIdKey) ?? '';
      final email = await _storageService!.getString(_userEmailKey) ?? '';
      final name = await _storageService!.getString(_userNameKey) ?? '';

      _currentUser.value = User(
        id: id,
        email: email,
        name: name,
        token: token,
        permissions: UserPermissions(inventoryAccess: true),
      );
      return true;
    } catch (e) {
      debugPrint('AuthService.restoreSession error: $e');
      return false;
    }
  }

  /// Logout and cleanup session
  void logout() {
    debugPrint("AuthService: Logout initiated.");

    // Call the logout API in background (don't await)
    if (_currentUser.value?.token != null) {
      _authRepository.logout(_currentUser.value!.token).catchError((e) {
        debugPrint('AuthService.logout API error: $e');
      });
    }

    // Schedule the deletion to happen after the current frame.
    // This ensures the navigation has started and the old view is being disposed,
    // preventing it from trying to access a deleted controller.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      debugPrint(
          "AuthService: Frame complete. Deleting all session dependencies.");
      _sessionManager.clearSession();

      // Show logout success snackbar after frame is complete
      Get.snackbar(
        'Success',
        'Logout successful',
        snackPosition: SnackPosition.BOTTOM,
      );
    });

    // Clear user state and persisted token immediately
    _currentUser.value = null;
    _clearPersistedSession();

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
      debugPrint('AuthService.validateSession error: $e');
      return false;
    }
  }

  /// Legacy method for backward compatibility
  Future<void> fakeLogin() async {
    await login('demo@example.com', 'password');
  }

  // ──────────────────────────────────────────────
  // Private helpers
  // ──────────────────────────────────────────────

  Future<void> _persistSession(User user) async {
    if (_storageService == null) return;
    await _storageService!.setString(_tokenKey, user.token);
    await _storageService!.setString(_userIdKey, user.id);
    await _storageService!.setString(_userEmailKey, user.email);
    await _storageService!.setString(_userNameKey, user.name);
  }

  Future<void> _clearPersistedSession() async {
    if (_storageService == null) return;
    await _storageService!.remove(_tokenKey);
    await _storageService!.remove(_userIdKey);
    await _storageService!.remove(_userEmailKey);
    await _storageService!.remove(_userNameKey);
  }
}
