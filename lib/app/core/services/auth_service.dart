import 'package:get/get.dart';

/// User roles
enum UserRole {
  admin,
  manager,
  salesperson,
}

/// User model
class AppUser {
  final String id;
  final String name;
  final String email;
  final UserRole role;

  const AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role.name,
    };
  }

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      role: UserRole.values.firstWhere(
        (r) => r.name == json['role'],
        orElse: () => UserRole.salesperson,
      ),
    );
  }
}

/// Authentication service
/// Mock implementation for local-only mode
class AuthService extends GetxService {
  final Rx<AppUser?> _currentUser = Rx<AppUser?>(null);

  AppUser? get currentUser => _currentUser.value;
  bool get isAuthenticated => _currentUser.value != null;

  /// Mock login - always succeeds
  Future<AppUser> login(String email, String password) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Mock user based on email
    final user = AppUser(
      id: 'user_1',
      name: email.split('@').first,
      email: email,
      role: email.contains('admin') ? UserRole.admin : UserRole.manager,
    );

    _currentUser.value = user;
    print('[AuthService] User logged in: ${user.name} (${user.role.name})');
    
    return user;
  }

  /// Logout
  void logout() {
    _currentUser.value = null;
    print('[AuthService] User logged out');
  }

  /// Check if user has specific role
  bool hasRole(UserRole role) {
    return _currentUser.value?.role == role;
  }

  /// Check if user has any of the specified roles
  bool hasAnyRole(List<UserRole> roles) {
    final userRole = _currentUser.value?.role;
    return userRole != null && roles.contains(userRole);
  }

  /// Create a mock instance with specific role
  static AuthService mock({required UserRole role}) {
    final service = AuthService();
    service._currentUser.value = AppUser(
      id: 'mock_user',
      name: 'Mock User',
      email: 'mock@example.com',
      role: role,
    );
    return service;
  }
}
