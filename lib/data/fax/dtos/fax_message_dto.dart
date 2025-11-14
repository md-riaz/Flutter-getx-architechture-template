import '../../../domain/fax/entities/fax_message.dart';

class FaxMessageDto {
  final String id;
  final String conversationId;
  final String sender;
  final String content;
  final DateTime timestamp;

  const FaxMessageDto({
    required this.id,
    required this.conversationId,
    required this.sender,
    required this.content,
    required this.timestamp,
  });

  FaxMessage toDomain() {
    return FaxMessage(
      id: id,
      conversationId: conversationId,
      sender: sender,
      content: content,
      timestamp: timestamp,
    );
  }
}
