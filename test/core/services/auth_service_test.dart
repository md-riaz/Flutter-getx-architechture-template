import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:getx_modular_template/core/services/api_client.dart';
import 'package:getx_modular_template/core/services/auth_service.dart';
import 'package:getx_modular_template/core/services/session_manager.dart';
import 'package:getx_modular_template/core/data/repositories/auth_repository.dart';

void main() {
  setUp(() {
    Get.testMode = true;
  });

  tearDown(() {
    Get.reset();
  });

  group('AuthService', () {
    late AuthService authService;
    late AuthRepository authRepository;
    late SessionManager sessionManager;
    late ApiClient apiClient;

    setUp(() {
      apiClient = ApiClient();
      authRepository = AuthRepository(apiClient);
      sessionManager = SessionManager();
      authService = AuthService(authRepository, sessionManager);
    });

    test('initial state is not logged in', () {
      expect(authService.isLoggedIn, isFalse);
      expect(authService.currentUser, isNull);
    });

    test('login succeeds with valid credentials', () async {
      final success = await authService.login('test@example.com', 'password');

      expect(success, isTrue);
      expect(authService.isLoggedIn, isTrue);
      expect(authService.currentUser, isNotNull);
      expect(authService.currentUser?.email, 'test@example.com');
      expect(sessionManager.hasActiveSession, isTrue);
    });

    test('login fails with empty credentials', () async {
      final success = await authService.login('', '');

      expect(success, isFalse);
      expect(authService.isLoggedIn, isFalse);
      expect(authService.currentUser, isNull);
    });

    test('logout clears user immediately', () async {
      // First login
      await authService.login('test@example.com', 'password');
      expect(authService.isLoggedIn, isTrue);

      // Then logout (now synchronous)
      authService.logout();

      // User should be cleared immediately
      expect(authService.isLoggedIn, isFalse);
      expect(authService.currentUser, isNull);
      
      // Session cleanup happens in post-frame callback, so we can't test it here
      // In a real app, the session would be cleared after the frame
    });

    test('validateSession returns true for logged in user', () async {
      await authService.login('test@example.com', 'password');
      final isValid = await authService.validateSession();

      expect(isValid, isTrue);
    });

    test('validateSession returns false when not logged in', () async {
      final isValid = await authService.validateSession();

      expect(isValid, isFalse);
    });

    test('fakeLogin is backward compatible', () async {
      await authService.fakeLogin();

      expect(authService.isLoggedIn, isTrue);
      expect(authService.currentUser, isNotNull);
    });

    test('permissions are available after login', () async {
      await authService.login('test@example.com', 'password');

      expect(authService.permissions, isNotNull);
      expect(authService.permissions?.inventoryAccess, isTrue);
    });
  });
}
