import '../repositories/todo_repository.dart';

class ClearTodosUseCase {
  final TodoRepository _repository;

  const ClearTodosUseCase(this._repository);

  Future<void> call() => _repository.clearTodos();
}
