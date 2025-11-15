import '../entities/sms_conversation.dart';
import '../entities/sms_message.dart';

abstract class SmsRepository {
  Future<List<SmsConversation>> fetchConversations();
  Future<List<SmsMessage>> fetchMessages(String conversationId);
}
