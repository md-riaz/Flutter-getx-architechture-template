import '../dtos/user_dto.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheUser(UserDto user);
  UserDto? getCachedUser();
  Future<void> clear();
}

class InMemoryAuthLocalDataSource implements AuthLocalDataSource {
  UserDto? _cachedUser;

  @override
  Future<void> cacheUser(UserDto user) async {
    _cachedUser = user;
  }

  @override
  UserDto? getCachedUser() => _cachedUser;

  @override
  Future<void> clear() async {
    _cachedUser = null;
  }
}
