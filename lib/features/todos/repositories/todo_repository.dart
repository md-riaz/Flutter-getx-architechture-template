import '../models/todo.dart';

/// In-memory todo repository for CRUD operations
class TodoRepository {
  final List<Todo> _todos = [];

  /// Get all todos
  List<Todo> getAll() {
    print('[TodoRepository] Getting all todos: ${_todos.length} items');
    return List.unmodifiable(_todos);
  }

  /// Get todo by id
  Todo? getById(String id) {
    try {
      return _todos.firstWhere((todo) => todo.id == id);
    } catch (e) {
      print('[TodoRepository] Todo not found: $id');
      return null;
    }
  }

  /// Create a new todo
  Future<Todo> create(String title, String description) async {
    print('[TodoRepository] Creating todo: $title');
    
    final todo = Todo(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      description: description,
      createdAt: DateTime.now(),
    );
    
    _todos.add(todo);
    print('[TodoRepository] Todo created: ${todo.id}');
    return todo;
  }

  /// Update a todo
  Future<Todo?> update(String id, {String? title, String? description, bool? isCompleted}) async {
    print('[TodoRepository] Updating todo: $id');
    
    final index = _todos.indexWhere((todo) => todo.id == id);
    if (index == -1) {
      print('[TodoRepository] Todo not found for update: $id');
      return null;
    }

    final todo = _todos[index];
    final updatedTodo = todo.copyWith(
      title: title,
      description: description,
      isCompleted: isCompleted,
      completedAt: isCompleted == true ? DateTime.now() : todo.completedAt,
    );

    _todos[index] = updatedTodo;
    print('[TodoRepository] Todo updated: $id');
    return updatedTodo;
  }

  /// Delete a todo
  Future<bool> delete(String id) async {
    print('[TodoRepository] Deleting todo: $id');
    
    final initialLength = _todos.length;
    _todos.removeWhere((todo) => todo.id == id);
    if (_todos.length < initialLength) {
      print('[TodoRepository] Todo deleted: $id');
      return true;
    }
    
    print('[TodoRepository] Todo not found for deletion: $id');
    return false;
  }

  /// Toggle todo completion status
  Future<Todo?> toggleComplete(String id) async {
    final todo = getById(id);
    if (todo == null) return null;
    
    return update(id, isCompleted: !todo.isCompleted);
  }

  /// Get completed todos
  List<Todo> getCompleted() {
    return _todos.where((todo) => todo.isCompleted).toList();
  }

  /// Get pending todos
  List<Todo> getPending() {
    return _todos.where((todo) => !todo.isCompleted).toList();
  }

  /// Clear all todos
  void clear() {
    print('[TodoRepository] Clearing all todos');
    _todos.clear();
  }

  /// Get todo count
  int get count => _todos.length;
}
