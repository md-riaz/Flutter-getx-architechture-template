import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class LoginParams {
  final String email;
  final String password;

  const LoginParams({required this.email, required this.password});
}

class LoginUseCase {
  final AuthRepository _repository;

  const LoginUseCase(this._repository);

  Future<User> call(LoginParams params) async {
    final isValid = await _repository.validateCredentials(
      params.email,
      params.password,
    );

    if (!isValid) {
      throw const LoginValidationException('Invalid credentials');
    }

    return _repository.login(params.email, params.password);
  }
}

class LoginValidationException implements Exception {
  final String message;

  const LoginValidationException(this.message);

  @override
  String toString() => message;
}
