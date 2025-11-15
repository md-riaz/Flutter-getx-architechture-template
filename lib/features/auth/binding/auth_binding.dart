import 'package:get/get.dart';
import '../../../data/auth/datasources/auth_local_data_source.dart';
import '../../../data/auth/datasources/auth_remote_data_source.dart';
import '../../../data/auth/repositories/auth_repository_impl.dart';
import '../../../domain/auth/repositories/auth_repository.dart';
import '../../../domain/auth/usecases/get_current_user_use_case.dart';
import '../../../domain/auth/usecases/login_use_case.dart';
import '../../../domain/auth/usecases/logout_use_case.dart';
import '../controllers/auth_controller.dart';
import '../services/auth_service.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthLocalDataSource>(
      () => InMemoryAuthLocalDataSource(),
      fenix: true,
    );

    Get.lazyPut<AuthRemoteDataSource>(
      () => FakeAuthRemoteDataSource(),
      fenix: true,
    );

    Get.lazyPut<AuthRepository>(
      () => AuthRepositoryImpl(
        remoteDataSource: Get.find<AuthRemoteDataSource>(),
        localDataSource: Get.find<AuthLocalDataSource>(),
      ),
      fenix: true,
    );

    Get.lazyPut<LoginUseCase>(
      () => LoginUseCase(Get.find<AuthRepository>()),
      fenix: true,
    );

    Get.lazyPut<LogoutUseCase>(
      () => LogoutUseCase(Get.find<AuthRepository>()),
      fenix: true,
    );

    Get.lazyPut<GetCurrentUserUseCase>(
      () => GetCurrentUserUseCase(Get.find<AuthRepository>()),
      fenix: true,
    );

    if (!Get.isRegistered<AuthService>()) {
      Get.put<AuthService>(
        AuthService(
          loginUseCase: Get.find<LoginUseCase>(),
          logoutUseCase: Get.find<LogoutUseCase>(),
          getCurrentUserUseCase: Get.find<GetCurrentUserUseCase>(),
        ),
        permanent: true,
      );
    }

    Get.lazyPut<AuthController>(
      () => AuthController(
        loginUseCase: Get.find<LoginUseCase>(),
        logoutUseCase: Get.find<LogoutUseCase>(),
        getCurrentUserUseCase: Get.find<GetCurrentUserUseCase>(),
        authService: Get.find<AuthService>(),
      ),
    );
  }
}
