import '../dtos/todo_dto.dart';

abstract class TodoRemoteDataSource {
  Future<List<TodoDto>> fetchTodos();
  Future<TodoDto> createTodo(String title, String description);
  Future<TodoDto?> updateTodo(
    String id, {
    String? title,
    String? description,
    bool? isCompleted,
  });
  Future<bool> deleteTodo(String id);
}

class FakeTodoRemoteDataSource implements TodoRemoteDataSource {
  final List<TodoDto> _seedData = [];

  @override
  Future<List<TodoDto>> fetchTodos() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return List.unmodifiable(_seedData);
  }

  @override
  Future<TodoDto> createTodo(String title, String description) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final todo = TodoDto(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      description: description,
      isCompleted: false,
      createdAt: DateTime.now(),
    );
    _seedData.add(todo);
    return todo;
  }

  @override
  Future<TodoDto?> updateTodo(
    String id, {
    String? title,
    String? description,
    bool? isCompleted,
  }) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final index = _seedData.indexWhere((todo) => todo.id == id);
    if (index == -1) {
      return null;
    }

    final existing = _seedData[index];
    final updated = TodoDto(
      id: existing.id,
      title: title ?? existing.title,
      description: description ?? existing.description,
      isCompleted: isCompleted ?? existing.isCompleted,
      createdAt: existing.createdAt,
      completedAt: isCompleted == true ? DateTime.now() : existing.completedAt,
    );
    _seedData[index] = updated;
    return updated;
  }

  @override
  Future<bool> deleteTodo(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _seedData.removeWhere((todo) => todo.id == id) > 0;
  }
}
