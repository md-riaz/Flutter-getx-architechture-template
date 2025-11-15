import '../entities/user.dart';

/// Abstract repository for authentication operations.
abstract class AuthRepository {
  /// Validates user credentials.
  /// Throws [DataException] if validation fails or network error occurs.
  Future<bool> validateCredentials(String email, String password);
  
  /// Authenticates a user and returns their profile.
  /// Throws [DataException] on invalid credentials or network error.
  Future<User> login(String email, String password);
  
  /// Signs out the current user.
  /// Throws [DataException] if logout fails.
  Future<void> logout();
  
  /// Returns the currently authenticated user, or null if no user is signed in.
  User? getCurrentUser();
}
