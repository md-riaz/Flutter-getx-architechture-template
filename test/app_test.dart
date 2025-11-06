import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:flutter_getx_architecture/services/feature_registry_service.dart';
import 'package:flutter_getx_architecture/features/auth/services/auth_service.dart';
import 'package:flutter_getx_architecture/features/auth/repositories/auth_repository.dart';
import 'package:flutter_getx_architecture/features/auth/controllers/auth_controller.dart';
import 'package:flutter_getx_architecture/features/home/controllers/home_controller.dart';
import 'package:flutter_getx_architecture/features/todos/controllers/todos_controller.dart';
import 'package:flutter_getx_architecture/features/todos/services/todos_service.dart';

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

  group('AuthService Tests', () {
    late AuthService authService;
    late FeatureRegistryService featureRegistry;

    setUp(() {
      Get.testMode = true;
      featureRegistry = FeatureRegistryService();
      Get.put<FeatureRegistryService>(featureRegistry, permanent: true);
      authService = AuthService();
    });

    tearDown(() {
      Get.reset();
    });

    test('should inject AuthRepository via constructor', () {
      final mockRepository = AuthRepository();
      final service = AuthService(authRepository: mockRepository);
      expect(service, isNotNull);
    });

    test('login should authenticate user and create feature bindings', () async {
      // Register a test feature
      final binding = BindingsBuilder(() {
        Get.put<TodosService>(TodosService());
      });
      featureRegistry.registerFeature('todos', binding);

      // Perform login
      final success = await authService.login('test@example.com', 'password');
      
      expect(success, true);
      expect(authService.isAuthenticated, true);
      expect(authService.currentUser?.email, 'test@example.com');
      
      // Verify feature bindings were created
      expect(Get.isRegistered<TodosService>(), true);
    });

    test('logout should clear user and delete feature bindings', () async {
      // Register and create feature bindings
      final binding = BindingsBuilder(() {
        Get.put<TodosService>(TodosService());
      });
      featureRegistry.registerFeature('todos', binding);
      
      // Login first
      await authService.login('test@example.com', 'password');
      expect(authService.isAuthenticated, true);
      expect(Get.isRegistered<TodosService>(), true);
      
      // Logout
      await authService.logout();
      
      expect(authService.isAuthenticated, false);
      expect(authService.currentUser, isNull);
      // Feature bindings should be deleted
      expect(Get.isRegistered<TodosService>(), false);
    });

    test('isAuthenticated should return false initially', () {
      expect(authService.isAuthenticated, false);
      expect(authService.currentUser, isNull);
    });
  });

  group('FeatureRegistryService Tests', () {
    late FeatureRegistryService service;

    setUp(() {
      Get.testMode = true;
      service = FeatureRegistryService();
    });

    tearDown(() {
      Get.reset();
    });

    test('should register feature', () {
      final binding = BindingsBuilder(() {});
      
      service.registerFeature('test', binding);
      
      expect(service.getRegisteredFeatures(), contains('test'));
    });

    test('should clear features', () {
      final binding = BindingsBuilder(() {});
      
      service.registerFeature('test', binding);
      expect(service.getRegisteredFeatures().length, 1);
      
      service.clearFeatures();
      expect(service.getRegisteredFeatures().length, 0);
    });

    test('should register multiple features', () {
      final binding1 = BindingsBuilder(() {});
      final binding2 = BindingsBuilder(() {});
      
      service.registerFeature('feature1', binding1);
      service.registerFeature('feature2', binding2);
      
      expect(service.getRegisteredFeatures().length, 2);
      expect(service.getRegisteredFeatures(), contains('feature1'));
      expect(service.getRegisteredFeatures(), contains('feature2'));
    });

    test('createFeatureBindings should initialize all registered features', () {
      // Register features with bindings
      final binding1 = BindingsBuilder(() {
        Get.put<TodosService>(TodosService());
      });
      final binding2 = BindingsBuilder(() {
        Get.put<String>('home-service');
      });
      
      service.registerFeature('todos', binding1);
      service.registerFeature('home', binding2);
      
      // Create bindings
      service.createFeatureBindings();
      
      // Verify bindings were created
      expect(Get.isRegistered<TodosService>(), true);
      expect(Get.isRegistered<String>(), true);
    });

    test('deleteFeatureBindings should remove all feature bindings', () {
      // Register and create features
      final binding = BindingsBuilder(() {
        Get.put<TodosService>(TodosService());
      });
      
      service.registerFeature('todos', binding);
      service.createFeatureBindings();
      
      expect(Get.isRegistered<TodosService>(), true);
      
      // Delete bindings
      service.deleteFeatureBindings();
      
      // Verify bindings were deleted
      expect(Get.isRegistered<TodosService>(), false);
    });
  });

  group('AuthController Tests', () {
    late AuthController controller;
    late AuthService authService;
    late FeatureRegistryService featureRegistry;

    setUp(() {
      Get.testMode = true;
      featureRegistry = FeatureRegistryService();
      Get.put<FeatureRegistryService>(featureRegistry, permanent: true);
      authService = AuthService();
      controller = AuthController(authService: authService);
    });

    tearDown(() {
      controller.onClose();
      Get.reset();
    });

    test('should inject AuthService via constructor', () {
      expect(controller, isNotNull);
    });

    test('login should validate inputs and authenticate', () async {
      controller.emailController.value = 'test@example.com';
      controller.passwordController.value = 'password';
      
      await controller.login();
      
      expect(authService.isAuthenticated, true);
    });

    test('login should show error for empty credentials', () async {
      controller.emailController.value = '';
      controller.passwordController.value = '';
      
      await controller.login();
      
      expect(authService.isAuthenticated, false);
    });

    test('logout should clear authentication', () async {
      // Login first
      controller.emailController.value = 'test@example.com';
      controller.passwordController.value = 'password';
      await controller.login();
      
      expect(authService.isAuthenticated, true);
      
      // Logout
      await controller.logout();
      
      expect(authService.isAuthenticated, false);
    });
  });

  group('HomeController Tests', () {
    late HomeController controller;
    late AuthService authService;
    late FeatureRegistryService featureRegistry;

    setUp(() {
      Get.testMode = true;
      featureRegistry = FeatureRegistryService();
      Get.put<FeatureRegistryService>(featureRegistry, permanent: true);
      authService = AuthService();
      // Login to create a user
      authService.login('test@example.com', 'password');
      controller = HomeController(authService: authService);
    });

    tearDown(() {
      controller.onClose();
      Get.reset();
    });

    test('should inject AuthService via constructor', () {
      expect(controller, isNotNull);
    });

    test('getUserEmail should return current user email', () {
      final email = controller.getUserEmail();
      expect(email, 'test@example.com');
    });

    test('incrementCounter should increase counter value', () {
      expect(controller.counter.value, 0);
      
      controller.incrementCounter();
      expect(controller.counter.value, 1);
      
      controller.incrementCounter();
      expect(controller.counter.value, 2);
    });

    test('logout should clear authentication', () async {
      expect(authService.isAuthenticated, true);
      
      await controller.logout();
      
      expect(authService.isAuthenticated, false);
    });
  });

  group('Memory Management Tests', () {
    late FeatureRegistryService featureRegistry;
    late AuthService authService;

    setUp(() {
      Get.testMode = true;
      featureRegistry = FeatureRegistryService();
      Get.put<FeatureRegistryService>(featureRegistry, permanent: true);
      authService = AuthService();
      Get.put<AuthService>(authService, permanent: true);
    });

    tearDown(() {
      Get.reset();
    });

    test('feature controllers should be cleaned up on logout', () async {
      // Register features
      final homeBinding = BindingsBuilder(() {
        Get.put<HomeController>(HomeController(authService: authService));
      });
      final todosBinding = BindingsBuilder(() {
        Get.put<TodosService>(TodosService());
      });
      
      featureRegistry.registerFeature('home', homeBinding);
      featureRegistry.registerFeature('todos', todosBinding);
      
      // Login to create feature bindings
      await authService.login('test@example.com', 'password');
      
      expect(Get.isRegistered<HomeController>(), true);
      expect(Get.isRegistered<TodosService>(), true);
      
      // Logout to delete feature bindings
      await authService.logout();
      
      // Verify cleanup
      expect(Get.isRegistered<HomeController>(), false);
      expect(Get.isRegistered<TodosService>(), false);
      expect(authService.isAuthenticated, false);
    });

    test('multiple login/logout cycles should properly manage memory', () async {
      final binding = BindingsBuilder(() {
        Get.put<TodosService>(TodosService());
      });
      featureRegistry.registerFeature('todos', binding);
      
      // First cycle
      await authService.login('user1@example.com', 'password');
      expect(authService.isAuthenticated, true);
      expect(Get.isRegistered<TodosService>(), true);
      
      await authService.logout();
      expect(authService.isAuthenticated, false);
      expect(Get.isRegistered<TodosService>(), false);
      
      // Second cycle
      await authService.login('user2@example.com', 'password');
      expect(authService.isAuthenticated, true);
      expect(authService.currentUser?.email, 'user2@example.com');
      expect(Get.isRegistered<TodosService>(), true);
      
      await authService.logout();
      expect(authService.isAuthenticated, false);
      expect(Get.isRegistered<TodosService>(), false);
    });

    test('TodosService onClose should clear data', () {
      final todosService = TodosService();
      todosService.onInit();
      
      // Create some todos
      todosService.createTodo('Test Todo', 'Description');
      expect(todosService.todoCount, greaterThan(0));
      
      // Call onClose to clean up
      todosService.onClose();
      
      // Data should be cleared
      expect(todosService.todoCount, 0);
    });

    test('controllers should handle disposal gracefully with active timers', () async {
      // Register features with controllers that have timers
      final homeBinding = BindingsBuilder(() {
        Get.put<HomeController>(HomeController(authService: authService));
      });
      final todosBinding = BindingsBuilder(() {
        Get.put<TodosService>(TodosService());
        Get.put<TodosController>(TodosController());
      });
      
      featureRegistry.registerFeature('home', homeBinding);
      featureRegistry.registerFeature('todos', todosBinding);
      
      // Login to create feature bindings (starts timers)
      await authService.login('test@example.com', 'password');
      
      expect(Get.isRegistered<HomeController>(), true);
      expect(Get.isRegistered<TodosController>(), true);
      
      // Wait briefly to ensure timers are running
      await Future.delayed(const Duration(milliseconds: 100));
      
      // Logout immediately (should cancel timers without errors)
      await authService.logout();
      
      // Wait a bit to ensure no timer callbacks execute after disposal
      await Future.delayed(const Duration(milliseconds: 100));
      
      // Verify cleanup - controllers should be deleted without errors
      expect(Get.isRegistered<HomeController>(), false);
      expect(Get.isRegistered<TodosController>(), false);
      expect(authService.isAuthenticated, false);
    });
  });
}
