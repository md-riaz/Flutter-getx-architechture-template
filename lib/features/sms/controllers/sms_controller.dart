import 'package:get/get.dart';
import '../../../base/base_controller.dart';
import '../../../domain/sms/entities/sms_conversation.dart';
import '../services/sms_service.dart';

class SmsController extends BaseController {
  static const tag = 'SmsController';

  @override
  String get controllerName => tag;

  final SmsService _smsService;
  final isLoading = false.obs;
  final errorMessage = RxnString();

  SmsController({required SmsService smsService}) : _smsService = smsService;

  RxList<SmsConversation> get conversations => _smsService.conversations;

  @override
  void onReady() {
    super.onReady();
    loadConversations();
  }

  Future<void> loadConversations() async {
    isLoading.value = true;
    errorMessage.value = null;
    try {
      await _smsService.refreshConversations();
    } catch (error) {
      errorMessage.value = 'Unable to load SMS conversations';
    } finally {
      isLoading.value = false;
    }
  }
}
