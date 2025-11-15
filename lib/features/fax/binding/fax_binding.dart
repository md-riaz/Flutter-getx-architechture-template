import 'package:get/get.dart';
import '../../../data/fax/datasources/fax_local_data_source.dart';
import '../../../data/fax/datasources/fax_remote_data_source.dart';
import '../../../data/fax/repositories/fax_repository_impl.dart';
import '../../../domain/fax/repositories/fax_repository.dart';
import '../../../domain/fax/usecases/fetch_fax_conversations_use_case.dart';
import '../../../domain/fax/usecases/fetch_fax_messages_use_case.dart';
import '../controllers/fax_controller.dart';
import '../controllers/fax_detail_controller.dart';
import '../services/fax_service.dart';

class FaxBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FaxLocalDataSource>(
      () => InMemoryFaxLocalDataSource(),
      fenix: true,
    );

    Get.lazyPut<FaxRemoteDataSource>(
      () => FakeFaxRemoteDataSource(),
      fenix: true,
    );

    Get.lazyPut<FaxRepository>(
      () => FaxRepositoryImpl(
        remoteDataSource: Get.find<FaxRemoteDataSource>(),
        localDataSource: Get.find<FaxLocalDataSource>(),
      ),
      fenix: true,
    );

    Get.lazyPut<FetchFaxConversationsUseCase>(
      () => FetchFaxConversationsUseCase(Get.find<FaxRepository>()),
      fenix: true,
    );

    Get.lazyPut<FetchFaxMessagesUseCase>(
      () => FetchFaxMessagesUseCase(Get.find<FaxRepository>()),
      fenix: true,
    );

    Get.lazyPut<FaxService>(
      () => FaxService(
        fetchConversations: Get.find<FetchFaxConversationsUseCase>(),
        fetchMessages: Get.find<FetchFaxMessagesUseCase>(),
      ),
      fenix: true,
    );

    Get.lazyPut<FaxController>(
      () => FaxController(faxService: Get.find<FaxService>()),
    );

    Get.lazyPut<FaxDetailController>(
      () => FaxDetailController(faxService: Get.find<FaxService>()),
    );
  }
}
