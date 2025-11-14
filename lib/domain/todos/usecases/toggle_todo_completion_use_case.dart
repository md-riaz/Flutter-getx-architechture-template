import '../entities/todo.dart';
import '../repositories/todo_repository.dart';

class ToggleTodoCompletionUseCase {
  final TodoRepository _repository;

  const ToggleTodoCompletionUseCase(this._repository);

  Future<Todo?> call(String id) => _repository.toggleTodo(id);
}
