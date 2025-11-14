import '../dtos/user_dto.dart';

abstract class AuthRemoteDataSource {
  Future<bool> validateCredentials(String email, String password);
  Future<UserDto> login(String email, String password);
  Future<void> logout();
}

class FakeAuthRemoteDataSource implements AuthRemoteDataSource {
  @override
  Future<bool> validateCredentials(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return email.isNotEmpty && password.isNotEmpty;
  }

  @override
  Future<UserDto> login(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return UserDto(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: email.split('@').first,
      email: email,
    );
  }

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 200));
  }
}
