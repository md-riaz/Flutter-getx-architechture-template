import 'package:get/get.dart';
import '../../../domain/todos/entities/todo.dart';
import '../../../domain/todos/usecases/clear_todos_use_case.dart';
import '../../../domain/todos/usecases/create_todo_use_case.dart';
import '../../../domain/todos/usecases/delete_todo_use_case.dart';
import '../../../domain/todos/usecases/fetch_todos_use_case.dart';
import '../../../domain/todos/usecases/toggle_todo_completion_use_case.dart';
import '../../../domain/todos/usecases/update_todo_use_case.dart';

class TodosService extends GetxService {
  final FetchTodosUseCase _fetchTodosUseCase;
  final CreateTodoUseCase _createTodoUseCase;
  final UpdateTodoUseCase _updateTodoUseCase;
  final DeleteTodoUseCase _deleteTodoUseCase;
  final ToggleTodoCompletionUseCase _toggleTodoCompletionUseCase;
  final ClearTodosUseCase _clearTodosUseCase;

  final _todos = <Todo>[].obs;

  TodosService({
    required FetchTodosUseCase fetchTodosUseCase,
    required CreateTodoUseCase createTodoUseCase,
    required UpdateTodoUseCase updateTodoUseCase,
    required DeleteTodoUseCase deleteTodoUseCase,
    required ToggleTodoCompletionUseCase toggleTodoCompletionUseCase,
    required ClearTodosUseCase clearTodosUseCase,
  })  : _fetchTodosUseCase = fetchTodosUseCase,
        _createTodoUseCase = createTodoUseCase,
        _updateTodoUseCase = updateTodoUseCase,
        _deleteTodoUseCase = deleteTodoUseCase,
        _toggleTodoCompletionUseCase = toggleTodoCompletionUseCase,
        _clearTodosUseCase = clearTodosUseCase;

  RxList<Todo> get todos => _todos;
  int get todoCount => _todos.length;
  int get completedCount =>
      _todos.where((todo) => todo.isCompleted).length;
  int get pendingCount =>
      _todos.where((todo) => !todo.isCompleted).length;

  Future<void> loadTodos() async {
    final results = await _fetchTodosUseCase();
    _todos.assignAll(results);
  }

  Future<Todo> createTodo(String title, String description) async {
    final todo = await _createTodoUseCase(
      CreateTodoParams(title: title, description: description),
    );
    _todos.add(todo);
    return todo;
  }

  Future<Todo?> updateTodo(
    String id, {
    String? title,
    String? description,
    bool? isCompleted,
  }) async {
    final todo = await _updateTodoUseCase(
      UpdateTodoParams(
        id: id,
        title: title,
        description: description,
        isCompleted: isCompleted,
      ),
    );
    if (todo != null) {
      final index = _todos.indexWhere((item) => item.id == todo.id);
      if (index != -1) {
        _todos[index] = todo;
      }
    }
    return todo;
  }

  Future<bool> deleteTodo(String id) async {
    final deleted = await _deleteTodoUseCase(id);
    if (deleted) {
      _todos.removeWhere((todo) => todo.id == id);
    }
    return deleted;
  }

  Future<Todo?> toggleTodoComplete(String id) async {
    final todo = await _toggleTodoCompletionUseCase(id);
    if (todo != null) {
      final index = _todos.indexWhere((item) => item.id == todo.id);
      if (index != -1) {
        _todos[index] = todo;
      }
    }
    return todo;
  }

  Future<void> clearAllTodos() async {
    await _clearTodosUseCase();
    _todos.clear();
  }
}
