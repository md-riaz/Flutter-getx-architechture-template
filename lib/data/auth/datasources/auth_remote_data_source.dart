import '../dtos/user_dto.dart';

abstract class AuthRemoteDataSource {
  Future<bool> validateCredentials(String email, String password);
  Future<UserDto> login(String email, String password);
  Future<void> logout();
}

class FakeAuthRemoteDataSource implements AuthRemoteDataSource {
  FakeAuthRemoteDataSource();

  final Map<String, _FakeUserRecord> _users = {
    'alex.operations@example.com': _FakeUserRecord(
      id: 'user-001',
      name: 'Alex Operations',
      password: 'Passw0rd!',
      features: const ['sms', 'voice'],
    ),
    'brenda.dispatch@example.com': _FakeUserRecord(
      id: 'user-002',
      name: 'Brenda Dispatch',
      password: 'FaxMeNow',
      features: const ['fax', 'todos'],
    ),
    'cameron.supervisor@example.com': _FakeUserRecord(
      id: 'user-003',
      name: 'Cameron Supervisor',
      password: 'Secure*123',
      features: const ['sms', 'fax', 'voice', 'todos'],
    ),
  };

  @override
  Future<bool> validateCredentials(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 250));
    final record = _users[email.toLowerCase()];
    return record != null && record.password == password;
  }

  @override
  Future<UserDto> login(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 350));
    final record = _users[email.toLowerCase()];
    if (record == null || record.password != password) {
      throw const FormatException('Invalid credentials');
    }
    return UserDto(
      id: record.id,
      name: record.name,
      email: email.toLowerCase(),
      enabledFeatures: record.features,
    );
  }

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 150));
  }
}

class _FakeUserRecord {
  final String id;
  final String name;
  final String password;
  final List<String> features;

  const _FakeUserRecord({
    required this.id,
    required this.name,
    required this.password,
    required this.features,
  });
}
