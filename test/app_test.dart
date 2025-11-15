import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:getx_modular_template/core/services/api_client.dart';
import 'package:getx_modular_template/core/services/auth_service.dart';
import 'package:getx_modular_template/core/services/session_manager.dart';
import 'package:getx_modular_template/core/data/repositories/auth_repository.dart';
import 'package:getx_modular_template/modules/inventory/data/dto/inventory_request.dart';
import 'package:getx_modular_template/modules/inventory/data/models/inventory_item.dart';
import 'package:getx_modular_template/modules/inventory/data/repositories/inventory_repository.dart';
import 'package:getx_modular_template/modules/inventory/services/inventory_service.dart';
import 'package:getx_modular_template/modules/inventory/controllers/inventory_controller.dart';

void main() {
  setUp(() {
    Get.testMode = true;
  });

  tearDown(() {
    Get.reset();
  });

  group('Core Services', () {
    test('ApiClient returns inventory data', () async {
      final apiClient = ApiClient();
      final data = await apiClient.getInventoryItems({'warehouse_id': 'test'});

      expect(data, isNotEmpty);
      expect(data.length, 3);
      expect(data.first['name'], 'Laptop');
    });

    test('AuthService manages login state with new architecture', () async {
      final apiClient = ApiClient();
      final authRepository = AuthRepository(apiClient);
      final sessionManager = SessionManager();
      final authService = AuthService(authRepository, sessionManager);

      expect(authService.isLoggedIn, isFalse);

      await authService.login('test@example.com', 'password');

      expect(authService.isLoggedIn, isTrue);
      expect(authService.permissions?.inventoryAccess, isTrue);

      authService.logout(); // Now synchronous

      expect(authService.isLoggedIn, isFalse);
    });
  });

  group('Inventory Module', () {
    test('InventoryItem parses from JSON', () {
      final json = {'id': '123', 'name': 'Widget', 'quantity': 42};
      final item = InventoryItem.fromJson(json);

      expect(item.id, '123');
      expect(item.name, 'Widget');
      expect(item.quantity, 42);
    });

    test('InventoryRequest converts to JSON', () {
      final request = InventoryRequest(warehouseId: 'warehouse-1');
      final json = request.toJson();

      expect(json['warehouse_id'], 'warehouse-1');
    });

    test('InventoryRepository fetches and parses items', () async {
      final apiClient = ApiClient();
      final repository = InventoryRepository(apiClient);
      final request = InventoryRequest(warehouseId: 'default');

      final items = await repository.fetchItems(request);

      expect(items, isNotEmpty);
      expect(items.first, isA<InventoryItem>());
      expect(items.first.name, 'Laptop');
    });

    test('InventoryService uses repository', () async {
      final apiClient = ApiClient();
      final repository = InventoryRepository(apiClient);
      final service = InventoryService(repository);

      final items = await service.getItemsForWarehouse('warehouse-1');

      expect(items, isNotEmpty);
      expect(items.length, 3);
    });

    test('InventoryController loads items on init', () async {
      final apiClient = ApiClient();
      final repository = InventoryRepository(apiClient);
      final service = InventoryService(repository);
      final controller = InventoryController(service);

      controller.onInit();

      // Wait for async loading to complete
      await Future.delayed(const Duration(milliseconds: 700));

      expect(controller.items, isNotEmpty);
      expect(controller.items.length, 3);
      expect(controller.isLoading.value, isFalse);
    });
  });
}
