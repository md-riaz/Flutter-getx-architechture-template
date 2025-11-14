import 'package:get/get.dart';
import '../../../domain/fax/entities/fax_conversation.dart';
import '../../../domain/fax/entities/fax_message.dart';
import '../../../domain/fax/usecases/fetch_fax_conversations_use_case.dart';
import '../../../domain/fax/usecases/fetch_fax_messages_use_case.dart';

class FaxService extends GetxService {
  final FetchFaxConversationsUseCase _fetchConversations;
  final FetchFaxMessagesUseCase _fetchMessages;

  final _conversations = <FaxConversation>[].obs;
  final _messagesByConversation = <String, List<FaxMessage>>{}.obs;

  FaxService({
    required FetchFaxConversationsUseCase fetchConversations,
    required FetchFaxMessagesUseCase fetchMessages,
  })  : _fetchConversations = fetchConversations,
        _fetchMessages = fetchMessages;

  RxList<FaxConversation> get conversations => _conversations;

  List<FaxMessage> messagesFor(String conversationId) {
    return _messagesByConversation[conversationId] ?? const [];
  }

  Future<void> refreshConversations() async {
    final results = await _fetchConversations();
    _conversations.assignAll(results);
  }

  Future<void> refreshMessages(String conversationId) async {
    final results = await _fetchMessages(
      FetchFaxMessagesParams(conversationId: conversationId),
    );
    _messagesByConversation[conversationId] = results;
    _messagesByConversation.refresh();
  }
}
