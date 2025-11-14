import 'package:get/get.dart';
import '../../../domain/auth/usecases/get_current_user_use_case.dart';
import '../../../domain/auth/usecases/logout_use_case.dart';
import '../../auth/services/auth_service.dart';
import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(
      () => HomeController(
        getCurrentUserUseCase: Get.find<GetCurrentUserUseCase>(),
        logoutUseCase: Get.find<LogoutUseCase>(),
        authService: Get.find<AuthService>(),
      ),
    );
  }
}
