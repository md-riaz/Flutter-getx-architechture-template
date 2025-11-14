import '../../../domain/todos/entities/todo.dart';
import '../../../domain/todos/repositories/todo_repository.dart';
import '../../core/data_exception.dart';
import '../datasources/todo_local_data_source.dart';
import '../datasources/todo_remote_data_source.dart';

class TodoRepositoryImpl implements TodoRepository {
  final TodoRemoteDataSource _remoteDataSource;
  final TodoLocalDataSource _localDataSource;

  TodoRepositoryImpl({
    required TodoRemoteDataSource remoteDataSource,
    required TodoLocalDataSource localDataSource,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource;

  @override
  Future<List<Todo>> fetchTodos() async {
    try {
      final remoteTodos = await _remoteDataSource.fetchTodos();
      await _localDataSource.seed(remoteTodos);
      return remoteTodos.map((dto) => dto.toDomain()).toList();
    } catch (error) {
      final cached = _localDataSource.getAll();
      if (cached.isNotEmpty) {
        return cached.map((dto) => dto.toDomain()).toList();
      }
      throw DataException('Failed to load todos', error);
    }
  }

  @override
  Future<Todo> createTodo(String title, String description) async {
    try {
      final dto = await _remoteDataSource.createTodo(title, description);
      await _localDataSource.save(dto);
      return dto.toDomain();
    } catch (error) {
      throw DataException('Failed to create todo', error);
    }
  }

  @override
  Future<Todo?> updateTodo(
    String id, {
    String? title,
    String? description,
    bool? isCompleted,
  }) async {
    try {
      final dto = await _remoteDataSource.updateTodo(
        id,
        title: title,
        description: description,
        isCompleted: isCompleted,
      );
      if (dto == null) {
        return null;
      }
      await _localDataSource.save(dto);
      return dto.toDomain();
    } catch (error) {
      throw DataException('Failed to update todo', error);
    }
  }

  @override
  Future<bool> deleteTodo(String id) async {
    try {
      final deleted = await _remoteDataSource.deleteTodo(id);
      if (deleted) {
        await _localDataSource.delete(id);
      }
      return deleted;
    } catch (error) {
      throw DataException('Failed to delete todo', error);
    }
  }

  @override
  Future<Todo?> toggleTodo(String id) async {
    try {
      final cached = _localDataSource.getById(id);
      final toggledValue = !(cached?.isCompleted ?? false);
      final dto = await _remoteDataSource.updateTodo(
        id,
        isCompleted: toggledValue,
      );
      if (dto == null) {
        return null;
      }
      await _localDataSource.save(dto);
      return dto.toDomain();
    } catch (error) {
      throw DataException('Failed to toggle todo', error);
    }
  }

  @override
  Future<void> clearTodos() async {
    try {
      await _localDataSource.clear();
      await _localDataSource.seed([]);
    } catch (error) {
      throw DataException('Failed to clear todos', error);
    }
  }
}
