import 'package:get/get.dart';

class UserPermissions {
  final bool inventoryAccess;

  UserPermissions({required this.inventoryAccess});
}

class AuthService extends GetxService {
  final _isLoggedIn = false.obs;
  final _permissions = UserPermissions(inventoryAccess: true).obs;

  bool get isLoggedIn => _isLoggedIn.value;
  UserPermissions get permissions => _permissions.value;

  Future<void> fakeLogin() async {
    await Future.delayed(const Duration(milliseconds: 400));
    _isLoggedIn.value = true;
  }

  void logout() {
    _isLoggedIn.value = false;
    // Here you would trigger session cleanup using tags if implemented
  }
}
