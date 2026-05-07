import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:getx_modular_template/core/implementations/memory_storage_service.dart';
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

  group('AuthService (without storage)', () {
    late AuthService authService;
    late AuthRepository authRepository;
    late SessionManager sessionManager;

    setUp(() {
      final apiClient = ApiClient();
      authRepository = AuthRepository(apiClient);
      sessionManager = SessionManager();
      // No storageService — token persistence is skipped
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
    });

    test('login fails with empty credentials', () async {
      final success = await authService.login('', '');

      expect(success, isFalse);
      expect(authService.isLoggedIn, isFalse);
      expect(authService.currentUser, isNull);
    });

    test('logout clears user immediately', () async {
      await authService.login('test@example.com', 'password');
      expect(authService.isLoggedIn, isTrue);

      authService.logout();

      expect(authService.isLoggedIn, isFalse);
      expect(authService.currentUser, isNull);
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

    test('restoreSession returns false when no storageService is provided', () async {
      final restored = await authService.restoreSession();
      expect(restored, isFalse);
    });
  });

  group('AuthService (with storage)', () {
    late AuthService authService;
    late MemoryStorageService storage;

    setUp(() async {
      storage = MemoryStorageService();
      await storage.init();
      final apiClient = ApiClient();
      final authRepository = AuthRepository(apiClient);
      final sessionManager = SessionManager();
      authService = AuthService(authRepository, sessionManager, storage);
    });

    test('login persists token to storage', () async {
      await authService.login('test@example.com', 'password');

      final token = await storage.getString('auth_token');
      expect(token, isNotNull);
      expect(token, isNotEmpty);
    });

    test('restoreSession restores user from stored token', () async {
      // Login to persist token
      await authService.login('test@example.com', 'password');
      final originalToken = authService.currentUser!.token;

      // Simulate app restart by creating a fresh AuthService with same storage
      final apiClient2 = ApiClient();
      final authRepository2 = AuthRepository(apiClient2);
      final sessionManager2 = SessionManager();
      final freshAuthService =
          AuthService(authRepository2, sessionManager2, storage);

      expect(freshAuthService.isLoggedIn, isFalse);

      final restored = await freshAuthService.restoreSession();

      expect(restored, isTrue);
      expect(freshAuthService.isLoggedIn, isTrue);
      expect(freshAuthService.currentUser?.token, originalToken);
    });

    test('restoreSession returns false when no token is stored', () async {
      final restored = await authService.restoreSession();
      expect(restored, isFalse);
    });

    test('logout clears persisted token', () async {
      await authService.login('test@example.com', 'password');
      expect(await storage.getString('auth_token'), isNotNull);

      authService.logout();

      // Give the logout time to clear storage (it is async but not awaited)
      await Future.delayed(const Duration(milliseconds: 50));
      expect(await storage.getString('auth_token'), isNull);
    });
  });
}

