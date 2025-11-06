import 'package:get/get.dart';
import '../features/todos/controllers/todos_controller.dart';
import '../features/todos/services/todos_service.dart';

/// Todos feature binding
class TodosBinding extends Bindings {
  @override
  void dependencies() {
    print('[TodosBinding] Setting up todos dependencies');
    
    // Only register if not already registered to avoid double initialization
    if (!Get.isRegistered<TodosService>()) {
      // Register TodosService (not permanent, can be deleted on logout)
      Get.put<TodosService>(
        TodosService(),
      );
    } else {
      print('[TodosBinding] TodosService already registered, skipping');
    }
    
    if (!Get.isRegistered<TodosController>()) {
      // Register TodosController with fenix: true for auto-recovery
      Get.lazyPut<TodosController>(
        () => TodosController(),
        fenix: true,
      );
    } else {
      print('[TodosBinding] TodosController already registered, skipping');
    }
  }
}
