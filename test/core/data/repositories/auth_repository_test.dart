import 'package:flutter_test/flutter_test.dart';
import 'package:getx_modular_template/core/services/api_client.dart';
import 'package:getx_modular_template/core/data/repositories/auth_repository.dart';

void main() {
  group('AuthRepository', () {
    late AuthRepository authRepository;
    late ApiClient apiClient;

    setUp(() {
      apiClient = ApiClient();
      authRepository = AuthRepository(apiClient);
    });

    test('login returns user with valid credentials', () async {
      final user = await authRepository.login('test@example.com', 'password');

      expect(user.email, 'test@example.com');
      expect(user.name, 'John Doe');
      expect(user.token, isNotEmpty);
      expect(user.permissions.inventoryAccess, isTrue);
    });

    test('login throws exception with empty email', () async {
      expect(
        () => authRepository.login('', 'password'),
        throwsException,
      );
    });

    test('login throws exception with empty password', () async {
      expect(
        () => authRepository.login('test@example.com', ''),
        throwsException,
      );
    });

    test('logout completes successfully', () async {
      await expectLater(
        authRepository.logout('mock_token'),
        completes,
      );
    });

    test('validateToken returns true for non-empty token', () async {
      final isValid = await authRepository.validateToken('valid_token');
      expect(isValid, isTrue);
    });

    test('validateToken returns false for empty token', () async {
      final isValid = await authRepository.validateToken('');
      expect(isValid, isFalse);
    });

    test('refreshToken returns new token', () async {
      final oldToken = 'old_token';
      final newToken = await authRepository.refreshToken(oldToken);

      expect(newToken, isNotEmpty);
      expect(newToken, isNot(equals(oldToken)));
    });
  });
}
