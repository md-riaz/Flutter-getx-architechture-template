import 'package:get/get.dart';
import '../../../base/base_controller.dart';
import '../../../domain/sms/entities/sms_message.dart';
import '../services/sms_service.dart';

class SmsThreadController extends BaseController {
  static const tag = 'SmsThreadController';

  @override
  String get controllerName => tag;

  final SmsService _smsService;
  final isLoading = false.obs;
  final errorMessage = RxnString();
  final Set<String> _loadedConversationIds = {};
  final Set<String> _loadingConversationIds = {};

  SmsThreadController({required SmsService smsService})
      : _smsService = smsService;

  List<SmsMessage> messagesFor(String conversationId) {
    return _smsService.messagesFor(conversationId);
  }

  Future<void> ensureMessagesLoaded(String conversationId) async {
    if (_loadedConversationIds.contains(conversationId) ||
        _loadingConversationIds.contains(conversationId)) {
      return;
    }
    _loadingConversationIds.add(conversationId);
    try {
      await loadMessages(conversationId);
      if (errorMessage.value == null) {
        _loadedConversationIds.add(conversationId);
      }
    } finally {
      _loadingConversationIds.remove(conversationId);
    }
  }

  Future<void> loadMessages(String conversationId) async {
    isLoading.value = true;
    errorMessage.value = null;
    try {
      await _smsService.refreshMessages(conversationId);
    } catch (error) {
      errorMessage.value = 'Unable to load conversation';
    } finally {
      isLoading.value = false;
    }
  }
}
