import '../../../domain/sms/entities/sms_message.dart';

class SmsMessageDto {
  final String id;
  final String conversationId;
  final String sender;
  final String content;
  final DateTime timestamp;
  final bool isIncoming;

  const SmsMessageDto({
    required this.id,
    required this.conversationId,
    required this.sender,
    required this.content,
    required this.timestamp,
    required this.isIncoming,
  });

  SmsMessage toDomain() {
    return SmsMessage(
      id: id,
      conversationId: conversationId,
      sender: sender,
      content: content,
      timestamp: timestamp,
      isIncoming: isIncoming,
    );
  }
}
