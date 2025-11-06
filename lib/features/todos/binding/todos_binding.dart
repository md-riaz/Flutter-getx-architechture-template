import 'package:get/get.dart';
import '../controllers/todos_controller.dart';
import '../services/todos_service.dart';

/// Todos feature binding
class TodosBinding extends Bindings {
  @override
  void dependencies() {
    print('[TodosBinding] Setting up todos dependencies');
    
    // Register TodosService (not permanent, will be deleted on logout)
    // Skip registration if already registered
    if (!Get.isRegistered<TodosService>()) {
      Get.put<TodosService>(
        TodosService(),
      );
    } else {
      print('[TodosBinding] TodosService already registered, skipping');
    }
    
    // Register TodosController with fenix: true for auto-recovery
    // Skip registration if already prepared to avoid "already registered" error
    if (!Get.isRegistered<TodosController>()) {
      Get.lazyPut<TodosController>(
        () => TodosController(),
        fenix: true,
      );
    } else {
      print('[TodosBinding] TodosController already registered, skipping');
    }
  }
}
