import 'package:get/get.dart';
import '../models/todo.dart';
import '../repositories/todo_repository.dart';

/// Todos service for managing todo operations
class TodosService extends GetxService {
  final TodoRepository _todoRepository = TodoRepository();
  final _todos = <Todo>[].obs;

  List<Todo> get todos => _todos;
  int get todoCount => _todos.length;
  int get completedCount => _todos.where((t) => t.isCompleted).length;
  int get pendingCount => _todos.where((t) => !t.isCompleted).length;

  @override
  void onInit() {
    super.onInit();
    print('[TodosService] onInit called');
    _loadTodos();
  }

  /// Load all todos from repository
  void _loadTodos() {
    _todos.value = _todoRepository.getAll();
    print('[TodosService] Loaded ${_todos.length} todos');
  }

  /// Create a new todo
  Future<Todo> createTodo(String title, String description) async {
    print('[TodosService] Creating todo: $title');
    final todo = await _todoRepository.create(title, description);
    _loadTodos();
    return todo;
  }

  /// Update a todo
  Future<Todo?> updateTodo(
    String id, {
    String? title,
    String? description,
    bool? isCompleted,
  }) async {
    print('[TodosService] Updating todo: $id');
    final todo = await _todoRepository.update(
      id,
      title: title,
      description: description,
      isCompleted: isCompleted,
    );
    _loadTodos();
    return todo;
  }

  /// Delete a todo
  Future<bool> deleteTodo(String id) async {
    print('[TodosService] Deleting todo: $id');
    final success = await _todoRepository.delete(id);
    if (success) {
      _loadTodos();
    }
    return success;
  }

  /// Toggle todo completion
  Future<void> toggleTodoComplete(String id) async {
    print('[TodosService] Toggling todo completion: $id');
    await _todoRepository.toggleComplete(id);
    _loadTodos();
  }

  /// Get completed todos
  List<Todo> getCompletedTodos() {
    return _todos.where((t) => t.isCompleted).toList();
  }

  /// Get pending todos
  List<Todo> getPendingTodos() {
    return _todos.where((t) => !t.isCompleted).toList();
  }

  /// Clear all todos
  void clearAllTodos() {
    print('[TodosService] Clearing all todos');
    _todoRepository.clear();
    _loadTodos();
  }
}
