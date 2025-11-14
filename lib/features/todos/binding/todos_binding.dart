import 'package:get/get.dart';
import '../../../data/todos/datasources/todo_local_data_source.dart';
import '../../../data/todos/datasources/todo_remote_data_source.dart';
import '../../../data/todos/repositories/todo_repository_impl.dart';
import '../../../domain/todos/repositories/todo_repository.dart';
import '../../../domain/todos/usecases/clear_todos_use_case.dart';
import '../../../domain/todos/usecases/create_todo_use_case.dart';
import '../../../domain/todos/usecases/delete_todo_use_case.dart';
import '../../../domain/todos/usecases/fetch_todos_use_case.dart';
import '../../../domain/todos/usecases/toggle_todo_completion_use_case.dart';
import '../../../domain/todos/usecases/update_todo_use_case.dart';
import '../controllers/todos_controller.dart';
import '../services/todos_service.dart';

class TodosBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TodoLocalDataSource>(
      () => InMemoryTodoLocalDataSource(),
      fenix: true,
    );

    Get.lazyPut<TodoRemoteDataSource>(
      () => FakeTodoRemoteDataSource(),
      fenix: true,
    );

    Get.lazyPut<TodoRepository>(
      () => TodoRepositoryImpl(
        remoteDataSource: Get.find<TodoRemoteDataSource>(),
        localDataSource: Get.find<TodoLocalDataSource>(),
      ),
      fenix: true,
    );

    Get.lazyPut<FetchTodosUseCase>(
      () => FetchTodosUseCase(Get.find<TodoRepository>()),
      fenix: true,
    );

    Get.lazyPut<CreateTodoUseCase>(
      () => CreateTodoUseCase(Get.find<TodoRepository>()),
      fenix: true,
    );

    Get.lazyPut<UpdateTodoUseCase>(
      () => UpdateTodoUseCase(Get.find<TodoRepository>()),
      fenix: true,
    );

    Get.lazyPut<DeleteTodoUseCase>(
      () => DeleteTodoUseCase(Get.find<TodoRepository>()),
      fenix: true,
    );

    Get.lazyPut<ToggleTodoCompletionUseCase>(
      () => ToggleTodoCompletionUseCase(Get.find<TodoRepository>()),
      fenix: true,
    );

    Get.lazyPut<ClearTodosUseCase>(
      () => ClearTodosUseCase(Get.find<TodoRepository>()),
      fenix: true,
    );

    Get.lazyPut<TodosService>(
      () => TodosService(
        fetchTodosUseCase: Get.find<FetchTodosUseCase>(),
        createTodoUseCase: Get.find<CreateTodoUseCase>(),
        updateTodoUseCase: Get.find<UpdateTodoUseCase>(),
        deleteTodoUseCase: Get.find<DeleteTodoUseCase>(),
        toggleTodoCompletionUseCase:
            Get.find<ToggleTodoCompletionUseCase>(),
        clearTodosUseCase: Get.find<ClearTodosUseCase>(),
      ),
    );

    Get.lazyPut<TodosController>(
      () => TodosController(
        fetchTodosUseCase: Get.find<FetchTodosUseCase>(),
        createTodoUseCase: Get.find<CreateTodoUseCase>(),
        updateTodoUseCase: Get.find<UpdateTodoUseCase>(),
        deleteTodoUseCase: Get.find<DeleteTodoUseCase>(),
        toggleTodoCompletionUseCase:
            Get.find<ToggleTodoCompletionUseCase>(),
        clearTodosUseCase: Get.find<ClearTodosUseCase>(),
        todosService: Get.find<TodosService>(),
      ),
    );
  }
}
