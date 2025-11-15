import '../entities/todo.dart';
import '../repositories/todo_repository.dart';

class FetchTodosUseCase {
  final TodoRepository _repository;

  const FetchTodosUseCase(this._repository);

  Future<List<Todo>> call() => _repository.fetchTodos();
}
