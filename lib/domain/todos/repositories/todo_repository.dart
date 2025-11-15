import '../entities/todo.dart';

abstract class TodoRepository {
  Future<List<Todo>> fetchTodos();
  Future<Todo> createTodo(String title, String description);
  Future<Todo?> updateTodo(
    String id, {
    String? title,
    String? description,
    bool? isCompleted,
  });
  Future<bool> deleteTodo(String id);
  Future<Todo?> toggleTodo(String id);
  Future<void> clearTodos();
}
