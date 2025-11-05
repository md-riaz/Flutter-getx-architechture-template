import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:flutter_getx_architecture/services/feature_registry_service.dart';
import 'package:flutter_getx_architecture/services/auth_service.dart';
import 'package:flutter_getx_architecture/features/auth/repositories/auth_repository.dart';

void main() {
  group('AuthRepository Tests', () {
    late AuthRepository authRepository;

    setUp(() {
      authRepository = AuthRepository();
    });

    test('validate should always return true', () async {
      final result = await authRepository.validate('test@example.com', 'password');
      expect(result, true);
    });

    test('login should create user in memory', () async {
      final user = await authRepository.login('test@example.com', 'password');
      expect(user.email, 'test@example.com');
      expect(user.name, 'test');
      expect(authRepository.isAuthenticated(), true);
    });

    test('logout should clear user from memory', () async {
      await authRepository.login('test@example.com', 'password');
      expect(authRepository.isAuthenticated(), true);
      
      await authRepository.logout();
      expect(authRepository.isAuthenticated(), false);
    });
  });

  group('FeatureRegistryService Tests', () {
    setUp(() {
      Get.testMode = true;
    });

    tearDown(() {
      Get.reset();
    });

    test('should register feature', () {
      final service = FeatureRegistryService();
      final binding = BindingsBuilder(() {});
      
      service.registerFeature('test', binding);
      
      expect(service.getRegisteredFeatures(), contains('test'));
    });

    test('should clear features', () {
      final service = FeatureRegistryService();
      final binding = BindingsBuilder(() {});
      
      service.registerFeature('test', binding);
      expect(service.getRegisteredFeatures().length, 1);
      
      service.clearFeatures();
      expect(service.getRegisteredFeatures().length, 0);
    });
  });
}
