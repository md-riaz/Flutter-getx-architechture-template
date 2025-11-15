import '../dtos/todo_dto.dart';

abstract class TodoLocalDataSource {
  Future<void> seed(List<TodoDto> todos);
  List<TodoDto> getAll();
  TodoDto? getById(String id);
  Future<void> save(TodoDto todo);
  Future<void> saveAll(List<TodoDto> todos);
  Future<void> delete(String id);
  Future<void> clear();
}

class InMemoryTodoLocalDataSource implements TodoLocalDataSource {
  final List<TodoDto> _storage = [];

  @override
  Future<void> seed(List<TodoDto> todos) async {
    _storage
      ..clear()
      ..addAll(todos);
  }

  @override
  List<TodoDto> getAll() => List.unmodifiable(_storage);

  @override
  TodoDto? getById(String id) {
    try {
      return _storage.firstWhere((todo) => todo.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> save(TodoDto todo) async {
    final index = _storage.indexWhere((item) => item.id == todo.id);
    if (index == -1) {
      _storage.add(todo);
    } else {
      _storage[index] = todo;
    }
  }

  @override
  Future<void> saveAll(List<TodoDto> todos) async {
    _storage
      ..clear()
      ..addAll(todos);
  }

  @override
  Future<void> delete(String id) async {
    _storage.removeWhere((todo) => todo.id == id);
  }

  @override
  Future<void> clear() async {
    _storage.clear();
  }
}
