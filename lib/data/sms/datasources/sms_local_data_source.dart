import '../dtos/sms_conversation_dto.dart';
import '../dtos/sms_message_dto.dart';

abstract class SmsLocalDataSource {
  Future<void> cacheConversations(List<SmsConversationDto> conversations);
  List<SmsConversationDto> getCachedConversations();
  List<SmsMessageDto> getCachedMessages(String conversationId);
  Future<void> cacheMessages(String conversationId, List<SmsMessageDto> messages);
}

class InMemorySmsLocalDataSource implements SmsLocalDataSource {
  List<SmsConversationDto> _conversations = const [];
  final Map<String, List<SmsMessageDto>> _messages = {};

  @override
  Future<void> cacheConversations(List<SmsConversationDto> conversations) async {
    _conversations = List.unmodifiable(conversations);
  }

  @override
  List<SmsConversationDto> getCachedConversations() => _conversations;

  @override
  List<SmsMessageDto> getCachedMessages(String conversationId) {
    return _messages[conversationId] ?? const [];
  }

  @override
  Future<void> cacheMessages(
    String conversationId,
    List<SmsMessageDto> messages,
  ) async {
    _messages[conversationId] = List.unmodifiable(messages);
  }
}
