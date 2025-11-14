import '../../../domain/fax/entities/fax_conversation.dart';
import 'fax_message_dto.dart';

class FaxConversationDto {
  final String id;
  final String company;
  final String subject;
  final DateTime receivedAt;
  final int pageCount;
  final List<FaxMessageDto> messages;

  const FaxConversationDto({
    required this.id,
    required this.company,
    required this.subject,
    required this.receivedAt,
    required this.pageCount,
    required this.messages,
  });

  FaxConversation toDomain() {
    return FaxConversation(
      id: id,
      company: company,
      subject: subject,
      receivedAt: receivedAt,
      pageCount: pageCount,
    );
  }
}
