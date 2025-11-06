import '../models/user.dart';

/// Local authentication repository
/// Validates locally and stores user in memory
class AuthRepository {
  User? _currentUser;

  /// Validates user credentials locally
  /// Always returns true for demo purposes
  Future<bool> validate(String email, String password) async {
    print('[AuthRepository] Validating credentials for: $email');
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }

  /// Login and store user in memory
  Future<User> login(String email, String password) async {
    print('[AuthRepository] Logging in user: $email');
    
    final user = User(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: email.split('@').first,
      email: email,
    );
    
    _currentUser = user;
    return user;
  }

  /// Logout and clear user from memory
  Future<void> logout() async {
    print('[AuthRepository] Logging out user: ${_currentUser?.email}');
    _currentUser = null;
  }

  /// Get current user from memory
  User? getCurrentUser() {
    return _currentUser;
  }

  /// Check if user is authenticated
  bool isAuthenticated() {
    return _currentUser != null;
  }
}
