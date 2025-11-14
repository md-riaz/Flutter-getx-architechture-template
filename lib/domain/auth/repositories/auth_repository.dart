import '../entities/user.dart';

abstract class AuthRepository {
  Future<bool> validateCredentials(String email, String password);
  Future<User> login(String email, String password);
  Future<void> logout();
  User? getCurrentUser();
}
