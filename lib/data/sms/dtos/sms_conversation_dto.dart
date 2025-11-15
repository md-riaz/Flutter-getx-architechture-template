import '../../../domain/sms/entities/sms_conversation.dart';
import 'sms_message_dto.dart';

class SmsConversationDto {
  final String id;
  final String contactName;
  final String contactHandle;
  final String lastMessagePreview;
  final DateTime lastUpdated;
  final int unreadCount;
  final List<SmsMessageDto> messages;

  const SmsConversationDto({
    required this.id,
    required this.contactName,
    required this.contactHandle,
    required this.lastMessagePreview,
    required this.lastUpdated,
    required this.unreadCount,
    required this.messages,
  });

  SmsConversation toDomain() {
    return SmsConversation(
      id: id,
      contactName: contactName,
      contactHandle: contactHandle,
      lastMessagePreview: lastMessagePreview,
      lastUpdated: lastUpdated,
      unreadCount: unreadCount,
    );
  }
}
