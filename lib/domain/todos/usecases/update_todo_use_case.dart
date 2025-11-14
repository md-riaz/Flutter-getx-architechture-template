import '../entities/todo.dart';
import '../repositories/todo_repository.dart';

class UpdateTodoParams {
  final String id;
  final String? title;
  final String? description;
  final bool? isCompleted;

  const UpdateTodoParams({
    required this.id,
    this.title,
    this.description,
    this.isCompleted,
  });
}

class UpdateTodoUseCase {
  final TodoRepository _repository;

  const UpdateTodoUseCase(this._repository);

  Future<Todo?> call(UpdateTodoParams params) {
    return _repository.updateTodo(
      params.id,
      title: params.title,
      description: params.description,
      isCompleted: params.isCompleted,
    );
  }
}
