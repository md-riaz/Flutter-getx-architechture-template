import 'package:get/get.dart';
import '../../../base/base_controller.dart';
import '../../../domain/todos/entities/todo.dart';
import '../../../domain/todos/usecases/clear_todos_use_case.dart';
import '../../../domain/todos/usecases/create_todo_use_case.dart';
import '../../../domain/todos/usecases/delete_todo_use_case.dart';
import '../../../domain/todos/usecases/fetch_todos_use_case.dart';
import '../../../domain/todos/usecases/toggle_todo_completion_use_case.dart';
import '../../../domain/todos/usecases/update_todo_use_case.dart';
import '../services/todos_service.dart';

class TodosController extends BaseController {
  static const tag = 'TodosController';

  @override
  String get controllerName => tag;

  final FetchTodosUseCase _fetchTodosUseCase;
  final CreateTodoUseCase _createTodoUseCase;
  final UpdateTodoUseCase _updateTodoUseCase;
  final DeleteTodoUseCase _deleteTodoUseCase;
  final ToggleTodoCompletionUseCase _toggleTodoCompletionUseCase;
  final ClearTodosUseCase _clearTodosUseCase;
  final TodosService _todosService;

  final title = ''.obs;
  final description = ''.obs;
  final isLoading = false.obs;
  final errorMessage = RxnString();

  TodosController({
    required FetchTodosUseCase fetchTodosUseCase,
    required CreateTodoUseCase createTodoUseCase,
    required UpdateTodoUseCase updateTodoUseCase,
    required DeleteTodoUseCase deleteTodoUseCase,
    required ToggleTodoCompletionUseCase toggleTodoCompletionUseCase,
    required ClearTodosUseCase clearTodosUseCase,
    required TodosService todosService,
  })  : _fetchTodosUseCase = fetchTodosUseCase,
        _createTodoUseCase = createTodoUseCase,
        _updateTodoUseCase = updateTodoUseCase,
        _deleteTodoUseCase = deleteTodoUseCase,
        _toggleTodoCompletionUseCase = toggleTodoCompletionUseCase,
        _clearTodosUseCase = clearTodosUseCase,
        _todosService = todosService;

  RxList<Todo> get todos => _todosService.todos;
  int get todoCount => _todosService.todoCount;
  int get completedCount => _todosService.completedCount;
  int get pendingCount => _todosService.pendingCount;

  @override
  void onInit() {
    super.onInit();
    _loadTodos();
  }

  Future<void> _loadTodos() async {
    try {
      errorMessage.value = null;
      final items = await _fetchTodosUseCase();
      todos.assignAll(items);
    } catch (_) {
      errorMessage.value = 'Unable to load todos.';
    }
  }

  Future<bool> createTodo() async {
    if (title.value.isEmpty) {
      errorMessage.value = 'Please enter a title';
      return false;
    }

    isLoading.value = true;
    errorMessage.value = null;

    try {
      final todo = await _createTodoUseCase(
        CreateTodoParams(title: title.value, description: description.value),
      );
      todos.add(todo);
      title.value = '';
      description.value = '';
      return true;
    } catch (_) {
      errorMessage.value = 'Unable to create todo. Please try again.';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> toggleTodo(String id) async {
    try {
      errorMessage.value = null;
      final todo = await _toggleTodoCompletionUseCase(id);
      if (todo == null) {
        return false;
      }
      final index = todos.indexWhere((item) => item.id == todo.id);
      if (index != -1) {
        todos[index] = todo;
      }
      return true;
    } catch (_) {
      errorMessage.value = 'Unable to update todo.';
      return false;
    }
  }

  Future<bool> deleteTodo(String id) async {
    try {
      errorMessage.value = null;
      final deleted = await _deleteTodoUseCase(id);
      if (deleted) {
        todos.removeWhere((todo) => todo.id == id);
      }
      return deleted;
    } catch (_) {
      errorMessage.value = 'Unable to delete todo.';
      return false;
    }
  }

  Future<bool> updateTodo(
    String id, {
    String? title,
    String? description,
    bool? isCompleted,
  }) async {
    try {
      errorMessage.value = null;
      final todo = await _updateTodoUseCase(
        UpdateTodoParams(
          id: id,
          title: title,
          description: description,
          isCompleted: isCompleted,
        ),
      );
      if (todo == null) {
        return false;
      }
      final index = todos.indexWhere((item) => item.id == todo.id);
      if (index != -1) {
        todos[index] = todo;
      }
      return true;
    } catch (_) {
      errorMessage.value = 'Unable to update todo.';
      return false;
    }
  }

  Future<bool> clearAll() async {
    try {
      errorMessage.value = null;
      await _clearTodosUseCase();
      todos.clear();
      return true;
    } catch (_) {
      errorMessage.value = 'Unable to clear todos.';
      return false;
    }
  }
}
