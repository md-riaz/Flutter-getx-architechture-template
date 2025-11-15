import '../repositories/todo_repository.dart';

class DeleteTodoUseCase {
  final TodoRepository _repository;

  const DeleteTodoUseCase(this._repository);

  Future<bool> call(String id) => _repository.deleteTodo(id);
}
