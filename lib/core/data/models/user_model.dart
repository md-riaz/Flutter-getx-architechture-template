class UserPermissions {
  final bool inventoryAccess;

  UserPermissions({required this.inventoryAccess});

  factory UserPermissions.fromJson(Map<String, dynamic> json) {
    return UserPermissions(
      inventoryAccess: json['inventory_access'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'inventory_access': inventoryAccess,
    };
  }
}

class User {
  final String id;
  final String email;
  final String name;
  final String token;
  final UserPermissions permissions;

  User({
    required this.id,
    required this.email,
    required this.name,
    required this.token,
    required this.permissions,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      token: json['token'],
      permissions: UserPermissions.fromJson(json['permissions'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'token': token,
      'permissions': permissions.toJson(),
    };
  }
}
