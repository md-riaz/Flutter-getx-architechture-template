import '../entities/fax_conversation.dart';
import '../entities/fax_message.dart';

abstract class FaxRepository {
  Future<List<FaxConversation>> fetchConversations();
  Future<List<FaxMessage>> fetchMessages(String conversationId);
}
