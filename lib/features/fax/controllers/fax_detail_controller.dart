import 'package:get/get.dart';
import '../../../base/base_controller.dart';
import '../../../domain/fax/entities/fax_message.dart';
import '../services/fax_service.dart';

class FaxDetailController extends BaseController {
  static const tag = 'FaxDetailController';

  @override
  String get controllerName => tag;

  final FaxService _faxService;
  final isLoading = false.obs;
  final errorMessage = RxnString();
  final Set<String> _loadedConversationIds = {};

  FaxDetailController({required FaxService faxService})
      : _faxService = faxService;

  List<FaxMessage> messagesFor(String conversationId) {
    return _faxService.messagesFor(conversationId);
  }

  Future<void> ensureLoaded(String conversationId) async {
    if (_loadedConversationIds.contains(conversationId)) {
      return;
    }
    await loadMessages(conversationId);
    _loadedConversationIds.add(conversationId);
  }

  Future<void> loadMessages(String conversationId) async {
    isLoading.value = true;
    errorMessage.value = null;
    try {
      await _faxService.refreshMessages(conversationId);
    } catch (_) {
      errorMessage.value = 'Unable to load fax document';
    } finally {
      isLoading.value = false;
    }
  }
}
