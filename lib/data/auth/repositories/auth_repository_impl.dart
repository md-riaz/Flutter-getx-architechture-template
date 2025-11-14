import '../../../domain/auth/entities/user.dart';
import '../../../domain/auth/repositories/auth_repository.dart';
import '../../core/data_exception.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_remote_data_source.dart';
import '../dtos/user_dto.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;

  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required AuthLocalDataSource localDataSource,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource;

  @override
  Future<bool> validateCredentials(String email, String password) async {
    try {
      return _remoteDataSource.validateCredentials(email, password);
    } catch (error) {
      throw DataException('Failed to validate credentials', error);
    }
  }

  @override
  Future<User> login(String email, String password) async {
    try {
      final dto = await _remoteDataSource.login(email, password);
      await _localDataSource.cacheUser(dto);
      return dto.toDomain();
    } catch (error) {
      throw DataException('Failed to login user', error);
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _remoteDataSource.logout();
      await _localDataSource.clear();
    } catch (error) {
      throw DataException('Failed to logout user', error);
    }
  }

  @override
  User? getCurrentUser() {
    final dto = _localDataSource.getCachedUser();
    return dto?.toDomain();
  }
}
