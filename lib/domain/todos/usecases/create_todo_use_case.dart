import '../entities/todo.dart';
import '../repositories/todo_repository.dart';

class CreateTodoParams {
  final String title;
  final String description;

  const CreateTodoParams({required this.title, required this.description});
}

class CreateTodoUseCase {
  final TodoRepository _repository;

  const CreateTodoUseCase(this._repository);

  Future<Todo> call(CreateTodoParams params) {
    return _repository.createTodo(params.title, params.description);
  }
}
