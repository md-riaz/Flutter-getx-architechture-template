import '../dtos/fax_conversation_dto.dart';
import '../dtos/fax_message_dto.dart';

abstract class FaxLocalDataSource {
  Future<void> cacheConversations(List<FaxConversationDto> conversations);
  List<FaxConversationDto> getCachedConversations();
  List<FaxMessageDto> getCachedMessages(String conversationId);
  Future<void> cacheMessages(String conversationId, List<FaxMessageDto> messages);
}

class InMemoryFaxLocalDataSource implements FaxLocalDataSource {
  List<FaxConversationDto> _conversations = const [];
  final Map<String, List<FaxMessageDto>> _messages = {};

  @override
  Future<void> cacheConversations(List<FaxConversationDto> conversations) async {
    _conversations = List.unmodifiable(conversations);
  }

  @override
  List<FaxConversationDto> getCachedConversations() => _conversations;

  @override
  List<FaxMessageDto> getCachedMessages(String conversationId) {
    return _messages[conversationId] ?? const [];
  }

  @override
  Future<void> cacheMessages(
    String conversationId,
    List<FaxMessageDto> messages,
  ) async {
    _messages[conversationId] = List.unmodifiable(messages);
  }
}
