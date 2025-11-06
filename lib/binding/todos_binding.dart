import 'package:get/get.dart';
import '../features/todos/controllers/todos_controller.dart';
import '../features/todos/services/todos_service.dart';

/// Todos feature binding
class TodosBinding extends Bindings {
  @override
  void dependencies() {
    print('[TodosBinding] Setting up todos dependencies');
    
    // Register TodosService as permanent (feature-level service)
    Get.put<TodosService>(
      TodosService(),
      permanent: true,
    );
    
    // Register TodosController with fenix: true for auto-recovery
    Get.lazyPut<TodosController>(
      () => TodosController(),
      fenix: true,
      tag: TodosController.tag,
    );
  }
}
