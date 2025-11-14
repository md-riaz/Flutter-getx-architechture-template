import 'package:get/get.dart';
import '../../../base/base_controller.dart';
import '../../../domain/fax/entities/fax_conversation.dart';
import '../services/fax_service.dart';

class FaxController extends BaseController {
  static const tag = 'FaxController';

  @override
  String get controllerName => tag;

  final FaxService _faxService;
  final isLoading = false.obs;
  final errorMessage = RxnString();

  FaxController({required FaxService faxService}) : _faxService = faxService;

  RxList<FaxConversation> get conversations => _faxService.conversations;

  @override
  void onReady() {
    super.onReady();
    loadConversations();
  }

  Future<void> loadConversations() async {
    isLoading.value = true;
    errorMessage.value = null;
    try {
      await _faxService.refreshConversations();
    } catch (_) {
      errorMessage.value = 'Unable to load fax inbox';
    } finally {
      isLoading.value = false;
    }
  }
}
