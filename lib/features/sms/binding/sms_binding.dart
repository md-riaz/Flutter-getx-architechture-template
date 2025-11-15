import 'package:get/get.dart';
import '../../../data/sms/datasources/sms_local_data_source.dart';
import '../../../data/sms/datasources/sms_remote_data_source.dart';
import '../../../data/sms/repositories/sms_repository_impl.dart';
import '../../../domain/sms/repositories/sms_repository.dart';
import '../../../domain/sms/usecases/fetch_sms_conversations_use_case.dart';
import '../../../domain/sms/usecases/fetch_sms_messages_use_case.dart';
import '../controllers/sms_controller.dart';
import '../controllers/sms_thread_controller.dart';
import '../services/sms_service.dart';

class SmsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SmsLocalDataSource>(
      () => InMemorySmsLocalDataSource(),
      fenix: true,
    );

    Get.lazyPut<SmsRemoteDataSource>(
      () => FakeSmsRemoteDataSource(),
      fenix: true,
    );

    Get.lazyPut<SmsRepository>(
      () => SmsRepositoryImpl(
        remoteDataSource: Get.find<SmsRemoteDataSource>(),
        localDataSource: Get.find<SmsLocalDataSource>(),
      ),
      fenix: true,
    );

    Get.lazyPut<FetchSmsConversationsUseCase>(
      () => FetchSmsConversationsUseCase(Get.find<SmsRepository>()),
      fenix: true,
    );

    Get.lazyPut<FetchSmsMessagesUseCase>(
      () => FetchSmsMessagesUseCase(Get.find<SmsRepository>()),
      fenix: true,
    );

    Get.lazyPut<SmsService>(
      () => SmsService(
        fetchConversations: Get.find<FetchSmsConversationsUseCase>(),
        fetchMessages: Get.find<FetchSmsMessagesUseCase>(),
      ),
      fenix: true,
    );

    Get.lazyPut<SmsController>(
      () => SmsController(smsService: Get.find<SmsService>()),
    );

    Get.lazyPut<SmsThreadController>(
      () => SmsThreadController(smsService: Get.find<SmsService>()),
    );
  }
}
