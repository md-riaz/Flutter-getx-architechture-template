import 'package:get/get.dart';
import '../controllers/todos_controller.dart';
import '../services/todos_service.dart';

/// Todos feature binding
class TodosBinding extends Bindings {
  @override
  void dependencies() {
    print('[TodosBinding] Setting up todos dependencies');
    
    // Register TodosService (not permanent, will be deleted on logout)
    Get.put<TodosService>(
      TodosService(),
    );
    
    // Register TodosController - factory will be cleared on logout
    Get.lazyPut<TodosController>(
      () => TodosController(),
    );
  }
}
