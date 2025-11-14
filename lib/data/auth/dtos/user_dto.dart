import '../../../domain/auth/entities/user.dart';

class UserDto {
  final String id;
  final String name;
  final String email;
  final List<String> enabledFeatures;

  const UserDto({
    required this.id,
    required this.name,
    required this.email,
    required this.enabledFeatures,
  });

  factory UserDto.fromDomain(User user) {
    return UserDto(
      id: user.id,
      name: user.name,
      email: user.email,
      enabledFeatures:
          user.enabledFeatures.map((feature) => feature.name).toList(),
    );
  }

  User toDomain() {
    return User(
      id: id,
      name: name,
      email: email,
      enabledFeatures: enabledFeatures
          .map((raw) {
            try {
              return AppFeature.values.byName(raw);
            } catch (_) {
              return null;
            }
          })
          .whereType<AppFeature>()
          .toSet(),
    );
  }

  factory UserDto.fromJson(Map<String, dynamic> json) {
    return UserDto(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      enabledFeatures: (json['features'] as List<dynamic>)
          .map((item) => item.toString())
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'features': enabledFeatures,
    };
  }
}
