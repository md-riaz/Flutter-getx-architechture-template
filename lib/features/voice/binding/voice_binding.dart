import 'package:get/get.dart';
import '../../../data/voice/datasources/voice_local_data_source.dart';
import '../../../data/voice/datasources/voice_remote_data_source.dart';
import '../../../data/voice/repositories/voice_repository_impl.dart';
import '../../../domain/voice/repositories/voice_repository.dart';
import '../../../domain/voice/usecases/fetch_call_history_use_case.dart';
import '../../../domain/voice/usecases/get_call_details_use_case.dart';
import '../controllers/call_detail_controller.dart';
import '../controllers/voice_controller.dart';
import '../services/voice_service.dart';

class VoiceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VoiceLocalDataSource>(
      () => InMemoryVoiceLocalDataSource(),
      fenix: true,
    );

    Get.lazyPut<VoiceRemoteDataSource>(
      () => FakeVoiceRemoteDataSource(),
      fenix: true,
    );

    Get.lazyPut<VoiceRepository>(
      () => VoiceRepositoryImpl(
        remoteDataSource: Get.find<VoiceRemoteDataSource>(),
        localDataSource: Get.find<VoiceLocalDataSource>(),
      ),
      fenix: true,
    );

    Get.lazyPut<FetchCallHistoryUseCase>(
      () => FetchCallHistoryUseCase(Get.find<VoiceRepository>()),
      fenix: true,
    );

    Get.lazyPut<GetCallDetailsUseCase>(
      () => GetCallDetailsUseCase(Get.find<VoiceRepository>()),
      fenix: true,
    );

    Get.lazyPut<VoiceService>(
      () => VoiceService(
        fetchCallHistoryUseCase: Get.find<FetchCallHistoryUseCase>(),
        getCallDetailsUseCase: Get.find<GetCallDetailsUseCase>(),
      ),
      fenix: true,
    );

    Get.lazyPut<VoiceController>(
      () => VoiceController(voiceService: Get.find<VoiceService>()),
    );

    Get.lazyPut<CallDetailController>(
      () => CallDetailController(voiceService: Get.find<VoiceService>()),
    );
  }
}
