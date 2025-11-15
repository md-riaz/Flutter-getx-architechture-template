import '../../../core/services/api_client.dart';
import '../models/user_model.dart';

/// Repository for authentication operations
/// Follows the repository pattern for clean architecture
class AuthRepository {
  final ApiClient _apiClient;

  AuthRepository(this._apiClient);

  /// Login with credentials
  Future<User> login(String email, String password) async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 800));

    // In a real app, this would call _apiClient.post('/auth/login', ...)
    // For now, return mock user data
    if (email.isNotEmpty && password.isNotEmpty) {
      return User(
        id: '1',
        email: email,
        name: 'John Doe',
        token: 'mock_token_${DateTime.now().millisecondsSinceEpoch}',
        permissions: UserPermissions(inventoryAccess: true),
      );
    }

    throw Exception('Invalid credentials');
  }

  /// Logout user
  Future<void> logout(String token) async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 300));

    // In a real app, this would call _apiClient.post('/auth/logout', ...)
    // For now, just simulate the delay
  }

  /// Refresh authentication token
  Future<String> refreshToken(String oldToken) async {
    await Future.delayed(const Duration(milliseconds: 500));

    // In a real app, this would call _apiClient.post('/auth/refresh', ...)
    return 'refreshed_token_${DateTime.now().millisecondsSinceEpoch}';
  }

  /// Validate current token
  Future<bool> validateToken(String token) async {
    await Future.delayed(const Duration(milliseconds: 300));

    // In a real app, this would call _apiClient.get('/auth/validate', ...)
    return token.isNotEmpty;
  }
}
