import 'package:get/get.dart';
import '../../../domain/sms/entities/sms_conversation.dart';
import '../../../domain/sms/entities/sms_message.dart';
import '../../../domain/sms/usecases/fetch_sms_conversations_use_case.dart';
import '../../../domain/sms/usecases/fetch_sms_messages_use_case.dart';

class SmsService extends GetxService {
  final FetchSmsConversationsUseCase _fetchConversations;
  final FetchSmsMessagesUseCase _fetchMessages;

  final _conversations = <SmsConversation>[].obs;
  final _messagesByConversation = <String, List<SmsMessage>>{}.obs;

  SmsService({
    required FetchSmsConversationsUseCase fetchConversations,
    required FetchSmsMessagesUseCase fetchMessages,
  })  : _fetchConversations = fetchConversations,
        _fetchMessages = fetchMessages;

  RxList<SmsConversation> get conversations => _conversations;

  List<SmsMessage> messagesFor(String conversationId) {
    return _messagesByConversation[conversationId] ?? const [];
  }

  Future<void> refreshConversations() async {
    final results = await _fetchConversations();
    _conversations.assignAll(results);
  }

  Future<void> refreshMessages(String conversationId) async {
    final results = await _fetchMessages(
      FetchSmsMessagesParams(conversationId: conversationId),
    );
    _messagesByConversation[conversationId] = results;
    _messagesByConversation.refresh();
  }
}
